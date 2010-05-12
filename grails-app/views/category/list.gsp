<%@ page import="mulan.Category" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
       
    </head>
    <body>
    	<content tag="nav">       
          
        </content>
       
        <div class="body">
        <h1>分类列表</h1>
            <g:each in="${categoryInstanceList}" status="i" var="categoryInstance">
             <g:if test="${(i % 4) == 0}">
            <h2>
            </g:if>
            <g:link action="edit" id="${categoryInstance.id.getId()}">${fieldValue(bean:categoryInstance, field:'name')}（${categoryInstance.tasks.size()}）</g:link>
            <span class="tagspan">|</span>
           </g:each>
           
        </div>
    </body>
</html>
