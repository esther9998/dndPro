<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.marketAdmin_wrap table th {
	font-size:13px;
	text-align:center;
}
.marketAdmin_wrap table td {
	font-size:12px;
	text-align:center;
}
.marketAdmin_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
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
.market_add_btn {
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
</style>
<script>
var MarketAdminTable = "";
$(document).ready( function() {
	
	$('#marketAdmin tbody').off( 'click', 'tr');
	
	MarketAdminTable = $("#marketAdmin").DataTable({
    
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
		    "url": "/ADM/marketInfo",
		    "type": "POST",  	
		    "dataType": 'json',
		    "dataSrc":function(json) { 
		    	
	        	for (var i=0; i<json.data.length; i++) {
	        		json.data[i].MARKET_KIND_SHOW = "";

	        		//TARGET / BASE
	        		json.data[i].MARKET = json.data[i].TARGET_COIN_UNIT + " / " + json.data[i].BASE_COIN_UNIT;
	        		json.data[i].MARKET_REVISE = "<span id='revise_market' style='color:#ED6E02; cursor:pointer; font-weight:600;'>[ 수정 ]</span>";
	        		json.data[i].MARKET_FEE = json.data[i].MARKET_FEE + " " + json.data[i].BASE_COIN_UNIT;
	        		
	        		if ( json.data[i].MARKET_KIND == "00") {
	        			json.data[i].MARKET_KIND_SHOW = "가격범위 없음";
	        		} else if ( json.data[i].MARKET_KIND == "01") {
	        			json.data[i].MARKET_KIND_SHOW = "일반";
	        		} else if ( json.data[i].MARKET_KIND == "02") {
	        			json.data[i].MARKET_KIND_SHOW = "라이즈(하한=현재가)";
	        		} else if ( json.data[i].MARKET_KIND == "03") {
	        			json.data[i].MARKET_KIND_SHOW = "하한";
	        		} else if ( json.data[i].MARKET_KIND == "04") {
	        			json.data[i].MARKET_KIND_SHOW = "하한률";
	        		} else if ( json.data[i].MARKET_KIND == "05") {
	        			json.data[i].MARKET_KIND_SHOW = "상한";
	        		} else if ( json.data[i].MARKET_KIND == "06") {
	        			json.data[i].MARKET_KIND_SHOW = "상한률";
	        		} else if ( json.data[i].MARKET_KIND == "07") {
	        			json.data[i].MARKET_KIND_SHOW = "상하한";
	        		} else if ( json.data[i].MARKET_KIND == "08") {
	        			json.data[i].MARKET_KIND_SHOW = "상하한률";
	        		} else if ( json.data[i].MARKET_KIND == "09") {
	        			json.data[i].MARKET_KIND_SHOW = "매수만가능";
	        		} else if ( json.data[i].MARKET_KIND == "10") {
	        			json.data[i].MARKET_KIND_SHOW = "매도만가능";
	        		} else if ( json.data[i].MARKET_KIND == "11") {
	        			json.data[i].MARKET_KIND_SHOW = "거래제한";
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
		    { "width": "5%", "data": "MARKET_NUM", "visible": false},
		    { "width": "5%", "data": "BASE_COIN_NUM", "visible": false },
		    { "width": "5%", "data": "TARGET_COIN_NUM", "visible": false},
		    { "width": "8%", "data": "MARKET" },
		    { "width": "5%", "data": "BASE_COIN_UNIT" },
		    { "width": "5%", "data": "TARGET_COIN_UNIT" },
		    { "width": "8%", "data": "MARKET_KIND", "visible": false },
		    { "width": "8%", "data": "MARKET_KIND_SHOW" },
		    { "width": "10%", "data": "MARKET_MINAMOUNT" },
		    { "width": "10%", "data": "MARKET_LOWERPRICE" },
		    { "width": "10%", "data": "MARKET_UPPERPRICE" },
		    { "width": "8%", "data": "MARKET_FEE" },
		    { "width": "6%", "data": "MARKET_USE" },
		    { "width": "7%", "data": "MARKET_PRIORITY" },
		    { "width": "12%", "data": "MARKET_DATE" },
		    { "width": "8%", "data": "MARKET_REVISE" }
		]
	});
	
	//수정
	$(document).on('click','#marketAdmin td #revise_market',function(){
   		var row_data = $(this).closest('tr');
	    MARKET_NUM = MarketAdminTable.row(row_data).data()['MARKET_NUM'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/market_revise/"+MARKET_NUM , function() { 

	    	$("#coinrevise_close").on('click', function() {
	    		$("#balance_form").hide();
			    $("#popup_mask").hide();
			    $("#marketrevise_wrap").empty();
	    	});
		});
    });
	
// 	$('#coinAdmin tbody').on('click', 'tr', function (e) {
		
// 		if(e.target.offsetParent.id != "coinAdmin" ) return;
		
// 		$('#popup_mask').show();		
		
// 	    var data = CoinAdminTable.row( this ).data();
// 	    var COIN_NUM = data["COIN_NUM"];

// 	    $('#balance_form').show();
	   
//    		$("#balance_content").load( "/ADM/coin_detail/"+COIN_NUM , function() {
//     	}); 
// 	}); 
	
	//마켓 등록
	$("#market_add").on('click', function() {
		$('#popup_mask').show();		
	    $('#balance_form').show();
	   
   		$("#balance_content").load( "/ADM/market_insert" , function() {
    	});
	});
	
	$("#Pop_close").on('click', function() {
		$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#marketinsert_wrap").empty();
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
<div class="marketAdmin_wrap">
	<div style="display:inline-block; width:100%;">
		<div class="market_add_btn" id="market_add" style="float:left;">마켓 등록</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="marketAdmin" class="display" cellspacing="0" width="100%;" height="80%;">
	        <thead>
	            <tr style="text-align:left;">
	                <th>&nbsp;</th>
	                <th>&nbsp;</th>
	                <th>&nbsp;</th>
	                <th>MARKET</th>
	                <th>BASE</th>
	                <th>TARGET</th>
	                <th>&nbsp;</th>
	                <th>KIND</th>
	                <th>최소거래금액</th>
	                <th>하한가</th>
	                <th>상한가</th>
	                <th>수수료</th>
	                <th>사용중</th>
	                <th>우선순위</th>
	                <th>등록일자</th>
	                <th>&nbsp;</th>
	            </tr>
	        </thead>
		</table>
	</div>
</div>
</body>
</html>