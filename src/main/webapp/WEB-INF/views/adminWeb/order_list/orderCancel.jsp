<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.ordercancel_wrap {
	background-color:#ffffff;
	width:600px;
	height:600px;
}
.ordercancel_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:40px;
}
.ordercancel_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.ordercancel_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:37px;
	background-color:#ffffff;
	text-align:center;
}
.ordercancel_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:37px;
	background-color:#fffffff;
}
.ordercancel_close {
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
.ordercancel_btn {
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
var ORDER_KIND = "";
$(document).ready(function() {
	if ( "${ORDER_KIND}" == "31" ) {
		ORDER_KIND = "매수";
		$("#order_kind").text(ORDER_KIND);
	} else {
		ORDER_KIND = "매도";
		$("#order_kind").text(ORDER_KIND);
	}
});
</script>
</head>
<body>
<div class="ordercancel_wrap" id="ordercancel_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div style="padding-top:50px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="ordercancel_subject">ID</td>
					<td class="ordercancel_content">${MEMBER_ID}</td>
				</tr>
				<tr>
					<td class="ordercancel_subject">이름</td>
					<td class="ordercancel_content">${MEMBER_NAME}</td>
				</tr>
				<tr>
					<td class="ordercancel_subject">마켓</td>
					<td class="ordercancel_content">${BASE}&nbsp;&nbsp;/&nbsp;&nbsp;${TARGET}</td>
				</tr>
				<tr>
					<td class="ordercancel_subject">분류</td>
					<td class="ordercancel_content" id="order_kind">${ORDER_KIND}</td>
				</tr>
				<tr>
					<td class="ordercancel_subject">금액</td>
					<td class="ordercancel_content">${ORDER_PRICE}<span style="margin-left:10px;">${BASE}</span></td>
				</tr>
				<tr>
					<td class="ordercancel_subject">수량</td>
					<td class="ordercancel_content">${ORDER_AMOUNT}<span style="margin-left:10px;">${TARGET}</span></td>
				</tr>
				<tr>
					<td class="ordercancel_subject">잔량</td>
					<td class="ordercancel_content">${ORDER_REMAIN}<span style="margin-left:10px;">${TARGET}</span></td>
				</tr>
				<tr>
					<td class="ordercancel_subject">시각</td>
					<td class="ordercancel_content">${ORDER_DATE}</td>
				</tr>
				<tr>
					<td class="ordercancel_subject" style="height:60px;">사유</td>
					<td class="ordercancel_content" style="height:60px;"><input type=text size=21; id="ordercancel_reason"><br>
						<span style="font-size:11px; color:red; position:relative; top:3px; font-weight:500;">※ ex) 2017/06/07 사용자 요청에 의해 주문취소</span>
					</td>
				</tr>
				<tr>
					<td class="ordercancel_subject" style="border-bottom:1px solid #bbb;" >비밀번호</td>
					<td class="ordercancel_content" style="border-bottom:1px solid #bbb; "><input type="password" size=21; id="password"></td>
			</table>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="ordercancel_btn" id="ordercancel_btn">주문취소</div>
			<div class="ordercancel_close" id="ordercancel_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>