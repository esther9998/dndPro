<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.withdrawList_wrap table th {
	font-size:12px;
}
.withdrawList_wrap table td {
	font-size:12px;
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
.w_taddr {
	width:10% !important;
}
.withdrawList_wrap .mem_num, .coin_unit, .b_kind, .w_state, .b_date, .w_addr {
	text-align:center;
}
.deposit_data {
	color:#ED6E02;
	font-weight:600;
}
.withdraw_data {
	color:#161B61;
	font-weight:600;
}
.auth_wait {
	color:#de8187;
	font-weight:600;
}
.cancel_auth {
	color:#ff0000;
	font-weight:600;
}
.auth_suc {
	color:#3377bb;
	font-weight:600;
}
.WithdrawalSelect_form {
	width:250px;
	height:40px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.WithdrawalSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
.address_btn_show{
	display:none;	
	height:25px; 
	line-height:25px;
	text-align:center;
/* 	padding-left:10px; */
/* 	padding-right:10px; */
	z-index:10;
	background-color:#dddddd; 
}
.address_btn {
	position:relative;
}
.address_btn:hover .address_btn_show {
	display:block;
	position:absolute;
	left:0px;
	top:-5px;
	font-weight:600;
}
</style>
<script>
var WithdrawalListTable = "";
$(document).ready( function() {
	
	$(document).off('click','#withdrawList_all td #withdraw_taddr_btn');
	
	$('#withdrawList_all tbody').off( 'click', 'tr');
	
	WithdrawalListTable = $("#withdrawList_all").DataTable({
    
	    "language": {
   		    "emptyTable": "등록된 출금내역이 없습니다.",
   			"zeroRecords": "검색된 출금내역이 없습니다.",
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
		    "url": "/ADM/withdrawlist_data",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
		    	
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].BANKING_KIND_SHOW = "";
	        		json.data[i].WITHDRAW_STATE_SHOW = "";
	        		json.data[i].WITHDRAW_STATE_TYPE = "";
	        		json.data[i].BANKING_TYPE = "";
	        		json.data[i].WITHDRAW_PROGRESS = "";

	        		if ( json.data[i].BANKING_KIND == "22" || json.data[i].BANKING_KIND == "24" || json.data[i].BANKING_KIND == "25") {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='withdraw_data'>출금</label>"
        				json.data[i].BANKING_TYPE = "출금"
	        		} else if ( json.data[i].BANKING_KIND == "26") {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='withdraw_data'>강제출금</label>"
       					json.data[i].BANKING_TYPE = "강제출금"
	        		} 
	        		
	        		if ( json.data[i].WITHDRAW_STATE == "71" ) {
	        			//WITHDRAW_STATE 출금취소 버튼 디비전 만들기.
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_wait'>인증 대기중</label>"
	        			json.data[i].WITHDRAW_STATE_TYPE = "인증 대기중"
	        		} else if ( json.data[i].WITHDRAW_STATE == "72" ) {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='cancel_auth'>인증 취소</label>"
        				json.data[i].WITHDRAW_STATE_TYPE = "인증 취소"
	        		} else if ( json.data[i].WITHDRAW_STATE == "73") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>인증 완료</label>"
        				json.data[i].WITHDRAW_STATE_TYPE = "인증 완료"
	        		}  else if ( json.data[i].WITHDRAW_STATE == "74") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>출금 완료</label>"
        				json.data[i].WITHDRAW_STATE_TYPE = "출금 완료"
	        		}  else if ( json.data[i].WITHDRAW_STATE == "79") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>입금 완료</label>"
        				json.data[i].WITHDRAW_STATE_TYPE = "입금 완료"
	        		} 
	        		
	        		json.data[i].BANKING_AMOUNT_SHOW = json.data[i].BANKING_AMOUNT + " " + json.data[i].COIN_UNIT;
	        		json.data[i].BANKING_BALANCE_SHOW = json.data[i].BANKING_BALANCE + " " + json.data[i].COIN_UNIT;
	        		
	        		//#######################
	        		//다시확인해볼것 - ! 
	        		if ( json.data[i].WITHDRAW_ADDR == "" )  {
	        			if ( json.data[i].BANKING_KIND == "12" || json.data[i].BANKING_KIND == "16" || json.data[i].BANKING_KIND == "17") {
	        				json.data[i].WITHDRAW_TADDR = "";
	        			} else { 
	   						json.data[i].WITHDRAW_TADDR = "<div class='address_btn' id='address_btn' title='"+json.data[i].WITHDRAW_TADDR+"'>"+number_chk(json.data[i].WITHDRAW_TADDR) + "<div class='address_btn_show'>" + json.data[i].WITHDRAW_TADDR + "</div>" + "</div> ";
	        			}	
	        		}
	        		
	        		json.data[i].BANKING_DATE_SHOW = json.data[i].BANKING_DATE + "<br>" + json.data[i].WITHDRAW_MDATE;
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
		    { "width": "12%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "9%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "6%", className:"coin_unit", "data": "COIN_UNIT" },
		    { "width": "0%", className:"", "data": "COIN_NUM", "visible":false },
		    { "width": "0%", className:"", "data": "BANKING_NUM", "visible":false },
		    { "width": "0%", className:"", "data": "BANKING_KIND", "visible":false },
		    { "width": "0%", className:"", "data": "BANKING_TYPE", "visible":false},
		    { "width": "6%", className:"b_kind", "data": "BANKING_KIND_SHOW"},
		    { "width": "0%", className:"", "data": "BANKING_AMOUNT", "visible":false},
		    { "width": "13%", className:"b_amount", "data": "BANKING_AMOUNT_SHOW" },
		    { "width": "0%", className:"", "data": "BANKING_BALANCE", "visible":false },
		    { "width": "14%", className:"b_balance", "data": "BANKING_BALANCE_SHOW" },
		    { "width": "6%", className:"w_addr", "data": "WITHDRAW_ADDR" },
		    { "width": "10%", className:"w_taddr", "data": "WITHDRAW_TADDR" },
		    { "width": "0%", className:"", "data": "WITHDRAW_STATE", "visible":false },
		    { "width": "0%", className:"", "data": "WITHDRAW_STATE_TYPE", "visible":false },
		    { "width": "7%", className:"w_state", "data": "WITHDRAW_PROGRESS"},
		    { "width": "12%", className:"b_date", "data": "BANKING_DATE_SHOW" },
		],
		"initComplete": function(settings, json) {
		
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				WithdrawalListTable.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				WithdrawalListTable.column(1).search("").draw();
				WithdrawalListTable.column(2).search("").draw();
			}); 
			
			var coin = this.api().column(3);
            var type = this.api().column(7);
            var state = this.api().column(16);
            
            var select = $('<select class="WithdrawalSelectBox"><option value="">전체</option>')
            //마켓 필터링
            .appendTo('#selectTriggerFilter')
                .on('change', function () {
                   var val = $(this).val();
                   coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
                });
            coin.data().unique().sort().each(function (d, j) {
                select.append('<option value="' + d + '">' + d + '</option>');
            });
            
            //타입 필터링
            var type_select = $('<select class="WithdrawalSelectBox"><option value="">전체</option>')
            .appendTo('#selectTypeFilter')
            .on('change', function () {
               var val = $(this).val();
               type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            type.data().unique().sort().each(function (d, j) {
            	type_select.append('<option value="' + d + '">' + d + '</option>');
            });
			
            //상태 필터링
            var state_select = $('<select class="WithdrawalSelectBox"><option value="">전체</option>')
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

function number_chk(param) {
	var param_rst = "";
	if ( param == null ) {
		param_rst = "[지갑주소]";
	} else {
		param_rst = param.substr(0,15) + "...";
	}
	return param_rst;
}

</script>
</head>
<body>
<div class="withdrawList_wrap" id="withdrawList_wrap">
	<div style="width:100%; text-align:right;">
		<div id="find_type_form" class="find_id_form">
			<div class="WithdrawalSelect_form" id="selectTriggerFilter"><label><b>코인 : </b></label></div>
			<div class="WithdrawalSelect_form" id="selectTypeFilter"><label><b>분류 : </b></label></div>
			<div class="WithdrawalSelect_form" id="selectStateFilter"><label><b>상태 : </b></label></div>
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
		<table id="withdrawList_all" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>ID</th>
		                <th>이름</th>
		                <th>코인</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>분류</th>
		                <th>&nbsp;</th>
		                <th>금액</th>
		                <th>&nbsp;</th>
		                <th>잔액</th>
		                <th>은행</th>
		                <th>계좌 및 주소</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>상태</th>
		                <th>출금시각<br>인증시각</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>
</body>
</html>