<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.read_notice_wrap {
	background-color:#ffffff;
	width:800px;
	height:630px;
	font-size:13px;
}
.read_notice_tab {
	width:60px;
}
.read_notice_wrap tr {
	height:35px;
}
.read_notice_close_btn {
	display:inline-block;
	background-color: #bbbbbb;
    width: 70px;
    height: 30px;
    cursor: pointer;
    line-height: 30px;
    text-align: center;
    color: #ffffff;
    font-size: 13px;
    letter-spacing: 1px;
    border: 1px solid #d7d7d7;
    border-radius: 3px;
    font-weight: 600;
}
</style>
<script>
var notice_content = '${NOTICE_CONTENT}';
var notice_type = "${NOTICE_TYPE}";
var notice_num = "${NOTICE_NUM}";
var notice_use = "${NOTICE_USE}";
$(document).ready(function() {
	//팝업 공지일때,
	if(notice_type == "03") {
		$("#notice_date").show();
	} else {
		$("#notice_date").hide();
	}
	
	$("#read_notice_use").val(notice_use);
	$("#read_notice_type").val(notice_type);
	$("#read_notice_content").html(notice_content);
});
</script>
</head>
<body>
<div class="read_notice_wrap" id="read_notice_wrap">
	<div style="position:relative; padding-top:25px; padding-left:45px;">
		<table style="width:100%;">
			<tr>
				<td>번호</td>
				<td><input type="text" id="read_notice_num" disabled value="${NOTICE_NUM}">
			</tr>
			<tr>
				<td>분류</td>
				<td>
					<select disabled style="width:80px; height:25px;" id="read_notice_type">
					  <option value="01">공지</option>
					  <option value="02">긴급</option>
					  <option value="03">팝업</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>사용여부</td>
				<td>
					<select disabled style="width:80px; height:25px;" id="read_notice_use">
						<option value="N">N</option>
						<option value="Y">Y</option>	
					</select>
				</td>
			</tr>
			<tr id="notice_date" style="display:none;">
				<td>기간</td>
				<td><input type="text" disabled id="start_date" style="width:80px; text-align:center;" value="${START_DATE}"> ~ <input type="text" disabled id="end_date" style="width:80px; text-align:center;" value="${END_DATE}"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" disabled  style="width:350px; height:23px; line-heght:23px;" id="read_notice_title" value="${NOTICE_TITLE}"></td>
			</tr>
			<tr>
				<td>내용</td>
			</tr>
			<tr>
				<td colspan="2"><div id="read_notice_content"style="width:700px; height:320px; border:1px solid #aaaaaa; padding-left:10px; padding-top:10px; overflow:auto;"></div>
			</tr>
		</table>
	</div>
	<div style="width:100%; text-align:center; margin-top:10px;">
		<div class="read_notice_close_btn" id="read_notice_close_btn">닫기</div>
	</div>
</div>
</body>
</html>