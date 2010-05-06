<%@ page import="mulan.Task" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
    </head>
    <body>
        
        <div class="body">
            <h1>任务详情</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Status:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'status')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Goal:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'goal')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Begin Date:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'beginDate')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">End Date:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'endDate')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Author:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'author')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Categories:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:taskInstance, field:'cats')}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${fieldValue(bean:taskInstance, field:'id')}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
