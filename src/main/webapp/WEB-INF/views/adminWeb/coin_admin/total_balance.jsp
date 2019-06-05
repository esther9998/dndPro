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
</style>
<script>
var TotalBalanceTable = "";
$(document).ready( function() {
	TotalBalanceTable = $("#total_balance_table").DataTable({
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
	    "ajax": {
		    "url": "/ADM/total_balance_data",
		    "type": "POST",  	
		    "dataType": 'json',
			"dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
					json.data[i].WALLET_BALANCE = json.data[i].WALLET_BALANCE + " " + json.data[i].COIN_UNIT;
					json.data[i].ORDER_SUM = json.data[i].ORDER_SUM + " " + json.data[i].COIN_UNIT;
					json.data[i].SUM_TOTAL = json.data[i].SUM_TOTAL + " " + json.data[i].COIN_UNIT;
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
		    { "width": "0%", "data": "COIN_NUM", "visible": false},
		    { "width": "8%", "data": "COIN_UNIT"},
		    { "width": "0%", "data": "COIN_KIND", "visible": false},
		    { "width": "30%", "data": "WALLET_BALANCE" },
		    { "width": "30%", "data": "ORDER_SUM" },
		    { "width": "30%", "data": "SUM_TOTAL" }
		]
	});
	
	$("#Pop_close").on('click', function() {
		$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#coindetail_wrap").empty();
    	$("#coininsert_wrap").empty();
	});
});


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
	<div style="position:relative; top:20px;" id="total_balance_form">
		<table id="total_balance_table" class="display" cellspacing="0" width="100%;" height="80%;">
        	<thead>
	            <tr style="text-align:left;">
	            	<th>&nbsp;</th>
	                <th>코인명</th>
	                <th>&nbsp;</th>
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