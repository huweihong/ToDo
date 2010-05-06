

package mulan

import com.google.appengine.api.datastore.KeyFactory.Builder;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

class CategoryController {
	User user = UserUtil.getMe()
	def index = { redirect(action:list,params:params)
	}
	
	// the delete, save and update actions only accept POST requests
	static allowedMethods = [ save:'POST', update:'POST']
	
	def list = {
		
		if(user){
			params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
			params.where=[author:user]
			params.sorts="name" 
			params.order="desc"		 
			return [ categoryInstanceList:Category.list(params), categoryInstanceTotal: Category.count(params) ,]
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/list")])
		}
	}
	
	def show = {
		if(user){
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Category.class.getSimpleName(),params.id.toInteger());
			def categoryInstance = Category.get(keyBuilder.getKey())
			
			if(!categoryInstance) {
				flash.message = "Category not found with id ${params.id}"
				redirect(action:list)
			}
			else { return [ categoryInstance : categoryInstance ]
			}
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/show")])
		}
		
	}
	
	def delete = {
		if(user){
			
			def tasks=[]
			Category.withTransaction {
				Builder keyBuilder = new Builder("Root", 1);
				keyBuilder.addChild(Category.class.getSimpleName(),params.id.toLong());
				
				def categoryInstance = Category.get(keyBuilder.getKey())
				if(categoryInstance) {
					try {
						categoryInstance.tasks.each {taskid->
							def taskBuilder = new Builder("Root", 1);
							taskBuilder.addChild(Task.class.getSimpleName(),taskid.toLong());
							def task=Task.get(taskBuilder.getKey())
							task.cats.remove(params.id.toLong())
							task.save()		 							
						}
						
						categoryInstance.delete(flush:true)
						
					}
					catch(org.springframework.dao.DataIntegrityViolationException e) {
						flash.message = "Category ${params.id} could not be deleted"
						redirect(action:show,id:params.id)
					}finally{
						flash.message = "Category ${params.id} deleted"
						redirect(action:create)
					}
				}
				else {
					flash.message = "Category not found with id ${params.id}"
					redirect(action:list)
				}			
			}
			
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/list")])
		}
	}
	
	def edit = {
		if(user){
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Category.class.getSimpleName(),params.id.toInteger());
			def categoryInstance = Category.get(keyBuilder.getKey())
			
			if(!categoryInstance) {
				flash.message = "Category not found with id ${params.id}"
				redirect(action:list)
			}
			else {
				def tasks=[]
				
				categoryInstance.tasks.each{taskid->
					def taskBuilder = new Builder("Root", 1);
					taskBuilder.addChild(Task.class.getSimpleName(),taskid);
					tasks<<Task.get(taskBuilder.getKey())	 					
				}
				def cats=Category.list([max:6,offset:0,where:[author:user],sorts:"id",order:"desc"])
				return [ categoryInstance : categoryInstance,tasks:tasks,cats:cats ]
			}
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/edit")])
		}
	}
	
	def update = {
		if(user){
			Category.withTransaction {
				Builder keyBuilder = new Builder("Root", 1);
				keyBuilder.addChild(Category.class.getSimpleName(),params.id.toInteger());
				def categoryInstance = Category.get(keyBuilder.getKey())
				if(categoryInstance) {
					if(params.version) {
						def version = params.version.toLong()
						if(categoryInstance.version > version) {
							
							categoryInstance.errors.rejectValue("version", "category.optimistic.locking.failure", "Another user has updated this Category while you were editing.")
							render(view:'edit',model:[categoryInstance:categoryInstance])
							return
						}
					}
					categoryInstance.properties = params
					if(!categoryInstance.hasErrors() && categoryInstance.save()) {
						flash.message = "Category ${params.id} updated"
						redirect(action:edit,id:params.id)
					}
					else {
						render(view:'edit',model:[categoryInstance:categoryInstance])
					}
				} 
				else {
					flash.message = "Category not found with id ${params.id}"
					redirect(action:list)
				}			
			}
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/list")])
		}
	}
	
	def create = {
		
		if(user){
			def categoryInstance = new Category()
			categoryInstance.properties = params
			def cats=Category.list([max:6,offset:0,where:[author:user],sorts:"id",order:"desc"])
			return ['categoryInstance':categoryInstance,'cats':cats]
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/create")])
		}
	}
	
	def save = {
		
		if(user){
			def categoryInstance = new Category(params)
			categoryInstance.author=user
			def keyBuilder = new Builder("Root", 1);
			keyBuilder.addChild(Category.class.getSimpleName(),getCateogryId());
			categoryInstance.id=keyBuilder.getKey()
			Category.withTransaction {
				if(categoryInstance.save(flush:true)) {
					
					redirect(action:create)
				}
				else {
					render(view:'create',model:[categoryInstance:categoryInstance])  
				}
			}
		}else{
			render(view:"/login",model:[login:UserUtil.getLogInUrl("/category/list")])
		}
	}
	public static int getCateogryId(){
		def cat=Category.find("select cat from mulan.Category cat order by cat.id desc")
		if (cat){
			return cat.id.getId()+1
		}else{
			return 1
		}
		    
	}
	def removeTask={
		def keyBuilder = new Builder("Root", 1);
		keyBuilder.addChild(Task.class.getSimpleName(),params.taskid.toInteger());
		def task=Task.get(keyBuilder.getKey())
		keyBuilder = new Builder("Root", 1);
		keyBuilder.addChild(Category.class.getSimpleName(),params.catid.toInteger());
		def cat=Category.get(keyBuilder.getKey())
		Category.withTransaction{
			task.cats.remove(params.catid.toLong())
			task.save()
			cat.tasks.remove(params.taskid.toLong())
			cat.save()
		}
		redirect(action:edit,id:params.catid)
	}
	
}
