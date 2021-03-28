<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--加入日期插件--%>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		// 页面加载完成后显示备注信息列表
        showRemarkList();
        // 给备注更新按钮添加事件，点击更新按钮后更新备注信息
        $("#updateRemarkBtn").click(updateRemark);
        // 给保存按钮添加事件，点击按钮新建备注信息
        $("#saveRemarkBtn").click(saveRemark);

        // 给市场活动编辑按钮添加事件，点击按钮打开市场活动修改模态窗口，并填充数据
        $("#editActivityBtn").click(editActivity);

        // 为大标题中的更新按钮绑定事件，点击按钮更新市场活动信息
        $("#updateActivityBtn").click(updateActivity);

        // 大标题中的删除按钮绑定事件，点击按钮删除当前市场活动信息
        $("#deleteActivityBtn").click(deleteActivity);
        // 让备注信息图标显示
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })
	})
    // 获取备注信息列表方法
    function showRemarkList() {
        $.ajax({
            url:"workbench/Activity/getRmList",
            type:"get",
            dataType:"json",
            data:{"activityId":"${activity.id}"},
            success:function (data) {
                if (data.success){
                    // 拼接备注信息列表
                    var html = "";
                    $.each(data.rmList,function (i,n) {
                        html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="h'+n.id+'">'+n.noteContent+'</h5>';
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })
                    // 将拼接好的格式添加到备注列表中
                    $("#remarkDiv").before(html);
                }else {
                    alert("备注信息获取失败，请尝试刷新页面！")
                }
            }
        })
    }
    // 给备注信息的删除图标绑定事件，点击图标删除对应备注
    function deleteRemark(id) {
        $.ajax({
            url:"workbench/Activity/deleteRemark",
            type:"post",
            dataType: "json",
            data:{"id":id},
            success:function (data) {
                if (data){
                    $("#"+id).remove();
                }else{
                    alert("备注删除失败！")
                }
            }
        })
    }
    // 给备注信息的修改图标绑定事件，点击图标跳出备注修改的模态窗口
    function editRemark(id) {
	    // 将备注内容noteContent填充
        $("#noteContent").val($("#h"+id).html());
        // 将备注id放入到隐藏标签中
        $("#remarkId").val(id);
	    // 打开模态窗口
        $("#editRemarkModal").modal("show");
    }
    // 给备注模态窗口的更新按钮添加事件，点击按钮更新备注信息
    function updateRemark() {
	    var id = $("#remarkId").val();
	    $.ajax({
            url:"workbench/Activity/updateRemark",
            type:"post",
            dataType:"json",
            data:{
                "id":id,
                "noteContent":$.trim($("#noteContent").val())
            },
            success:function (data) {
                if (data.success){
                    // 更改备注内容、修改人、修改时间
                    var aRemark = data.aRemark;
                    $("#h"+id).html(aRemark.noteContent);
                    var html = aRemark.editTime + " 由 "+ aRemark.editBy;
                    $("#s"+id).html(html);
                    // 关闭模态窗口
                    $("#editRemarkModal").modal("hide");
                }else {
                    alert("备注修改失败！")
                }
            }
        })
    }

    // 给保存按钮绑定事件，点击保存按钮，新建备注消息
    function saveRemark() {
	    $.ajax({
            url:"workbench/Activity/saveRemark",
            type:"post",
            dataType:"json",
            data:{
                "noteContent":$.trim($("#remark").val()),
                "activityId":"${avtivity.id}"
            },
            success:function (data) {
                if (data.success){
                    var html = "";
                    var aRemark = data.aRemark;
                    html += '<div id="'+aRemark.id+'" class="remarkDiv" style="height: 60px;">';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id="h'+aRemark.id+'">'+aRemark.noteContent+'</h5>';
                    html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+aRemark.id+'"> '+aRemark.createTime+' 由 '+aRemark.createBy+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+aRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+aRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                    // 在最下面添加一个备注信息
                    $("#remarkDiv").before(html);
                    // 清空文本域汇中的信息
                    $("#remark").val("");
                }else {
                    alert("添加备注信息失败！")
                }
            }
        })
    }
    // 打开模态窗口并填充内容
    function editActivity() {
        // 引入日期插件
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        })
        // 所有者获取下拉列表数据及铺值
        $.ajax({
            url:"workbench/Activity/edit",
            type:"get",
            dataType:"json",
            data:{"id":"${activity.id}"},
            success:function (data) {
                var html = "";
                $.each(data.ulist,function (i,n) {
                    html += "<option value ='"+n.id+"'>"+n.name+"</option>";
                })
                $("#edit-owner").html(html);
                // 将市场活动信息填充到页面中
                $("#edit-id").val(data.activity.id);
                $("#edit-owner").val(data.activity.owner);
                $("#edit-name").val(data.activity.name);
                $("#edit-startDate").val(data.activity.startDate);
                $("#edit-endDate").val(data.activity.endDate);
                $("#edit-cost").val(data.activity.cost);
                $("#edit-description").val(data.activity.description);
            }
        })
	    // 打开市场活动修改模态窗口
        $("#editActivityModal").modal("show");
    }
    // 为更新按钮绑定事件，点击按钮更新市场活动信息
    function updateActivity() {
	    $.ajax({
            url:"workbench/Activity/updateAndGet",
            type:"post",
            dataType:"json",
            data:{
                "id":$("#edit-id").val(),
                "owner":$("#edit-owner").val(),
                "name":$.trim($("#edit-name").val()),
                "startDate":$("#edit-startDate").val(),
                "endDate":$("#edit-endDate").val(),
                "cost":$.trim($("#edit-cost").val()),
                "description":$.trim($("#edit-description").val())
            },
            success:function (data) {
                if (data.success){
                    // 更改信息
                    var activity = data.activity;
                    var html = "市场活动-"+activity.name+"<small> "+activity.startDate+" ~ "+activity.endDate+"</small>";
                    $("#activityName1").html(html);
                    $("#activityOwner").html(activity.owner);
                    $("#activityName2").html(activity.name);
                    $("#activityStart").html(activity.startDate);
                    $("#activityEnd").html(activity.endDate);
                    $("#activityCost").html(activity.cost);
                    $("#activityCB").html(activity.createBy);
                    $("#activityCT").html(" "+activity.createTime);
                    $("#activityEB").html(activity.editBy);
                    $("#activityET").html(" "+activity.editTime);
                    $("#activityDescription").html(activity.description);
                    // 关闭市场创建模态窗口
                    $("#editActivityModal").modal("hide");
                }else {
                    alert(data.msg);
                }
            }
        })
    }
    // 删除当前市场活动，并返回市场活动列表页
    function deleteActivity() {
        $.ajax({
            url:"workbench/Activity/delete",
            type:"post",
            dataType:"json",
            data:{"id":"${activity.id}"},
            success:function (data) {
                if (data.success){
                    window.location.href="workbench/activity/index.jsp";
                }else {
                    alert("市场活动删除失败！");
                }
            }
        })
    }
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">
                        <input type="hidden" id="edit-id">
                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
                                    <%--<option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>--%>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startDate" readonly>
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endDate" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="location='workbench/activity/index.jsp'"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="activityName1">市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="activityOwner">${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityName2">${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="activityStart">${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityEnd">${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="activityCost">${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="activityCB">${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="activityCT">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="activityEB">${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="activityET">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="activityDescription">
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>