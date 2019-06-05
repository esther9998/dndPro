<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.add_admin_wrap {
	background-color:#ffffff;
	width:600px;
	height:500px;
	font-size:13px;
}
.add_admin_close {
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
.add_admin_btn {
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
.add_admin_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:50px;
	background-color:#ffffff;
	text-align:center;
}
.add_admin_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:40px;
	background-color:#fffffff;
}
.id_chk{
	color:#161B61;
	font-weight:600;
	font-size:12px;
	cursor:pointer;
}
</style>
</head>
<body>
<div class="add_admin_wrap" id="add_admin_wrap">
	<div style="top:45px; position:relative; margin-left:100px; margin-right:100px;">
		<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="add_admin_subject">ID</td>
					<td class="add_admin_content"><input type="text" size=20; id="admin_id"><span style="margin-left:20px;" id="id_chk" class="id_chk">[ 중복확인 ]</span></td>
				</tr>
				<tr>
					<td class="add_admin_subject">이름</td>
					<td class="add_admin_content"><input type="text" size=20; id="admin_name"></td>
				</tr>
				<tr>
					<td class="add_admin_subject">비밀번호</td>
					<td class="add_admin_content"><input type="password" size=20; id="admin_password"></td>
				</tr>
				<tr>
					<td class="add_admin_subject">비밀번호 확인</td>
					<td class="add_admin_content"><input type="password" size=20; id="admin_password_chk"></td>
				</tr>
				<tr>
					<td class="add_admin_subject">관리권한</td>
					<td class="add_admin_content">	
						<select id="level_select" style=" width:173px; height:22px; padding-left:8px;" id="admin_level">
						<option value="1">1</option>
						<option value="2">2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="add_admin_subject"style="border-bottom:1px solid #bbb; height:60px;">관리자 비밀번호</td>
					<td class="add_admin_content"style="border-bottom:1px solid #bbb; height:60px;"><input type=password size=20; id="password"><br>
						<div style="margin-top:5px;">
							<span class="memo_1">※ 접속하신 관리자 비밀번호를 입력해주세요.</span>
						</div>
					</td>
				</tr>
			</table>
			<div style="margin-top:25px; text-align:center;"> 
				<div class="add_admin_btn" id="add_admin_btn">회원가입</div>
				<div class="add_admin_close" id="add_admin_close">닫기</div>
			</div>
	</div>
</div>
</body>
</html>