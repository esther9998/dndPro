<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.adminInfo_wrap table th {
	font-size:13px;
}

.adminInfo_wrap {
	font-size:13px;
}		    
.adminInfo_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
	text-align:center;
}
.dataTables_paginate  {
	margin-top:15px;
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
.adminInfo_wrap .o_kind, .orderInfo_wrap .o_market, .orderInfo_wrap .mem_phone, .orderInfo_wrap .o_trading{
	text-align:center;
}
.delete_admin{
    color: #ED6E02;
    font-size: 11px;
    cursor: pointer;
    font-weight: 600;
}
.change_level{
    color: #ED6E02;
    font-size: 11px;
    cursor: pointer;
    font-weight: 600;
}
.change_password {
    color: #3377bb;
    font-size: 11px;
    cursor: pointer;
    font-weight: 600;
}
.add_admin {
	background-color: #bbbbbb;
    width: 110px;
    height: 30px;
    color: #ffffff;
    font-size: 13px;
    line-height: 30px;
    letter-spacing: 1px;
    text-align: center;
    border: 1px solid #d7d7d7;
    border-radius: 3px;
    margin-left: 20px;
    cursor: pointer;
    font-weight: 600;
}
</style>
<script>
var AdminReviseTable = "";
$(document).ready( function() {
	
	$(document).off('click','#adminInfo td #change_password');
	$(document).off('click','#adminInfo td #change_level');
	$(document).off('click','#adminInfo td #delete_admin');
	$(document).off('click','#add_admin_btn');
	
	$('#adminInfo tbody').off( 'click', 'tr');
	
	AdminReviseTable = $("#adminInfo").DataTable({
		"language": {
   		    "emptyTable": "등록된 관리자가 없습니다.",
   			"zeroRecords": "검색된 관리자가 없습니다.",
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
		    "url": "/ADM/adminInfo",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
	        	
	        		
	        		
	        		if ( json.data[i].ADMIN_USE == "Y" ) {
	        			json.data[i].ADMIN_REVISE = "<span class='change_password' id='change_adminInfo'>[ 수정 ]</span>";
	        			json.data[i].ADMIN_DELETE = "<span class='delete_admin' id='delete_admin'>[ 회원탈퇴 ]</span>";
	        		} else {
	        			json.data[i].ADMIN_REVISE = "";
	        			json.data[i].ADMIN_DELETE = "";
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
			{ "width": "7%", className:"mem_num", "data": "ADMIN_MEMBER_NUM"},
		    { "width": "12%", className:"mem_id", "data": "ADMIN_ID" },
		    { "width": "8%", className:"mem_name", "data": "ADMIN_NAME" },
		    { "width": "6%", className:"mem_name", "data": "ADMIN_LEVEL" },
		    { "width": "6%", className:"mem_name", "data": "ADMIN_USE" },
		    { "width": "12%", className:"mem_name", "data": "ADMIN_REGDATE" },
		    { "width": "12%", className:"mem_name", "data": "ADMIN_LOGINDATE" },
		    { "width": "8%", className:"", "data": "ADMIN_REVISE" },
		    { "width": "6%", className:"", "data": "ADMIN_DELETE" }
		],		
	    "initComplete": function(settings, json) {
		
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				AdminReviseTable.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				AdminReviseTable.column(1).search("").draw();
				AdminReviseTable.column(2).search("").draw();
			}); 
		}
	});
	
	//권한 변경
	 $(document).on('click','#adminInfo td #change_level',function(){
    	var row_data = $(this).closest('tr');
	    ADMIN_MEMBER_NUM = AdminReviseTable.row(row_data).data()['ADMIN_MEMBER_NUM'];
		ADMIN_NAME = AdminReviseTable.row(row_data).data()['ADMIN_NAME'];
		ADMIN_ID = AdminReviseTable.row(row_data).data()['ADMIN_ID'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/change_level" , function() { 
	    	
	    	$("#change_level_close").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#change_level_wrap").empty();
	    	});
	    	
	    	$("#change_level_btn").on('click', function() {
	    		
	    		if ( $("#password").val() == "" ) {
	    			alert("비밀번호를 입력해주세요.");
	    			return;
	    		}
	    		
	    		var confirm_rst = confirm("번호 : " + ADMIN_MEMBER_NUM + "\n이름 : " + ADMIN_NAME + "\nID : " + ADMIN_ID + "\n\n관리자에 대하여 관리권한 변경을 실행하시겠습니까?");
		    	
		    	if ( confirm_rst == false) {
		    		return;
		    	} else {
			    	$("#progresspanel").show();   
				    var url = "/ADM/change_level_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"ADMIN_MEMBER_NUM":ADMIN_MEMBER_NUM,
				    			"ADMIN_LEVEL":$("#level_select").val(),
				    			"ADMIN_PASSWORD":$("#password").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				      				$("#progresspanel").hide();
				    	    		$("#balance_form").hide();	
				    	    		$("#popup_mask").hide();
				    	    		AdminReviseTable.ajax.reload(null, false);
				     			} else if (obj.ResultCode == "1") {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#progresspanel").hide();
				    			return;
				    		}
				    	});
				    	
				    },1000);
		    	}
	    	});
 		});
	 });
	 
	//수정
	 $(document).on('click','#adminInfo td #change_adminInfo',function(){
    	var row_data = $(this).closest('tr');
	    ADMIN_MEMBER_NUM = AdminReviseTable.row(row_data).data()['ADMIN_MEMBER_NUM'];
	    ADMIN_ID = AdminReviseTable.row(row_data).data()['ADMIN_ID'];
	    ADMIN_NAME = AdminReviseTable.row(row_data).data()['ADMIN_NAME'];
	    ADMIN_LEVEL = AdminReviseTable.row(row_data).data()['ADMIN_LEVEL'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/change_adminInfo/"+ADMIN_MEMBER_NUM , function() { 

	    	$("#change_adminInfo_close").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#change_adminInfo_wrap").empty();
	    	});
	    	
		    $("#change_adminInfo_btn").on('click', function() {
	    		
		    	if ( $("#password").val() == "" ) {
	    			alert("관리자 비밀번호를 입력해주세요.");
	    			return;
	    		}
	    		
	    		var confirm_rst = confirm("번호 : " + ADMIN_MEMBER_NUM + "\n이름 : " + ADMIN_NAME + "\nID : " + ADMIN_ID + "\n\n관리자에 대하여 비밀번호 변경을 실행하시겠습니까?");
		    	
		    	if ( confirm_rst == false) {
		    		return;
		    	} else {
			    	$("#progresspanel").show();   
				    var url = "/ADM/change_adminInfo_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"ADMIN_MEMBER_NUM":ADMIN_MEMBER_NUM,
				    			"CHANGE_PASSWORD":$("#admin_password").val(),
				    			"ADMIN_PASSWORD":$("#password").val(),
				    			"ADMIN_LEVEL":$("#level_select").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				      				$("#progresspanel").hide();
				    	    		$("#balance_form").hide();	
				    	    		$("#popup_mask").hide();
				    	    		AdminReviseTable.ajax.reload(null, false);
				     			} else if (obj.ResultCode == "1") {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#progresspanel").hide();
				    			return;
				    		}
				    	});
				    	
				    },1000);
		    	}
	    	});
 		});
	 });
	
	//회원탈퇴
	 $(document).on('click','#adminInfo td #delete_admin',function(){
    	var row_data = $(this).closest('tr');
	    ADMIN_MEMBER_NUM = AdminReviseTable.row(row_data).data()['ADMIN_MEMBER_NUM'];
	    ADMIN_ID = AdminReviseTable.row(row_data).data()['ADMIN_ID'];
	    ADMIN_NAME = AdminReviseTable.row(row_data).data()['ADMIN_NAME'];
	    
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/delete_admin" , function() { 
	    	
	    	$("#delete_admin_close").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#delete_admin_wrap").empty();
	    	});
	    	
			$("#delete_admin_btn").on('click', function() {
	    		
	    		if ( $("#delete_desc").val() == "") {
	    			alert("탈퇴사유를 입력해주세요.");
	    			return;
	    		}
	    		
		    	if ( $("#password").val() == "" ) {
	    			alert("비밀번호를 입력해주세요.");
	    			return;
	    		}
	    		
	    		var confirm_rst = confirm("번호 : " + ADMIN_MEMBER_NUM + "\n이름 : " + ADMIN_NAME + "\nID : " + ADMIN_ID + "\n\n관리자에 대하여 회원탈퇴 실행하시겠습니까?");
		    	
		    	if ( confirm_rst == false) {
		    		return;
		    	} else {
			    	$("#progresspanel").show();   
				    var url = "/ADM/delete_admin_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"ADMIN_MEMBER_NUM":ADMIN_MEMBER_NUM,
				    			"DELETE_REASON":$("#delete_desc").val(),
				    			"ADMIN_PASSWORD":$("#password").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				      				$("#progresspanel").hide();
				    	    		$("#balance_form").hide();	
				    	    		$("#popup_mask").hide();
				    	    		AdminReviseTable.ajax.reload(null, false);
				     			} else if (obj.ResultCode == "1") {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#progresspanel").hide();
				    			return;
				    		}
				    	});
				    	
				    },1000);
		    	}
	    	});
 		});
	 });
	
	//관리자 등록
	 $(document).on('click','#add_admin',function(){
			
	 	var id_chk_result = "";
	 	
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/add_admin" , function() { 
	    	
	    	$("#add_admin_close").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#add_admin_wrap").empty();
	    	});
	    	
	    	//중복 확인
	    	$("#id_chk").on('click', function() {
	    	
	    		$("#progresspanel").show();
	    		
		    	if(id_chk_result == true) {
			   		 $("#admin_id").attr("disabled",false); //비활성화
			   		 $("#id_chk").text("[ 중복확인 ]");
			   		 id_chk_result = false;
			   		 $("#progresspanel").hide();
			   		 return;
		   		} 
		    	
	    		var url="/ADM/id_chk_process";
	    		 setTimeout(function(){
			    	$.ajax({
			    		type:"POST",
			    		url:url,
			    		async:false,
			    		dataType : 'json',
			    		data: {
				    		"ADMIN_ID":$("#admin_id").val()
			    		},
			    		success:function(obj) { //가져오는 값(변수)
			     			if (obj.ResultCode == "0") {
			     				alert(obj.Data); 
			     				id_chk_result = true;
			     				$("#id_chk").text("[ 수정 ]");
			     				$("#admin_id").attr("disabled",true); //비활성화
			     				$("#progresspanel").hide();
			     			} else if (obj.ResultCode == "1") {
			     				alert(obj.Data);
			     				$("#progresspanel").hide();
			     				location.href="/ADM/loginPage";
			     				id_chk_result = false;
			     			} else {
			     				alert(obj.Data);
			     				id_chk_result = false;
			     				$("#progresspanel").hide();
			     				return;
			     			}
			    		},
			    		error:function(e) { //500 ERR
			    			//서버내부오류
			    			alert("잠시 후 시도해주세요.");
			    			$("#progresspanel").hide();
			    			id_chk_result = false;
			    			return;
			    		}
			    	});
			    },1000);
	    	});
	    	
	    	//회원가입
	    	$("#add_admin_btn").on('click', function() {
	    		if ( $("#admin_id").val() == "") {
	    			alert("아이디를 입력해주세요.");
	    			return;
	    		}
	    		
		    	if ( $("#admin_name").val() == "" ) {
	    			alert("이름을 입력해주세요.");
	    			return;
	    		}
		    	
		    	if ( $("#admin_password").val() == "" ) {
	    			alert("비밀번호를 입력해주세요.");
	    			return;
	    		}
		    	
		    	if ( $("#admin_password_chk").val() == "" ) {
	    			alert("비밀번호 확인을 입력해주세요.");
	    			return;
	    		}
		    	
		    	if ( $("#password").val() == "" ) {
	    			alert("관리자 비밀번호를 입력해주세요.");
	    			return;
	    		}
	    		
		    	if ( id_chk_result == false) {
		    		alert("중복 체크를 해주시기 바랍니다.");
		    		return;
	    		}
		    	
		    	if ( $("#admin_password_chk").val() != $("#admin_password_chk").val() ) {
		    		alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		    		return;
		    	}
	    		var confirm_rst = confirm("관리자 등록을 실행하시겠습니까?");
		    	
		    	if ( confirm_rst == false) {
		    		return;
		    	} else {
			    	$("#progresspanel").show();   
				    var url = "/ADM/insert_admin_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"TARGET_ADMIN_ID":$("#admin_id").val(),
				    			"TARGET_ADMIN_NAME":$("#admin_name").val(),
				    			"TARGET_ADMIN_PASSWORD":$("#admin_password").val(),
				    			"TARGET_ADMIN_PASSWORD_CHK":$("#admin_password_chk").val(),
				    			"TARGET_ADMIN_LEVEL":$("#level_select").val(),
				    			"ADMIN_PASSWORD":$("#password").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				      				$("#progresspanel").hide();
				    	    		$("#balance_form").hide();	
				    	    		$("#popup_mask").hide();
				    	    		AdminReviseTable.ajax.reload(null, false);
				     			} else if (obj.ResultCode == "1") {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#progresspanel").hide();
				    			return;
				    		}
				    	});
				    	
				    },1000);
		    	}
	    	});
 		});
	 });
	 
	//팝업 닫기
 	$("#Pop_close").on("click", function() {
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#balance_content").empty();
    	$("#change_password_wrap").empty();
    	$("#delete_admin_wrap").empty();
    	$("#add_admin_wrap").empty();
 	});
	
});
</script>
</head>
<body>

<div class="adminInfo_wrap">
	<div style="width:100%;">
		<div style="display:inline-block; text-align:left;">
			<div id="add_admin" class="add_admin">관리자 등록</div>
		</div>
		<div style="position:absolute; display:inline-block; right:0px;">
		<div id="find_type_form" class="find_id_form">
			<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
				<option value="2">이름</option>
				<option value="1">ID</option>
			</select>
		</div>
		<div id="find_text" class="find_id_form">
			<input id="find_input" type="text" size=20px; style="margin-left:10px;">
		</div>
		</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="adminInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>ID</th>
		                <th>이름</th>
		                <th>관리 권한</th>
		                <th>사용중</th>
		                <th>가입 날짜</th>
		                <th>마지막 로그인</th>
		                <th></th>
		                <th></th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>

</body>
</html>