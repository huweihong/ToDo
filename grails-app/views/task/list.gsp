<%@ page import="mulan.Task" %>
<%@ page import="mulan.Category" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory.Builder"%>
<html>
    <head>
        <title>Welcome to Grails</title>
		<meta name="layout" content="main" />			
		<style type="text/css" >

			#nav {
				margin-top:20px;
				margin-left:30px;
				width:228px;
				float:left;

			}
			.homePagePanel * {
				margin:0px;
			}
			.homePagePanel .panelBody ul {
				list-style-type:none;
				margin-bottom:10px;
			}
			.homePagePanel .panelBody h1 {
				text-transform:uppercase;
				font-size:1.1em;
				margin-bottom:10px;
			}
			.homePagePanel .panelBody {
			    background: url(images/leftnav_midstretch.png) repeat-y top;
				margin:0px;
				padding:15px;
			}
			.homePagePanel .panelBtm {
			    background: url(images/leftnav_btm.png) no-repeat top;
				height:20px;
				margin:0px;
			}

			.homePagePanel .panelTop {
			    background: url(images/leftnav_top.png) no-repeat top;
				height:11px;
				margin:0px;
			}
			h2 {
				margin-top:15px;
				margin-bottom:15px;
				font-size:1.2em;
			}
			#pageBody {
				margin-left:280px;
				margin-right:20px;
			}
		</style>
    </head>
    <body>
		<div id="nav">
			<div class="homePagePanel">
				<div class="panelTop">

				</div>
				<div class="panelBody">
					<h1>分类列表</h1>
					<ul>
						<g:each in="${categoryInstanceList}" var="cat">
						<li><g:link controller="task" action="list" id="${cat.id.getId()}">${fieldValue(bean:cat, field:'name')}
						<g:if test="${cat.tasks==null}">
                             		（0）
                        </g:if>
                        <g:else>
                            	（${cat.tasks.size()}）
                        </g:else>
                        </g:link>
                        </li>
						</g:each>
					</ul>
					<h1>任务状态</h1>
					<ul>
						<li><g:link controller="task" action="list" params="[status:'Open']">正在进行中</g:link><li>
						<li><g:link controller="task" action="list" params="[status:'Cancel']">撤销</g:link><li>
						<li><g:link controller="task" action="list" params="[status:'End']">已结束</g:link><li>
						
					</ul>
				</div>
				<div class="panelBtm">
				</div>
			</div>


		</div>
		<div id="pageBody">
	        <h1>${categoryname}</h1>	        

	        <div id="controllerList" >	
	        	<g:if test="${taskInstanceTotal>3 }">
	        	<div class="paginateToDo">
                <g:paginate total="${taskInstanceTotal}" />
            	</div>	
	        	</g:if>
	        			
	            <ul class="concernBox">
	              <g:each in="${taskInstanceList}" status="i" var="task">           
                    	      
                 <li class="linedot" onmouseover="changeBackColor(event,this);"
				onmouseout="changeBackColor(event,this);" id="${task.id.getId()}">    
                 	<div class="content">
                 	
                 		<g:link controller="task" action="edit" id="${task.id.getId()}"><span class="tagspan">${task.goal}</span></g:link>   
                 
                 		<div class="conBox_r" style="display: none;" id="operation_${task.id.getId()}">	
                            	
                            	<g:link controller="task" action="delete"  class="btn_normal" id="${task.id.getId()}"><em>删除</em></g:link>
                            
                          
						</div>	
                 		
                     </div>   	
                           
                      <div class="cat_list01">
                       
                        	
                        	<p class="setupTag_tip2 gray6">分类 ：
                           	
                            	<g:each in="${task.cats}"  var="catid"> 
                            	<% def keyBuilder = new Builder("Root", 1);
                    				keyBuilder.addChild(Category.class.getSimpleName(),catid.toLong());
                    				
                            	%>                            	
                          		<span class="tagspan">
                            	     <g:link controller="category" action="edit"  title="查看分类${Category.get(keyBuilder.getKey())}详情" id="${catid}"><em>+</em>${Category.get(keyBuilder.getKey())}</g:link>
                            	     </span>                          	    
                            	</g:each>
								</p>            
                       </div>       	                         
                     </li>      
                </g:each>
	            </ul>
	        </div>
		</div>
    </body>
</html>