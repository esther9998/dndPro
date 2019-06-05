<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.balance_wrap {
	width:800px;
	height:550px;
	background-color:#fff;
	position:relative;
	z-index:11;
    font-weight:500;
    font-size:13px;
	letter-spacing:1px;
	overflow-y:auto;
}
.balance_wrap table.dataTable tbody tr {
	background-color:#ffffff !important;
}
.type {
	text-align:center;
	height:22px;
}
.addr {
	text-align:center;
}
.balance_advise {
	margin-top:15px;
}
.delete_member_cancel {
	display:inline-block;
	background-color:#bbbbbb;
	width:80px;
	height:30px;
	color:#ffffff;
	font-size:13px;
	line-height:30px;
	letter-spacing:1px;
	text-align:center;
	border:1px solid #d7d7d7;
	border-radius:3px;
	margin-left:20px;
	cursor:pointer;
}
.delete_member_set {
	display:inline-block;
	background-color:#bbb;
	width:80px;
	height:30px;
	color:#ffffff;
	font-size:13px;
	line-height:30px;
	letter-spacing:1px;
	text-align:center;
	border:1px solid #d7d7d7;
	border-radius:3px;
	cursor:pointer;
}
.withdraw_data {
	color:#272fa6;
}
.auth_wait {
	color:#de8187;
}
.auth_suc {
	color:#3377bb;
}
</style>

<script>
var MemberBalanceTable = "";
var WithdarwInfoTable = "";
var walletAddressTable = "";
var MEMBER_NUM = "${MEMBER_NUM}";

$(document).ready( function() {
	
	MemberBalanceTable = $("#memberBalance").DataTable({

		"serverSide": false,
        "info": false,
        "searching": false,
        "paging" : false,
        "retrieve" : true,
        "ordering": false,
    	"autoFill": {
            update: true
        },
		"ajax": {
		    "url": "/ADM/balanceList/"+MEMBER_NUM,
		    "type": "POST",  	
		    "dataType": 'json',
	        error: function (xhr, error, thrown) {
				console.log(xhr);
				console.log(error);
				console.log(thrown);
	        }
	    },
	    "columns": [
// 	    	{ "width": "4%", className:"null", "defaultContent":"<div>&nbsp</div>", "data":null},
            { "width": "0%", className:"null", "data":"COIN_KIND", "visible": false},
            { "width": "8%", className:"type", "data": "COIN_UNIT"},
            { "width": "17%", className:"balance", "data": "WALLET_BALANCE" },
            { "width": "18%", className:"wait_balance", "data": "ORDER_SUM" },
            { "width": "17%", className:"total", "data": "WALLET_TOTAL" }
//             { "width": "4%", className:"null", "defaultContent":"<div>&nbsp</div>", "data":null}
		]
	});
	
	walletAddressTable = $("#wallet_addressInfo").DataTable({

		"serverSide": false,
        "info": false,
        "searching": false,
        "paging" : false,
        "retrieve" : true,
        "ordering": false,
    	"autoFill": {
            update: true
        },
		"ajax": {
		    "url": "/ADM/wallet_addressList/"+MEMBER_NUM,
		    "type": "POST",  	
		    "dataType": 'json',
	        error: function (xhr, error, thrown) {
				console.log(xhr);
				console.log(error);
				console.log(thrown);
	        }
	    },
	    "columns": [
// 	    	{ "width": "4%", className:"null", "defaultContent":"<div>&nbsp</div>", "data":null},
            { "width": "15%", className:"type", "data":"COIN_UNIT"},
            { "width": "70%", className:"addr", "data": "WALLET_ADDR"}
//             { "width": "17%", className:"balance", "data": "WALLET_BALANCE" },
//             { "width": "18%", className:"wait_balance", "data": "ORDER_SUM" },
//             { "width": "17%", className:"total", "data": "WALLET_TOTAL" }
//             { "width": "4%", className:"null", "defaultContent":"<div>&nbsp</div>", "data":null}
		]
	});
	
	WithdrawInfoTable = $("#withdrawInfo").DataTable({

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
        "searching": false,
	    "paging" : true,
	    "lengthChange": false,
	    "pageLength": 5,
        "retrieve" : true,
        "ordering": false,
    	"autoFill": {
            update: true
        },
		"ajax": {
		    "url": "/ADM/withdrawList/"+MEMBER_NUM,
		    "type": "POST",  	
		    "dataType": 'json',
	        error: function (xhr, error, thrown) {
				console.log(xhr);
				console.log(error);
				console.log(thrown);
	        },
	        "dataSrc":function (json ) {
			    
	        	for (var i = 0; i < json.data.length; i++) {
	        		
	 				json.data[i].BANKING_TYPE = "";
		        	json.data[i].WITHDRAW_CANCEL = "";
		        	json.data[i].WITHDRAW_PROGRESS = "";
		        	
	        		if ( json.data[i].BANKING_KIND == "12" || json.data[i].BANKING_KIND == "16") {
	        			json.data[i].BANKING_TYPE = "<label class='deposit_data'>입금</label>"
	        			json.data[i].BANKING_KIND = "입금"
	        		} else if ( json.data[i].BANKING_KIND == "22" || json.data[i].BANKING_KIND == "24" || json.data[i].BANKING_KIND == "25") {
	        			json.data[i].BANKING_TYPE = "<label class='withdraw_data'>출금</label>"
        				json.data[i].BANKING_KIND = "출금"
	        		} 
	        		
	        		if ( json.data[i].WITHDRAW_STATE == "71" ) {
	        			//WITHDRAW_STATE 출금취소 버튼 디비전 만들기.
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_wait'>인증 대기중</label>"
	        			json.data[i].WITHDRAW_STATE = "인증 대기중"
	        		} else if ( json.data[i].WITHDRAW_STATE == "73") {
	        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>인증 완료</label>"
        				json.data[i].WITHDRAW_STATE = "인증 완료"
	        		} 
	        	}
	        	
 	        	return json.data;
 	        }
	    },
	    "columns": [
	        { "width": "9%", className:"type", "data": "COIN_UNIT"},
	        { "width": "9%", className:"kind", "data": "BANKING_TYPE"},
	        { "width": "16%", className:"amount", "data": "BANKING_AMOUNT" },
	        { "width": "17%", className:"balance", "data": "BANKING_BALANCE" },
	        { "width": "10%", className:"state", "data": "WITHDRAW_PROGRESS"},
	        { "width": "19%", className:"date", "data": "BANKING_DATE" }
		]
	});
});
</script>
</head>
<body>
<div class="balance_wrap" id="balance_wrap">
	<div style="position:relative; top:30px; width:700px; margin-left:50px;">
		<div style="font-size:14px; margin-bottom:15px;"><span style="font-weight:600;">· ${MEMBER_NAME}</span> <span> 님의 지갑 정보입니다.</span></div>
		<table id="memberBalance" class="display" cellspacing="0" height="80%;" style="width:700px;">
		        <thead>
		            <tr style="text-align:left;">
