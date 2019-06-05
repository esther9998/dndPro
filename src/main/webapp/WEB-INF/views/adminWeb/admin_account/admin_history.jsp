<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
#admin_history_list .admin_num, #admin_history_list .admin_name, #admin_history_list .admin_level, #admin_history_list .excute_date {
	text-align:center;
}  
.memberInfo_wrap {
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
.reasonSelect_form {
	width:260px;
	height:20px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.reasonSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
</style>
<script>
var AdminHistory = "";
$(document).ready( function() {
	
	AdminHistory = $("#admin_history_list").DataTable({
		"language": {
   		    "emptyTable": "등록된 내역이 없습니다.",
   			"zeroRecords": "검색된 내역이 없습니다.",
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
		    "url": "/ADM/adminHistory_data",
		    "type": "POST",		 
// 		    "dataSrc":function(json) { 
// 	        	for (var i=0; i<json.data.length; i++) {
	        	
	        		
	        		
// 	        		if ( json.data[i].ADMIN_USE == "Y" ) {
// 	        			json.data[i].ADMIN_REVISE = "<span class='change_password' id='change_adminInfo'>[ 수정 ]</span>";
// 	        			json.data[i].ADMIN_DELETE = "<span class='delete_admin' id='delete_admin'>[ 회원탈퇴 ]</span>";
// 	        		} else {
// 	        			json.data[i].ADMIN_REVISE = "";
// 	        			json.data[i].ADMIN_DELETE = "";
// 	        		}
	        	
// 	        	}
// 	        	return json.data;
// 		    },
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
			{ "width": "6%", className:"admin_num", "data": "ADMIN_MEMBER_NUM"},
		    { "width": "6%", className:"admin_id", "data": "ADMIN_ACCOUNT" },
		    { "width": "6%", className:"admin_name", "data": "ADMIN_NAME" },
		    { "width": "5%", className:"admin_level", "data": "ADMIN_LEVEL" },
		    { "width": "5%", className:"execute_kind", "data": "EXECUTE_KIND" },
		    { "width": "10%", className:"req_page", "data": "REQUEST_PAGE" },
		    { "width": "25%", className:"admin_desc", "data": "ADMIN_DESC" },
		    { "width": "20%", className:"admin_desc", "data": "EXECUTE_REASON" },
		    { "width": "13%", className:"excute_date", "data": "EXECUTE_DATE" }
		],		
	    "initComplete": function(settings, json) {
		
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				AdminHistory.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				AdminHistory.column(1).search("").draw();
				AdminHistory.column(2).search("").draw();
				AdminHistory.column(6).search("").draw();
				AdminHistory.column(7).search("").draw();
			}); 
			
			var type = this.api().column(4);
	        var req_page = this.api().column(5);
	        
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
			
		}
	});
});
</script>
</head>
<body>
<div class="memberInfo_wrap">
	<div style="width:100%; text-align:right;">
<!-- 		<div class="typeSelect_form" id="selectpageFilter"><label><b>페이지 : </b></label></div>  -->
		<div class="typeSelect_form" id="selectTriggerFilter"><label><b>분류 : </b></label></div> 
		<div id="find_type_form" class="find_id_form">
			<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
				<option value="1">ID</option>
				<option value="2">이름</option>
				<option value="6">실행결과</option>
				<option value="7">실행사유</option>
			</select>
		</div>
		<div id="find_text" class="find_id_form">
			<input id="find_input" type="text" size=20px; style="margin-left:10px;">
		</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="admin_history_list" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th style="text-align:center;">관리자<br>번호</th>
		                <th>ID</th>
		                <th>이름</th>
		                <th>권한</th>
		                <th>분류</th>
		                <th>요청 페이지</th>
		                <th>실행 결과</th>
		                <th>실행 사유</th>
		                <th>실행 시간</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>
</body>
</html>