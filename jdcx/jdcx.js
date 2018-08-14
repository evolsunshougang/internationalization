//var array = new Array();
/**
 *查询当前登录人可管理组织机构
 **/
function queryKglZZ(){
	var data = null;
	$.ajax({
      url:"cn.digitaltest.linglong.testmgr.bntestsampleinfobiz.queryKglZZ.biz.ext",
      type:'POST',
      data:null,
      cache:false,
      async:false,
      contentType:'text/json',
      success:function(text){
          var returnJson = nui.decode(text);
          if(returnJson.exception == null){
        	  data = returnJson.str;
          }else{
              nui.alert("保存失败", "系统提示", function(action){
                  if(action == "ok" || action == "close"){
                      //CloseWindow("saveFailed");
                  }
                  });
              }
          }
      });
  return data;
}
/**
 *渲染申请单
 **/
function onAppRenderer(e) {
	var record = e.record;
	var uid = record._uid;
	var s = '<a href="javascript:detialBnTestApplicationByAppId(\'' + uid
			+ '\');">' + e.value + '</a>';
	var levelNum = record.handleLevelNum;
	if(levelNum!=null && levelNum !=""){
		array.push(levelNum);
	}
	return s;
}
/**
 * 方法用途：查询该申请单下的所有样品信息(未领取)
 * 时间：2016-08-18 20:26:11
 * 作者：miaohh
 */
  function queryAllItem(sampleId,handleLevel,handleLevelNum,isFollowItem){
  	var returnData = null;
  	var map={map:{sampleId:sampleId,handleLevelNum:handleLevelNum,
  		handleLevel:handleLevel,isFollowItem:isFollowItem}};
  	var json = nui.encode(map);
     $.ajax({
         url:"cn.digitaltest.linglong.testmgr.bntestsampleinfobiz.QueryBnTestSampleItemLingQu.biz.ext",
         type:'POST',
         data:json,
         cache:false,
         contentType:'text/json',
         async:false,
         success:function(text){
             var returnJson = nui.decode(text);
             if(returnJson.exception){
                 //这里应该调用一个公共的打开窗口方法将异常信息传进去进行显示
                 var message = "code:"+returnJson.exception.code+",message:"+returnJson.exception.message;
                 var status = "1";//已知并自定义
                 openErrorWind(message,status,servpath);
                 return;
             }
             if(returnJson.exception == null){
                 //常规处理调用替下语句即可，如需个性化处理自行处理
                 returnData = returnJson.datas;
             }else{
                 nui.alert("保存失败", "系统提示", function(action){
                     if(action == "ok" || action == "close"){
                         //CloseWindow("saveFailed");
                     }
                 });
             }
         },
         error: function (jqXHR, textStatus, errorThrown) {
             alert(jqXHR.responseText);
         }
     });
     return returnData;
  }
