<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.withdraw_address {
	width:700px;
	height:200px;
	background-color:#fff;
	position:relative;
	z-index:11;
    font-weight:500;
    font-size:13px;
	letter-spacing:1px;
	overflow-y:auto;
}
</style>
<script>
</script>
</head>
<body>
<div class="withdraw_address" id="withdraw_address">
	<div style="position:relative; top:30px; width:600px; margin-left:50px;">
		<div style="font-size:14px; margin-bottom:25px;"><span style="font-weight:600;">· ${MEMBER_NAME}</span><span>님이 입력하신 이체 지갑 주소 입니다.</span></div>
		<div style="border-top:1px solid #bbb; border-bottom:1px solid #bbb; border-left:none; border-right:none; height:50px; font-size:16px; letter-spacing:1px; text-align:center; line-height:50px;">
			<span id="wallet_address_text">${WITHDRAW_TADDR}</span>
		</div>
	</div>
</div>
</body>
</html>