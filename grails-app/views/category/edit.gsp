<%@ page import="mulan.Category" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" />
       
        <script type="text/javascript" src="/js/yui/2.7.0/yahoo-dom-event/yahoo-dom-event.js"></script>
    </head>
    <body>       
        <div class="body">
            <h1>分类详情</h1>
            
            <g:form action="update" method="post" >
            	<input type="hidden" name="id" value="${categoryInstance?.id.getId()}" />
                <input type="hidden" name="version" value="${categoryInstance?.version}" />
            	<div class="setupTag_box">
                    	<div class="setupTag_boxL">
                        	<div class="setupTag_input">
                        	<g:textField name="name" id="name" value="${categoryInstance?.name}" style="color: black;" class="setupTag_txt"/></br>
                        	<a href="javascript:;" class="btn_normal" onclick="catValidate();"><em>修改</em></a>
                        	<g:link controller="category" class="btn_normal" action="delete" id="${categoryInstance?.id.getId()}" onclick="return confirm('Are you sure?');"><em>删除</em></g:link>
			                
                            </div>
                            <div class="setupTag_tip gray9" id="tip_or_error" style="display: block;"> 
                            </div>

                        </div>
                         <div class="setupTag_boxR">                       	
                        	 
                            <div class="setupTag_list01" id="rec_tags">
                             	<g:link controller="category" action="list"  title="查看更多分类详情" ><em>+</em>更多分类--></g:link> </br>
                            	<g:each in="${cats}" status="i" var="cat"> 
                            	   <g:link controller="category" action="edit"  title="查看${cat?.name}详情" id="${cat.id.getId()}"><em>+</em>${cat?.name}</g:link>                            	    
                            	</g:each>
								          
                              	                         
                            </div>
                            </div>
                    </div>
            	
            </g:form>            
            <div class="category">
                <table>
                    <thead>
                        <tr>
                   	        <th>Task Name</th>
                   	        
                            <th>operation</th>
                        
                        </tr>
                    </thead>
                    <tbody>                    
						<g:each in="${tasks}" status="i" var="task">
							<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<% 
                    				def param=[taskid:task.id.getId(),catid:categoryInstance?.id.getId()]
                            	%>
                            	<td>${task}</td>    
                            	<td>
                            	<div class="setupTag_input">
                            	<g:link controller="category" class="btn_normal" action="removeTask" params="${param}"><em>剔除任务</em></g:link>
                            	</div>
                            	</td>                    	
							
                    		</tr>        
                    
                        </g:each>
                    
                    </tbody>
                </table>
            </div>
            
        </div>
    </body>
</html>
