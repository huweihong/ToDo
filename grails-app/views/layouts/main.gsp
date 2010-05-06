<%@ page import="mulan.User" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="mulan.UserUtil" %>
<html>
    <head>
        <title><g:layoutTitle default="ToDo" /></title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
		<link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" />
		
        <g:layoutHead />
         <g:javascript library="yui/2.7.0/yahoo-dom-event/yahoo-dom-event" />
        <g:javascript library="application" />
       
    </head>
    <body>
        <div id="spinner" class="spinner" style="display:none;">
            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner" />
        </div>
        <div id="grailsLogo" class="logo"><a href="http://grails.org"><img src="${resource(dir:'images',file:'grails_logo.png')}" alt="Grails" border="0" /></a></div>
        <div class="nav">
           
            
             <%
            
             User user = UserUtil.getMe();             

			%>
            <g:if test="${user}">
            	Wlecome,${user.getNickname()}!
            	<span class="menuButton"><a href="<%= UserUtil.getLogoutUrl("/") %>">退出</a></span>
           		 <span class="menuButton"><g:link controller="category" class="list" action="create">管理分类</g:link></span>
           		 <span class="menuButton"><g:link controller="task" class="create" action="create">新任务</g:link></span>
           		<!-- <span class="menuButton"><g:link  class="search" >查询</g:link></span> --> 
            </g:if>
            <g:else>
                Wlecome!
            	<span class="menuButton"><a href="<%= UserUtil.getLogInUrl("/") %>">Sign in</a>
				</span>
            	 <span class="menuButton"><g:link controller="auth" action="create">Regist</g:link></span>
            </g:else>
            <g:pageProperty name="page.nav"/>
            <span class="menuButton"><a class="home" href="${resource(dir:'/')}">Home</a></span>
        </div>
        <g:layoutBody />
    </body>
</html>