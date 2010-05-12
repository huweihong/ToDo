package mulan

import com.google.appengine.api.datastore.KeyFactory.Builder;
import com.google.appengine.api.users.User;

class TaskController {
	User user = UserUtil.getMe()
	def index = { redirect(action:list,params:params)
	}
	
	// the delete, save and update actions only accept POST requests
	static allowedMethods = [ save:'POST', update:'POST']
	
	def list = {
		
		if(user){
			def tasks=[]
			if (params.status){
				params.max = Math.min( params.max ? params.max.toInteger() : 5,  100)   				
				params.where=[author:user,status:params.status]
				params.sorts=["beginDate"]  
				params.order="desc"	  
				tasks=Task.list(params)
				return [ taskInstanceList: tasks, 
				         taskInstanceTotal: Task.count(params),  
				                          categoryInstanceList:Category.list([where:[author:user],sorts:"name",order:"desc"]),
				                          categoryname:params.status+"的任务",
				 				         opens:getNumbers("Open",user),
								         cancels:getNumbers("Cancel",user),
								         ends:getNumbers("End",user)]
			}
			if(params.id){
				Builder keyBuilder = new Builder("Root", 1);
				keyBuilder.addChild(Category.class.getSimpleName(),params.id.toLong());
				def cat = Category.get(keyBuilder.getKey()) 
				cat.tasks.each {taskid->      
					keyBuilder = new Builder("Root", 1);
					keyBuilder.addChild(Task.class.getSimpleName(),taskid.toLong());
					tasks<<Task.get(keyBuilder.getKey()) 
					        
				}
				return [taskInstanceList: tasks, 
				                          taskInstanceTotal: tasks.size(),
				                          cat:cat,
				                          categoryInstanceList:Category.list([where:[author:user],sorts:"name",order:"desc"]),
				                          categoryname:"属于"+cat.name+"的任务",
				 				         opens:getNumbers("Open",user),
								         cancels:getNumbers("Cancel",user),
								         ends:getNumbers("End",user)]
			
			}else{
				params.max = Math.min( params.max ? params.max.toInteger() : 5 ,  100)   				
				params.where=[author:user,status:'Open']
				params.sorts=["beginDate"]  
				params.order="desc"	
				tasks=Task.list(params)
				
				return [ taskInstanceList: tasks, 
				         taskInstanceTotal: Task.count(params),
				         categoryInstanceList:Category.list([where:[author:user],sorts:"name",order:"desc"]),
				         categoryname:"所有任务",
				         opens:getNumbers("Open",user),
				         cancels:getNumbers("Cancel",user),
				         ends:getNumbers("End",user)]
			}
			
		}else{ 
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/task/list")]) 
		}
	}
	public int getNumbers(String status,User user){
		params.where=[author:user,status:status]
		return Task.count(params)              
		
	}
	def show = {
		
		if(user){
			Builder keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Task.class.getSimpleName(),params.id.toInteger());
			def taskInstance = Task.get( keyBuilder.getKey()) 
			
			if(!taskInstance) {
				flash.message = "Task not found with id ${params.id}"
				redirect(action:list)
			}
			else { 
				
				return [ taskInstance : taskInstance ]
			}
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/task/show")])
		}
	}
	
	def delete = {
		if(user){
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Task.class.getSimpleName(),params.id.toLong());
			def taskInstance = Task.get(keyBuilder.getKey())				
			if(taskInstance) {
				Task.withTransaction {	
					
					try {
						taskInstance.cats.each { catid->
							def catBuilder = new Builder("Root", 1);
							catBuilder.addChild(Category.class.getSimpleName(),catid.toLong());
							def cat=Category.get(catBuilder.getKey())
							cat.tasks.remove (taskInstance.id.getId())
							cat.save()							
						}
						taskInstance.delete(flush:true)
						redirect(action:list)
					}
					catch(org.springframework.dao.DataIntegrityViolationException e) {
						flash.message = "Task ${params.id} could not be deleted"
						redirect(action:show,id:params.id)
					}
				}
				
			}else {
				flash.message = "Task not found with id ${params.id}"
				redirect(action:list)
			}	
			
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/task/list")])
		}
	}
	
	def edit = {
		
		if(user){
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Task.class.getSimpleName(),params.id.toInteger());
			def taskInstance = Task.get(keyBuilder.getKey())
			if(!taskInstance) {
				flash.message = "Task not found with id ${params.id}"
				redirect(action:list)
			}
			else {
				def categories=Category.findAll("select c from mulan.Category c where c.author=:author",[author:user])
				
				if(taskInstance.cats)
				return [ taskInstance : taskInstance ,categories:categories,oldcategories:taskInstance.cats]
				else
				return [ taskInstance : taskInstance ,categories:categories,oldcategories:"notask"]
			}
		}
		else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/task/edit")])
		}
	}
	
	def update = {
		if(user){				
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Task.class.getSimpleName(),params.id.toInteger());
			def taskInstance = Task.get(keyBuilder.getKey())					
			if(taskInstance) {
				Task.withTransaction {
					if(params.version) {
						def version = params.version.toLong()
						if(taskInstance.version > version) {
							
							taskInstance.errors.rejectValue("version", "task.optimistic.locking.failure", "Another user has updated this Task while you were editing.")
							render(view:'edit',model:[taskInstance:taskInstance])
							return
						}
					} 
					taskInstance.cats.each{catid->
						def catBuilder = new Builder("Root", 1);
						catBuilder.addChild(Category.class.getSimpleName(),catid.toLong());
						
						def cat=Category.get(catBuilder.getKey())
						cat.tasks.remove(taskInstance.id.getId())
						cat.save()	
						
					}	 
					taskInstance.cats=[]
					taskInstance.save()
					if(params.selects.equals("1")){
						def catBuilder = new Builder("Root", 1);
						catBuilder.addChild(Category.class.getSimpleName(),params.categories.toInteger());
						def category=Category.get(catBuilder.getKey())
						if(category){
							category.tasks<<params.id.toLong()
							category.save()
							taskInstance.cats<<category.id.getId()
						}
					}else{
						params.categories.each {catid-> 
							def catBuilder = new Builder("Root", 1);
							catBuilder.addChild(Category.class.getSimpleName(),catid.toLong());
							def category=Category.get(catBuilder.getKey()) 
							if(category){
								category.tasks<<params.id.toLong()
								category.save()	
								taskInstance.cats<<category.id.getId()
							}
						}
					} 
					if (!params.status.equals("Open")){ 
						taskInstance.endDate=new Date()
					}
					taskInstance.status=params.status
					taskInstance.goal=params.goal
					taskInstance.save()
					redirect(action:list)
					
					
				}
				
				
			}
			else {
				flash.message = "Task not found with id ${params.id}"
				redirect(action:list)
				
			}			
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/list")])
		}
		
	}
	
	def create = {
		
		if(user){
			def taskInstance = new Task()
			taskInstance.properties = params
			def categories=Category.findAll("select c from mulan.Category c where c.author=:author",[author:user])
			return ['taskInstance':taskInstance,categories:categories]
			
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/task/create")])
		}
	}
	
	def save = {
		
		if(user){			
			def taskInstance = new Task(params)			
			taskInstance.author=user	
			taskInstance.status="Open"
			taskInstance.beginDate=new Date()
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Task.class.getSimpleName(),getTaskId());
			taskInstance.id=keyBuilder.getKey()			
			Task.withTransaction {
				if(params.categories){						
					
					if(params.selects.equals("1")){
						def catBuilder = new Builder("Root", 1);
						catBuilder.addChild(Category.class.getSimpleName(),params.categories.toLong())
						def cat=Category.get(catBuilder.getKey())
						taskInstance.cats<<cat.id.getId()
						
						cat.tasks<<taskInstance.id.getId()
						cat.save()
					}else{
						params.categories.each{caid->
							def catkeyBuilder = new Builder("Root", 1);
							catkeyBuilder.addChild(Category.class.getSimpleName(),caid.toLong());
							taskInstance.cats<<caid
							def cat=Category.get(catkeyBuilder.getKey())
							cat.tasks<<taskInstance.id.getId()	
							cat.save()
						}
					}
				}
				
				if(taskInstance.save(flush:true)) {
					flash.message = "Task ${taskInstance.id} created"
					redirect(action:list)
				}
				else {
					render(view:'create',model:[taskInstance:taskInstance])
				}
				
			}
			
		}else{
			
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/task/list")])
		}
	}
	
	def findTasks={
		def tasks=[]
		if (params.year){
			def month=params.month.toInteger()+1
			//println "$params.year-$month-$params.day"
			tasks=Task.findAll("select task from mulan.Task task where  task.beginDate > '$params.date' ")
			
			render(view:"list",taskInstanceList: tasks, taskInstanceTotal:tasks.size())
		}else{
			Builder keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Category.class.getSimpleName(),params.id.toLong());
			def cat = Category.get(keyBuilder.getKey())
			println cat
			cat.tasks.each {taskid->
				keyBuilder = new Builder("Root", 1);
				keyBuilder.addChild(Task.class.getSimpleName(),taskid.toLong());
				tasks<<Task.get(keyBuilder.getKey()) 
				//dd   ddds w
			}
			  
			render(view:"list",model:[taskInstanceList: tasks, 
			                          taskInstanceTotal: tasks.size(),
			                          cat:cat,
			                          categoryInstanceList:Category.list([where:[author:user],sorts:"name",order:"desc"]),
			                          categoryname:"属于"+cat.name+"的任务"])
		}
		
		
	}
	public static int getTaskId(){
		def task=Category.find("select task from mulan.Task task order by task.id desc")
		if (task){
			return task.id.getId()+1
		}else{
			return 1
		}
	}
	def deleteExpire={
		def tasks=Task.findAll("select task from mulan.Task task where task.endDate< new Date()")
		Task.withTransaction{
			tasks.each {task->
				task.status=""
				
			}
		}
		
		render(action:list)
	} 
}
