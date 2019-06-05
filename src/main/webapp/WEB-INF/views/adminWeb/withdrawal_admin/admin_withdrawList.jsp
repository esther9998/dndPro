<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.krw_withdraw_wrap {
	width:100%;
	height:100%;
	position:relative;
    font-weight:500;
    font-size:12px;
	letter-spacing:1px;
	overflow-y:auto;
	top:20px;
}
.withListSelect_form {
	width:220px;
	height:20px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.auth_wait {
	color:#de8187;
}
.auth_suc {
	color:#3377bb;
}
.withdraw_btn {
	color:#ED6E02;
	font-size:11px;
	font-weight:600;
	cursor:pointer;
}
.cancel_auth {
	color:red;
}
.withdraw_data {
	color:#272fa6;
}
.deposit_data {
	color:#ED6E02;
}
.krw_withdraw_wrap .dataTables_paginate {
	margin-right:124px;
	margin-top:30px;
}
.krw_withdraw_wrap .type, .krw_withdraw_wrap .kind, .krw_withdraw_wrap .state, .krw_withdraw_wrap .date {
	text-align:center;
}
.withListSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
</style>
<script>
var KrwWithdrawInfoTable = "";
var COIN_NUM = "${COIN_NUM}";
var MEMBER_NUM = "${MEMBER_NUM}";

$(document).ready(function() { 

	KrwWithdrawInfoTable = $("#krw_withdrawInfo").DataTable({
	
	   "language": {
  		    "emptyTable": "입·출금 내역이 없습니다.",
  		 	"zeroRecords": "검색된 내역이 없습니다.",
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
	    "pageLength": 10,
	    "Filter": true,
	    "dom": 'rtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
	    "ajax": {
	        "url": "/ADM/admin_withdrawalList/"+COIN_NUM+"/"+MEMBER_NUM,
	        "type": "POST",
	    	error: function (xhr, error, thrown) {
				console.log(xhr);
				console.log(error);
				console.log(thrown);
				if (xhr.readyState == 0) {
					return true;
				}
	    	},
	        "dataSrc":function(json){
	        	//for 문
	        	for (var i = 0; i < json.data.length; i++) {
	        		
	 				json.data[i].BANKING_TYPE = "";
		        	json.data[i].WITHDRAW_PROGRESS = "";
		        	
	        		if ( json.data[i].BANKING_KIND == "12" ) {
	        			json.data[i].BANKING_TYPE = "<label class='deposit_data'>입금</label>"
	        			json.data[i].BANKING_KIND = "입금"
	        		} else if ( json.data[i].BANKING_KIND == "16") {
	        			json.data[i].BANKING_TYPE = "<label class='deposit_data'>강제입금</label>"
	        			json.data[i].BANKING_KIND = "강제입금"
	        		} else if ( json.data[i].BANKING_KIND == "17" ) {
	        			json.data[i].BANKING_TYPE = "<label class='deposit_data'>채굴입금</label>"
	        			json.data[i].BANKING_KIND = "채굴입금"
	        		} else if ( json.data[i].BANKING_KIND == "22" || json.data[i].BANKING_KIND == "24" || json.data[i].BANKING_KIND == "25") {
	        			json.data[i].BANKING_TYPE = "<label class='withdraw_data'>출금</label>"
       					json.data[i].BANKING_KIND = "출금"
	        		} else if ( json.data[i].BANKING_KIND == "26") {
	        			json.data[i].BANKING_TYPE = "<label class='withdraw_data'>강제출금</label>"
       					json.data[i].BANKING_KIND = "강제출금"
	        		} else if ( json.data[i].BANKING_KIND == "15" ) {
	        			json.data[i].BANKING_TYPE = "<label class='cancel_auth'>취소</label>"
        				json.data[i].BANKING_KIND = "취소"
	        		}
	        		
	        		if ( json.data[i].WITHDRAW_STATE == "71" ) {
	        			//WITHDRAW_STATE 출금취소 버튼 디비전 만들기.
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_wait'>인증 대기중</label>"
	        			json.data[i].WITHDRAW_STATE = "인증 대기중"
	        		} else if ( json.data[i].WITHDRAW_STATE == "72" ) {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='cancel_auth'>인증 취소</label>"
       					json.data[i].WITHDRAW_STATE = "인증 취소"
	        		} else if ( json.data[i].WITHDRAW_STATE == "73") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>인증 완료</label>"
       					json.data[i].WITHDRAW_STATE = "인증 완료"
	        		}  else if ( json.data[i].WITHDRAW_STATE == "74") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>출금 완료</label>"
       					json.data[i].WITHDRAW_STATE = "출금 완료"
	        		}  else if ( json.data[i].WITHDRAW_STATE == "79") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>입금 완료</label>"
       					json.data[i].WITHDRAW_STATE = "입금 완료"
	        		} 
	        	}
	        	
	        	return json.data;
	        }
	    },
	    "columns": [
	        { "width": "9%", className:"type", "data": "COIN_UNIT"},
	        { "width": "0%", className:"kind", "data": "BANKING_NUM", "visible": false},
	        { "width": "0%", className:"kind", "data": "BANKING_KIND", "visible": false},
	        { "width": "9%", className:"kind", "data": "BANKING_TYPE"},
	        { "width": "16%", className:"amount", "data": "BANKING_AMOUNT" },
	        { "width": "10%", className:"fee", "data": "WITHDRAW_FEE" },
	        { "width": "17%", className:"balance", "data": "BANKING_BALANCE" },
	        { "width": "0%", className:"fee", "data": "WITHDRAW_STATE", "visible": false },
	        { "width": "10%", className:"state", "data": "WITHDRAW_PROGRESS"},
	        { "width": "19%", className:"date", "data": "BANKING_DATE" }

	    ],
	    
       initComplete: function () {
           var coin = this.api().column(0);
           var type = this.api().column(2);
           var state = this.api().column(7);
           
           var select = $('<select class="withListSelectBox "><option value="">전체</option>')
           //코인 필터링
           .appendTo('#selectTriggerFilter')
           .on('change', function () {
              var val = $(this).val();
              coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
           });
           coin.data().unique().sort().each(function (d, j) {
               select.append('<option value="' + d + '">' + d + '</option>');
           });
           
           //분류 필터링
           var type_select = $('<select class="withListSelectBox "><option value="">전체</option>')
           .appendTo('#selectTypeFilter')
           .on('change', function () {
              var val = $(this).val();
              type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
           });
           type.data().unique().sort().each(function (d, j) {
           	type_select.append('<option value="' + d + '">' + d + '</option>');
           });
           
           //상태 필터링
           var state_select = $('<select class="withListSelectBox "><option value="">전체</option>')
           .appendTo('#selectStateFilter')
           .on('change', function () {
              var val = $(this).val();
              state.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
           });
           state.data().unique().sort().each(function (d, j) {
           	state_select.append('<option value="' + d + '">' + d + '</option>');
       	});
   	}
	});
});

</script>
</head>
<body>
<div class="krw_withdraw_wrap" id="krw_withdraw_wrap">
	<div style="text-align:right; margin-right:125px;">
		<div class="withListSelect_form" id="selectTriggerFilter"><label><b>마켓 : </b></label></div>
		<div class="withListSelect_form" id="selectTypeFilter"><label><b>분류 : </b></label></div>
		<div class="withListSelect_form" id="selectStateFilter"><label><b>상태 : </b></label></div>
	</div>
	<table id="krw_withdrawInfo" class="display" cellspacing="0" height="20%" style="width:90%; margin:0; position:relative; top:20px;" >
		<thead>
			<tr>
                <th>코인</th> 
                <th>&nbsp;</th> 
                <th>&nbsp;</th> 
                <th>분류</th>
                <th style="text-align:left;">금액</th>
                <th style="text-align:left;">수수료</th>
                <th style="text-align:left;">잔액</th>
                <th>&nbsp;</th>
                <th>상태</th>
                <th>시각</th>
			</tr>
		</thead>
	</table>
</div>

</body>
</html>