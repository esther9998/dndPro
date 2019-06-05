<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.coinAdmin_wrap table th {
	font-size:13px;
	text-align:center;
}
.coinAdmin_wrap table td {
	font-size:12px;
	text-align:center;
}
.coinAdmin_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
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
.coin_add_btn {
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
.lastblock_show {
	display:none;	
	height:25px; 
	line-height:25px;
	text-align:center;
/* 	padding-left:10px; */
/* 	padding-right:10px; */
	z-index:10;
	background-color:#dddddd; 
}
.lastblock_btn {
	position:relative;
}
.lastblock_btn:hover .lastblock_show {
	display:block;
	position:absolute;
	left:0px;
	top:-5px;
	font-weight:600;
}
.txid_btn:hover .txid_show {
	display:block;
	position:absolute;
	left:0px;
	top:-5px;
	font-weight:600; 
}
.hash_btn:hover .hash_show {
	display:block;
	position:absolute;
	left:-20px;
/* 	left:-300px; */
	top:-5px;
	font-weight:600;
}
</style>
<script>
var CoinAdminTable = "";
$(document).ready( function() {
	
	$('#coinAdmin tbody').off( 'click', 'tr');
	
	CoinAdminTable = $("#coinAdmin").DataTable({
    
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
		    "url": "/ADM/coinInfo",
		    "type": "POST",  	
		    "dataType": 'json',
		    "dataSrc":function(json) { 
		    	
	        	for (var i=0; i<json.data.length; i++) {
	        		json.data[i].REWRITE_COIN = "<span id='revise_coin' style='color:#ED6E02; font-size:11px; font-weight:600; cursor:pointer;'>[ 수정 ]</span>";
					json.data[i].COIN_DATE = json.data[i].COIN_REGDATE + "<br>" + json.data[i].COIN_MODIDATE;
	        	
					if ( json.data[i].COIN_KIND == "00" ) {
						json.data[i].COIN_KIND_SHOW = "전부 입·출금 제한";
					} else if ( json.data[i].COIN_KIND == "01") {
						json.data[i].COIN_KIND_SHOW = "KRW <br>입·출금";
					} else if ( json.data[i].COIN_KIND == "02") {
						json.data[i].COIN_KIND_SHOW = "BTC 계열<br>입·출금";
					} else if ( json.data[i].COIN_KIND == "03") {
						json.data[i].COIN_KIND_SHOW = "ETH 계열<br>입·출금";
					} else if ( json.data[i].COIN_KIND == "04") {
						json.data[i].COIN_KIND_SHOW = "기타 계열<br>입·출금";
					} else if ( json.data[i].COIN_KIND == "05") {
						json.data[i].COIN_KIND_SHOW = "KRW<br>입금";
					} else if ( json.data[i].COIN_KIND == "06") {
						json.data[i].COIN_KIND_SHOW = "KRW<br>출금";
					} else if ( json.data[i].COIN_KIND == "07") {
						json.data[i].COIN_KIND_SHOW = "BTC 계열<br>입금";
					} else if ( json.data[i].COIN_KIND == "08") {
						json.data[i].COIN_KIND_SHOW = "BTC 계열<br>출금";
					} else if ( json.data[i].COIN_KIND == "09") {
						json.data[i].COIN_KIND_SHOW = "ETH 계열<br>입금";
					} else if ( json.data[i].COIN_KIND == "10") {
						json.data[i].COIN_KIND_SHOW = "ETH 계열<br>출금";
					} 
					
					if ( json.data[i].COIN_LASTBLOCK.length > 10 ) {
						json.data[i].COIN_LASTBLOCK_SHOW = "<div class='lastblock_btn' id='lastblock_btn' title="+ json.data[i].COIN_LASTBLOCK + ">" + number_chk(json.data[i].COIN_LASTBLOCK) + "<div class='lastblock_show'>" + json.data[i].COIN_LASTBLOCK + "</div>" + "</div>";
					} else {
						json.data[i].COIN_LASTBLOCK_SHOW = "<div title=" + json.data[i].COIN_LASTBLOCK + ">" +json.data[i].COIN_LASTBLOCK + "</div>";
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
		    { "width": "5%", "data": "COIN_NUM"},
		    { "width": "5%", "data": "COIN_UNIT" },
		    { "width": "6%", "data": "COIN_KIND_SHOW" },
		    { "width": "7%", "data": "COIN_LASTBLOCK_SHOW" },
		    { "width": "11%", "data": "COIN_LASTTRANS" },
		    { "width": "8%", "data": "COIN_MINTRANS" },
		    { "width": "7%", "data": "COIN_MAXTRANS" },
		    { "width": "7%", "data": "COIN_DAILYTRANS" },
		    { "width": "7%", "data": "COIN_MONTHTRANS" },
		    { "width": "8%", "data": "COIN_MINDEPOSIT" },
		    { "width": "7%", "data": "COIN_FEE" },
		    { "width": "5%", "data": "COIN_RPCUSE" },
		    { "width": "12%", "data": "COIN_DATE" },
		    { "width": "5%", "data": "REWRITE_COIN" },
		]
	});
	
	//수정
	$(document).on('click','#coinAdmin td #revise_coin',function(){
   		var row_data = $(this).closest('tr');
	    COIN_NUM = CoinAdminTable.row(row_data).data()['COIN_NUM'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/coin_revise/"+COIN_NUM , function() { 

	    	$("#coinrevise_close").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#coinrevise_wrap").empty();
	    	});
		});
    });
	
	$('#coinAdmin tbody').on('click', 'tr', function (e) {
		
		if(e.target.offsetParent.id != "coinAdmin" ) return;
		
		$('#popup_mask').show();		
		
	    var data = CoinAdminTable.row( this ).data();
	    var COIN_NUM = data["COIN_NUM"];

	    $('#balance_form').show();
	   
   		$("#balance_content").load( "/ADM/coin_detail/"+COIN_NUM , function() {
    	}); 
	}); 
	
	$("#coin_add").on('click', function() {
		$('#popup_mask').show();		
	    $('#balance_form').show();
	   
   		$("#balance_content").load( "/ADM/coin_insert" , function() {
    	});
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
<div class="coinAdmin_wrap">
	<div style="display:inline-block; width:100%;">
		<div class="coin_add_btn" id="coin_add" style="float:left;">코인 등록</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="coinAdmin" class="display" cellspacing="0" width="100%;" height="80%;">
	        <thead>
	            <tr style="text-align:left;">
	                <th>번호</th>
	                <th>코인</th>
	                <th>KIND</th>
	                <th>LAST_BLOCK</th>
	                <th>LAST_TRANS</th>
	                <th>출금<br>최소금액</th>
	                <th>출금<br>최대금액</th>
	                <th>출금<br>일일한도</th>
	                <th>출금<br>한달한도</th>
	                <th>입금<br>최소금액</th>
	                <th>수수료</th>
	                <th>RPC_USE</th>
	                <th>등록일자<br>수정일자</th>
	                <th>&nbsp;</th>
	            </tr>
	        </thead>
		</table>
	</div>
</div>
</body>
</html>