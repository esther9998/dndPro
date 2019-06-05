<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.delete_admin_wrap {
	background-color:#ffffff;
	width:600px;
	height:220px;
	font-size:13px;
}
.delete_admin_close {
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
.delete_admin_btn {
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
.memo_1 {
	font-size:12px;
	color:red;
}
</style>
</head>
<body>
<div class="delete_admin_wrap" id="delete_admin_wrap">
	<div style="top:30px; position:relative; margin-left:100px; margin-right:100px; text-align:center;">
		<div>
			<div>
				<div style="display:inline-block;">
					<span>탈퇴사유 : </span>
				</div>
				<div style="display:inline-block; margin-left:30px;">
					<input type="text" id="delete_desc" size=20;>
				</div>
			</div>
			<div>
				<div style="display:inline-block; margin-top:25px;">
					<span>비밀번호 : </span>
				</div>
				<div style="display:inline-block; margin-left:30px;">
					<input type="password" id="password" size=20;>
				</div>
			</div>
			<div style="margin-top:10px;">
				<span class="memo_1">※ 접속하신 관리자 비밀번호를 입력해주세요.</span>
			</div>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="delete_admin_btn" id="delete_admin_btn">회원 탈퇴</div>
			<div class="delete_admin_close" id="delete_admin_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>