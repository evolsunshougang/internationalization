<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String type = request.getParameter("type");
	String captionName = "";
	if("0".equals(type)){
		captionName = "待发起的试验";
	}else if("1".equals(type)){
		captionName = "已完成的试验";
	}else if("2".equals(type)){
		captionName = "正在进行的试验";
	}else if("3".equals(type)){
		captionName = "已终止的试验";
	}else if("5".equals(type)){
		captionName = "已挂起的试验";
	}else{
	
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
	<head>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript">
         var api = frameElement.api;
         if (api!=undefined)
         {
         	var W = api.opener;
         }
        </script>
         <c:if test="${requestScope.message != null}">
         	<script type="text/javascript">
         		 alert("<c:out value='${requestScope.message}'></c:out>");
	         	 api.close();
	         	 W.reload();
	         </script>
         </c:if>
		<script type="text/javascript">
			 $(document).ready(function(){

				$("#gridTable").jqGrid({
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					datatype: "json",
					height: 500,
					autowidth: true, 
					colNames:['主键','流程类型','流程名称','流程类型id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colModel:[
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
					],   
					shrinkToFit:false,
					sortname:'ID',
					sortorder:'desc',
					viewrecords:true,
					multiselect: true, // 是否显示复选框
					multiboxonly : true, 
					rownumbers: false,//显示行号
					editable:true, 
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowList:[15,20,50,200,500],
					toolbar: [false,"top"],
					jsonReader: {
						root:"rows",		// 数据行（默认为：rows）
						page: "page",  	// 当前页
						total: "total",  // 总页数
						records: "records",  // 总记录数
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
					},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					pager:"#gridPager",
					caption: "<%=captionName%>"
				});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
						{ 	
						caption: "列状态",                          
						title: "Reorder Columns",                           
						onClickButton : function (){                               
						jQuery("#gridTable").jqGrid('columnChooser');                           
						}
					}); 
			});
			function showView(){
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
				if (!ids) {
				    alert("请先选择记录!");  
				    return false;  
				}
				if(ids.indexOf(",")!=-1){
					  alert("只能选择一条记录!");  
				      return false; 
				}
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var id = row.ID;//获取选中行的id属性
				 $.dialog({
					        id:'codereviewnext',
					        title:row.FLOWNAME, 
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        okVal:false,//确定按钮文字
					        cancelVal:false,//取消按钮文字
					        min:true, //是否显示最小化按钮
					        max:false,//是否显示最大化按钮
					        fixed:false,//开启静止定位
					        lock:true,//开启锁屏 
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        time:null,//设置对话框显示时间
					        resize:true,//是否允许用户调节尺寸
					        drag:true,//是否允许用户拖动位置
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        width: '1050px',
					        height: 650,
					        close: function(){
					        	window.parent.document.documentElement.scrollTop=0;
					        	gridSearch();
					        }
			        });
	        }
	        
			
	        //刷新页面
			function shuaXin(){
			 //  document.location.href='haslaunched_worklist.jsp'; 
			  jQuery("#gridTable").jqGrid('setGridParam',
                    {
                        url:'waitWork.action'
                    }).trigger("reloadGrid", [{page:1}]); 
	        }
			function reload(){
			   location.reload();
	        }
	         
	         //查询
		function gridSearch(){
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var params = {  
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
			};							 
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 $.extend(postData, params);
			jQuery("#gridTable").jqGrid('setGridParam',
			{
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
			}).trigger("reloadGrid", [{page:1}]); 
        } 
        
        function changeState(state){
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
		    if (!ids) {
		    	alert("请先选择记录!");  
				return false;  
			} 
			
	        var operationName;
        	if(state == 2){
        		operationName = '挂起';
        	}else if(state == 3){
        		operationName = '终止';
        	}else if(state == 0){
        		operationName = '恢复';
        	}
        	
			if(!confirm("是否确认"+operationName+"？")){
				return false;
			}
			var params = {};
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			$.ajax({  
				  url : actionUrl,  
			      type : "post", 
			      data : params,  
			      dataType : "json",  
			      cache : false,  
			      error : function(textStatus, errorThrown) {  
			          alert("系统ajax交互错误: " + textSt<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%@ page import="com.tjtt.tdm.base.PubMethod" %>
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
<%
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String type = request.getParameter("type");
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	String captionName = "";
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
	if("0".equals(type)){
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
		captionName = "待发起的试验";
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
	}else if("1".equals(type)){
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
		captionName = "已完成的试验";
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
	}else if("2".equals(type)){
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
		captionName = "正在进行的试验";
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
	}else if("3".equals(type)){
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
		captionName = "已终止的试验";
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
	}else if("5".equals(type)){
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
		captionName = "已挂起的试验";
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	}else{
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
	}
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>
%>




































<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">   
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
	<head>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<%@ include file="../jslib/jquerylib.jsp" %>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/js/base/jquery.form.js"></script>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
		<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
				<script type='text/javascript' src="<%=request.getContextPath() %>/jslib/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         var api = frameElement.api;
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         if (api!=undefined)
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         {
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         	var W = api.opener;
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
         }
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
        </script>
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         <c:if test="${requestScope.message != null}">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         	<script type="text/javascript">
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
         		 alert("<c:out value='${requestScope.message}'></c:out>");
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 api.close();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         	 W.reload();
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
	         </script>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
         </c:if>
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
		<script type="text/javascript">
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){
			 $(document).ready(function(){




































				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
				$("#gridTable").jqGrid({
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>',
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					datatype: "json",
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					height: 500,
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					autowidth: true, 
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colNames:['主键','<fmt:message key="shiyanchul">','流程名称','<fmt:message key="shiyanchul">id','流程状态id','流程状态','操作类型','实体ID','','','','','最近操作人','','最近操作时间'],
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
					colModel:[
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'ID',index:'ID', width:40,key:true,sorttype:"int",hidden:true,hidedlg:true}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOWTYPENAME',index:'FLOWTYPENAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_NAME',index:'FLOW_NAME', width:210}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_TYPE_ID',index:'FLOW_TYPE_ID', width:140,hidden:true,hidedlg:true}, 
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_ID',index:'FLOW_STATE_ID', width:170,hidden:true,hidedlg:true},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_STATE_NAME',index:'FLOW_STATE_NAME', width:200},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'FLOW_ACTION_TYPE',index:'FLOW_ACTION_TYPE', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'INSTANCE_ID',index:'INSTANCE_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_ID',index:'NEXT_ROLES_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_ROLES_NAME',index:'NEXT_ROLES_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_ID',index:'NEXT_USERS_ID', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'NEXT_USERS_NAME',index:'NEXT_USERS_NAME', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_NAME',index:'ADD_USER_NAME', width:100},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'ADD_USER_ID',index:'ADD_USER_ID', width:150,hidden:true,hidedlg:true},
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
						{name:'operatortime',index:'operatortime', width:150, align:"center"}
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					],   
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					shrinkToFit:false,
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortname:'ID',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					sortorder:'desc',
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					viewrecords:true,
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiselect: true, // 是否显示复选框
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					multiboxonly : true, 
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					rownumbers: false,//显示行号
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					editable:true, 
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					rowList:[15,20,50,200,500],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					toolbar: [false,"top"],
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
					jsonReader: {
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						root:"rows",		// 数据行（默认为：rows）
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						page: "page",  	// 当前页
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						total: "total",  // 总页数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						records: "records",  // 总记录数
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
						repeatitems : false		// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					pager:"#gridPager",
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
					caption: "<%=captionName%>"
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
				 jQuery("#gridTable").jqGrid('navGrid','#gridPager',{add:false,edit:false,del:false,search:false,refresh:false});
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
					jQuery("#gridTable").jqGrid('navButtonAdd','#gridPager',
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						{ 	
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						caption: "列状态",                          
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						title: "Reorder Columns",                           
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						onClickButton : function (){                               
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						jQuery("#gridTable").jqGrid('columnChooser');                           
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
						}
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
					}); 
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			});
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
			function showView(){
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	        	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				if (!ids) {
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    alert("请先选择记录!");  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				    return false;  
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
				if(ids.indexOf(",")!=-1){
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
					  alert("只能选择一条记录!");  
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				      return false; 
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				}
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var row = jQuery("#gridTable").jqGrid('getRowData',ids);//获取选中行.
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				var id = row.ID;//获取选中行的id属性
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
				 $.dialog({
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        id:'codereviewnext',
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        title:row.FLOWNAME, 
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        content:'url:<%=path %>/workflowAction!viewFlowinfo.action?flowtaskid='+ id+'&flowtypeid='+row.FLOW_TYPE_ID+'&stateid='+row.FLOW_STATE_ID,
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        okVal:false,//确定按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        cancelVal:false,//取消按钮文字
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        min:true, //是否显示最小化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        max:false,//是否显示最大化按钮
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        fixed:false,//开启静止定位
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        lock:true,//开启锁屏 
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        focus:true,//弹出窗口后是否自动获取焦点（4.2.0新增）
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        time:null,//设置对话框显示时间
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        resize:true,//是否允许用户调节尺寸
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        drag:true,//是否允许用户拖动位置
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        cache:false,//是否缓存iframe方式加载的窗口内容页
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        width: '1050px',
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        height: 650,
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        close: function(){
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	window.parent.document.documentElement.scrollTop=0;
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        	gridSearch();
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
					        }
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
			        });
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
	        
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
	        //刷新页面
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			function shuaXin(){
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			 //  document.location.href='haslaunched_worklist.jsp'; 
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
			  jQuery("#gridTable").jqGrid('setGridParam',
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                    {
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                        url:'waitWork.action'
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
                    }).trigger("reloadGrid", [{page:1}]); 
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			function reload(){
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
			   location.reload();
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	        }
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
	         //查询
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
		function gridSearch(){
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOWNAME = jQuery("#FLOWNAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var FLOW_NAME = jQuery("#FLOW_NAME").val();
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
			var params = {  
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOWNAME" : encodeURIComponent($.trim(FLOWNAME)),
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
	            "FLOW_NAME" : encodeURIComponent($.trim(FLOW_NAME))
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			};							 
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 var postData = $("#gridTable").jqGrid("getGridParam", "postData");
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			 $.extend(postData, params);
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			jQuery("#gridTable").jqGrid('setGridParam',
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
			{
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
				url:'workflowAction!queryWaitExperientWorkExec.action?type=<%=type%>'
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
			}).trigger("reloadGrid", [{page:1}]); 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        } 
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
        function changeState(state){
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
			var ids = $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    if (!ids) {
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
		    	alert("请先选择记录!");  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
				return false;  
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			} 
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
	        var operationName;
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        	if(state == 2){
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        		operationName = '挂起';
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        	}else if(state == 3){
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        		operationName = '终止';
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        	}else if(state == 0){
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        		operationName = '恢复';
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	}
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
			if(!confirm("是否确认"+operationName+"？")){
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
				return false;
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var params = {};
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			var actionUrl = "<%=request.getContextPath() %>/workflowAction!changeFlowTaskState.action?state="+state+"&ids="+ids;
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
			$.ajax({  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
				  url : actionUrl,  
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      type : "post", 
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      data : params,  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      dataType : "json",  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      cache : false,  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			      error : function(textStatus, errorThrown) {  
			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt			          alert("系统ajax交互错误: " + textSt