/**
 * 方法用途：渲染样品编号(是否领取使用)
 * 时间：2016-08-18 20:26:11
 * 作者：miaohh
 */
 function ypbhIsObtainRender(e){
 	var record = e.record;
 	var s = '<a class="New_Button" href="javascript:yplqRecord(\''+record.FIELD21+'\')">'+record.FIELD21+'</a>';
 	/*var level = record.handleLevel;
 	var num = record.handleLevelNum;
 	var code = record.FIELD21;
 	var sampleState = record.sampleState;
 	var lsArr = new Array();
	if(sampleState=="20"){
		e.cellStyle = "background : #CCFF00" ;//绿色
	}else if(sampleState=="10"){
		if(level!=null && level !="" && num != null && num != ""){
			var levelArr = record.handleLevel.split("-");
			var allItem = queryAllItem(code,null,null);
			
			if(allItem!=null && allItem.length>0){
				for(var j=0;j<allItem.length;j++){
					if(allItem[j].handleLevel !=null ){
                    	var arrs = allItem[j].handleLevel.split("-");
                    	if(allItem[j].handleLevelNum != null && allItem[j].handleLevelNum!=""){
                    			if(allItem[j].sampleState !="20"){//未领取
                    				if(levelArr[1]>arrs[1]){
                    					e.cellStyle = "background : #FF6A6A" ;//红色
        							}else{//平级
			        					if(record.handleLevelNum*1>allItem[j].handleLevelNum*1){
			        						e.cellStyle = "background : #FF6A6A" ;//红色
			        					}
			        				}
        						}else{//已领取
        							if(levelArr[1]>arrs[1]){
            							if(allItem[j].itemState != "批准通过" && allItem[j].itemState != "申请方申请终止通过" && allItem[j].itemState != "批准中" && allItem[j].itemState !="已完成加工" && allItem[j].itemState !="已完成预处理" 
            								&& allItem[j].itemState != "试验方申请终止中完成"){
            								e.cellStyle = "background : #FF6A6A" ;//红色
		        						}
        							}else{//等级平级
	        							if(record.handleLevelNum>allItem[j].handleLevelNum){
		        							if(allItem[j].itemState != "批准通过" && allItem[j].itemState != "申请方申请终止通过" && allItem[j].itemState != "批准中" && allItem[j].itemState !="已完成加工" && allItem[j].itemState !="已完成预处理" 
		        								&& allItem[j].itemState != "试验方申请终止中完成"){
		        								e.cellStyle = "background : #FF6A6A" ;//红色
			        						}
			        					}
	        						}
	        					}	
    					}else{//顺序为空
    						
						}
    						
                	}else{//等级为空
                		if(allItem[j].sampleState !="20"){//未领取
                			if(record.empId == allItem[j].empId){
        						//if(record.handleLevelNum*1>allItem[j].handleLevelNum*1){
        						//	e.cellStyle = "background : #FF6A6A" ;//红色
        						//}
    						}else{
    							
    						}
    					}else{
    						if(allItem[j].itemState != "批准通过" && allItem[j].itemState != "申请方申请终止通过" && allItem[j].itemState != "批准中" && allItem[j].itemState !="已完成加工" && allItem[j].itemState !="已完成预处理" 
    							&& allItem[j].itemState != "试验方申请终止中完成"){
    							e.cellStyle = "background : #FF6A6A" ;//红色
    						}	
        					
						}
                	}
                }
            }
		}else if(level != null && level != "" && (num==null || num =="")){
			var levelStrs = level.split("-");
			var levelData = queryAllItem(code,null,null);
			if(levelData!= null && levelData.length>0){
    			for(var t=0;t<levelData.length;t++){
    			
    				if(levelData[t].handleLevel != null ){//如有比该等级小的并且未领  则不允许领取
    					if(levelData[t].handleLevelNum != null && levelData[t].handleLevelNum !=""){
    						if(levelData[t].sampleState !="20"){
    							e.cellStyle = "background : #FF6A6A" ;//红色
        					}else{
        						
        						if(levelData[t].itemState != "批准通过" && levelData[t].itemState != "申请方申请终止通过" && levelData[t].itemState != "批准中" && levelData[t].itemState !="已完成加工" && levelData[t].itemState !="已完成预处理" 
        							&& levelData[t].itemState != "试验方申请终止中完成"){
        							e.cellStyle = "background : #FF6A6A" ;//红色
        						}	
	        					
    						}
    					
    					}else{
        					var strs = levelData[t].handleLevel.split("-");
        					
        					if(levelData[t].sampleState !="20"){
        						if(levelStrs[1]*1>strs[1]*1){
        							e.cellStyle = "background : #FF6A6A" ;//红色
        						}
        					}else{
        						if(levelData[t].itemState != "批准通过" && levelData[t].itemState != "申请方申请终止通过" && levelData[t].itemState != "批准中" && levelData[t].itemState !="已完成加工" && levelData[t].itemState !="已完成预处理" 
        							&& levelData[t].itemState != "试验方申请终止中完成"){
        							e.cellStyle = "background : #FF6A6A" ;//红色
        						}	
	        					
    						}
    					}
    					
    				}else{
    					if(levelData[t].sampleState !="20"){
    						//if(levelStrs[1]*1>strs[1]*1){
    							e.cellStyle = "background : #FF6A6A" ;//红色
    						//}
    					}else{
    						if(levelData[t].itemState != "批准通过" && levelData[t].itemState != "申请方申请终止通过" && levelData[t].itemState != "批准中" && levelData[t].itemState !="已完成加工" && levelData[t].itemState !="已完成预处理" 
    							&& levelData[t].itemState != "试验方申请终止中完成"){
    							e.cellStyle = "background : #FF6A6A" ;//红色
    						}	
	    					
    					}
    					
    				}
    			}
			}
				
		}else{
			var retData = queryAllItem(code,null,null);
			if(retData!= null && retData.length>0){
    			for(var n=0;n<retData.length;n++){
    				
    				if(retData[n].handleLevel != null){//同一样品 中既有等级也有无等级的
    					if(retData[n].sampleState !="20"){//未领取
							if(retData[n].itemState != "批准通过" && retData[n].itemState != "申请方申请终止通过" && retData[n].itemState != "批准中" && retData[n].itemState !="已完成加工" && retData[n].itemState !="已完成预处理" 
								&& retData[n].itemState != "试验方申请终止中完成"){
								e.cellStyle = "background : #FF6A6A" ;//红色
    						}
						}else{
    						if(retData[n].itemState != "批准通过" && retData[n].itemState != "申请方申请终止通过" && retData[n].itemState != "批准中" && retData[n].itemState !="已完成加工" && retData[n].itemState !="已完成预处理" 
    							&& retData[n].itemState != "试验方申请终止中完成"){
    							e.cellStyle = "background : #FF6A6A" ;//红色
    						}	
	    					
						}
    				}
    				
				}
			}
		}
	}else{
		
	}*/
 	return s;
 }
 /**
  * 方法用途：渲染样品编号
  * 时间：2016-08-18 20:26:11
  * 作者：miaohh
  */
  function ypbhRender(e){
  	var record = e.record;
  	var s = '<a class="New_Button" href="javascript:yplqRecord(\''+record.FIELD21+'\')">'+record.FIELD21+'</a>';
  	return s;
  }
 
 /**
  * 方法用途：样品领取记录
  * 时间：2016-08-18 20:26:11
  * 作者：miaohh
  */
  function yplqRecord(ypbh){
  	maskwin = nui.open({
			url : servpath+ "/digitaltest/linglong/testmgr/itemobtain/BnTestSampleObtainRecordList.jsp",
			title : "样品领取记录",
			width : clientWidth,
			height : clientHeight,
			showMaxButton : true,
			onload : function() {//弹出页面加载完成
				var iframe = this.getIFrameEl();
				var data = {ypbh:ypbh};//传入页面的json数据
	            iframe.contentWindow.setData(data);
			},
			ondestroy : function(action) {//弹出页面关闭前
				if (action == "saveSuccess") {
				}
			}
		});
  }