<!-- 			                <th>&nbsp;</th>  -->
			                <th>&nbsp;</th> 
			                <th>코인</th> 
			                <th>잔액</th>
			                <th>거래중인 금액</th>
			                <th>합계</th>
<!-- 			                <th>&nbsp;</th>  -->
		            </tr>
		        </thead>
		</table>
		
		<div style="margin-top:20px; font-size:12px; letter-spacing:0; margin-bottom:10px;" id='wallet_address_form' >
			<div style="font-size:14px; margin-bottom:10px;"><span style="font-weight:600;">· ${MEMBER_NAME}</span> <span> 님의 지갑 주소 입니다.</span></div>
			<table id="wallet_addressInfo" class="display" cellspacing="0" width=700px;>
				<thead>
					<tr>
						<th>코인</th>
						<th>주소</th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div style="margin-top:20px; font-size:12px; letter-spacing: 0; display:none;" id="withdarw_form">
			<div style="font-size:14px; margin-bottom:15px;"><span style="font-weight:600;">· ${MEMBER_NAME}</span> <span> 님의 출금 대기중 내역입니다.</span></div>
			<table id="withdrawInfo" class="display" cellspacing="0" height="20%" style="width:700px;">
				<thead>
					<tr style="text-align:left">
		                <th>코인</th> 
		                <th>분류</th>
		                <th style="text-align:left;">금액</th>
		                <th style="text-align:left;">잔액</th>
		                <th>상태</th>
		                <th>시각</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="balance_bottom">
			<div class='balance_advise' id='balance_advise'> 
<!-- 				<div style="margin-top:20px; font-size:12px;"><span style="margin-right:20px;">사유 : </span> <input type="text" size="25" id="member_delete_reason"><br><span style="line-height:25px; font-size:11px; color:red;">ex) 2017/06/08 사용자요청에 의해 회원 탈퇴 요청</span> -->
<!-- 				</div> -->
				<div style="margin-top:10px; font-size:12px;"><span style="margin-right:20px;">비밀번호 : </span><input type="password" size=21; id="password"></div>
				<div style="margin-top:20px;"><span style='color:red; font-size:13px; font-weight:600;'>※ 잔액 또는 거래중인 금액이 있을 시 회원 탈퇴가 불가능합니다.</span></div>
				<div style='margin-top:20px; text-align:center; padding-bottom:20px;'> 
					<div class='delete_member_set' id='delete_member_set'>회원탈퇴</div> 
					<div class='delete_member_cancel' id='delete_member_cancel'>닫기</div>
				</div>
			</div>	
		</div>
	</div>
</div>
</body>
</html>