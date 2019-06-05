<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.curbalance_wrap table th {
	font-size:13px;
	text-align:center;
}
.curbalance_wrap table td {
	font-size:12px;
	text-align:center;
}
.curbalance_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
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
.balance_search_btn {
	background-color:#dddddd; 
	width:50px; 
	height:25px; 
	cursor:pointer; 
	line-height:25px; 
	text-align:center; 
	color:#333333; 
	font-size:12px;
	letter-spacing:2px;
	border:1px solid #aaaaaa;
	display:inline-block;
	margin-left:15px;
}
</style>
<script>
var CurBalanceTable = "";
$(document).ready( function() {
	CurDataTableInit(1);

	$("#balance_search_btn").on('click', function() {
		var coin_num = $("#coin_select_box").val(); 
		
		CurDataTableInit(coin_num);
	});
	
	$("#Pop_close").on('click', function() {
		$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#coindetail_wrap").empty();
    	$("#coininsert_wrap").empty();
	});
});

function CurDataTableInit(COIN_NUM) {
	CurBalanceTable = $("#curbalance_table").DataTable({
	    "language": {
   		    "emptyTable": "등록된 코인이 없습니다.",
   			"zeroRecords": "검색된 코인이 없습니다.",
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
	    "data":[],
		"columns": [
		    { "width": "0%", "data": "COIN_NUM", "visible": false},
		    { "width": "8%", "data": "COIN_UNIT"},
		    { "width": "0%", "data": "COIN_KIND", "visible": false},
		    { "width": "8%", "data": "MEMBER_NUM" },
		    { "width": "12%", "data": "MEMBER_ID" },
		    { "width": "10%", "data": "MEMBER_NAME" },
		    { "width": "8%", "data": "MEMBER_USE" },
		    { "width": "15%", "data": "WALLET_BALANCE" },
		    { "width": "15%", "data": "ORDER_SUM" },
		    { "width": "15%", "data": "SUM_TOTAL" }
		]
	});
	
	var url = "/ADM/cur_balance_data/"+COIN_NUM;
	$.ajax({
		type:"POST",
		url:url,
		dataType : 'json',
		success:function(data) { //가져오는 값(변수)
			CurDataTableDraw(data, COIN_NUM);
		},
		error:function(e) { //500 ERR
			//서버내부오류
			alert("잠시 후 시도해주세요.");
			return;
		}
	});
}

function CurDataTableDraw(data, COIN_NUM) {
	CurBalanceTable.clear();
	CurBalanceTable.rows.add(data.data).draw();
	
	CurBalanceTable.data().draw();
}

function number_chk(param) {
	var param_rst = "";
	if ( param == "" ) {
		param_rst = "";
	} else if (param.length > 10) {
		param_rst = param.substr(0,10) + "...";
	} else {
		param_rst = param;
	}
	return param_rst;
}
</script>
</head>
<body>
<div class="curbalance_wrap">
	<div style="display:inline-block; width:100%;">
		<select id="coin_select_box" style="width:120px; display:inline-block; height:25px; float:left;">
		  <c:forEach items="${COIN_LIST}" var="COIN_LIST">
		    <option value="${COIN_LIST[0]}">
		        ${COIN_LIST[1]}
		    </option>
		  </c:forEach>
		</select>
		<div class="balance_search_btn" id="balance_search_btn" style="float:left;">조회</div>
	</div>
	<div style="position:relative; top:20px;" id="curbalance_form">
		<table id="curbalance_table" class="display" cellspacing="0" width="100%;" height="80%;">
        	<thead>
	            <tr style="text-align:left;">
	            	<th>&nbsp;</th>
	                <th>코인명</th>
	                <th>&nbsp;</th>
	                <th>회원번호</th>
	                <th>ID</th>
	                <th>이름</th>
	                <th>사용중</th>
	                <th>현재 잔액</th>
	                <th>주문 잔액</th>
	                <th>총 합계 잔액</th>
	            </tr>
	        </thead>
		</table>
	</div>
</div>
</body>
</html>