<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.rewrite_wrap {
	background-color:#ffffff;
	width:600px;
	height:600px;
}

.rewrite_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:50px;
	background-color:#ffffff;
	text-align:center;
}
.rewrite_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:40px;
	background-color:#fffffff;
}
.rewrite_close {
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
.rewrite_update {
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
</script>
</head>
<body>
<div class="rewrite_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div style="margin-top:30px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="rewrite_subject">ID</td>
					<td class="rewrite_content">${MEMBER_ID}</td>
				</tr>
				<tr>
					<td class="rewrite_subject">이름</td>
					<td class="rewrite_content">${MEMBER_NAME}</td>
				</tr>
				<tr>
					<td class="rewrite_subject">휴대폰 번호</td>
					<td class="rewrite_content">${MEMBER_PHONE}</td>
				</tr>
				<tr>
					<td class="rewrite_subject">잔액</td>
					<td class="rewrite_content">${WALLET_BALANCE} <span style="margin-left:5px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="rewrite_subject">입금 금액</td>
					<td class="rewrite_content"><input type="text" size=21; id="deposit_amount">  <span>${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="rewrite_subject" style="height:60px;">사유</td>
					<td class="rewrite_content" style="height:60px;"><input type=text size=21; id="deposit_reason"><br>
						<span style="font-size:11px; color:red; position:relative; top:3px; font-weight:500;">※ ex) 2017/06/07 사용자 요청에 의해 1000KRW 입금</span>
					</td>
				</tr>
				<tr>
					<td class="rewrite_subject" style="border-bottom:1px solid #bbb;" >비밀번호</td>
					<td class="rewrite_content" style="border-bottom:1px solid #bbb; "><input type="password" size=21; id="admin_password"></td>
			</table>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="rewrite_update" id="deposit_btn">변경</div>
			<div class="rewrite_close" id="deposit_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>