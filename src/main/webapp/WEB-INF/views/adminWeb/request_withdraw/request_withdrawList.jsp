<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.req_withdrawList_wrap table th {
	font-size:13px;
}
.req_withdrawList_wrap table td {
	font-size:12px;
}
.req_withdrawList_wrap {
	font-size:13px;
	letter-spacing:1px;
	font-weight:500;
}
.dataTables_paginate  {
	margin-top:15px;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
	width:30px !important;
	height:30px !important;
	font-size:12px;
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
.withdraw_data {
	color:#272fa6;
}
.with_suc {
	color:red;
	font-weight:600;
}
.find_id_form {
	display:inline-block;
}
.find_coin_form {
	display:inline-block;
}
.CoinSelect_form {
	width:250px;
	height:22px;
	position:relative;
	display:inline-block;
	line-height:22px;
	font-size:12px;
	text-align:left;
	margin-left:10px;
}
.CoinSelectBox{
	width:150px;
	height:100%;
	line-height:20px;
}
.withdraw_cancel_btn {
	color:#647fe3;
	cursor:pointer;
}
.wallet_address_btn {
	cursor:pointer;
}

.withdraw_type_form {
	width:100px;
	height:40px;
	broder:1px solid #aacef4;
}
.kind {
	text-align:center;
}
/*
#withdraw_auth_type input:nth-of-type(1):checked ~ div:nth-of-type(1),
#withdraw_auth_type input:nth-of-type(2):checked ~ div:nth-of-type(2),
#withdraw_auth_type input:nth-of-type(2):checked ~ div:nth-of-type(3){
	display:block;
	margin:0 auto;
	width:450px;
}
#withdraw_auth_type > label {
	display:inline-block;
	font-size:12px;
	text-align:center;
	width:170px;
	height:35px;
	line-height:35px;
	font-weight:700;
	color:#fff;
	border-width:1px 1px 0;
	background-color:#aacef4;
}
#withdraw_auth_type input[type=radio]:nth-of-type(1), #withdrawal_type input[type=radio]:nth-of-type(1) ~ div:nth-of-type(1),
#withdraw_auth_type input[type=radio]:nth-of-type(2), #withdrawal_type input[type=radio]:nth-of-type(2) ~ div:nth-of-type(2),
#withdraw_auth_type input[type=radio]:nth-of-type(3), #withdrawal_type input[type=radio]:nth-of-type(3) ~ div:nth-of-type(3){
	display:none;	
}
#withdraw_auth_type > label:hover {
    cursor: pointer;
}
#withdraw_auth_type input:nth-of-type(1):checked ~ label:nth-of-type(1), 
#withdraw_auth_type > label[for=withdraw_auth_success]:hover,#withdraw_auth_type > label[for=withdraw_auth_success]:focus{
	background:#7a92ac;
}
#withdraw_auth_type input:nth-of-type(2):checked ~ label:nth-of-type(2),
#withdraw_auth_type > label[for=withdraw_auth_wait]:hover,#withdraw_auth_type > label[for=withdraw_auth_wait]:focus{
	background:#7a92ac;
}
#withdraw_auth_type input:nth-of-type(3):checked ~ label:nth-of-type(3),
#withdraw_auth_type > label[for=withdraw_success]:hover,#withdraw_auth_type > label[for=withdraw_success]:focus{
	background:#7a92ac;
}
#withdraw_auth_type > label[for=withdraw_auth_success]:hover,
#withdraw_auth_type > label[for=withdraw_auth_wait]:hover,
#withdraw_auth_type > label[for=withdraw_auth_success]:hover{
	background:#7a92ac;
}
*/

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
</style>
<script>
var RequestWithdrawTable = "";
$(document).ready(function() { 
	
	$(document).off('click','#req_withdrawList td #withdraw_btn');
	$(document).off('click','#req_withdrawList td #wallet_address_btn');
	$(document).off('click','#req_withdrawList td #withdraw_cancel_btn');
	$(document).off('click','#Pop_close');
	$(document).off('click','#withdraw_close');
	$(document).off('click','#withdraw_btn_confrim');
	$(document).off('click','#withdraw_cancel');
	
// 	$('#req_withdrawList tbody').off( 'click', 'tr');
	
	RequestWithdrawTable = $("#req_withdrawList").DataTable({

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
    "pageLength": 8,
    "Filter": true,
    "dom": 'rtipS',
    "retrieve" : true,
    "ordering": false,
	"autoFill": {
        update: true
    },
	"ajax": {
	    "url": "/ADM/req_withdrawList/1",
	    "type": "POST",  	
	    "dataType": 'json',
        error: function (xhr, error, thrown) {
			console.log(xhr);
			console.log(error);
			console.log(thrown);
			if (xhr.readyState == 0) {
				return true;
			}
        },
        "dataSrc":function (json ) {
		    
        	for (var i = 0; i < json.data.length; i++) {
        		
 				json.data[i].BANKING_TYPE = "";
	        	json.data[i].WITHDRAW_PROGRESS = "";
				json.data[i].WITHDRAW__BUTTON = "";
				json.data[i].WITHDRAW_CANCEL = "";
				
        		if ( json.data[i].BANKING_KIND == "22" || json.data[i].BANKING_KIND == "24" || json.data[i].BANKING_KIND == "25") {
        			json.data[i].BANKING_TYPE = "<label class='withdraw_data'>출금</label>"
    				json.data[i].BANKING_KIND = "출금"
        		} 
        		
        		//취소버튼
        		if (json.data[i].COIN_UNIT == "KRW") {
        			if ( json.data[i].WITHDRAW_STATE == "71" || json.data[i].WITHDRAW_STATE == "73" ) {
        				json.data[i].WITHDRAW_CANCEL = "<span class='withdraw_cancel_btn' id='withdraw_cancel_btn'> [ 취소 ] </span>";
        			}
        		} 
        		
        		if ( json.data[i].WITHDRAW_STATE == "71" ) {
        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_wait'>인증대기 중</label>"
        			json.data[i].WITHDRAW_STATE = "인증대기 중"
       				json.data[i].WITHDRAW_CANCEL = "<span class='withdraw_cancel_btn' id='withdraw_cancel_btn'> [ 취소 ] </span>";
        		} else if ( json.data[i].WITHDRAW_STATE == "73") {
        			json.data[i].WITHDRAW_PROGRESS = "<label class='auth_suc'>인증완료</label>"
    				json.data[i].WITHDRAW_STATE = "인증완료"
    				json.data[i].WITHDRAW__BUTTON = "<span class='withdraw_btn' id='withdraw_btn'> [ 출금 ] </span>"
        		} else if ( json.data[i].WITHDRAW_STATE == "74" ) {
        			json.data[i].WITHDRAW_PROGRESS = "<label class='with_suc'>출금완료</label>"
       				json.data[i].WITHDRAW_STATE = "출금완료"
        		}
        		
        		if (json.data[i].COIN_UNIT != "KRW") {
        			json.data[i].WITHDRAW_TADDR = "<div id='wallet_address_btn' class='address_btn' title="+ json.data[i].WITHDRAW_TADDR + ">" + number_chk(json.data[i].WITHDRAW_TADDR) + "<div class='address_btn_show'>" + json.data[i].WITHDRAW_TADDR + "</div>" + "</div> "; 
        		}
        		
        		if (json.data[i].COIN_UNIT == "KRW") {
        			json.data[i].BANKING_AMOUNT = numberWithCommas(json.data[i].BANKING_AMOUNT);
        		}
        		json.data[i].BANKING_DATE_SHOW = json.data[i].BANKING_DATE + "<br>" + json.data[i].WITHDRAW_MDATE; 
        	}
        	
        	return json.data;
	        
        }
    },
    "columns": [
        { "width": "6%", className:"type", "data": "MEMBER_NUM"},
        { "width": "0%", className:"banking_num", "data": "BANKING_NUM",  "visible": false },
        { "width": "9%", className:"type", "data": "MEMBER_ID"},
        { "width": "7%", className:"type", "data": "MEMBER_NAME"},
        { "width": "9%", className:"type", "data": "MEMBER_PHONE"},
        { "width": "0%", className:"banking_num", "data": "COIN_NUM",  "visible": false },
        { "width": "5%", className:"kind", "data": "COIN_UNIT"},
//         { "width": "5%", className:"kind", "data": "BANKING_TYPE"},
        { "width": "7%", className:"kind", "data": "WITHDRAW_ADDR"},
        { "width": "11%", className:"kind", "data": "WITHDRAW_TADDR"},
        { "width": "10%", className:"amount", "data": "BANKING_AMOUNT" },
        { "width": "12%", className:"balance", "data": "BANKING_BALANCE" },
        { "width": "0%", className:"balance", "data": "WITHDRAW_STATE", "visible": false },
        { "width": "0%", className:"fee", "data": "WITHDRAW_PROGRESS",  "visible": false },
        { "width": "12%", className:"date", "data": "BANKING_DATE_SHOW" },
        { "width": "5.5%", className:"withdraw_btn", "data": "WITHDRAW__BUTTON" },
        { "width": "5.5%", className:"", "data": "WITHDRAW_CANCEL" }
	],
	  initComplete: function () {
          var column_type="10";
//           var coin_type="";
          var val = "";
//           var coin_val = "";
		  var coin = this.api().column(6);
			
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				$("#req_withdrawal_List_form").hide();
				RequestWithdrawTable.column($('#find_type').val()).search( this.value ).draw();
			});
			
			$('#find_type').bind('change', function(e) {
				RequestWithdrawTable.column(2).search("").draw();
				RequestWithdrawTable.column(3).search("").draw();
				RequestWithdrawTable.column(4).search("").draw();
			}); 
			
            //코인 필터링
            var coin_select = $('<select class="CoinSelectBox"><option value="">전체</option>')
            .appendTo('#selectStateFilter')
            .on('change', function () {
            	$("#req_withdrawal_List_form").hide();
               var val = $(this).val();
               coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            coin.data().unique().sort().each(function (d, j) {
            	coin_select.append('<option value="' + d + '">' + d + '</option>');
            });
   		}
	});
	
	$('#req_withdrawList tbody').on('click', 'tr', function (e) {
		if(e.target.offsetParent.id != "req_withdrawList" ) return;
		
	    var data = RequestWithdrawTable.row( this ).data();
	    
	    var MEMBER_NUM = data["MEMBER_NUM"];
	    var MEMBER_ID = data["MEMBER_ID"];
	    var COIN_NUM = data["COIN_NUM"];
		
	    $("#req_withdrawal_List_form").show();
   		$("#req_withdrawal_List_form").load( "/ADM/reqWithdrawalList_page/"+COIN_NUM+"/"+MEMBER_NUM , function() {
    	});
	    
	    $('#popup_mask').show();
	    $('#balance_form').show();
   		$("#balance_content").load( "/ADM/balance/"+MEMBER_NUM , function() {
    	}); 
	}); 
	
	//출금 버튼
    $(document).on('click','#req_withdrawList td #withdraw_btn',function(){
    	var row_data = $(this).closest('tr');
	    MEMBER_NUM = RequestWithdrawTable.row(row_data).data()['MEMBER_NUM'];
	    BANKING_NUM = RequestWithdrawTable.row(row_data).data()['BANKING_NUM'];
	    BANKING_AMOUNT = RequestWithdrawTable.row(row_data).data()['BANKING_AMOUNT'];
	    BANKING_BALANCE = RequestWithdrawTable.row(row_data).data()['BANKING_BALANCE'];
	    WITHDRAW_FEE = RequestWithdrawTable.row(row_data).data()['WITHDRAW_FEE'];
	    MEMBER_NAME = RequestWithdrawTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = RequestWithdrawTable.row(row_data).data()['MEMBER_ID'];
	    COIN_UNIT = RequestWithdrawTable.row(row_data).data()['COIN_UNIT'];
	    
	    BANKING_AMOUNT = numberDeleteCommas(BANKING_AMOUNT);
	    
	    var WITHDRAW_TOTAL = new Big(BANKING_AMOUNT).add(new Big(WITHDRAW_FEE));
	    
	    $('#popup_mask').show();
	    
	    $('#balance_form').show();
	    
	    $("#balance_content").load( "/ADM/withdrawPage/"+MEMBER_NUM+"/"+BANKING_NUM , function() {

    	 	$("#withdraw_close").on("click", function() {
    			$("#withdraw_wrap").empty(); //내용 지우기
    		    $('#balance_form').hide();
    			$('#popup_mask').hide();
    		});
    	 	
	    	$('#withdraw_btn_confrim').on('click', function () { 
	    		
	    		if ( $("#withdraw_reason").val() == "") {
	    			alert("사유를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    		if ( $("#password").val() == "" ) {
	    			alert("비밀번호를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    		
	     		var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n코인 : " + COIN_UNIT + "\n금액 : " + BANKING_AMOUNT + " " + COIN_UNIT + "\n\n회원에 대하여 출금 요청 처리를 실행하시겠습니까?");
	     		
	    		if ( confirm_rst == false) {
	     			return;
	     		} else { 
	     			$("#progresspanel").show();   
				    var url = "/ADM/req_withdraw_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"MEMBER_NUM":MEMBER_NUM,
				    			"BANKING_NUM":BANKING_NUM,
				    			"WITHDRAW_TOTAL":WITHDRAW_TOTAL.toFixed(8),
				    			"BANKING_BALANCE":BANKING_BALANCE,
				    			"ADMIN_PASSWORD":$("#password").val(),
				    			"WITHDRAW_REASON":$("#withdraw_reason").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				     				RequestWithdrawTable.ajax.reload(null, false);
				     				$("#balance_form").hide();
				      				$("#progresspanel").hide();
				      				$("#popup_mask").hide();
				      				$("#withdraw_wrap").empty();
				     			} else if (obj.ResultCode == "100"){
				     				alert(obj.Data);
				     				$("#balance_form").hide();
				     				$("#progresspanel").hide();
				      				$("#popup_mask").hide();
				     				$("#withdraw_wrap").empty();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#balance_form").hide();
				     				$("#progresspanel").hide();
				      				$("#popup_mask").hide();
				     				$("#withdraw_wrap").empty();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#balance_form").hide();
				    			$("#progresspanel").hide();
			      				$("#popup_mask").hide();
				    			$("#withdraw_wrap").empty();
				    			return;
				    		}
				    	});
				    	
				    },1000);
	     		}
			});
	    });
    });
    
  //출금 취소 버튼
    $(document).on('click','#req_withdrawList td #withdraw_cancel_btn',function(){
    	var row_data = $(this).closest('tr');
	    MEMBER_NUM = RequestWithdrawTable.row(row_data).data()['MEMBER_NUM'];
	    BANKING_NUM = RequestWithdrawTable.row(row_data).data()['BANKING_NUM'];
	    BANKING_AMOUNT = RequestWithdrawTable.row(row_data).data()['BANKING_AMOUNT'];
	    BANKING_BALANCE = RequestWithdrawTable.row(row_data).data()['BANKING_BALANCE'];
	    WITHDRAW_FEE = RequestWithdrawTable.row(row_data).data()['WITHDRAW_FEE'];
	    MEMBER_NAME = RequestWithdrawTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = RequestWithdrawTable.row(row_data).data()['MEMBER_ID'];
	    COIN_UNIT = RequestWithdrawTable.row(row_data).data()['COIN_UNIT'];
	    
	    BANKING_AMOUNT = numberDeleteCommas(BANKING_AMOUNT);
	    
	    var WITHDRAW_TOTAL = new Big(BANKING_AMOUNT).add(new Big(WITHDRAW_FEE));
	    
	    $('#popup_mask').show();
	    
	    $('#balance_form').show();
	    
	    $("#balance_content").load( "/ADM/withdraw_cancelPage/"+MEMBER_NUM+"/"+BANKING_NUM , function() {

    	 	$("#withdraw_close").on("click", function() {
    			$("#withdraw_wrap").empty(); //내용 지우기
    		    $('#balance_form').hide();
    			$('#popup_mask').hide();
    		});
    	 	
	    	$('#withdraw_cancel').on('click', function () { 
	    		
	    		if ( $("#withdraw_reason").val() == "") {
	    			alert("사유를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    		if ( $("#password").val() == "" ) {
	    			alert("비밀번호를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    		
	     		var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n코인 : " + COIN_UNIT + "\n금액 : " + BANKING_AMOUNT + " " + COIN_UNIT + "\n\n회원에 대하여 출금 취소 처리를 실행하시겠습니까?");
	     		
	    		if ( confirm_rst == false) {
	     			return;
	     		} else { 
	     			$("#progresspanel").show();   
				    var url = "/ADM/withdraw_cancel_process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"MEMBER_NUM":MEMBER_NUM,
				    			"BANKING_NUM":BANKING_NUM,
				    			"WITHDRAW_TOTAL":WITHDRAW_TOTAL.toFixed(8),
				    			"BANKING_BALANCE":BANKING_BALANCE,
				    			"ADMIN_PASSWORD":$("#password").val(),
				    			"WITHDRAW_REASON":$("#cancel_reason").val()
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				     				RequestWithdrawTable.ajax.reload(null, false);
				     				$("#balance_form").hide();
				      				$("#progresspanel").hide();
				      				$("#popup_mask").hide();
				      				$("#withdraw_wrap").empty();
				     			} else if (obj.ResultCode == "100"){
				     				alert(obj.Data);
				     				$("#balance_form").hide();
				     				$("#progresspanel").hide();
				      				$("#popup_mask").hide();
				     				$("#withdraw_wrap").empty();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#balance_form").hide();
				     				$("#progresspanel").hide();
				      				$("#popup_mask").hide();
				     				$("#withdraw_wrap").empty();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#balance_form").hide();
				    			$("#progresspanel").hide();
			      				$("#popup_mask").hide();
				    			$("#withdraw_wrap").empty();
				    			return;
				    		}
				    	});
				    	
				    },1000);
	     		}
			});
	    });
    });
    
 	$("#Pop_close").on("click", function() {
 		$("#withdraw_wrap").empty();	
 		$("#withdraw_address").empty();	
 		$("#balance_wrap").empty();	
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    });
});

