<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
var req_withdrawal_list = "";
$(document).ready( function() {
	req_withdrawal_list = $("#req_withdrawal_List").DataTable({
	    "language": {
			    "emptyTable": "입·출금내역이 없습니다.",
				"zeroRecords": "입·출금내역이 없습니다",
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
	    "pageLength": 5,
	    "Filter": true,
	    "dom": 'rtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
		"ajax": {
		    "url": "/ADM/reqWithdrawalList_data/"+${COIN_NUM}+"/"+${MEMBER_NUM},
		    "type": "POST",		 
		    "dataSrc":function(json) { 
		    	
		    	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].BANKING_KIND_SHOW = "";
	        		json.data[i].WITHDRAW_STATE_SHOW = "";
	        		json.data[i].WITHDRAW_STATE_TYPE = "";
	        		json.data[i].BANKING_TYPE = "";
	        		json.data[i].WITHDRAW_PROGRESS = "";
	
	        		if ( json.data[i].BANKING_KIND == "12") {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='deposit_data'>입금</label>";
	        			json.data[i].BANKING_TYPE = "입금";
	        		} else if ( json.data[i].BANKING_KIND == "16") {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='deposit_data'>강제입금</label>";
	        			json.data[i].BANKING_TYPE = "강제입금";
	        		} else if ( json.data[i].BANKING_KIND == "17" ) {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='deposit_data'>채굴입금</label>";
	        			json.data[i].BANKING_TYPE = "채굴입금";
	        		} else if ( json.data[i].BANKING_KIND == "22" || json.data[i].BANKING_KIND == "24" || json.data[i].BANKING_KIND == "25") {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='withdraw_data'>출금</label>";
	    				json.data[i].BANKING_TYPE = "출금";
	        		} else if ( json.data[i].BANKING_KIND == "26") {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='withdraw_data'>강제출금</label>";
	   					json.data[i].BANKING_TYPE = "강제출금";
	        		} else if ( json.data[i].BANKING_KIND == "15" ) {
	        			json.data[i].BANKING_KIND_SHOW = "<label class='cancel_auth'>취소</label>";
	        				json.data[i].BANKING_TYPE = "취소";
	        		}
	        		
	        		if ( json.data[i].WITHDRAW_STATE == "71" ) {
	        			//WITHDRAW_STATE 출금취소 버튼 디비전 만들기.
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_wait'>인증 대기중</label>";
	        			json.data[i].WITHDRAW_STATE_TYPE = "인증 대기중";
	        		} else if ( json.data[i].WITHDRAW_STATE == "72" ) {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='cancel_auth'>인증 취소</label>";
	    				json.data[i].WITHDRAW_STATE_TYPE = "인증 취소";
	        		} else if ( json.data[i].WITHDRAW_STATE == "73") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>인증 완료</label>";
	    				json.data[i].WITHDRAW_STATE_TYPE = "인증 완료";
	        		}  else if ( json.data[i].WITHDRAW_STATE == "74") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>출금 완료</label>";
	    				json.data[i].WITHDRAW_STATE_TYPE = "출금 완료";
	        		}  else if ( json.data[i].WITHDRAW_STATE == "79") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>입금 완료</label>";
	    				json.data[i].WITHDRAW_STATE_TYPE = "입금 완료";
	        		} 
	        		
	        		json.data[i].BANKING_AMOUNT_SHOW = json.data[i].BANKING_AMOUNT + " " + json.data[i].COIN_UNIT;
	        		json.data[i].BANKING_BALANCE_SHOW = json.data[i].BANKING_BALANCE + " " + json.data[i].COIN_UNIT;
	        		
	        		
					if (json.data[i].WITHDRAW_TADDR.length > 12 ) {
							json.data[i].WITHDRAW_TADDR = "<div id='wallet_address_btn' class='address_btn' title="+ json.data[i].WITHDRAW_TADDR + ">" + number_chk(json.data[i].WITHDRAW_TADDR) + "<div class='address_btn_show'>" + json.data[i].WITHDRAW_TADDR + "</div>" + "</div> "; 
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
			{ "width": "5%", className:"kind", "data": "MEMBER_NUM"},
		    { "width": "11%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "10%", className:"kind", "data": "MEMBER_NAME" },
		    { "width": "5%", className:"kind", "data": "COIN_UNIT" },
		    { "width": "0%", className:"", "data": "COIN_NUM", "visible":false },
		    { "width": "0%", className:"", "data": "BANKING_NUM", "visible":false },
		    { "width": "0%", className:"", "data": "BANKING_KIND", "visible":false },
		    { "width": "0%", className:"", "data": "BANKING_TYPE", "visible":false},
		    { "width": "7%", className:"kind", "data": "BANKING_KIND_SHOW"},
		    { "width": "0%", className:"", "data": "BANKING_AMOUNT", "visible":false},
		    { "width": "12%", className:"b_amount", "data": "BANKING_AMOUNT_SHOW" },
		    { "width": "0%", className:"", "data": "BANKING_BALANCE", "visible":false },
		    { "width": "14%", className:"b_balance", "data": "BANKING_BALANCE_SHOW" },
		    { "width": "7%", className:"kind", "data": "WITHDRAW_ADDR" },
		    { "width": "9%", className:"", "data": "WITHDRAW_TADDR" },
		    { "width": "0%", className:"", "data": "WITHDRAW_STATE", "visible":false },
		    { "width": "0%", className:"", "data": "WITHDRAW_STATE_TYPE", "visible":false },
		    { "width": "8%", className:"w_state", "data": "WITHDRAW_PROGRESS"},
		    { "width": "15%", className:"b_date", "data": "BANKING_DATE_SHOW" }
		],
		initComplete: function () {
			$('#find_account_input').unbind();
			$('#find_account_input').bind('keyup', function(e) {
				req_withdrawal_list.column($('#find_account').val()).search( this.value ).draw();
			});
			
  		}
	});
});
</script>
</head>
<body>
<div style="display:inline-block; text-align:right; position:relative; right:0px; width:100%;">
	<div id="find_type_form" class="find_id_form">
		<select id="find_account" style="width:120px; height:22px; padding-left:8px;">
			<option value="14">계좌번호</option>
		</select>
	</div>
	<div id="find_text" class="find_id_form">
		<input id="find_account_input" type="text" size=20px; style="margin-left:10px;">
	</div>
</div>
<table id="req_withdrawal_List" class="display" cellspacing="0" width="100%;" height="80%;">
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
               <th style="text-align:center;">입·출금시각<br>인증시각</th>
           </tr>
       </thead>
</table>
</body>
</html>