/**
 *查看申请单信息
 **/
function detialBnTestApplicationByAppId(uid) {
	var row = grid.getRowByUID(uid);
	maskwin = nui.open({
		url : servpath+ "/digitaltest/linglong/testmgr/bntestapp/jdcx/BnTestApplicationFormJdcx.jsp?appFormFlag=false&itemlist=all&appId="+row.id,
		title : "申请单信息",
		width : clientWidth,
		height : clientHeight,
		showMaxButton : true,
		onload : function() {//弹出页面加载完成
			var iframe = this.getIFrameEl();
			var data = {pageType:"edit",id:row.id};//传入页面的json数据
            iframe.contentWindow.initAppForm(data);
		},
		ondestroy : function(action) {//弹出页面关闭前
			if (action == "saveSuccess") {
			}
		}
	});
}

/**
 * 方法用途：检测项目检测参数结果值单位
 * 参数含义：
 * 时间：2016/07/19
 * 作者：wangyj
 */
function TDM_LINGLONG_JGZDWRender(e){
	var text = nui.getDictText("TDM_LINGLONG_JGZDW",e.value);
	return text;
}


/**
 * 方法用途：结果值类型
 * 参数含义：
 * 时间：2016/07/19
 * 作者：wangyj
 */
function jGZLXRender(e){
	var text = nui.getDictText("TDM_LINGLONG_JGZLX",e.value);
	return text;
}

