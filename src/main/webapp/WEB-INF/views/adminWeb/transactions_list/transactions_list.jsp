<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.transactionInfo_wrap table th {
	font-size:13px;
}
.transactionInfo_wrap .coin_num, .transactionInfo_wrap .block_index {
	text-align:center;
}

.transactionInfo_wrap {
	font-size:13px;
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

.OrderSelect_form {
	width:250px;
	height:40px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.OrderSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
.address_show, .txid_show , .hash_show {
	display:none;	
	height:25px; 
	line-height:25px;
	text-align:center;
/* 	padding-left:10px; */
/* 	padding-right:10px; */
	z-index:10;
	background-color:#dddddd; 
}
.address_btn, .txid_btn , .hash_btn {
	position:relative;
}
.address_btn:hover .address_show {
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
.transactionSelect_form {
	width:198px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.transactionSelectBox {
	width:130px;
	height:25px;
	margin-left:5px;
	left:-20px;
}
</style>
<script>
var TransactionInfo = "";
$(document).ready( function() {
	
	$('#transactionInfo tbody').off( 'click', 'tr');
	
	TransactionInfo = $("#transactionInfo").DataTable({
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
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
		"ajax": {
		    "url": "/ADM/transaction_List_data",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
	        		json.data[i].TRANS_ADDRESS_SHOW = "<div class='address_btn' id='address_btn' title="+ json.data[i].TRANS_ADDRESS + ">" + number_chk(json.data[i].TRANS_ADDRESS) + "<div class='address_show'>" + json.data[i].TRANS_ADDRESS + "</div>" + "</div>" ;
	        		json.data[i].TRANS_TXID_SHOW = "<div class='txid_btn' id='txid_btn' title="+ json.data[i].TRANS_TXID + ">" + number_chk(json.data[i].TRANS_TXID) + "<div class='txid_show'>" + json.data[i].TRANS_TXID + "</div>" + "</div> ";
	        		json.data[i].TRANS_BLOCKHASH_SHOW = "<div class='hash_btn' id='hash_btn' title="+ json.data[i].TRANS_BLOCKHASH + ">" + number_chk(json.data[i].TRANS_BLOCKHASH) + "<div class='hash_show'>" + json.data[i].TRANS_BLOCKHASH + "</div>" + "</div>";
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
		    { "width": "0%", className:"mem_num", "data": "TRANS_NUM", "visible":false},
		    { "width": "0%", className:"coin_num", "data": "COIN_NUM","visible":false},
		    { "width": "6%", className:"coin_num", "data": "COIN_UNIT"},
		    { "width": "7%", className:"mem_name", "data": "TRANS_CATEGORY" },
		    { "width": "9%", className:"mem_name", "data": "TRANS_AMOUNT" },
		    { "width": "8%", className:"mem_name", "data": "TRANS_FEE" },
		    { "width": "17%", className:"mem_name", "data": "TRANS_TIME" },
		    { "width": "17%", className:"mem_name", "data": "TRANS_MDATE" },
		    { "width": "12%", className:"", "data": "TRANS_ACCOUNT"}, 
		    { "width": "0", className:"", "data": "TRANS_ADDRESS", "visible":false}, 
		    { "width": "11", className:"", "data": "TRANS_ADDRESS_SHOW"}, 
		    { "width": "0%", className:"", "data": "TRANS_TXID", "visible":false}, 
		    { "width": "11%", className:"", "data": "TRANS_TXID_SHOW"}, 
		    { "width": "0%", className:"", "data": "TRANS_BLOCKHASH", "visible":false}, 
		    { "width": "11%", className:"", "data": "TRANS_BLOCKHASH_SHOW"}, 
		    { "width": "7%", className:"block_index", "data": "TRANS_BLOCKINDEX"}
		],
		initComplete: function () {
            var coin = this.api().column(2);
            
            var select = $('<select class="transactionSelectBox "><option value="">전체</option>')
            //코인 필터링
            .appendTo('#selectTriggerFilter')
                .on('change', function () {
                   var val = $(this).val();
                   coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
                });
            coin.data().unique().sort().each(function (d, j) {
                select.append('<option value="' + d + '">' + d + '</option>');
            });
		}
	});
});

function number_chk(param) {
	var param_rst = param.substr(0,15) + "...";
	return param_rst;
}
</script>
</head>
<body>
<div class="transactionInfo_wrap">
	<div style="position:relative; top:20px;">
		<div style="width:100%; text-align:left;">
			<div>
				<div class="transactionSelect_form" id="selectTriggerFilter"><label><b>코인 : </b></label></div>
			</div>
		</div>
		<table id="transactionInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>코인</th>
		                <th>분류</th>
		                <th>수량</th>
		                <th>수수료</th>
		                <th>전환시간</th>
		                <th>수정시간</th>
		                <th>ID</th>
		                <th>&nbsp;</th>
		                <th>주소</th>
		                <th>&nbsp;</th>
		                <th>TXID</th>
		                <th>&nbsp;</th>
		                <th>HASH</th>
		                <th>INDEX</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>

</body>
</html>