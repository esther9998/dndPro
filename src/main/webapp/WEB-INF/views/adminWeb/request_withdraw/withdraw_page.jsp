<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.withdraw_wrap {
	background-color:#ffffff;
	width:600px;
	height:650px;
}
.withdraw_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:50px;
}
.withdraw_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.withdraw_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:40px;
	background-color:#ffffff;
	text-align:center;
}
.withdraw_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:40px;
	background-color:#fffffff;
}
.withdraw_close {
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
.withdraw_btn_confrim {
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
</style>

<script>
	if ( "${WITHDRAW_ADDR}" == "") {
		$("#account_number").text("${WITHDRAW_TADDR}");
	}
</script>
</head>
<body>
<div class="withdraw_wrap" id="withdraw_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px; top:50px;">
		<div style="">
			<table style="font-size:12px; border-spacing:0px;" width=400px; >
				<tr>
					<td class="withdraw_subject">ID</td>
					<td class="withdraw_content">${MEMBER_ID}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">이름</td>
					<td class="withdraw_content">${MEMBER_NAME}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">휴대폰 번호</td>
					<td class="withdraw_content">${MEMBER_PHONE}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">계좌</td>
					<td class="withdraw_content" id="account_number">[ ${WITHDRAW_ADDR} ]   ${WITHDRAW_TADDR}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">금액</td>
					<td class="withdraw_content">${WITHDRAW_AMOUNT}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">잔액</td>
					<td class="withdraw_content">${BANKING_BALANCE}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">시각</td>
					<td class="withdraw_content">${WITHDRAW_DATE}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">현재 잔액</td>
					<td class="withdraw_content">${WALLET_BALANCE}</td>
				</tr>
				<tr>
					<td class="withdraw_subject" style="border-bottom:1px solid #bbb;">비밀번호</td>
					<td class="withdraw_content" style="border-bottom:1px solid #bbb;"><input type="password" size="21" id="password"></td>
				</tr>
			</table>
		</div>
		<div style="font-size:12px; text-align:left; margin-top:20px; text-align:center;">
			<div style="display:inline-block;">사유 : 
				<div style="display:inline-block; margin-left:20px;"><input type="text" size=30; id="withdraw_reason"></div>
				<div style="margin-top:10px; font-size:11px; color:red;"> * 육하원칙으로 작성해주시기 바랍니다.</div>
				<div style="margin-top:3px; font-size:11px;"> ex) 2017년 05월 31일 11시 30분 OOO 전화통화 후, 출금 요청으로 인한 출금</div>
			</div>
		</div>
		<div style="margin-top:20px;">
			<div style="font-size:12px; color:red; font-weight:600;">
				<span>※ 출금 정보들을 정확히 확인해주시기 바랍니다.</span>
			</div>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="withdraw_btn_confrim" id="withdraw_btn_confrim">출금</div>
			<div class="withdraw_close" id="withdraw_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>