//上限符号
function sxfh(e)
{
   var dicname = nui.getDictText("IQS_XXYSF",e.value);
   return dicname;
}
//下限符号
function xxfh(e)
{
  var dicname = nui.getDictText("IQS_SXYSF",e.value);
  return dicname;
}
//样品大类
function sampleClass1Render(e)
{
   var name = nui.getDictText("DIC_SAMPLE_CLASS1",e.value);
   return name;
}
//样品小类
function sampleClass2Render(e)
{
  var name = nui.getDictText("DIC_SAMPLE_CLASS2",e.value);
  return name;
}
function levelRender(e){
	var name = nui.getDictText("DIC_HANDLE_LEVEL",e.value);
	return name;
}
//是否
function isSfRender(e){
	var name = nui.getDictText("TDM_BOOLEAN_DIC",e.value);
	return name;
}
//有无内胎
function ywntRender(e){
	var text = nui.getDictText("DIC_YWNT",e.value);
	return text;
}
//规格类型
function GGLXRender(e){
	var text = nui.getDictText("TDM_LINGONG_GGLX",e.value);
	return text;
}
//花纹类型
function hwlxRender(e){
	var text = nui.getDictText("DIC_HWLX",e.value);
	return text;
}
//速度级别
function sdjbRender(e){
	var text = nui.getDictText("TDM_SPEED_SYMBOL",e.value);
	return text;
}
//充气压力单位
function cqyldwRender(e){
	var text = nui.getDictText("TDM_INFLATION_PRESSURE",e.value);
	return text;
}
//负荷单位
function fhdwRender(e){
	var text = nui.getDictText("TDM_LOAD_UNIT",e.value);
	return text;
}
//轮辋名义直径
function lwmyzjRender(e){
	var text = nui.getDictText("TDM_RINODI",e.value);
	return text;
}
//名义断面宽
function mydmkRender(e){
	var text = nui.getDictText("TDM_NSW",e.value);
	return text;
}
//胎体材料
function ttclRender(e){
	var text = nui.getDictText("TDM_MATRIX_MATERIAL",e.value);
	return text;
}

//轮辋类型
function lwlxRender(e){
	var text = nui.getDictText("TDM_LINGLONG_LWLX",e.value);
	return text;
}
//轮辋材质
function lwczRender(e){
	var text = nui.getDictText("TDM_LINGLONG_CZ",e.value);
	return text;
}
//法规类型
function fglxRender(e){
	var text = nui.getDictText("TDM_FGLX",e.value);
	return text;
}
//轮胎分类
function ltflRender(e){
	var text = nui.getDictText("TDM_LTFL",e.value);
	return text;
}
//轮胎/工况类型
function ltgklxRender(e){
	var text = nui.getDictText("DIC_LTGK",e.value);
	return text;
}
/**
 * 方法用途：根据加工项目id查询检测项目的加工项目
 * 时间：2016-08-18 20:26:11
 * 作者：miaohh
 */
  function queryJgItemById(jgxmId){
  	var returnData = null;
  	var map={id:jgxmId};
  	var json = nui.encode({map:map});
     $.ajax({
         url:"cn.digitaltest.linglong.testmgr.bntestsampleinfobiz.queryBnTestSampleItemById.biz.ext",
         type:'POST',
         data:json,
         cache:false,
         contentType:'text/json',
         async:false,
         success:function(text){
             var returnJson = nui.decode(text);
             if(returnJson.exception){
                 //这里应该调用一个公共的打开窗口方法将异常信息传进去进行显示
                 var message = "code:"+returnJson.exception.code+",message:"+returnJson.exception.message;
                 var status = "1";//已知并自定义
                 openErrorWind(message,status,servpath);
                 return;
             }
             if(returnJson.exception == null){
                 //常规处理调用替下语句即可，如需个性化处理自行处理
                 returnData = returnJson.datas;
             }else{
                 nui.alert("保存失败", "系统提示", function(action){
                     if(action == "ok" || action == "close"){
                         //CloseWindow("saveFailed");
                     }
                 });
             }
         },
         error: function (jqXHR, textStatus, errorThrown) {
             alert(jqXHR.responseText);
         }
     });
     return returnData;
  }
