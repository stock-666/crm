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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<%--分页插件--%>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.css"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">
	$(function(){

		// 点击创建按钮，进入创建市场活动的模态窗口
		$("#createActivityBtn").click(function () {
			// 引入日期插件
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			// 给所有者下拉框铺值
			$.ajax({
				url:"workbench/Activity/getUserList",
				type:"get",
				dataType:"json",
				success:function (data) {
					var html = "<option></option>";

					$.each(data,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#create-owner").html(html);
				}
			})
			// 设置默认用户
			var id ="${user.id}";
			$("#create-owner").val(id);
			// 打开创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		})

		// 为保存按钮添加事件
		$("#saveActivity").click(function () {
			// 通过ajax请求进行添加市场活动
			$.ajax({
				url:"workbench/Activity/saveActivity",
				type:"post",
				dataType:"json",
				data:{
					"owner":$("#create-owner").val(),
					"name":$.trim($("#create-name").val()),
					"startDate":$("#create-startDate").val(),
					"endDate":$("#create-endDate").val(),
					"cost":$.trim($("#create-cost").val()),
					"description":$.trim($("#create-description").val())
				},
				success:function (data) {
					if (data.success){
						// 重置表单
						$("#createActivityForm")[0].reset();
						// 刷新市场活动列表,有bootstrap插件提供
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						alert("市场活动创建成功");
						// 关闭市场创建模态窗口
						$("#createActivityModal").modal("hide");
					}else {
						alert(data.msg);
					}
				}
			})
		})
		// 加载页面后访问数据库，展示市场活动列表
		pageList(1,2);
		// 为查询按钮绑定事件
		$("#searchBtn").click(function () {
			// 点击查询按钮时，将查询参数保存到隐藏域中
			$("#hide-name").val($.trim($("#searchName").val()));
			$("#hide-owner").val($.trim($("#searchOwner").val()));
			$("#hide-startDate").val($.trim($("#searchStartTime").val()));
			$("#hide-endDate").val($.trim($("#searchEndTime").val()));
			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

		})
		// 修改按钮添加pageList方法
		// 为删除按钮添加pageList方法
		// 为分页插件添加pageList方法
		// 获取市场活动列表
		function pageList(pageNo,pageSize) {
			// 每次查询的时候，将隐藏域中的值赋给搜索框
			$("#searchName").val($.trim($("#hide-name").val()));
			$("#searchOwner").val($.trim($("#hide-owner").val()));
			$("#searchStartTime").val($.trim($("#hide-startDate").val()));
			$("#searchEndTime").val($.trim($("#hide-endDate").val()));
			$.ajax({
				url:"workbench/Activity/pageList",
				type:"get",
				dataType:"json",
				data:{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"searchName":$.trim($("#searchName").val()),
					"searchOwner":$.trim($("#searchOwner").val()),
					"searchStartTime":$("#searchStartTime").val(),
					"searchEndTime":$("#searchEndTime").val()
				},
				success:function (data) {
					// 插入市场活动列表
					var html = "";
					$.each(data.objList,function (i,n) {
						html +='<tr class="active">';
						html +='<td><input type="checkbox" name="oncheck" value="'+n.id+'"/></td>';
						html +='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'detail.html\';">'+n.name+'</a></td>';
						html +='<td>'+n.owner+'</td>';
						html +='<td>'+n.startDate+'</td>';
						html +='<td>'+n.endDate+'</td>';
						html +='</tr>';
					})
					$("#activityTbody").html(html);
					// 计算总页数
					var totalPages = data.total%pageSize?parseInt(data.total/pageSize)+1:data.total/pageSize;
					// 加入分页组件
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					})
				}
			})

		}
		// 复选框的全选和全不选
		// 给全选框添加事件
		$("#allChecked").click(function () {
			$("input[name=oncheck]").prop("checked",this.checked)
		})
		// 通过复选框的选中个数来控制全选框的选中
		$("#activityTbody").on("click",$("input[name=oncheck]"),function () {
			$("#allChecked").prop("checked",$("input[name=oncheck]").length==$("input[name=oncheck]:checked").length)
		})

		// 为删除按钮绑定事件，点击按钮删除选中的市场活动
		$("#deleteBtn").click(function () {
			// 获取被选中的市场活动对象
			var $activities = $("input[name=oncheck]:checked");
			// 判断市场活动id的个数
			if ($activities.length == 0){
				alert("请选择要删除的市场活动")
			}else {
				if (confirm("是否确定删除选中市场活动")){
					var ids = new Array();
					// 获取选中的市场活动id
					$.each($activities,function (i,n) {
						ids.push(n.value);
					})
					// 发送ajax请求，删除数据
					$.ajax({
						url:"workbench/Activity/delete",
						type:"post",
						dataType:"json",
						traditional:true,
						data:{"ids":ids},
						success:function (data) {
							// 判断是否删除成功
							if (data.success){
								// 成功后刷新列表
								pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
										,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

								// 成功后去除全选
								$("#allChecked").prop("checked",false);
							}else{
								alert(data.msg)
							}
						}
					})
				}
			}
		})

		// 为修改按钮绑定事件，点击按钮打开修改模态窗口，默认加载选中的市场活动信息
		$("#editBtn").click(function () {
			// 判断选中的条数
			var $activitiy = $("input[name=oncheck]:checked");
			if ($activitiy.length ==1){
				var id = $activitiy.val();
				// 引入日期插件
				$(".time").datetimepicker({
					minView: "month",
					language:  'zh-CN',
					format: 'yyyy-mm-dd',
					autoclose: true,
					todayBtn: true,
					pickerPosition: "bottom-left"
				});
				// 获取选中的市场活动信息并铺值
				$.ajax({
					url:"workbench/Activity/edit",
					type:"post",
					dataType:"json",
					data:{"id":id},
					success:function (data) {
						var html = "<option></option>";

						$.each(data.ulist,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						// 给所有者下拉框铺值
						$("#edit-owner").html(html);
						// 给市场活动信息铺值
						$("#edit-id").val(data.activity.id);
						$("#edit-name").val(data.activity.name);
						$("#edit-owner").val(data.activity.owner);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-description").val(data.activity.description);
					}
				})
				// 打开修改市场活动的模态窗口
				$("#editActivityModal").modal("show");
			}else{
				alert("请选择一条需要修改的市场活动")
			}

		})

		// 为修改按钮绑定事件，点击按钮执行update操作
		$("#updateBtn").click(function () {
			// 通过ajax请求进行添加市场活动
			$.ajax({
				url:"workbench/Activity/update",
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
						// 刷新市场活动列表
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						alert("市场修改创建成功");
						// 成功后去除全选
						$("#allChecked").prop("checked",false);
						// 关闭市场创建模态窗口
						$("#editActivityModal").modal("hide");
					}else {
						alert(data.msg);
					}
				}
			})
		})
	})
	
</script>
</head>
<body>
	<input type="hidden" id="hide-name">
	<input type="hidden" id="hide-owner">
	<input type="hidden" id="hide-startDate">
	<input type="hidden" id="hide-endDate">
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createActivityForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveActivity">保存</button>
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
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
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
								<input type="text" class="form-control" id="edit-startDate" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endDate" value="2020-10-20">
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
					<button type="button" class="btn btn-primary" id="updateBtn" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="searchName" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="searchOwner" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="searchStartTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="searchEndTime">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="allChecked"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTbody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
                <div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>