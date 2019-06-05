<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.change_level_wrap {
	background-color:#ffffff;
	width:600px;
	height:220px;
	font-size:13px;
}
.change_level_close {
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
.change_level_btn {
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
<div class="change_level_wrap" id="change_level_wrap">
	<div style="top:30px; position:relative; margin-left:100px; margin-right:100px; text-align:center;">
		<div>
			<div>
				<div style="display:inline-block;">
					<span>관리권한 : </span>
				</div>
				<div style="display:inline-block; margin-left:30px;">
					<select id="level_select" style=" width:173px; height:22px; padding-left:8px;">
					<option value="1">1</option>
					<option value="2">2</option>
				</select>
				</div>
			</div>
			<div style="margin-top:30px;">
				<div style="display:inline-block;">
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
			<div class="change_level_btn" id="change_level_btn">변경</div>
			<div class="change_level_close" id="change_level_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>