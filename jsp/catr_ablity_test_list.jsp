<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">  
<head>   
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />   
<title>消息列表</title>  
<c:if test="${requestScope.msg!=null}">
			<script type="text/javascript">
	  	 		     alert('<c:out value="${requestScope.msg}"></c:out>');
	  	 		     window.close();
	  			</script>
</c:if>
<%@ include file="../jslib/jquerylib.jsp" %> 
<link href="<%=request.getContextPath() %>/web/style/layout.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="<%=request.getContextPath() %>/jslib/lhgdialog/lhgcore.lhgdialog.min.js?skin=mac"></script>
<style>
body {   
    font-family:"Microsoft YaHei"; font-size:14px;;   
    
}  
.html{
	overflow:scroll;
	overflow-x:hidden;
}
 
.button{font-size:12px;height:21px;color:#000;padding-left:14px;padding-right:14px;border:solid 1px #4183CF;background-image:url(../images/button.gif); background-repeat:repeat-x;}
</style>  
 <script type="text/javascript">
         var api = frameElement.api;
         if (api!=undefined)
         {
         	var W = api.opener;
         }
        </script>  
<script type="text/javascript"><!--
    /**
 * 初始化消息列表的js
 * @author andrew
 */
$(document).ready(function(){ 
	// 绑定回车事件
	$(document).keypress(function(e) {
		if (e.which == 13) {
			//gridSearch();
			//reSearch();
		} 
	});
 
	  $("#deptName").textbox({onClickButton:function(){
	    	 $.dialog({
	 	        title: '选择部门',
	 	        content:'url:<%=request.getContextPath() %>/view/select_sys_organization.jsp?temp='+Math.round(Math.random()*10000),
	 	        okVal: false,//确定按钮文字
	 	        cancelVal: false,//取消按钮文字
	 	        min: true, //是否显示最小化按钮
	 	        max: false,//是否显示最大化按钮
	 	        fixed: false,//开启静止定位
	 	        lock: true,//开启锁屏
	 	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
	 	        time: null,//设置对话框显示时间
	 	        resize: true,//是否允许用户调节尺寸
	 	        drag: true,//是否允许用户拖动位置
	 	        cache: false,//是否缓存iframe方式加载的窗口内容页
	 	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
	 	        width: '900px',
	 	        height: '480px',
	 	        close: function () { 
	 	        	var returnValue = this.content.document.getElementById("jsonStr").value;
	 	        	if(returnValue){
	 	        		var json = eval('(' + returnValue + ')');
				        $("#deptName").textbox('setValue',json.name);
				        $("#dept").val(json.name);
	   	    		}
	 	        	return true;
	 	        } 
	 		});
	    }}) 
	     $("#productTypeName").textbox({onClickButton:function(){
	    	 $.dialog({
	  	        title: '选择产品类别',
	  	        content:'url:<%=request.getContextPath() %>/view/choose_catr_product_code.jsp?pid=1&temp='+Math.round(Math.random()*10000),
	  	        okVal: false,//确定按钮文字
	  	        cancelVal: false,//取消按钮文字
	  	        min: true, //是否显示最小化按钮
	  	        max: false,//是否显示最大化按钮
	  	        fixed: false,//开启静止定位
	  	        lock: true,//开启锁屏
	  	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
	  	        time: null,//设置对话框显示时间
	  	        resize: true,//是否允许用户调节尺寸
	  	        drag: true,//是否允许用户拖动位置
	  	        cache: false,//是否缓存iframe方式加载的窗口内容页
	  	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
	  	        width: '900px',
	  	        height: '480px',
	  	        close: function () { 
	  	        	var returnValue = this.content.document.getElementById("jsonStr").value;
	  	        	if(returnValue){
	  	        		var json = eval('(' + returnValue + ')');
	  	        		$("#productTypeName").textbox('setValue',json.name);
			           	$("#productType").val(json.id);
	    	    	}
	  	        	return true;
	  	        } 
	  		});
	    }})
	     $("#domainName").textbox({onClickButton:function(){
	    	 var domainid = $("#domain").val();
	    	 $.dialog({
	   	        title: '选择领域代码',
	   	        content:'url:<%=request.getContextPath() %>/view/choose_catr_domain_list.jsp?pid=11111&domainid='+domainid+'&temp='+Math.round(Math.random()*10000),
	   	        okVal: false,//确定按钮文字
	   	        cancelVal: false,//取消按钮文字
	   	        min: true, //是否显示最小化按钮
	   	        max: false,//是否显示最大化按钮
	   	        fixed: false,//开启静止定位
	   	        lock: true,//开启锁屏
	   	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
	   	        time: null,//设置对话框显示时间
	   	        resize: true,//是否允许用户调节尺寸
	   	        drag: true,//是否允许用户拖动位置
	   	        cache: false,//是否缓存iframe方式加载的窗口内容页
	   	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
	   	        		width: '1000px',
	   	    	    	height: '600px',
	   	        close: function () { 
	   	        	var returnValue = this.content.document.getElementById("jsonStr").value;
	   	        	if(returnValue){
	   	        		var json = eval('(' + returnValue + ')');
	   	        		$("#domainName").textbox('setValue',json.name);
			           	$("#domain").val(json.id);
	     	    	}
	   	        	return true;
	   	        } 
	   		});
	    }})
	     $("#zizhiName").textbox({onClickButton:function(){
    	 var zizhi = $("#zizhi").val();
    	 $.dialog({
 	        title: '选择资质类型',
 	        content:'url:<%=request.getContextPath() %>/view/select_catr_zizhi.jsp?id='+zizhi+'&temp='+Math.round(Math.random()*10000),
 	        okVal: false,//确定按钮文字
 	        cancelVal: false,//取消按钮文字
 	        min: true, //是否显示最小化按钮
 	        max: false,//是否显示最大化按钮
 	        fixed: false,//开启静止定位
 	        lock: true,//开启锁屏
 	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
 	        time: null,//设置对话框显示时间
 	        resize: true,//是否允许用户调节尺寸
 	        drag: true,//是否允许用户拖动位置
 	        cache: false,//是否缓存iframe方式加载的窗口内容页
 	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
 	        width: '600px',
 	        height: '480px',
 	        close: function () { 
 	        	var returnValue = this.content.document.getElementById("jsonStr").value;
 	        	if(returnValue){
 	        		var json = eval('(' + returnValue + ')');
			        $("#zizhiName").textbox('setValue',json.name);
			        $("#zizhi").val(json.id);
   	    		}
 	        	return true;
 	        } 
 		});
    }})
      $("#createUserName").textbox({onClickButton:function(){
    	 $.dialog({
 	        title: '选择人员',
 	        content:'url:<%=request.getContextPath() %>/view/choose_organization_users.jsp?userids=&multiple=false&temp='+Math.round(Math.random()*10000),
 	        okVal: false,//确定按钮文字
 	        cancelVal: false,//取消按钮文字
 	        min: true, //是否显示最小化按钮
 	        max: false,//是否显示最大化按钮
 	        fixed: false,//开启静止定位
 	        lock: true,//开启锁屏
 	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
 	        time: null,//设置对话框显示时间
 	        resize: true,//是否允许用户调节尺寸
 	        drag: true,//是否允许用户拖动位置
 	        cache: false,//是否缓存iframe方式加载的窗口内容页
 	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
 	        width: '900px',
 	        height: '500px',
 	        close: function () { 
 	        	var returnValue = this.content.document.getElementById("jsonStr").value;
 	        	if(returnValue){
 	        		var json = eval('(' + returnValue + ')');
			        $("#createUserName").textbox('setValue',json.name);
					$("#createUser").val(json.id);
   	    		}
 	        	return true;
 	        } 
 		});
    }}) 
    
	//高级搜索结束
	 //显示jqGrid数据的方法，和其中设置的一些属性
	$("#gridTable").jqGrid({
		url:'ablity!queryAblityTest.action?status=1&datatype=1',
		datatype: "json",
		height: "500",
		autowidth: true, 
		colNames:['主键','','','能力编号','所属部门','所属地点','标准编号','年号/版本号','标准名称','标准条款号','参数名称','产品类别','领域代码','批准日期','设备id','仪器设备名称','查看设备','检验规程','检测开展日期','认可状态','备注','登记人','登记时间','','数据类型','登记人id'],
		colModel:[
			{name:'id',index:'id', width:150,hidden:true,hidedlg:true}, 
			{name:'myac',index:'myac',width:50,formatter: 
				function(cellvalue, options, rowObject) {
				    if(rowObject.cjr=="<%= request.getSession().getAttribute("TDM_USER_ID").toString() %>")
				    {
            		 return "<a href='#' onclick=updateDomain('"+rowObject.id+"')><font color=blue>修改领域代码</font></a>";
            		}else{
            		 return "";
            		}
  			   }},
  			 {name:'myac1',index:'myac1',width:50,formatter: 
 				function(cellvalue, options, rowObject) {
 				    if(rowObject.cjr=="<%= request.getSession().getAttribute("TDM_USER_ID").toString() %>")
				    {
             		return "<a href='#' onclick=updateEquipment('"+rowObject.id+"','"+rowObject.record_no+"')><font color=blue>修改设备</font></a>";
             		}else{
             		  return "";
             		}
   			   }},
			{name:'record_no',index:'record_no',width:100},
			{name:'org_name',index:'org_name',width:150},
			{name:'location_name',index:'location_name', width:200}, 
			{name:'standardNo',index:'standardNo', width:150},
			{name:'version',index:'version', width:150},
			{name:'standard_cnname',index:'standard_cnname', width:150},
			{name:'sno',index:'sno', width:150},
			{name:'cnname',index:'cnname',width:150 },
			{name:'cn_name',index:'cn_name',width:150 },
			{name:'domain_code',index:'domain_code',width:150},
			{name:'approve_date',index:'approve_date',width:80,hidden:true,hidedlg:true},
			{name:'equipmentid',index:'equipmentid',width:100,hidden:true,hidedlg:true},
			{name:'equipment_name',index:'equipment_name',width:100},
			{name:'myvi',align:'center',index:'myvi',width:50,formatter:viewEquipment},
			{name:'test_proce',index:'test_proce',width:250,hidden:true,hidedlg:true},
			{name:'startdate',align:'left',index:'startdate',width:80},
			{name:'status',index:'status',width:50,hidden:true},
			{name:'remark',index:'remark',width:200,hidden:true,hidedlg:true},
			{name:'create_user',index:'create_user',width:50},
			{name:'create_date',index:'create_date',width:100},
			{name:'domain_id',index:'domain_id',width:100,hidden:true,hidedlg:true},
			{name:'datatype',index:'datatype',width:50},
			{name:'cjr',index:'cjr',width:100,hidden:true,hidedlg:true}
		],
		shrinkToFit:false,
		sortname:'product_type_id,standard_cnname,CNNAME,EQUIPMENT_NAME',
		sortorder:'desc',
		viewrecords:true,
		multiselect: true, // 是否显示复选框
		multiboxonly : true, 
		gridview: true,  //提升速度
// 		toppager: true,    
		rownumbers: true,//显示行号
		rowNum:<%=session.getAttribute("SYS_PAGECOUNT")%>,
		rowList:[15,20,25,50,200,300,1000],
		ondblClickRow:function(rowid,iRow,iCol,e){
			editAblity(rowid);
		},
		//toolbar: [true,"top"],
		jsonReader: {
			root:"rows",		// 数据行（默认为：rows）
			page: "page",  	// 当前页
			total: "total",  // 总页数
			records: "records",  // 总记录数
			repeatitems : false	// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设
		},
		prmNames:{rows:"rows",page:"page",sort:"sidx",order:"sord",search:"search"},
		pager:"#gridPager",
		caption: "能力库列表",
		subGrid: true,  // (1)开启子表格支持  
        subGridRowExpanded: function(subgrid_id, row_id) {  // (2)子表格容器的id和需要展开子表格的行id，将传入此事件函数  
        	var subgrid_table_id;  
            subgrid_table_id = subgrid_id + "_t";   // (3)根据subgrid_id定义对应的子表格的table的id  
            var subgrid_pager_id;  
            subgrid_pager_id = subgrid_id + "_pgr"  // (4)根据subgrid_id定义对应的子表格的pager的id  
            var parentRow = $("#gridTable").jqGrid("getRowData",row_id);
            var isSubEdit = false;
            if(parentRow.cjr=="<%= request.getSession().getAttribute("TDM_USER_ID").toString() %>")
            {
               isSubEdit = true;
            } 
            // (5)动态添加子报表的table和pager  
            $("#" + subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+subgrid_pager_id+"' class='scroll'></div>");   
              
            // (6)创建jqGrid对象  
            $("#" + subgrid_table_id).jqGrid({  
                url: "ablity!queryAcceptStateList.action?id="+row_id,  // (7)子表格数据对应的url，注意传入的contact.id参数  
                datatype: "json",  
                colNames: ['id','资质类型','状态','认可时间','限制说明中文','限制说明英文','备注'], 
                colModel: [  
                    {name:"id",index:"id",width:80,key:true,hidden:true},  
                    {name:"name",index:"name",width:230,
                    	editable: true,
            			edittype:"select",
            			editoptions:{dataUrl:'<%=request.getContextPath() %>/ablity!queryQualificationOption.action'}
                    },  
                    {name:"status",index:"status",width:80}, 
                    {name:"accept_date",index:"accept_date",width:80},
                    {name:"limit_cn",index:"limit_cn",width:280,editable: true,edittype:"textarea", editoptions:{rows:"5",cols:"55"}},
                    {name:"limit_en",index:"limit_en",width:280,editable: true,edittype:"textarea", editoptions:{rows:"5",cols:"55"}},
                    {name:"remark",index:"remark",width:80}
                ],  
                jsonReader: {   // (8)针对子表格的jsonReader设置  
                	root:"rows",		// 数据行（默认为：rows）
        			page: "page",  	// 当前页
        			total: "total",  // 总页数
        			records: "records",  // 总记录数
        			repeatitems : false	// 设置成false，在后台设置值的时候，可以乱序。且并非每个值都得设 
                },  
                sortname:'id',
        		sortorder:'asc',
                viewrecords: true,  
                pager: subgrid_pager_id, 
                height: "100%",  
                rowNum: 10  
           });  
            //checkOnUpdate:true,savekey: [true,13], navkeys: [true,38,40], checkOnSubmit : true,
            jQuery("#"+subgrid_table_id).jqGrid('navGrid','#'+subgrid_pager_id,
            		{view:false,search:false,del:isSubEdit,edit:isSubEdit,add:isSubEdit},  //options  {view:true, del:false}, //启用查看按钮，禁用删除按钮
            		{height:290,width:690,reloadAfterSubmit:true, jqModal:true, closeOnEscape:true, closeAfterEdit: true,
            			url: "ablity!saveLimit.action?flag=edit"}, // edit options
            		{height:290,width:690,reloadAfterSubmit:true,jqModal:true, closeOnEscape:true, closeAfterAdd: true,addedrow:'last',
            			url: "ablity!saveLimit.action?flag=add&ablityid="+row_id}, // add options
            		{reloadAfterSubmit:false,jqModal:false, closeOnEscape:true,
            			url: "ablity!saveLimit.action?flag=del"}, // del options
            		{closeOnEscape:false}, // search options
            		{height:250,jqModal:false,closeOnEscape:true} // view options
            		);
       }  
	});
}); 	
function updateDomain(rowid){
	var rowData = $('#gridTable').jqGrid('getRowData',rowid);
	 $.dialog({
	        title: '选择领域代码',
	        content:'url:<%=request.getContextPath() %>/view/choose_catr_domain_list.jsp?pid=11111&domainid='+rowData.domain_id+'&temp='+Math.round(Math.random()*10000),
	        okVal: false,//确定按钮文字
	        cancelVal: false,//取消按钮文字
	        min: true, //是否显示最小化按钮
	        max: false,//是否显示最大化按钮
	        fixed: false,//开启静止定位
	        lock: true,//开启锁屏
	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
	        time: null,//设置对话框显示时间
	        resize: true,//是否允许用户调节尺寸
	        drag: true,//是否允许用户拖动位置
	        cache: false,//是否缓存iframe方式加载的窗口内容页
	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
      		width: '1000px',
  	    	height: '600px',
	        close: function () { 
	        	var returnValue = this.content.document.getElementById("jsonStr").value;
	        	if(returnValue){
	        		var json = eval('(' + returnValue + ')');
		           	var params = {
	        			"domain" : json.id,
	        			"domainName" : json.name,
	        			"id" : rowid,
	        			"type" : '1',
	        			"flag" : 'domain'
	        		};
	        		// alert(1);
	        		var actionUrl = "<%=request.getContextPath() %>/ablity!saveLimit.action";
	        		$.ajax({
	        			url : actionUrl,
	        			type : "post",
	        			data : params,
	        			dataType : "json",
	        			cache : false,
	        			success : function(data, textStatus) {
	        				if (data.success == "true") {
	        					jQuery("#gridTable").jqGrid('setGridParam',
      							{
      							url:'ablity!queryAblityTest.action?status=1&datatype=1'
      							}).trigger("reloadGrid", [{page:1}]); 
	        				} else {
	        					alert("保存失败,请重试!");
	        				}
	        			}
	        		});
	 	    	}
	        	return true;
	        } 
		});
}
function updateEquipment(rowid,record_no){
	var chargeDept='${sessionScope.USER_DEPT_NAME }';
	var rowData = $('#gridTable').jqGrid('getRowData',rowid);
	var equipids = rowData.equipmentid;
	var ablityid= rowid;
	 $.dialog({
	        title: '选择设备',
	        content:'url:<%=request.getContextPath() %>/view/choose_equipment_dept.jsp?isedit=true&ablityid='+ablityid+'&ablityno='+record_no+'&chargeDept='+chargeDept+'&equipmentid='+equipids+'&temp='+Math.round(Math.random()*10000),
	        okVal: false,//确定按钮文字
	        cancelVal: false,//取消按钮文字
	        min: true, //是否显示最小化按钮
	        max: false,//是否显示最大化按钮
	        fixed: false,//开启静止定位
	        lock: true,//开启锁屏
	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
	        time: null,//设置对话框显示时间
	        resize: true,//是否允许用户调节尺寸
	        drag: true,//是否允许用户拖动位置
	        cache: false,//是否缓存iframe方式加载的窗口内容页
	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
      		width: '1000px',
  	    	height: '600px',
	        close: function () { 
	        	var returnValue = this.content.document.getElementById("jsonStr").value;
	        	if(returnValue){
	        		var json = eval('(' + returnValue + ')');
		           	var params = {
	        			"equipmentid" : json.id,
	        			"equipmentName" : json.name,
	        			"id" : rowid,
	        			"type" : '1',
	        			"flag" : 'equipment'
	        		};
	        		// alert(1);
	        		var actionUrl = "<%=request.getContextPath() %>/ablity!saveLimit.action";
	        		$.ajax({
	        			url : actionUrl,
	        			type : "post",
	        			data : params,
	        			dataType : "json",
	        			cache : false,
	        			success : function(data, textStatus) {
	        				if (data.success == "true") {
	        					jQuery("#gridTable").jqGrid('setGridParam',
      							{
      							url:'ablity!queryAblityTest.action?status=1&datatype=1'
      							}).trigger("reloadGrid", [{page:1}]); 
	        				} else {
	        					alert("保存失败,请重试!");
	        				}
	        			}
	        		});
	 	    	}
	        	return true;
	        } 
		});
}
function viewEquipment(cellvalue, options, rowObject){
	var rowid = rowObject.id;
    return "<a href='#' onclick=viewChooseEquipment('"+rowid+"')>查看</a>";
}
function viewChooseEquipment(rowid){
	var rowData = $('#gridTable').jqGrid('getRowData',rowid);
	var equipmentid =  rowData.equipmentid;
	if(equipmentid=="" || equipmentid == null){
		alert("没有选择设备");
		return false;
	}
	 var ablityid= rowid;
	 var recordno = rowData.record_no;
	 $.dialog({
	        title: '选择设备',
	        content:'url:<%=request.getContextPath() %>/view/choose_equipment_dept.jsp?isedit=false&ablityid='+ablityid+'&ablityno='+recordno+'&equipmentid='+equipmentid+'&temp='+Math.round(Math.random()*10000),
	        okVal: false,//确定按钮文字
	        cancelVal: false,//取消按钮文字
	        min: true, //是否显示最小化按钮
	        max: false,//是否显示最大化按钮
	        fixed: false,//开启静止定位
	        lock: true,//开启锁屏
	        focus: true,//弹出窗口后是否自动获取焦点（4.2.0新增）
	        time: null,//设置对话框显示时间
	        resize: true,//是否允许用户调节尺寸
	        drag: true,//是否允许用户拖动位置
	        cache: false,//是否缓存iframe方式加载的窗口内容页
	        zIndex:W==null?1976:W.$.dialog.setting.zIndex+1,
	        width: '1000px',
  	    	height: '600px',
	        close: function () { 
	        	var returnValue = this.content.document.getElementById("jsonStr").value;
	        	if(returnValue){
	        		var json = eval('(' + returnValue + ')');
	        	//	jQuery("#gridTable").jqGrid('setRowData', rowid, { equipmentid: json.id, equipmentname: json.name });
//	        		$("#gridTable").jqGrid('setCell',rowid,3,json.id); 
//	        		$("#gridTable").jqGrid('setCell',rowid,4,json.name); 
	    	}
	        	return true;
	        } 
		});
}
//添加标准
function addAblity(){
	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	$.dialog({
        id:'add',
        title:"添加检测能力", 
        content:'url:<%=request.getContextPath() %>/ablity!gotoAddAblity.action?id='+ids,
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
        height: 1350,
        close: function(){
        	refresh();
        }
});
}
function editAblity(rowid){
	$.dialog({
        id:'add',
        title:"查看能力", 
        content:'url:<%=request.getContextPath() %>/ablity!gotoUpdateAbility.action?id='+rowid,
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
        height: 850,
        close: function(){
        }
});
} 
function delAblity(){
	var ids= $("#gridTable").jqGrid("getGridParam", "selarrrow") + "";
	if (!ids) {
	    alert("请先选择记录!");  
	    return false;  
	}
	//判断 是否能够删除 必须 数据创建人 =  登陆人。
	var arr = ids.split(",");
	for(var i=0;i<arr.length;i++)
	{
	   var row_id = arr[i];
	   var rowData = $("#gridTable").jqGrid("getRowData",row_id); 
       if(rowData.cjr!="<%= request.getSession().getAttribute("TDM_USER_ID").toString() %>" && '<%= request.getSession().getAttribute("TDM_USER_ID").toString() %>' !='5286')
       {
               alert("您不是编号为‘"+rowData.record_no+"’的能力数据的登记者，您没有权限删除！ ");
               return false;
       }
	}
	 
	if(!confirm("确定要删除吗？")){
		return false;
	}
	var params = {
			"ids" : ids
		};
		// alert(1);
		var actionUrl = "<%=request.getContextPath() %>/ablity!deleteAbility.action";
		$.ajax({
			url : actionUrl,
			type : "post",
			data : params,
			dataType : "json",
			cache : false,
			success : function(data, textStatus) {
				if (data.ajaxResult == "success") {
					refresh();    
					alert("删除成功！");
				} else {
					alert("删除失败,请重试!");
				}
			}
		});
} 
function changeAblity(){
	$.dialog({
        id:'add',
        title:"添加能力", 
        content:'url:<%=request.getContextPath() %>/ablity!gotoAblityChange.action',
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
        height: 1350,
        close: function(){
        	refresh();
        }
	});
}
function refresh(){
	var locationId = $("#locationId").combobox('getValue');
	var isRenke = $("#isRenke").combobox('getValue');
	var standardcnname = $('#standardcnname').textbox('getValue');
	var paramno = $('#paramno').textbox('getValue');
	var paramversion = $('#paramversion').textbox('getValue');
	var paramname = $('#paramname').textbox('getValue');
	var productType = $('#productType').val();
	var dept = $('#dept').val();
	var domain = $('#domain').val();
	var zizhi = $('#zizhi').val();
	var createUser = $('#createUser').val();
	var date1 = $('#date1').textbox('getValue');
	var date2 = $('#date2').textbox('getValue');
	var date3 = $('#date3').textbox('getValue');
	var date4 = $('#date4').textbox('getValue');
	var RECORD_NO  = $('#RECORD_NO').textbox('getValue');
	var params = {
			"locationId" : encodeURIComponent(locationId),
			"standardcnname" : encodeURIComponent(standardcnname),
			"paramno" : encodeURIComponent(paramno),
			"paramversion" : encodeURIComponent(paramversion),
			"paramname" : encodeURIComponent(paramname),
			"productType" : productType,
			"dept" : encodeURIComponent(dept),
			"domain" : domain,
			"zizhi" : zizhi,
			"createUser" : createUser,
			"date1" : date1,
			"date2" : date2,
			"date3" : date3,
			"date4" : date4,
			"RECORD_NO" : RECORD_NO,
			"isRenke" : isRenke
	};
	var postData = $("#gridTable").jqGrid("getGridParam", "postData");
	$.extend(postData, params);  //(9)将postData中的查询参数覆盖为空值
	jQuery("#gridTable").jqGrid('setGridParam',
	{
	url:'ablity!queryAblityTest.action?status=1&datatype=1'
	}).trigger("reloadGrid", [{page:1}]); 
}
function resetData(){
	$("#locationId").combobox("setValue",'');
	$("#isRenke").combobox("setValue",'');
	$('#standardcnname').textbox("setValue",'');
	$('#paramno').textbox("setValue",'');
	$('#paramversion').textbox("setValue",'');
	$('#paramname').textbox("setValue",'');
	$('#productType').val('');
	$('#dept').val('');
	$('#domain').val('');
	$('#productTypeName').textbox("setValue",'');
	$('#deptName').textbox("setValue",'');
	$('#domainName').textbox("setValue",'');
	$('#zizhi').val("");
	$('#zizhiName').textbox("setValue",'');
	$('#createUser').val("");
	$('#createUserName').textbox("setValue",'');
	$('#date1').textbox('setValue','');
	$('#date2').textbox('setValue','');
	$('#date3').textbox('setValue','');
	$('#date4').textbox('setValue','');
	$('#RECORD_NO').textbox('setValue','');
}

   --></script>
</head>  
 <body>  
		<table style="width: 100%;" class="tableCont">
		    
			<tr>
				<td >
					所属地点：
				</td>
				<td>
					<select class="easyui-combobox" name="locationId" id="locationId" 
		    			data-options="editable:false,valueField:'id',textField:'text',multiple:false,value:'',panelHeight:'auto'" 
		    			url='${pageContext.request.contextPath}/system/dictionary!queryDictionary.action?id=150922180452609096'  style="width:230px;height: 26px;">
		    		</select>
				</td>
				<td>
					标准名称：
				</td>
				<td>
					<input class="easyui-textbox" type="text" id="standardcnname" style="width:230px;height: 26px;"/>
				</td>
				<td style="width:150px">
					<a href="javascript:void(0)" class="easyui-linkbutton" onclick="refresh()">&nbsp;&nbsp;&nbsp;查询&nbsp;&nbsp;&nbsp;</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" onclick="resetData()">&nbsp;&nbsp;&nbsp;清空&nbsp;&nbsp;&nbsp;</a>
				</td>
			</tr>
			<tr>
				<td >
					标准编号：
				</td>
				<td>
					<input class="easyui-textbox" type="text" id="paramno" style="width:230px;height: 26px;"/>
				</td>
				<td >
					年号/版本号：
				</td>
				<td>
	    			<input class="easyui-textbox" type="text" name="paramversion" id="paramversion" style="width:230px;height: 26px;"></input>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td >
					标准参数：
				</td>
				<td>
					<input class="easyui-textbox" type="text" id="paramname" style="width:230px;height: 26px;"/>
				</td>
				<td >
					产品类别：
				</td>
				<td>
					 <input type="hidden" name="productType" id="productType"/>
					 <input type="hidden" name="datatype" id="datatype" value="1"/>
	    			<input class="easyui-textbox" type="text" name="productTypeName" id="productTypeName" data-options="buttonText:'选择',prompt:'请选择产品类别',editable:false" style="width:230px;height: 26px;"></input>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td >
					所属部门：
				</td>
				<td>
					<input type="hidden" name="dept" id="dept"/>
	    			<input class="easyui-textbox" type="text" name="deptName" id="deptName" data-options="buttonText:'选择',prompt:'请选择',editable:false" style="width:230px;height: 26px;"></input>
				</td>
				<td >
					领域代码：
				</td>
				<td>
					 <input type="hidden" name="domain" id="domain"/>
	    			<input class="easyui-textbox" type="text" name="domainName" id="domainName" data-options="buttonText:'选择',prompt:'请选择领域代码',editable:false" style="width:230px;height: 26px;"></input>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td >
					资质类型：
				</td>
				<td>
				    
					<input type="hidden" name="zizhi" id="zizhi"/>
	    			<input class="easyui-textbox" type="text" name="zizhiName" id="zizhiName" data-options="buttonText:'选择',prompt:'请选择',editable:false" style="width:230px;height: 26px;"></input>
				</td>
				<td>
					登记时间：
				</td>
				<td>
					 <input type="text" id="date1" name="date1" value=""   class="easyui-datebox" style="width:100px;height: 28px;" />&nbsp;至&nbsp;
	                 <input type="text" id="date2" name="date2" value=""   class="easyui-datebox" style="width:100px;height: 28px;" /></td>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td >
					登记人：
				</td>
				<td>
					<input type="hidden" name="createUser" id="createUser"/>
	    			<input class="easyui-textbox" type="text" name="createUserName" id="createUserName" data-options="buttonText:'选择',prompt:'请选择',editable:false" style="width:230px;height: 26px;"></input>
				</td>
				<td >认可状态：
				</td>
				<td>
				    
					<select class="easyui-combobox" name="isRenke" id="isRenke" 
			    			data-options="editable:false,valueField:'id',textField:'text',multiple:false,value:'',panelHeight:'auto'"  style="width:230px;height: 26px;">
			    			<option value=""></option>
			    			<option value="1">已认可</option>
			    			<option value="2">待认可</option>
			    			<option value="3">已申请</option>
			    			<option value="4">已评审</option>
			    			<option value="5">无</option>
			    		</select>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td >
					能力编号：
				</td>
				<td colspan=3>
					<input class="easyui-textbox" type="text" id="RECORD_NO" name="RECORD_NO" data-options="multiline:true" style="width:230px;height: 35px;"/>
				</td>
				<td >认可时间：
				</td>
				<td>
					<input type="text" id="date3" name="date3" value=""   class="easyui-datebox" style="width:100px;height: 28px;" />&nbsp;至&nbsp;
	                 <input type="text" id="date4" name="date4" value=""   class="easyui-datebox" style="width:100px;height: 28px;" /></td>
				</td>
									 
			 </tr>
			<tr>
				<td height="25" colspan="5" valign="top">
				<a href="javascript:void(0)" class="easyui-linkbutton" id="addAblity" onclick="addAblity()">&nbsp;&nbsp;&nbsp;新增&nbsp;&nbsp;&nbsp;</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" id="delAblity" onclick="delAblity()">&nbsp;&nbsp;&nbsp;删除&nbsp;&nbsp;&nbsp;</a>
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<table id="gridTable"></table>
					<div id="gridPager"></div>
				</td>
			</tr>
		</table>
</body>
</html>
