<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
#login_history_list .admin_num, #login_history_list .admin_name, #login_history_list .admin_level, #login_history_list .excute_date, #login_history_list .MEMBER_NUM {
	text-align:center;
}  
.login_history_wrap {
	font-size:13px;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
	width:30px !important;
	height:30px !important;
	font-size:12px;
}
.find_id_form {
	display:inline-block;
}
.find_name_form {
	margin-left:30px;
	display:inline-block;
}
.find_all_form {
	display:inline-block;
	margin-left:30px;
	cursor:pointer;
}
.typeSelect_form {
	width:260px;
	height:20px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.typeSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
.login_num, .login_time {
   	text-align:center;
}
</style>
<script>
var LoginHisotry = "";
	$(document).ready( function() {
		
		LoginHisotry = $("#login_history_list").DataTable({
			"language": {
	   		    "emptyTable": "등록된 로그인 내역이 없습니다.",
	   			"zeroRecords": "검색된 로그인 내역이 없습니다.",
		        paginate:
		        {
		            previous: "<",
		            next: ">",
		        }	
		    },
		    "serverSide": false,
		    "info": false,
		    "searching": true,
		    "paging" : true,
		    "lengthChange": false,
		    "pageLength": 20,
		    "Filter": true,
		    "dom": 'rtipS',
		    "retrieve" : true,
		    "ordering": false,
			"autoFill": {
		        update: true
		    },
			"ajax": {
			    "url": "/ADM/loginHistory_data",
			    "type": "POST",		 
	 		    "dataSrc":function(json) { 
	 	        	for (var i=0; i<json.data.length; i++) {
	 	        		
		        		if (json.data[i].LOGIN_TYPE == "1" ) {
		        			json.data[i].LOGIN_TYPE_SHOW = "MEMBER_로그인 성공";
		        		} else if ( json.data[i].LOGIN_TYPE == "2" ) {
		        			json.data[i].LOGIN_TYPE_SHOW = "MEMBER_아이디 오류";
		        		} else if ( json.data[i].LOGIN_TYPE == "3") {
		        			json.data[i].LOGIN_TYPE_SHOW = "MEMBER_비밀번호 오류";
		        		} else if ( json.data[i].LOGIN_TYPE == "5") {
		        			json.data[i].LOGIN_TYPE_SHOW = "ADMIN_로그인 성공";
		        		} else if ( json.data[i].LOGIN_TYPE == "6") {
		        			json.data[i].LOGIN_TYPE_SHOW = "ADMIN_아이디 오류";
		        		} else if ( json.data[i].LOGIN_TYPE == "7" ) {
		        			json.data[i].LOGIN_TYPE_SHOW = "ADMIN_비밀번호 오류";
		        		}
		        		
	 	        	}
	 	        	return json.data;
	 		    },
		        error: function (xhr, error, thrown) {
					console.log(xhr);
					console.log(error);
					console.log(thrown);
					if (xhr.readyState == 0) {
						return true;
					}
		        }
		    },
			"columns": [
				{ "width": "5%", className:"login_num", "data": "LOGIN_NUM"},
			    { "width": "2%", className:"MEMBER_NUM", "data": "MEMBER_NUM"},
			    { "width": "0%", className:"login_type", "data": "LOGIN_TYPE", "visible":false },
			    { "width": "10%", className:"login_type", "data": "LOGIN_TYPE_SHOW" },
			    { "width": "6%", className:"login_id", "data": "LOGIN_ID" },
			    { "width": "12%", className:"login_info", "data": "LOGIN_INFO" },
			    { "width": "8%", className:"login_ip", "data": "LOGIN_IP" },
			    { "width": "11%", className:"login_browser", "data": "LOGIN_BROWSER" },
			    { "width": "10%", className:"login_os", "data": "LOGIN_OS" },
			    { "width": "12%", className:"login_time", "data": "LOGIN_TIME" }
			],		
		    "initComplete": function(settings, json) {
			
				$('#find_input').unbind();
				$('#find_input').bind('keyup', function(e) {
					LoginHisotry.column($('#find_type').val()).search( this.value ).draw();
				}); 
				
				var type = this.api().column(3);
		        
				var select = $('<select class="typeSelectBox "><option value="">전체</option>')
				//분류 필터링
				.appendTo('#selectTriggerFilter')
				.on('change', function () {
				   var val = $(this).val();
				   type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
				});
				type.data().unique().sort().each(function (d, j) {
				    select.append('<option value="' + d + '">' + d + '</option>');
				});
				
				//페이지 필터링
//	 			var select = $('<select class="typeSelectBox "><option value="">전체</option>')
//	 			.appendTo('#selectpageFilter')
//	 			.on('change', function () {
//	 			   var val = $(this).val();
//	 			   req_page.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
//	 			});
//	 			req_page.data().unique().sort().each(function (d, j) {
//	 			    select.append('<option value="' + d + '">' + d + '</option>');
//	 			});
			}
		});
	});
</script>
</head>
<body>
	<div class="login_history_wrap">
		<div style="width:100%; text-align:right;">
	<!-- 		<div class="typeSelect_form" id="selectpageFilter"><label><b>페이지 : </b></label></div>  -->
			<div class="typeSelect_form" id="selectTriggerFilter"><label><b>분류 : </b></label></div> 
			<div id="find_type_form" class="find_id_form">
				<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
					<option value="4">ID</option>
					<option value="1">MEMBER_NUM</option>
				</select>
			</div>
			<div id="find_text" class="find_id_form">
				<input id="find_input" type="text" size=20px; style="margin-left:10px;">
			</div>
		</div>
		<div style="position:relative; top:20px;">
			<table id="login_history_list" class="display" cellspacing="0" width="100%;" height="80%;">
			        <thead>
			            <tr style="text-align:left;">
			                <th>번호</th>
			                <th style="text-align:center;">MEMBER<br>NUM</th>
			                <th>&nbsp;</th>
			                <th>분류</th>
			                <th>아이디</th>
			                <th>로그인 정보</th>
			                <th>IP</th>
			                <th>브라우저</th>
			                <th>운영체제</th>
			                <th>시각</th>
			            </tr>
			        </thead>
			</table>
		</div>
	</div>
</body>
</html>