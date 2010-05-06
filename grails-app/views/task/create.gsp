<%@ page import="mulan.Task" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <script type="text/javascript" src="../js/yui/2.7.0/yahoo-dom-event/yahoo-dom-event.js"></script>
        
          
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
        	showHint(YAHOO.util.Dom.get('goal').value);
        }
        YAHOO.util.Event.onDOMReady(Init);
        </script>      
    </head>
    <body>        
        <div class="body">
            <h1>创建任务</h1>
            
            <g:form action="save" method="post" >
            	<div class="setupTag_box">
                    	<div class="Task_boxL">
                        	<div class="setupTag_input">
                        	<div class="wordNumBg" ><span   id="txtHint">200</span></div>
                                <div class="New_contentarea">
                                    <g:textArea id="goal" name="goal" maxlength="200" value="${taskInstance?.goal}"  onkeyup="showHint(this.value);" />
                                </div>
                        	
                        	
                            </div>
                            <div class="setupTag_tip gray9" id="tip_or_error" style="display: block;"> 
                            <a id="add_tag" href="javascript:;" class="btn_normal" onclick="taskvalidateForm();"><em>添加</em></a>
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
                
            </g:form>
        </div>
    </body>
</html>
