<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.withdrawal_wrap {
	width:100%;
	height:100%;
	margin-left:100px;
}
.withdrawal_hearder {
	width:100%;
	height:50px;
}

#withdrawal_type > label {
	display:inline-block;
	font-size:12px;
	text-align:center;
	width:150px;
	height:35px;
	line-height:35px;
	font-weight:700;
	color:#fff;
	border-width:1px 1px 0;
	background-color:#aacef4;
}
.withdrawal_type {
	font-family: 'Nanum Gothic', serif;
    width: 580px;
}
#withdrawal_type input:nth-of-type(1):checked ~ div:nth-of-type(1),
#withdrawal_type input:nth-of-type(2):checked ~ div:nth-of-type(2){
	display:block;
	margin:0 auto;
	width:450px;
	height:170px;
	padding:70px;
}
#withdrawal_type input[type=radio]:nth-of-type(1), #withdrawal_type input[type=radio]:nth-of-type(1) ~ div:nth-of-type(1),
#withdrawal_type input[type=radio]:nth-of-type(2), #withdrawal_type input[type=radio]:nth-of-type(2) ~ div:nth-of-type(2){
	display:none;	
}
#withdrawal_type > label:hover {
    cursor: pointer;
}
#withdrawal_type input:nth-of-type(1):checked ~ label:nth-of-type(1), 
#withdrawal_type > label[for=krw_withdrawal_title]:hover,#withdrawal_type > label[for=krw_withdrawal_title]:focus{
	background:#7a92ac;
}
#withdrawal_type input:nth-of-type(2):checked ~ label:nth-of-type(2),
#withdrawal_type > label[for=coin_withdrawal_title]:hover,#withdrawal_type > label[for=coin_withdrawal_title]:focus{
	background:#7a92ac;
}
#withdrawal_type > label[for=krw_withdrawal_title]:hover,
#withdrawal_type > label[for=coin_withdrawal_title]:hover{
	background:#7a92ac;
}
.withdrawal_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
	text-align:center;
}
.email_resend {
	font-size:11px;
	cursor:pointer;
	color:#ED6E02;
	font-weight:600;
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
.deposit_krw {
	color:#ED6E02;
	font-weight:600;
	font-size:11px;
	cursor:pointer;
}
.withdraw_krw {
	color:#161B61;
	font-weight:600;
	font-size:12px;
	cursor:pointer;
}
.withdraw_list {
	font-size:12px;
	font-weight:600;
	cursor:pointer;
	color:#6f89a4;
}
.coinSelect_form {
	display:inline-block;
	width:250px;
}
.coinSelectBox {
	width:150px;
}
#content_krw table.dataTable.hover tbody tr:hover, #content_krw table.dataTable.display tbody tr:hover {
	cursor:pointer;
}
#content_coin table.dataTable.hover tbody tr:hover, #content_coin table.dataTable.display tbody tr:hover {
	cursor:pointer;
}
</style>
<script>
var Withdarw_MemberInfoTable = "";
var KrwWithdrawInfoTable ="";
var CoinWithdrawInfoTable = "";
$(document).ready( function() {
	
	$(document).off('click','#withdraw_memberInfos td #deposit_krw');
	$(document).off('click','#withdraw_memberInfo td #withdraw_krw');
	$(document).off('click','#withdraw_memberInfo td #withdrawal_list_btn');
	$(document).off('click','#coin_withdraw_Info td #deposit_coin');
	$(document).off('click','#coin_withdraw_Info td #withdraw_coin');
	$(document).off('click','#coin_withdraw_Info td #withdrawal_list_btn_coin');
	$(document).off('click','#deposit_close');
	$(document).off('click','#withdraw_close');
	$(document).off('click','#Pop_close');
	
	$('#withdraw_memberInfo tbody').off( 'click', 'tr');
	$('#coin_withdraw_Info tbody').off( 'click', 'tr');
	
//####################### KRW #######################
	Withdarw_MemberInfoTable = $("#withdraw_memberInfo").DataTable({
    
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
	    "pageLength": 7,
	    "Filter": true,
	    "dom": 'rtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
		"ajax": {
		    "url": "/ADM/memberInfo",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
		    	
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].DEPOSIT = "<span class='deposit_krw' id='deposit_krw'> [ 입금 ] </span>";
	        		json.data[i].WITHDRAW = "<span class='withdraw_krw' id='withdraw_krw'> [ 출금 ] </span>";
					json.data[i].WITHDRAW_LIST = "<span class='withdraw_list' id='wallet_list_btn'> [ 잔액 확인 ] </span>";
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
// 			{ "width": "5%", className:"null", "defaultContent":"<div>&nbsp</div>", "data":null},
		    { "width": "6%", className:"mem_num", "data": "MEMBER_NUM"},
		    { "width": "15%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "10%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "10%", className:"mem_phone", "data": "MEMBER_PHONE" },
		    { "width": "16%", className:"mem_login", "data": "MEMBER_LOGINDATE" },
		    { "width": "6%", className:"mem_login", "data": "DEPOSIT" },
		    { "width": "6%", className:"mem_login", "data": "WITHDRAW" },
		    { "width": "10%", className:"mem_login", "data": "WITHDRAW_LIST" },
// 		    { "width": "5%", className:"null", "defaultContent":"<div>&nbsp</div>", "data":null}
		],
		"initComplete": function(settings, json) {
		
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				$("#withdrawal_List_form").hide();
				Withdarw_MemberInfoTable.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				Withdarw_MemberInfoTable.column(1).search("").draw();
				Withdarw_MemberInfoTable.column(2).search("").draw();
				Withdarw_MemberInfoTable.column(3).search("").draw();
			}); 
		}
	});

	$('#withdraw_memberInfo tbody').on('click', 'tr', function (e) {
		
		if(e.target.offsetParent.id != "withdraw_memberInfo" ) return;
		
	    var data = Withdarw_MemberInfoTable.row( this ).data();
	    
// 	    var MEMBER_NUM = data["MEMBER_NUM"];
// 	    var MEMBER_ID = data["MEMBER_ID"];
// 	    $('#popup_mask').show();
// 	    $('#balance_form').show();
	   
//    		$("#balance_content").load( "/ADM/balance/"+MEMBER_NUM , function() {
//     	}); 
   		
	    MEMBER_NUM = data["MEMBER_NUM"];
		COIN_NUM = 1;
		
		$("#withdrawal_List_form").show();
		$("#withdrawal_List_form").load("/ADM/admin_withdrawal_ListPage/"+COIN_NUM+"/"+MEMBER_NUM , function() {
			
		});
	}); 
	
	//입금
	$(document).on('click','#withdraw_memberInfo td #deposit_krw',function(){
		var row_data = $(this).closest('tr');
	    MEMBER_NUM = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_NUM'];
	    MEMBER_NAME = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_ID'];
	    COIN_UNIT = "KRW"; 
	    
	    $('#popup_mask').show();
	    $('#balance_form').show();
   		$("#balance_content").load( "/ADM/deposit/"+MEMBER_NUM+"/1" , function() {
   			
   			$("#deposit_btn").on('click', function() {
   				
   				if ( $("#deposit_amount").val() == "" ) {
   					alert("입금 금액을 입력해주세요.");
   					return;
   				}
   				
   				if ( $("#deposit_reason").val() == "" ) {
   					alert("사유를 입력해주세요.");
   					return;
   				}
   				
   				if ( $("#admin_password").val() == "" ) {
   					alert("비밀번호를 입력해주세요.");
   					return;
   				}
   				var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n코인 : " + COIN_UNIT + "\n금액 : " + $("#deposit_amount").val() + " " + COIN_UNIT + "\n\n회원에 대하여 입금을 실행하시겠습니까?");
   		    	
   		    	if ( confirm_rst == false) {
   		    		return;
   		    	} else {
   		    		$("#progresspanel").show();   
   				    
   				    var url = "/ADM/deposit_process";
   				    setTimeout(function(){
   				    	$.ajax({
   				    		type:"POST",
   				    		url:url,
   				    		async:false,
   				    		dataType : 'json',
   				    		data: {
   				    			"MEMBER_NUM":MEMBER_NUM,
   				    			"COIN_NUM":"1",
   				    			"DEPOSIT_AMOUNT":$("#deposit_amount").val().replace(/,/g, ''),
   				    			"DEPOSIT_REASON":$("#deposit_reason").val(),
   				    			"ADMIN_PASSWORD":$("#admin_password").val(),
   				    			"DEPOSIT_TYPE":$("#deposit_type").val()
   				    		},
   				    		success:function(obj) { //가져오는 값(변수)
   				     			if (obj.ResultCode == "0") {
   				     				alert(obj.Data); 
   				      				$("#progresspanel").hide();
   				      				$('#balance_form').hide();
   				      				$('#popup_mask').hide();
   				      				$("#withdraw_wrap").empty();
   				      				Withdarw_MemberInfoTable.ajax.reload(null, false);
   				     			} else if ( obj.ResultCode == "100") {
   				     				alert(obj.Data);
   				     				$("#progresspanel").hide();
   									location.href="/ADM/loginPage";
   				     			} else {
   				     				alert(obj.Data);
   				     				$("#progresspanel").hide();
   				     				return;
   				     			}
   				    		},
   				    		error:function(e) { //500 ERR
   				    			//서버내부오류
   				    			alert("잠시 후 시도해주세요.");
   				    			$("#progresspanel").hide();
   				    			return;
   				    		}
   				    	});
   				    	
   				    },100);
   		    	}
   			});
   		});
	});
	
	//입출금 목록
	$(document).on('click','#withdraw_memberInfo td #wallet_list_btn',function(){
		$("#withdraw_wrap").empty();
		var row_data = $(this).closest('tr');
// 	    MEMBER_NUM = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_NUM'];
// 		COIN_NUM = 1;
		
// 		$("#withdrawal_List_form").show();
// 		$("#withdrawal_List_form").load("/ADM/admin_withdrawal_ListPage/"+COIN_NUM+"/"+MEMBER_NUM , function() {
			
// 		});
		
		
		MEMBER_NUM = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_NUM'];
		MEMBER_ID = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_ID'];

		$('#popup_mask').show();
	    $('#balance_form').show();
	   
   		$("#balance_content").load( "/ADM/balance/"+MEMBER_NUM , function() {
    	}); 
	});
	
	//출금
	$(document).on('click','#withdraw_memberInfo td #withdraw_krw',function(){
		$("#withdraw_wrap").empty();
		var row_data = $(this).closest('tr');
	    MEMBER_NUM = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_NUM'];
	    MEMBER_NAME = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = Withdarw_MemberInfoTable.row(row_data).data()['MEMBER_ID'];
		COIN_NUM = 1;
		COIN_UNIT = "KRW";
		
		$("#balance_form").show();
		$("#popup_mask").show();
		$("#balance_content").load("/ADM/withdraw/"+MEMBER_NUM+"/"+COIN_NUM , function() {
			
			$("#withdraw_btn").on('click', function() { 
				
				if ( $("#withdraw_amount").val() == "" || new Big($("#withdraw_amount").val().replace(/,/g, '')).cmp(new Big(0)) == 0) {
					alert("출금 금액을 입력해주세요.");
					return;
				}
				
				if ( new Big($("#withdraw_amount").val().replace(/,/g, '')).cmp(new Big(0))<=0) {
					alert("금액을 다시 입력해주세요.");
					return;
				}
				
				if ( $("#withdraw_account").val() == "") {
					alert("계좌번호를 입력해주세요.");
					return;
				}
				
				if ( $("#withdraw_reason").val() == "" ) {
					alert("사유를 입력해주세요.");
					return;
				}
				
				if ( $("#admin_password").val() == "" ) {
					alert("비밀번호를 입력해주세요.");
					return;
				}
				
				if ( $("#withdraw_total").val() != "force" ) {
					if ( new Big($("#withdraw_amount").val().replace(/,/g, '')).cmp(MaxWithdraw.toFixed(8)) > 0 ){
						alert("잔액이 부족합니다.");
						return;
					}
				}
				console.log($("#withdraw_amount").val().replace(/,/g, ''));
				console.log($("#withdraw_fee").val().replace(/,/g, ''));
				console.log($("#withdraw_total").val().replace(/,/g, ''));
				var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n코인 : " + COIN_UNIT + "\n금액 : " + $("#withdraw_amount").val() + " " + COIN_UNIT + "\n\n회원에 대하여 출금을 실행하시겠습니까?");
				
				if ( confirm_rst == false) {
			   		return;
			   	} else {
				//ajax 
					$("#progresspanel").show();
					var url = "/ADM/withdraw_process/"+MEMBER_NUM+"/"+COIN_NUM;
					
					setTimeout(function(){
						$.ajax({
							type:"POST",
							url:url,
							dataType : 'json',
							data: {
								"withdraw_amount":$("#withdraw_amount").val().replace(/,/g, ''), //이체 금액
								"withdraw_fee":$("#withdraw_fee").val().replace(/,/g, ''), //이체 수수료
								"withdraw_total":$("#withdraw_total").val().replace(/,/g, ''), //총액
								"withdraw_bank":$("#withdraw_bank").val(), // 은행
								"withdraw_account":$("#withdraw_account").val(), // 계좌
								"WITHDRAW_REASON":$("#withdraw_reason").val(),
								"ADMIN_PASSWORD":$("#admin_password").val(), //비밀번호
								"WITHDRAW_TYPE":$("#withdraw_type").val()
							},
							success:function(obj) { //가져오는 값(변수)
								if (obj.ResultCode == "0") {
									alert(obj.Data);
									$("#progresspanel").hide();
									$("#balance_form").hide();
									$("#popup_mask").hide();
									walletDataReload();
								} else if (obj.ResultCode == "100"){
									alert(obj.Data);
									$("#progresspanel").hide();
									$("#balance_form").hide();
									$("#popup_mask").hide();
									return "/ADM/loginPage";
								} else { 
									alert(obj.Data);
									$("#progresspanel").hide();
									return;
								}
							},
							error:function(e) { //500 ERR
								//서버내부오류
								console.log(e);
								alert("잠시 후 시도해주세요.");
								$("#progresspanel").hide();
								return;
							}
						});	
					},500);
			   	}
			});
		});
	});

	$(document).on('click','#deposit_close',function(){
	    $('#popup_mask').hide();
	    $('#balance_form').hide();
    	$("#deposit_wrap").empty();
	});
	
	$(document).on('click','#withdraw_close',function(){
	    $('#popup_mask').hide();
	    $('#balance_form').hide();
    	$("#withdraw_wrap").empty();
	});

 	$("#Pop_close").on("click", function() {	
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#withdraw_wrap").empty();
    	$("#deposit_wrap").empty();
    });
 	
 	//###################### COIN DataTable ############################
 	CoinWithdrawInfoTable = $("#coin_withdraw_Info").DataTable({
 	    
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
	    "pageLength": 7,
	    "Filter": true,
	    "dom": 'rtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
		"ajax": {
		    "url": "/ADM/walletInfoList",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
		    	
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].DEPOSIT = "<span class='deposit_krw' id='deposit_coin'> [ 입금 ] </span>";
	        		json.data[i].WITHDRAW = "<span class='withdraw_krw' id='withdraw_coin'> [ 출금 ] </span>";
// 					json.data[i].WITHDRAW_LIST = "<span class='withdraw_list' id='withdrawal_list_btn_coin'> [ 입·출금 목록 ] </span>";
					json.data[i].WITHDRAW_LIST = "<span class='withdraw_list' id='withdrawal_list_btn_coin'> [ 잔액 확인 ] </span>";
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
		    { "width": "6%", className:"mem_num", "data": "MEMBER_NUM"},
		    { "width": "0%", className:"mem_num", "data": "COIN_NUM", "visible": false},
		    { "width": "16%", className:"mem_login", "data": "COIN_UNIT" },
		    { "width": "15%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "10%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "10%", className:"mem_phone", "data": "MEMBER_PHONE" },
		    { "width": "16%", className:"mem_login", "data": "MEMBER_LOGINDATE" },
		    { "width": "6%", className:"mem_login", "data": "DEPOSIT" },
		    { "width": "6%", className:"mem_login", "data": "WITHDRAW" },
		    { "width": "10%", className:"mem_login", "data": "WITHDRAW_LIST" }
		],
		"initComplete": function(settings, json) {
		
		   var coin = this.api().column(2);
           
		   //default
		   coin.search('BTC').draw();
		   
           var select = $('<select class="coinSelectBox " id="coinSelectBox">')
           //코인 필터링
           .appendTo('#coinSelect')
           .on('change', function () {
        	   $("#withdrawal_List_form").hide();
              var val = $(this).val();
              coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
           });
           coin.data().unique().sort().each(function (d, j) {
               select.append('<option value="' + d + '">' + d + '</option>');
           });
           
	       $("#coinSelectBox").val("BTC");
	       
			$('#find_input_2').unbind();
			$('#find_input_2').bind('keyup', function(e) {
				$("#withdrawal_List_form").hide();				
				var str = this.value;//.replace(" ","|").replace("||","|").replace("||","|").replace("||","|").replace("||","|").replace("||","|");
				//CoinWithdrawInfoTable.column($('#find_type_2').val()).search( str, true, false ).draw();
				CoinWithdrawInfoTable.column($('#find_type_2').val()).search( str ).draw();				
			}); 
			
			$('#find_type_2').bind('change', function(e) {
				CoinWithdrawInfoTable.column(3).search("").draw();
				CoinWithdrawInfoTable.column(4).search("").draw();
				CoinWithdrawInfoTable.column(5).search("").draw();
			}); 
		}
	});
 	
 	$('input[name=withdrawal_title]').on('change', function () {
	 	if ( $('input:radio[id=krw_withdrawal_title]').is(':checked') == true  ) {
	 		$("#content_krw").show();
	 		$("#withdrawal_List_form").hide();
	 		$("#content_coin").hide();
	 	} else if ( $('input:radio[id=coin_withdrawal_title]').is(':checked') == true ){
	 		$("#content_coin").show();
	 		$("#withdrawal_List_form").hide();
	 		$("#content_krw").hide();
	 	}
 	});
 	
 	//입출금 목록
	$('#coin_withdraw_Info tbody').on('click', 'tr', function (e) {
		
		if(e.target.offsetParent.id != "coin_withdraw_Info" ) return;
		
	    var data = CoinWithdrawInfoTable.row( this ).data();
	    
	    var MEMBER_NUM = data["MEMBER_NUM"];
	    var COIN_NUM = data["COIN_NUM"];
	    $("#withdrawal_List_form").show();
		$("#withdrawal_List_form").load("/ADM/admin_withdrawal_ListPage/"+COIN_NUM+"/"+MEMBER_NUM , function() {
			
		});
	}); 
	
	//입금
	//basic = 일반입금
	//miner = 채굴입금
	//force = 강제입금
	$(document).on('click','#coin_withdraw_Info td #deposit_coin',function(){
		var row_data = $(this).closest('tr');
	    MEMBER_NUM = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_NUM'];
	    COIN_NUM = CoinWithdrawInfoTable.row(row_data).data()['COIN_NUM'];
	    MEMBER_NAME = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_ID'];
	    COIN_UNIT = CoinWithdrawInfoTable.row(row_data).data()['COIN_UNIT'];
	    
	    $('#popup_mask').show();
	    $('#balance_form').show();
   		$("#balance_content").load( "/ADM/deposit/"+MEMBER_NUM+"/"+COIN_NUM , function() {
   			
   			$("#deposit_btn").on('click', function() {
   				
   				if ( $("#deposit_amount").val() == "" ) {
   					alert("입금 금액을 입력해주세요.");
   					return;
   				}
   				
   				if ( $("#deposit_reason").val() == "" ) {
   					alert("사유를 입력해주세요.");
   					return;
   				}
   				
   				if ( $("#admin_password").val() == "" ) {
   					alert("비밀번호를 입력해주세요.");
   					return;
   				}
   				
   				var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n코인 : " + COIN_UNIT + "\n금액 : " + $("#deposit_amount").val() + " " + COIN_UNIT + "\n\n회원에 대하여 입금을 실행하시겠습니까?");
   		    	
   		    	if ( confirm_rst == false) {
   		    		return;
   		    	} else {
   		    		$("#progresspanel").show();   
   				    
   				    var url = "/ADM/deposit_process";
   				    setTimeout(function(){
   				    	$.ajax({
   				    		type:"POST",
   				    		url:url,
   				    		async:false,
   				    		dataType : 'json',
   				    		data: {
   				    			"MEMBER_NUM":MEMBER_NUM,
   				    			"COIN_NUM":COIN_NUM,
   				    			"DEPOSIT_AMOUNT":$("#deposit_amount").val(),
   				    			"DEPOSIT_REASON":$("#deposit_reason").val(),
   				    			"ADMIN_PASSWORD":$("#admin_password").val(),
   				    			"DEPOSIT_TYPE":$("#deposit_type").val(),
   				    			"REWARD_FEE":$("#deposit_fee").val(),
   				    			"MINER_COUNT":$("#miner_count").val(),
   				    			"EMAIL_SEND":$("#miner_email_chk").is(":checked")
   				    		},
   				    		success:function(obj) { //가져오는 값(변수)
   				     			if (obj.ResultCode == "0") {
   				     				alert(obj.Data); 
   				      				$("#progresspanel").hide();
   				      				$('#balance_form').hide();
   				      				$("#popup_mask").hide();
   				      				$("#deposit_wrap").empty();
   				      				Withdarw_MemberInfoTable.ajax.reload(null, false);
   				     			} else if ( obj.ResultCode == "100") {
   				     				alert(obj.Data);
   				     				$("#progresspanel").hide();
   				     				$("#balance_form").hide();
   				     				$("#popup_mask").hide();
   									location.href="/ADM/loginPage";
   				     			} else {
   				     				alert(obj.Data);
   				     				$("#progresspanel").hide();
   				     				return;
   				     			}
   				    		},
   				    		error:function(e) { //500 ERR
   				    			//서버내부오류
   				    			alert("잠시 후 시도해주세요.");
   				    			$("#progresspanel").hide();
   				    			return;
   				    		}
   				    	});
   				    	
   				    },100);
   		    	}
   			});
   		});
	});
	
	//잔액 확인 
	$(document).on('click','#coin_withdraw_Info td #withdrawal_list_btn_coin',function(){
		$("#krw_withdraw_wrap").empty();
		
		var row_data = $(this).closest('tr');
	    MEMBER_NUM = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_NUM'];
	    COIN_NUM = CoinWithdrawInfoTable.row(row_data).data()['COIN_NUM'];    
	    $('#popup_mask').show();
	    $('#balance_form').show();
	   
   		$("#balance_content").load( "/ADM/balance/"+MEMBER_NUM , function() {
   		});
	});
	
	//출금
	$(document).on('click','#coin_withdraw_Info td #withdraw_coin',function(){
		$("#withdraw_wrap").empty();
		var row_data = $(this).closest('tr');
	    MEMBER_NUM = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_NUM'];
	    COIN_NUM = CoinWithdrawInfoTable.row(row_data).data()['COIN_NUM'];
	    MEMBER_NAME = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_NAME'];
	    MEMBER_ID = CoinWithdrawInfoTable.row(row_data).data()['MEMBER_ID'];
	    COIN_UNIT = CoinWithdrawInfoTable.row(row_data).data()['COIN_UNIT'];
	    
		$("#balance_form").show();
		$("#popup_mask").show();
		$("#balance_content").load("/ADM/withdraw/"+MEMBER_NUM+"/"+COIN_NUM , function() {
			
			$("#withdraw_btn").on('click', function() { 
				
				if ( $("#withdraw_amount").val() == "" || new Big($("#withdraw_amount").val()).cmp(new Big(0)) == 0) {
					alert("출금 금액을 입력해주세요.");
					return;
				}
				
				if ( new Big($("#withdraw_amount").val()).cmp(new Big(0))<=0) {
					alert("금액을 다시 입력해주세요.");
					return;
				}
				
				if ( $("#withdraw_addr").val() == "") {
					alert("이체지갑 주소를 입력해주세요.");
					return;
				}
				
				if ( $("#withdraw_reason").val() == "" ) {
					alert("사유를 입력해주세요.");
					return;
				}
				
				if ( $("#admin_password").val() == "" ) {
					alert("비밀번호를 입력해주세요.");
					return;
				}
				
				if ( $("#withdraw_type").val() == "force") {
					console.log("force");
				} else if ( new Big($("#withdraw_amount").val()).cmp(MaxWithdraw.toFixed(8)) > 0 ){
					alert("잔액이 부족합니다.");
					return;
				}
				
				var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n코인 : " + COIN_UNIT + "\n금액 : " + $("#withdraw_amount").val() + " " + COIN_UNIT + "\n\n회원에 대하여 출금을 실행하시겠습니까?");
				
				if ( confirm_rst == false) {
			   		return;
			   	} else {
			   		$("#progresspanel").show();
					var url = "/ADM/withdraw_process/"+MEMBER_NUM+"/"+COIN_NUM;
					
					setTimeout(function(){
						$.ajax({
							type:"POST",
							url:url,
							dataType : 'json',
							data: {
								"withdraw_amount":$("#withdraw_amount").val(), //이체 금액
								"withdraw_fee":$("#withdraw_fee").val(), //이체 수수료
								"withdraw_total":$("#withdraw_total").val(), //총액
								"withdraw_addr":$("#withdraw_addr").val(), // 이체주소
								"WITHDRAW_REASON":$("#withdraw_reason").val(),
								"ADMIN_PASSWORD":$("#admin_password").val(), //비밀번호
								"WITHDRAW_TYPE":$("#withdraw_type").val() //출금 분류
							},
							success:function(obj) { //가져오는 값(변수)
								if (obj.ResultCode == "0") {
									alert(obj.Data);
									$("#progresspanel").hide();
									$("#balance_form").hide();
									$("#popup_mask").hide();
									$("#withdraw_wrap").empty();
									walletDataReload();
								} else if (obj.ResultCode == "100"){
									alert(obj.Data);
									$("#progresspanel").hide();
									$("#balance_form").hide();
									$("#popup_mask").hide();
									return "/ADM/loginPage";
								} else { 
									alert(obj.Data);
									$("#progresspanel").hide();
									return;
								}
							},
							error:function(e) { //500 ERR
								//서버내부오류
								console.log(e);
								alert("잠시 후 시도해주세요.");
								$("#progresspanel").hide();
								return;
							}
						});	
					},500);
			   	}
			});
		});
	});
});

