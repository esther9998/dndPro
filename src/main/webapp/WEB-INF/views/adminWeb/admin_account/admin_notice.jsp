<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.noticeInfo_wrap table th {
	font-size:13px;
}

.noticeInfo_wrap {
	font-size:13px;
}		  
.noticeInfo_wrap table td, .noticeInfo_wrap tr {
	height:15px;
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
.notice_num, .admin_member_num, .notice_type, .notice_date, .start_date, .end_date, .notice_delete, .notice_revise, .notice_use, .notice_count {
	text-align:center;
}
.notice_revise, .notice_delete {
	cursor:pointer;
}
.notice_add_btn {
	background-color:#bbbbbb; 
	width:100px; 
	height:30px; 
	cursor:pointer; 
	line-height:30px;  
	text-align:center; 
	color:#ffffff; 
	font-size:13px;
	letter-spacing:1px;
	border:1px solid #d7d7d7;
	border-radius:3px;
	font-weight:600;
	display:inline-block;
}
.noticeTypeSelect_form {
	width:250px;
	height:22px;
	position:relative;
	display:inline-block;
	line-height:28px;
	font-size:13px;
	text-align:right;
	margin-left:10px;
	float:right;
	font-weight:500;
}
.noticeTypeSelectBox{
	width:150px;
	height:100%;
	line-height:20px;
}
</style>
<script>
var notice_infoTable = "";
$(document).ready( function () {
	$("#notice_add").on('click', function() {
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/insert_notice_page" , function() { 
			//공지 등록 닫기
		 	$("#notice_insert_cancel_btn").on("click", function() {
		    	$("#balance_form").hide();
		    	$('#popup_mask').hide();
		    	$("#insert_notice_wrap").empty();
		 	});
	    });
	});
	
	//팝업 닫기
 	$("#Pop_close").on("click", function() {
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#balance_content").empty();
    	$("#insert_notice_wrap").empty();
    	$("#read_notice_wrap").empty();
 	});
	
	notice_infoTable = $("#noticeInfo").DataTable({
		"language": {
   		    "emptyTable": "등록된 공지사항이 없습니다.",
   			"zeroRecords": "검색된 공지사항이 없습니다.",
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
	    "pageLength": 13,
	    "Filter": true,
	    "dom": 'rtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
		"ajax": {
		    "url": "/ADM/getNoticeInfo",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
        			json.data[i].NOTICE_REVISE = "<span class='change_password' id='revise_notice' style='color:#3377bb'>[ 수정 ]</span>";
        			json.data[i].NOTICE_TYPE_SHOW = "";
        			
        			json.data[i].NOTICE_CONTENT_SHOW = number_chk(json.data[i].NOTICE_CONTENT, "content");
        			json.data[i].NOTICE_TITLE_SHOW = number_chk(json.data[i].NOTICE_TITLE, "title");
        			
        			if ( json.data[i].NOTICE_TYPE == "01") {
        				json.data[i].NOTICE_TYPE_SHOW = "<span>공지</span>";
        				json.data[i].NOTICE_TYPE_FILTER = "공지";
        			} else if ( json.data[i].NOTICE_TYPE == "02") {
        				json.data[i].NOTICE_TYPE_SHOW = "<span style='color:red;'>긴급</span>";
        				json.data[i].NOTICE_TYPE_FILTER = "긴급";
        			} else if ( json.data[i].NOTICE_TYPE == "03") {
        				json.data[i].NOTICE_TYPE_SHOW = "<span>팝업</span>";
        				json.data[i].NOTICE_TYPE_FILTER = "팝업";
        			}
	        	}
	        	return json.data;
		    },
	        error: function (xhr, error, thrown) {
				if (xhr.readyState == 0) {
					return true;
				}
	        }
	    },
		"columns": [
			{ "width": "5%", className:"notice_num", "data": "NOTICE_NUM"},
			{ "width": "5%", className:"admin_member_num", "data": "ADMIN_MEMBER_NUM"},
		    { "width": "6%", className:"notice_type", "data": "NOTICE_TYPE", "visible": false },
		    { "width": "6%", className:"notice_type", "data": "NOTICE_TYPE_FILTER", "visible": false },
		    { "width": "5%", className:"notice_type", "data": "NOTICE_TYPE_SHOW" },
		    { "width": "10%", className:"notice_title", "data": "NOTICE_TITLE_SHOW" },
		    { "width": "10%", className:"notice_content", "data": "NOTICE_CONTENT_SHOW" },
		    { "width": "10%", className:"notice_date", "data": "NOTICE_DATE" },
		    { "width": "9%", className:"notice_date", "data": "NOTICE_MDATE" },
		    { "width": "9%", className:"start_date", "data": "START_DATE" },
		    { "width": "10%", className:"end_date", "data": "END_DATE" },
		    { "width": "6%", className:"notice_use", "data": "NOTICE_USE" },
		    { "width": "5%", className:"notice_count", "data": "NOTICE_COUNT" },
		    { "width": "5%", className:"notice_revise", "data": "NOTICE_REVISE" }
		],
	    initComplete: function () {
			var notice_type = this.api().column(3);
				
			console.log(notice_type);
			//코인 필터링
			var notice_type_select = $('<select class="noticeTypeSelectBox"><option value="">전체</option>')
			.appendTo('#selectStateFilter')
			.on('change', function () {
			   var val = $(this).val();
			   notice_type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
			});
			notice_type.data().unique().sort().each(function (d, j) {
				notice_type_select.append('<option value="' + d + '">' + d + '</option>');
			});
   		}
	});
	
	//수정
	$(document).on('click','#noticeInfo td #revise_notice',function(){
   	var row_data = $(this).closest('tr');
	    ADMIN_MEMBER_NUM = notice_infoTable.row(row_data).data()['ADMIN_MEMBER_NUM'];
	    NOTICE_NUM = notice_infoTable.row(row_data).data()['NOTICE_NUM'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/revise_notice/"+NOTICE_NUM , function() { 

	    	$("#notice_revise_close_btn").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#revise_notice_wrap").empty();
	    	});
		});
    });
	
	//tr 클릭시
	$('#noticeInfo tbody').on('click', 'tr', function (e) {
		
		if(e.target.offsetParent.id != "noticeInfo" ) return;
		
    	var data = notice_infoTable.row( this ).data();
	    var NOTICE_NUM = data["NOTICE_NUM"];
	    
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/read_notice/"+NOTICE_NUM , function() { 

	    	$("#read_notice_close_btn").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#read_notice_wrap").empty();
	    	});
		});
 	 }); 
});
function number_chk(param, type) {
	var param_rst = "";
	if ( type == "content") {
		if ( param.length > 20) {
			param_rst = param.substr(0,20) + "..";
		} else { 
			param_rst = param;
		}
	} else {
		if ( param.length > 10) {
			param_rst = param.substr(0,10) + "..";
		} else { 
			param_rst = param;
		}
	}
	return param_rst;
}
</script>
</head>
<body>
<div class="noticeInfo_wrap">
<!-- 	<div style="width:100%;"> -->
<!-- 		<div style="display:inline-block; text-align:left;"> -->
<!-- 			<div id="add_admin" class="add_admin">관리자 등록</div> -->
<!-- 		</div> -->
<!-- 		<div style="position:absolute; display:inline-block; right:0px;"> -->
<!-- 		<div id="find_type_form" class="find_id_form"> -->
<!-- 			<select id="find_type" style="width:120px; height:22px; padding-left:8px;"> -->
<!-- 				<option value="2">이름</option> -->
<!-- 				<option value="1">ID</option> -->
<!-- 			</select> -->
<!-- 		</div> -->
<!-- 		<div id="find_text" class="find_id_form"> -->
<!-- 			<input id="find_input" type="text" size=20px; style="margin-left:10px;"> -->
<!-- 		</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
<div style="display:inline-block; width:100%;">
	<div class="notice_add_btn" id="notice_add">공지 등록</div>
	<div class="noticeTypeSelect_form" id="selectStateFilter"><label><b>분류 : </b></label></div>
</div>
	<div style="position:relative; top:20px;">
		<table id="noticeInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>작성자</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>분류</th>
		                <th>제목</th>
		                <th>내용</th>
		                <th>등록일자</th>
		                <th>수정일자</th>
		                <th>시작일자</th>
		                <th>완료일자</th>
		                <th>사용여부</th>
		                <th>조회수</th>
		                <th>&nbsp;</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>
</body>
</html>