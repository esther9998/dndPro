<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.boardInfo_wrap table th {
	font-size:13px;
}

.boardInfo_wrap {
	font-size:13px;
}		  
.boardInfo_wrap table td, .boardInfo_wrap tr {
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
.board_num, .admin_member_num, .board_type, .board_date, .start_date, .end_date, .board_delete, .board_revise, .board_use, .board_count {
	text-align:center;
}
.board_revise, .board_delete {
	cursor:pointer;
}
.board_add_btn {
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
.boardTypeSelect_form {
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
.boardTypeSelectBox{
	width:150px;
	height:100%;
	line-height:20px;
}
</style>
<script>
var board_infoTable = "";
$(document).ready( function () {
	$("#board_add").on('click', function() {
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/insert_board_page" , function() { 
			//공지 등록 닫기
		 	$("#board_insert_cancel_btn").on("click", function() {
		    	$("#balance_form").hide();
		    	$('#popup_mask').hide();
		    	$("#insert_board_wrap").empty();
		 	});
	    });
	});
	
	//팝업 닫기
 	$("#Pop_close").on("click", function() {
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#balance_content").empty();
    	$("#insert_board_wrap").empty();
    	$("#read_board_wrap").empty();
 	});
	
	board_infoTable = $("#boardInfo").DataTable({
		"language": {
   		    "emptyTable": "등록된 게시판이 없습니다.",
   			"zeroRecords": "검색된 게시판이 없습니다.",
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
		    "url": "/ADM/getBoardInfo",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
	        		

	        		
        			json.data[i].BOARD_REVISE = "<span class='change_password' id='revise_board' style='color:#3377bb'>[ 수정 ]</span>";
        			json.data[i].BOARD_TYPE_SHOW = "";
        			
        			json.data[i].BOARD_CONTENT_SHOW = number_chk(json.data[i].BOARD_CONTENT, "content");
        			json.data[i].BOARD_TITLE_SHOW = number_chk(json.data[i].BOARD_TITLE, "title");
        			
        			if ( json.data[i].BOARD_TYPE == "01") {
        				json.data[i].BOARD_TYPE_SHOW = "<span style='color:blue;'>코인뉴스</span>";
        				json.data[i].BOARD_TYPE_FILTER = "코인뉴스";
        			} else if ( json.data[i].BOARD_TYPE == "02") {
        				json.data[i].BOARD_TYPE_SHOW = "<span style='color:red;'>블록체인뉴스</span>";
        				json.data[i].BOARD_TYPE_FILTER = "블록체인뉴스";
        			} /* else if ( json.data[i].BOARD_TYPE == "03") {
        				json.data[i].BOARD_TYPE_SHOW = "<span>팝업</span>";
        				json.data[i].BOARD_TYPE_FILTER = "팝업";
        			} */
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
			{ "width": "5%", className:"board_num", "data": "BOARD_NUM"},
			{ "width": "5%", className:"admin_member_num", "data": "ADMIN_MEMBER_NUM"},
		    { "width": "6%", className:"board_type", "data": "BOARD_TYPE", "visible": false },
		    { "width": "6%", className:"board_type", "data": "BOARD_TYPE_FILTER", "visible": false },
		    { "width": "7%", className:"board_type", "data": "BOARD_TYPE_SHOW" },
		    { "width": "10%", className:"board_title", "data": "BOARD_TITLE_SHOW" },
		    { "width": "10%", className:"board_content", "data": "BOARD_CONTENT_SHOW" },
		    { "width": "10%", className:"board_date", "data": "BOARD_DATA" },
		    { "width": "9%", className:"board_date", "data": "BOARD_MDATA" },
		    /* { "width": "10%", className:"board_count", "data": "BOARD_IMG" }, */
/* 		    { "width": "9%", className:"start_date", "data": "START_DATE", "visible": false },
		    { "width": "10%", className:"end_date", "data": "END_DATE", "visible": false }, */
		    { "width": "3%", className:"board_use", "data": "BOARD_USE"  },
		    { "width": "5%", className:"board_revise", "data": "BOARD_REVISE" } 
		],
	    initComplete: function () {
			var board_type = this.api().column(3);
				
			console.log(board_type);
			//코인 필터링
			var board_type_select = $('<select class="boardTypeSelectBox"><option value="">전체</option>')
			.appendTo('#selectStateFilter')
			.on('change', function () {
			   var val = $(this).val();
			   board_type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
			});
			board_type.data().unique().sort().each(function (d, j) {
				board_type_select.append('<option value="' + d + '">' + d + '</option>');
			});
   		}
	});
	
	//수정
	$(document).on('click','#boardInfo td #revise_board',function(){
   	var row_data = $(this).closest('tr');
	    ADMIN_MEMBER_NUM = board_infoTable.row(row_data).data()['ADMIN_MEMBER_NUM'];
	    board_NUM = board_infoTable.row(row_data).data()['board_NUM'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/revise_board/"+board_NUM , function() { 

	    	$("#board_revise_close_btn").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#revise_board_wrap").empty();
	    	});
		});
    });
	
	//tr 클릭시
	$('#boardInfo tbody').on('click', 'tr', function (e) {
		
		if(e.target.offsetParent.id != "boardInfo" ) return;
		
    	var data = board_infoTable.row( this ).data();
	    var BOARD_NUM = data["BOARD_NUM"];
	    
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/read_board/"+BOARD_NUM , function() { 

	    	$("#read_board_close_btn").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#read_board_wrap").empty();
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
<div class="boardInfo_wrap">
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
	<div class="board_add_btn" id="board_add">게시판 등록</div>
	<div class="boardTypeSelect_form" id="selectStateFilter"><label><b>분류 : </b></label></div>
</div>
	<div style="position:relative; top:20px;">
		<table id="boardInfo" class="display" cellspacing="0" width="100%;" height="80%;">
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
		           <!--      <th>이미지</th> -->
		          <!--       <th>시작일자</th>
		                <th>완료일자</th> -->
		                <th>사용여부</th>
	<!-- 	                <th>조회수</th> -->
		                <th>&nbsp;</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>
</body>
</html>