</script>
</head>
<body>
<div class="withdrawal_wrap">
	<div class="withdrawal_hearder">
		<div class="withdrawal_hearder_wrap">
			<div id="withdrawal_type" style="display:inline-block;">
				<input type="radio" id="krw_withdrawal_title" name="withdrawal_title" checked="checked"><label for="krw_withdrawal_title" style="margin-right:-5px;">KRW 입·출금</label>
				<input type="radio" id="coin_withdrawal_title" name="withdrawal_title"><label for="coin_withdrawal_title">COIN 입·출금</label>
			</div>	
		</div>
		
		<!--  KRW -->
		<div id="content_krw">
			<div style="position:absolute; top:1px; right:30px;">
				<div id="find_type_form" class="find_id_form">
					<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
						<option value="2">이름</option>
						<option value="1">ID</option>
						<option value="3">핸드폰 번호</option>
					</select>
				</div>
				<div id="find_text" class="find_id_form">
					<input id="find_input" type="text" size=20px; style="margin-left:10px;">
				</div>
			</div>
			<div>
				<div style="position:relative; top:20px; width:90%; font-size:13px; letter-spacing:1px; ">
					<table id="withdraw_memberInfo" class="display" cellspacing="0" width="80%;" height="80%;">
					        <thead>
					            <tr style="text-align:left;">
					                <th>번호</th>
					                <th>ID</th>
					                <th>이름</th>
					                <th>핸드폰 번호</th>
					                <th>마지막 로그인</th>
					                <th>입금</th>
					                <th>출금</th>
					                <th>잔액 확인</th>
					            </tr>
					        </thead>
					</table>
				</div>
			</div>
		</div>
		
		<!-- 코인 -->
		<div id="content_coin" style="display:none;">
			<div style="position:absolute; top:1px; right:30px;">
				<div class="coinSelect_form" id="coinSelect"><label><b>코인 : </b></label></div>
				
				<div id="find_type_form_2" class="find_id_form">
					<select id="find_type_2" style="width:120px; height:22px; padding-left:8px;">
						<option value="4">이름</option>
						<option value="3">ID</option>
						<option value="5">핸드폰 번호</option>
					</select>
				</div>
				<div id="find_text_2" class="find_id_form">
					<input id="find_input_2" type="text" size=20px; style="margin-left:10px;">
				</div>
			</div>
			<div>
				<div style="position:relative; top:20px; width:90%; font-size:13px; letter-spacing:1px; ">
					<table id="coin_withdraw_Info" class="display" cellspacing="0"height="80%;" style="width:100%;">
					        <thead>
					            <tr style="text-align:left;">
					                <th>번호</th>
					                <th>&nbsp;</th>
					                <th>코인</th>
					                <th>ID</th>
					                <th>이름</th>
					                <th>핸드폰 번호</th>
					                <th>마지막 로그인</th>
					                <th>입금</th>
					                <th>출금</th>
					                <th>잔액 확인</th>
					            </tr>
					        </thead>
					</table>
				</div>
			</div>
		</div>
			<div>
				<div id="withdrawal_List_form" style="position:relative; top:30px; ">
	
				</div>
			</div>
	</div>
</div>
</body>
</html>