<%@ page import="mulan.Category" %>
<%@ page import="mulan.Task" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory.Builder" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
       
    </head>
    <body>
      
        <div class="body">
            <h1>Category:${fieldValue(bean:categoryInstance, field:'name')}</h1>     
             
            
              
            <div class="category">
                <table>
                    <thead>
                        <tr>
                   	        <th>Task Name</th>
                   	        
                            <th>operation</th>
                        
                        </tr>
                    </thead>
                    <tbody>                    
						<g:each in="${categoryInstance.tasks}" status="i" var="taskid">
							<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<% def keyBuilder = new Builder("Root", 1);
                    				keyBuilder.addChild(Task.class.getSimpleName(),taskid);
                    				def param=[taskid:taskid,catid:categoryInstance.id.getId()]
                            	%>
                            	<td>${Task.get(keyBuilder.getKey())}</td>    
                            	<td><g:link controller="category" action="removeTask" params="${param}">RemoveTask</g:link></td>                    	
							
                    		</tr>        
                    
                        </g:each>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                     <input id="id" value="${fieldValue(bean:categoryInstance, field:'id')}">   
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