function number_chk(param) {
	var param_rst = param.substr(0,15) + "...";
	return param_rst;
}
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function numberDeleteCommas(x) {
	return x.toString().replace(/,/g, '');
}
</script>
</head>
<body>
<div class="req_withdrawList_wrap" id="req_withdrawList_wrap">
	<div style="display:inline-block; width:100%;" id="withdraw_auth_type">
<!-- 		<input type="radio" id="withdraw_auth_success" name="auth_success" checked="checked"><label for="withdraw_auth_success" style="margin-right:-5px;">출금요청 내역</label> -->
<!-- 		<input type="radio" id="withdraw_auth_wait" name="auth_success"><label for="withdraw_auth_wait">인증대기중인 목록</label> -->
<!-- 		<input type="radio" id="withdraw_success" name="auth_success" ><label for="withdraw_success" style="margin-left:-6px;" >출금완료 목록</label> -->
		
		<div style="display:inline-block; text-align:right; position:relative; right:0px; width:100%;">
			<div class="CoinSelect_form" id="selectStateFilter"><label><b>코인 : </b></label></div>
			<div id="find_type_form" class="find_id_form">
				<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
					<option value="3">이름</option>
					<option value="2">ID</option>
					<option value="4">핸드폰 번호</option>
				</select>
			</div>
			<div id="find_text" class="find_id_form">
				<input id="find_input" type="text" size=20px; style="margin-left:10px;">
			</div>
		</div>
	</div>
	<table id="req_withdrawList" class="display" cellspacing="0" height="100%" style="width:100%; margin-top:20px;">
		<thead>
			<tr style="text-align:left">
                <th>번호</th> 
                <th>&nbsp;</th> 
                <th>아이디</th> 
                <th>이름</th> 
                <th>핸드폰 번호</th> 
                <th>&nbsp;</th>
                <th>코인</th> 
                <th>은헁</th> 
                <th>계좌</th> 
<!--                 <th>분류</th> -->
                <th>금액</th>
                <th>잔액</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>시각</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
			</tr>
		</thead>
	</table>
	
	<div id="req_withdrawal_List_form" style="position:relative; top:30px; display:none; ">
		
	</div>
</div>
</body>
</html>