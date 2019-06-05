<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.coindetail_wrap {
	background-color:#ffffff;
	width:600px;
	height:680px;
	overflow-y:auto;
	padding-bottom:20px;
}
.coindetail_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:40px;
}
.coindetail_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.coindetail_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:37px;
	background-color:#ffffff;
	text-align:center;
}
.coindetail_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:37px;
	background-color:#fffffff;
	padding-left:10px;
    word-break: break-all;
}
.coindetail_close {
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
</style>
<script>
var COIN_MINDEPOSIT = "${COIN_MINDEPOSIT}";
var COIN_KIND = "${COIN_KIND}";
$(document).ready(function() {
	
	var COIN_KIND_VALUE = "";
	
	if ( COIN_MINDEPOSIT == "") {
		$("#coin_mindeposit").text(" ");
	}
	
	//COIN_KIND VALUE 셋팅
	//상세내역에서만 코인네임 보여주기. 나머지는 BTC출금 등등드으등;''
	if ( COIN_KIND == "00" ) {
		COIN_KIND_VALUE = "전부 입·출금 제한";
	} else if ( COIN_KIND == "01") {
		COIN_KIND_VALUE = "KRW 입·출금";
	} else if ( COIN_KIND == "02") {
		COIN_KIND_VALUE = "BTC 계열 입·출금";
	} else if ( COIN_KIND == "03") {
		COIN_KIND_VALUE = "ETH 계열 입·출금";
	} else if ( COIN_KIND == "04") {
		COIN_KIND_VALUE = "기타 계열 입·출금";
	} else if ( COIN_KIND == "05") {
		COIN_KIND_VALUE = "KRW 입금";
	} else if ( COIN_KIND == "06") {
		COIN_KIND_VALUE = "KRW 출금";
	} else if ( COIN_KIND == "07") {
		COIN_KIND_VALUE = "BTC 계열 입금";
	} else if ( COIN_KIND == "08") {
		COIN_KIND_VALUE = "BTC 계열 출금";
	} else if ( COIN_KIND == "09") {
		COIN_KIND_VALUE = "ETH 계열 입금";
	} else if ( COIN_KIND == "10") {
		COIN_KIND_VALUE = "ETH 계열 출금";
	} 
	
	$("#coin_kind").text(COIN_KIND_VALUE);
	
	$("#coindetail_close").on('click', function() {
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#coindetail_wrap").empty();
	});
});
</script>
</head>
<body>
<div class="coindetail_wrap" id="coindetail_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div style="padding-top:35px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="coindetail_subject">코인명</td>
					<td class="coindetail_content">${COIN_UNIT}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">DESC</td>
					<td class="coindetail_content">${COIN_DESC}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">KIND</td>
					<td class="coindetail_content" id="coin_kind">${COIN_KIND}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">LASTBLOCK</td>
					<td class="coindetail_content">${COIN_LASTBLOCK}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">최소출금액</td>
					<td class="coindetail_content">${COIN_MINTRANS}&nbsp;&nbsp;${COIN_UNIT}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">최대출금액</td>
					<td class="coindetail_content">${COIN_MAXTRANS}&nbsp;&nbsp;${COIN_UNIT}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">출금일일한도</td>
					<td class="coindetail_content">${COIN_DAILYTRANS}&nbsp;&nbsp;${COIN_UNIT}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">출금한달한도</td>
					<td class="coindetail_content">${COIN_MONTHTRANS}&nbsp;&nbsp;${COIN_UNIT}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">최소입금액</td>
					<td class="coindetail_content" id="coin_mindeposit">${COIN_MINDEPOSIT}&nbsp;&nbsp;${COIN_UNIT}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">최소컨펌</td>
					<td class="coindetail_content">${COIN_MINCONFIRM}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">COIN_ADDR</td>
					<td class="coindetail_content">${COIN_ADDR}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">COIN_RPCUSE</td>
					<td class="coindetail_content">${COIN_RPCUSE}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">Gas_Price</td>
					<td class="coindetail_content">${COIN_ETC}</td>
				</tr>
				<tr>
					<td class="coindetail_subject">우선순위</td>
					<td class="coindetail_content">${COIN_PRIORITY}</td>
				</tr>
				<tr>
					<td class="coindetail_subject" style="border-bottom:1px solid #bbb;">내부 전송</td>
					<td class="coindetail_content" style="border-bottom:1px solid #bbb;">${COIN_INTERNALTRANS}</td>
				</tr>
			</table>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="coindetail_close" id="coindetail_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>