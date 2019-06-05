<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.pwd_chk_wrap {
	width:550px;
	height:150px;
	text-align:center;
	background-color:#fff;
}
.pwd_chk_subject {
	width:100px;
	font-size:13px;
	display:inline-block;
}
.pwd_chk_content {
	width:200px;
	font-size:13px;
	display:inline-block;
}
.pwd_chk_btn {
	display:inline-block;
	font-size:13px;
	background-color:#bbbbbb;
	width:80px;
	height:30px;
	color:#ffffff;
	line-height:30px;
	letter-spacing:1px;
	text-align:center;
	border:1px solid #d7d7d7;
	border-radius:3px;
	cursor:pointer;
}
.pwd_chk_cancel {
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
	margin-left:20px;
}
.pwd_chk_btn_form {
	margin-top:20px;
}
</style>
</head>
<body>
<div class="pwd_chk_wrap">
	<div style="position:relative; top:30px;">
		<div class="pwd_chk_subject">
			<span>비밀번호</span>
		</div>
		<div class="pwd_chk_content">
			<input type="password" size="20" id="password">
		</div>
		<div class="pwd_chk_btn_form">
			<div class="pwd_chk_btn" id="pwd_chk_btn">확인</div>
			<div class="pwd_chk_cancel" id="pwd_chk_cancel">닫기</div>
		</div>
	</div>
</div>
</body>
</html>