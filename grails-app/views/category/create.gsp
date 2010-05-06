<%@ page import="mulan.Category" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" />
       
        <script type="text/javascript" src="../js/yui/2.7.0/yahoo-dom-event/yahoo-dom-event.js"></script>
    </head>
    <body>       
        <div class="body">
            <h1>创建分类</h1>            
            <g:form action="save" method="post" >
            	<div class="setupTag_box">
                    	<div class="setupTag_boxL">
                        	<div class="setupTag_input">
                        	<g:textField name="name" id="name" maxlength="20" value="${categoryInstance?.name}" style="color: black;" class="setupTag_txt"/>
                        	<a id="add_tag" href="javascript:;" class="btn_normal" onclick="catValidate();"><em>添加</em></a>
                            </div>
                            <div class="setupTag_tip gray9" id="tip_or_error" style="display: block;"> </div>

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
        </div>
    </body>
</html>
