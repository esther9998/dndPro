<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리자</title>
<style>
.memberInfo_wrap table th {
	font-size:13px;
}
.memberInfo_wrap table td {
	font-size:13px;
}
		    
.memberInfo_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
	text-align:center;
}
.email_resend {
	font-size:11px;
	cursor:pointer;
	color:#ED6E02;
	font-weight:600;
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
.memberSelect_form {
	width:250px;
	height:22px;
	position:relative;
	display:inline-block;
	line-height:22px;
	font-size:12px;
	text-align:left;
}
.memberSelectBox{
	width:150px;
	height:100%;
	line-height:20px;
	margin-left:10px;
}
.emailSelect_form {
	width:250px;
	height:22px;
	position:relative;
	display:inline-block;
	line-height:22px;
	font-size:12px;
	text-align:left;
	margin-right:30px;
}
</style>
<script>
var MemberInfoTable = "";
$(document).ready( function() {
	
	$(document).off('click','#memberInfo td #email_resend');
	$(document).off('click','#Pop_close');
	$(document).off('click','#pwd_chk_cancel');
	$(document).off('click','#pwd_chk_btn');
	
	$('#memberInfo tbody').off( 'click', 'tr');
	
	MemberInfoTable = $("#memberInfo").DataTable({
    
	    "language": {
   		    "emptyTable": "등록된 회원이 없습니다.",
   			"zeroRecords": "검색된 회원이 없습니다.",
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
// 	    "dom": 'BrtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
// 	    buttons: [
// 	    	{
// 	         	text: 'Excel',
// 	    		extend: 'excelFlash',
// 	            filename: 'CONCO_회원정보'
// 	        }
// 	    ],
		"ajax": {
		    "url": "/ADM/memberInfo",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
		    	
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].EMAIL_RESEND = "";
	        		
	        		if ( json.data[i].AUTH_AVAIL == "N" && json.data[i].MEMBER_USE == "Y") {
	        			json.data[i].EMAIL_RESEND = "<span class='email_resend' id='email_resend'> [ 이메일 재전송 ] </span>";
	        		}
	        		
	        		json.data[i].MEMBER_LOGINDATE = json.data[i].MEMBER_LOGINDATE + "<br/>" + json.data[i].MEMBER_REGDATE;
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
		    { "width": "6%", className:"mem_num", "data": "MEMBER_NUM"},
		    { "width": "14%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "9%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "8%", className:"mem_phone", "data": "MEMBER_PHONE" },
		    { "width": "0%", className:"mem_regdate", "data": "MEMBER_REGDATE" , "visible":false},
		    { "width": "13%", className:"mem_login", "data": "MEMBER_LOGINDATE" },
		    { "width": "8%", className:"mem_err", "data": "MEMBER_ERR" },
		    { "width": "6%", className:"mem_lock", "data": "MEMBER_LOCK" },
		    { "width": "7%", className:"mem_use", "data": "MEMBER_USE" },
		    { "width": "10%", className:"mem_authkey", "data": "AUTH_KEY" },
		    { "width": "9%", className:"mem_avail", "data": "AUTH_AVAIL" },
		    { "width": "10%", className:"", "data": "EMAIL_RESEND" }
		],
		"initComplete": function(settings, json) {
		
			var member_use = this.api().column(8);
			var email_auth = this.api().column(10);
			
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				MemberInfoTable.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				MemberInfoTable.column(1).search("").draw();
				MemberInfoTable.column(2).search("").draw();
				MemberInfoTable.column(3).search("").draw();
			}); 
			
		 	//코인 필터링
            var member_use_select = $('<select class="memberSelectBox"><option value="">전체</option>')
            .appendTo('#selectStateFilter')
            .on('change', function () {
               var val = $(this).val();
               member_use.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            member_use.data().unique().sort().each(function (d, j) {
            	member_use_select.append('<option value="' + d + '">' + d + '</option>');
            });
            
           //이메일 필터링
            var email_auth_select = $('<select class="memberSelectBox"><option value="">전체</option>')
            .appendTo('#emailStateFilter')
            .on('change', function () {
               var val = $(this).val();
               email_auth.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            email_auth.data().unique().sort().each(function (d, j) {
            	email_auth_select.append('<option value="' + d + '">' + d + '</option>');
            });
            
		}
	});

	$('#memberInfo tbody').on('click', 'tr', function (e) {
		
		if(e.target.offsetParent.id != "memberInfo" ) return;
		
	    var data = MemberInfoTable.row( this ).data();
	    
	    var MEMBER_NUM = data["MEMBER_NUM"];
	    var MEMBER_ID = data["MEMBER_ID"];

		var url = "/ADM/level_chk/1";
		$.ajax({
			type : "POST",
			url : url,
			async : false,
			dataType : 'json',
			success : function(obj) { //가져오는 값(변수)
				if (obj.ResultCode == "0") {
					   $('#popup_mask').show();
					    
					    $('#balance_form').show();
					   
				   		$("#balance_content").load( "/ADM/balance/"+MEMBER_NUM , function() {
				    	}); 
				} else if (obj.ResultCode == "1") {
					alert("권한이 없습니다");
					location.href = "/ADM/loginPage";
				} else {
					alert("권한이 없습니다");
					return;
				}
			},
			error : function(e) { //500 ERR
				//서버내부오류
				alert("잠시 후 시도해주세요.");
				location.href = "/ADM/loginPage";
			}
		});
		
	 
	}); 
	
    $(document).on('click','#memberInfo td #email_resend',function(){
    	var row_data = $(this).closest('tr');
	    MEMBER_NUM = MemberInfoTable.row(row_data).data()['MEMBER_NUM'];
	    MEMBER_NAME = MemberInfoTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = MemberInfoTable.row(row_data).data()['MEMBER_ID'];

	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/pwd_chk" , function() { 
	    	
	    	$("#pwd_chk_cancel").on('click', function() {
	    		$("#balance_form").hide();	
	    		$("#popup_mask").hide();
	    		$("#balance_content").empty();
	    	});
	    	
	    	$("#pwd_chk_btn").on('click', function() {
	    		
	    		if($("#password").val() == "") {
	    			alert("비밀번호를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    		
		    	var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n\n회원에 대하여 이메일 재전송을 실행하시겠습니까?");
		    	
		    	if ( confirm_rst == false) {
		    		return;
		    	} else {
			    	$("#progresspanel").show();   
				    var url = "/ADM/email_resend_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"MEMBER_NUM":MEMBER_NUM,
				    			"ADMIN_PASSWORD":$("#password").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				      				$("#progresspanel").hide();
				    	    		$("#balance_form").hide();	
				    	    		$("#balance_content").empty();
				    	    		$("#popup_mask").hide();
				     			} else if (obj.ResultCode == "100") {
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
    
 	$("#Pop_close").on("click", function() {
 		$("#balance_wrap").empty(); 	
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#balance_content").empty();
 	});
});

</script>

</head>
<body>
<div class="memberInfo_wrap">
	<div style="width:100%; text-align:right;">
		<div id="find_type_form" class="find_id_form">
		<div class="memberSelect_form" id="selectStateFilter"><label><b>사용중 : </b></label></div>
		<div class="emailSelect_form" id="emailStateFilter"><label><b>이메일 인증 : </b></label></div>
			<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
				<option value="2">이름</option>
				<option value="1">ID</option>
				<option value="3">핸드폰 번호</option>
			</select>
		</div>
		<div id="find_text" class="find_id_form">
			<input id="find_input" type="text" size=20px; style="margin-left:10px;">
		</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="memberInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>ID</th>
		                <th>이름</th>
		                <th>핸드폰 번호</th>
		                <th>가입 날짜</th>
		                <th>마지막 로그인<br>회원가입 시각</th>
		                <th>에러 횟수</th>
		                <th>잠금</th>
		                <th>사용중</th>
		                <th>이메일 인증키</th>
		                <th>이메일 인증</th>
		                <th>&nbsp;</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>
</body>
</html>