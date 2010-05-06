<%@ page import="mulan.Task" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        
         <script type="text/javascript" src="/js/yui/2.7.0/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script>
        var selects=0;
        function changeselect(){
        	var cat=YAHOO.util.Dom.get('categories');
        	selects=0;
        	
        	for (i=0;i<cat.length;i++){
            	if(cat.options[i].selected){
            		selects++;
               }
        	}
        	YAHOO.util.Dom.get('selects').value=selects;
        }
        	
        		
        	    var Init=function() {
        	    	var oldcategories="${oldcategories}";
            	    if(oldcategories!="notask"){
        	        	 	
        			    var cat=YAHOO.util.Dom.get('categories');
        			    
        			   for (i=0;i<cat.length;i++){
            			   for(j=0;j<oldcategories.length;j++){
                			   	if(cat.options[i].value==oldcategories[j]){
            			  		 cat.options[i].selected=true;
            			  		 break;
                			   	}
            			   }        			    	
        			    	
        			    }
        			   
        	    	}
            	    showHint(YAHOO.util.Dom.get('goal').value);
        	    	
        		}
        	YAHOO.util.Event.onDOMReady(Init);
        	
        </script>
    </head>
    <body>
        
        <div class="body">
            <h1>修改任务</h1>          
           
            <g:form action="update" method="post" >
                <input type="hidden" name="id" value="${fieldValue(bean:taskInstance, field:'id')}" />
                <input type="hidden" name="version" value="${taskInstance?.version}" />
                <input name="selects" type="hidden" id="selects" value="0">
                <div class="setupTag_box">
                    	<div class="Task_boxL">
                        	<div class="setupTag_input">
                        		<div class="wordNumBg" >
                        			<span  class=""tagspan  id="txtHint">200</span>                        		
                        			<g:select class="conBox_r" name="status" from="${taskInstance.constraints.status.inList}" value="${taskInstance?.status}" valueMessagePrefix="task.status"  />
                        		</div>
                                <div class="New_contentarea">
                                    <g:textArea id="goal" name="goal" maxlength="200" value="${taskInstance?.goal}"  onkeyup="showHint(this.value);" />
                                </div>                        	
                        	
                            </div>
                            <div class="setupTag_tip gray9" id="tip_or_error" style="display: block;"> 
                            	<a id="add_tag" href="javascript:;" class="btn_normal" onclick="taskvalidateForm();"><em>修改</em></a>
                            	<g:link controller="task" class="btn_normal" action="delete" id="${taskInstance?.id.getId()}" onclick="return confirm('Are you sure?');"><em>删除</em></g:link>
                            </div>

                        </div>
                        <div class="Task_boxR">                   	
                        	 
                            <div class="Task_list01" id="rec_tags">
                             	
								          <a ><em>+</em>选择分类--></a> </br>
                            	<select  name="categories" id="categories" multiple style="width:200px;height:70px;" onchange="changeselect()">
	                                <g:each in="${categories}" var="category">
	                                	<option value="${category.id.getId()}"  >${category.name}</option>
	                                	
	                                </g:each>
                                </select>  
                              	                         
                            </div>
                        </div>
                    </div>    
               </div>
            </g:form>
        </div>
    </body>
</html>
