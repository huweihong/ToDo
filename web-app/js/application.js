var Ajax;
if (Ajax && (Ajax != null)) {
	Ajax.Responders.register({
	  onCreate: function() {
        if($('spinner') && Ajax.activeRequestCount>0)
          Effect.Appear('spinner',{duration:0.5,queue:'end'});
	  },
	  onComplete: function() {
        if($('spinner') && Ajax.activeRequestCount==0)
          Effect.Fade('spinner',{duration:0.5,queue:'end'});
	  }
	});
}
var contains=function(oParentNode,oNode){
	 
	do{if(oParentNode==oNode){
		return true}
	}while(
				oNode=oNode.parentNode);
	return false
	};
var changeBackColor=function(event,el){
	
	event=event||window.event;
	
	var id=el.id;
	var cancel=YAHOO.util.Dom.get("operation_"+id);// $E("cancel_"+id);
	if(event.type=="mouseover"){
		var relatedTarget=event.relatedTarget||event.fromElement;
		
		if(el!=relatedTarget&&relatedTarget&&!contains(el,relatedTarget)){
			
			if(cancel){cancel.style.display=""}
		}
	}
	if(event.type=="mouseout"){
		var relatedTarget=event.relatedTarget||event.toElement;
		if(el!=relatedTarget&&relatedTarget&&!contains(el,relatedTarget)){
			if(cancel){cancel.style.display="none"}
		}
	}
};
var showHint=function(str){
	if (str.length==0){ 
		YAHOO.util.Dom.get("txtHint").innerHTML="200";
		return;
	 }else{
		 YAHOO.util.Dom.get("txtHint").innerHTML=200-str.length;
		  return;
	}
};
function sendAjaxRequest(url, handler, postData){
	
	   YAHOO.widget.Loading.show();
	    alert(url);
	    var callback={
	        success: function(o){
	                    YAHOO.widget.Loading.hide();
	                    handler(o);
	                },
	        failure: function(){
	                   YAHOO.widget.Loading.hide();
	                    alert("send request failed!");
	                 }
	    }
	    YAHOO.util.Connect.asyncRequest("POST", url, callback, postData);
}
var trim=function(value) {
	return value.replace(/(^[\s]*)|([\s]*$)/g,"");
}

var catValidate=function(){
	if(YAHOO.util.Dom.get('name').value.length==0){
		alert("请输入分类名称！");
		return false
	}else{
		document.forms[0].submit();
	}
}
var taskvalidateForm=function(){
	if(YAHOO.util.Dom.get('goal').value==""||(trim(YAHOO.util.Dom.get('goal').value)=="")){
		alert("你的任务是什么呢？");
		return false;
	}
	/*var now=new Date();
	var byearvalue=YAHOO.util.Dom.get('beginDate_year').value;
	var eyearvalue=YAHOO.util.Dom.get('endDate_year').value;
	if (now.getFullYear()>byearvalue){
		alert("没法回到过去，：）请重新确定任务的开始时间！");
		return false;
	}
	if(now.getFullYear()>eyearvalue){
		alert("没法回到过去，：）请重新确定任务的结束时间！");
		return false;
	}
	
	if(eyearvalue<byearvalue){
		alert("结束时间不能早于开始时间！");
		return false;
	}
	if(eyearvalue==byearvalue){
		
		var bmonvalue=YAHOO.util.Dom.get('beginDate_month').value;
		var emonvalue=YAHOO.util.Dom.get('endDate_month').value;
		if (now.getMonth()>bmonvalue){
			alert("没法回到过去，：）请重新确定任务的开始时间！");
			return false;
		}
		if(now.getMonth()>emonvalue){
			alert("没法回到过去，：）请重新确定任务的结束时间！");
			return false;
		}
		if(emonvalue<bmonvalue){
			alert("结束时间不能早于开始时间！");
			return false;
		}
		if(emonvalue==bmonvalue){
			var bdayvalue=YAHOO.util.Dom.get('beginDate_day').value;
			var edayvalue=YAHOO.util.Dom.get('endDate_day').value;
			if (now.getDate()>bdayvalue){
				alert("没法回到过去，：）请重新确定任务的开始时间！");
				return false;
			}
			if(now.getDate()>edayvalue){
				alert("没法回到过去，：）请重新确定任务的结束时间！");
				return false;
			}
			if(edayvalue<bdayvalue){
				alert("结束时间不能早于开始时间！");
				return false;
			}
		}
	}*/

	document.forms[0].submit();
	
	     
}
