<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.tradeInfo_wrap table th {
	font-size:13px;
}

.tradeInfo_wrap {
	font-size:13px;
}		    
.tradeInfo_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
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
.tradeInfo_wrap .o_kind, .orderInfo_wrap .o_market, .orderInfo_wrap .mem_phone, .orderInfo_wrap .o_trading{
	text-align:center;
}
.tradeSelect_form {
	width:250px;
	height:40px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.tradeSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
.t_type {
	padding-left:15px !important;
}
.t_market {
	text-align:center;
}
.base_coin, .buy_data {
	color:#ED6E02;
	font-weight:600;
}
.target_coin, .sell_data {
	color:#161B61;
	font-weight:600;
}
</style>
<script>
var TradeInfoTable = "";
$(document).ready( function() {
	
	$('#tradeInfo tbody').off( 'click', 'tr');
	
	TradeInfoTable = $("#tradeInfo").DataTable({
		"language": {
   		    "emptyTable": "등록된 거래내역이 없습니다.",
   			"zeroRecords": "검색된 거래내역이 없습니다.",
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
// 	    "dom": 'rtipS',
	    "dom": 'BrtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
	    buttons: [
	    	{
	         	text: 'Excel',
	    		extend: 'excelFlash',
	            filename: 'CONCO_거래내역'
	        }
	    ],
		"ajax": {
		    "url": "/ADM/TradeList_data",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].TARDE_MARKET_TYPE = json.data[i].BASE_COIN_UNIT + " / " + json.data[i].TARGET_COIN_UNIT;
					json.data[i].TRADE_MARKET = "<span class='base_coin'>"+json.data[i].BASE_COIN_UNIT+"</span>"+" / "+"<span class='target_coin'>"+json.data[i].TARGET_COIN_UNIT+"</span>";

	        		if ( json.data[i].TRADE_KIND == "31") {
	        			json.data[i].TRADE_KIND_TYPE = "매수";
	        			json.data[i].TRADE_KIND_SHOW = "<span class='buy_data'>매수</span>";
	        		} else {
	        			json.data[i].TRADE_KIND_TYPE = "매도";
	        			json.data[i].TRADE_KIND_SHOW = "<span class='sell_data'>매도</span>";
	        		}
	        		
	        		json.data[i].TRADE_PRICE_SHOW = json.data[i].TRADE_PRICE + " " + json.data[i].BASE_COIN_UNIT;
	        		json.data[i].TRADE_AMOUNT_SHOW = json.data[i].TRADE_AMOUNT + " " + json.data[i].TARGET_COIN_UNIT;
	        	}
	        	return json.data;
		    },
	        error: function (xhr, error, thrown) {
				console.log(xhr);
				console.log(error);
				console.log(thrown);
	        }
	    },
		"columns": [
		    { "width": "5%", className:"mem_num", "data": "MEMBER_NUM"},
		    { "width": "14%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "10%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "0%", className:"", "data": "ORDER_NUM" , "visible":false}, 
		    { "width": "0%", className:"", "data": "TRADE_NUM" , "visible":false}, 
		    { "width": "0%", className:"", "data": "MARKET_NUM" , "visible":false}, 
		    { "width": "0%", className:"o_target", "data": "BASE_COIN_UNIT", "visible":false}, 
		    { "width": "0%", className:"o_target", "data": "TARGET_COIN_UNIT", "visible":false}, 
		    { "width": "0%", className:"o_target", "data": "TARDE_MARKET_TYPE", "visible":false}, 
		    { "width": "10%", className:"t_market", "data": "TRADE_MARKET"}, 
		    { "width": "0%", className:"o_target", "data": "TRADE_KIND", "visible":false}, 
		    { "width": "0%", className:"o_target", "data": "TRADE_KIND_TYPE", "visible":false}, 
		    { "width": "5%", className:"t_type", "data": "TRADE_KIND_SHOW"}, 
		    { "width": "0%", className:"", "data": "TRADE_PRICE", "visible":false}, 
		    { "width": "16%", className:"", "data": "TRADE_PRICE_SHOW"}, 
		    { "width": "0%", className:"", "data": "TRADE_AMOUNT", "visible":false},
		    { "width": "16%", className:"", "data": "TRADE_AMOUNT_SHOW"},
		    { "width": "13%", className:"o_market", "data": "TRADE_DATE"}
		],
	    "initComplete": function(settings, json) {
		
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				TradeInfoTable.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				TradeInfoTable.column(1).search("").draw();
				TradeInfoTable.column(2).search("").draw();
			}); 
			
		 	var market = this.api().column(8);
            var type = this.api().column(11);
            
            var select = $('<select class="tradeSelectBox"><option value="">전체</option>')
            //마켓 필터링
            .appendTo('#selectTriggerFilter')
                .on('change', function () {
                   var val = $(this).val();
                   market.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
                });
            market.data().unique().sort().each(function (d, j) {
                select.append('<option value="' + d + '">' + d + '</option>');
            });
            
            //타입 필터링
            var type_select = $('<select class="tradeSelectBox"><option value="">전체</option>')
            .appendTo('#selectTypeFilter')
            .on('change', function () {
               var val = $(this).val();
               type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            type.data().unique().sort().each(function (d, j) {
            	type_select.append('<option value="' + d + '">' + d + '</option>');
            });
		}
	});
});

</script>
</head>
<body>

<div class="tradeInfo_wrap" id="tradeInfo_wrap">
	<div style="width:100%; text-align:right;">
		<div id="find_type_form" class="find_id_form">
			<div class="tradeSelect_form" id="selectTriggerFilter"><label><b>마켓 : </b></label></div>
			<div class="tradeSelect_form" id="selectTypeFilter"><label><b>분류 : </b></label></div>
			<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
				<option value="2">이름</option>
				<option value="1">ID</option>
			</select>
		</div>
		<div id="find_text" class="find_id_form">
			<input id="find_input" type="text" size=20px; style="margin-left:10px;">
		</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="tradeInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>ID</th>
		                <th>이름</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th style="text-aling:center;">마켓</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>분류</th>
		                <th>&nbsp;</th>
		                <th>금액</th>
		                <th>&nbsp;</th>
		                <th>수량</th>
		                <th>시각</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>
</body>
</html>