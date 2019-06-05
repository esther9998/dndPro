<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.marketinsert_wrap {
	background-color:#ffffff;
	width:600px;
	height:600px;
	padding-bottom:40px;
	overflow-y:auto;
}
.marketinsert_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:40px;
}
.marketinsert_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.marketinsert_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:37px;
	background-color:#ffffff;
	text-align:center;
}
.marketinsert_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:40px;
	background-color:#fffffff;
	padding-left:10px;
    word-break: break-all;
}
.marketinsert_close {
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
.marketinsert_btn {
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
$(document).ready(function() {
	
	$("#insert_market_name").val($.trim($("#insert_target_coin option:selected").text()) + " / " + $.trim($("#insert_base_coin option:selected").text()));
	$("#market_fee_coin").text($.trim($("#insert_base_coin option:selected").text()));
	
	$("#insert_base_coin").on('change', function() {
		$("#insert_market_name").val($.trim($("#insert_target_coin option:selected").text()) + " / " + $.trim($("#insert_base_coin option:selected").text()))
		$("#market_fee_coin").text($.trim($("#insert_base_coin option:selected").text()));
	});
	
	$("#insert_target_coin").on('change', function() {
		$("#insert_market_name").val($.trim($("#insert_target_coin option:selected").text()) + " / " + $.trim($("#insert_base_coin option:selected").text()));
		$("#market_fee_coin").text($.trim($("#insert_base_coin option:selected").text()));
	});
	
	$("#Pop_close").on('click', function() {
		$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#marketinsert_wrap").empty();
	});
	
	$("#marketinsert_close").on('click', function() {
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#marketinsert_wrap").empty();
	});
	
	$("#Pop_close").on('click', function() {
		$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#marketinsert_wrap").empty();
	});
	
	
	//toFixed(8);
	//최소거래금액
	$("#insert_market_minamount").keydown(function (key) {
        if(key.keyCode == 13) {
    	   var amount_res = new Big($("#insert_market_minamount").val());
    	   $("#insert_market_minamount").val(amount_res.toFixed(8));
    	}
	});
	//마우스 다른곳
	$("#insert_market_minamount").blur( function(){
		var amount_res = new Big($("#insert_market_minamount").val());
  	    $("#insert_market_minamount").val(amount_res.toFixed(8));

	});
	//하한가
	$("#insert_market_lowerprice").keydown(function (key) {
        if(key.keyCode == 13) {
    	   var amount_res = new Big($("#insert_market_lowerprice").val());
    	   $("#insert_market_lowerprice").val(amount_res.toFixed(8));
    	}
	});
	//마우스 다른곳
	$("#insert_market_lowerprice").blur( function(){
		var amount_res = new Big($("#insert_market_lowerprice").val());
  	    $("#insert_market_lowerprice").val(amount_res.toFixed(8));
	});
	//상한가
	$("#insert_market_upperprice").keydown(function (key) {
        if(key.keyCode == 13) {
    	   var amount_res = new Big($("#insert_market_upperprice").val());
    	   $("#insert_market_upperprice").val(amount_res.toFixed(8));
    	}
	});
	//마우스 다른곳
	$("#insert_market_upperprice").blur( function(){
		var amount_res = new Big($("#insert_market_upperprice").val());
  	    $("#insert_market_upperprice").val(amount_res.toFixed(8));
	});
	
	
	
	
	
	$("#marketinsert_btn").on('click', function() {
		
		if ( $("#insert_market_minamount").val() == "") {
			alert("최소 거래 금액을 입력해주세요.");
			return;
		}
		
		if ( $("#insert_market_lowerprice").val() == "") {
			alert("하한가를 입력해주세요.");
			return;
		}
		
		if ( $("#insert_market_upperprice").val() == "") {
			alert("상한가를 입력해주세요.");
			return;
		}
		
		if ( $("#insert_market_fee").val() == "") {
			alert("수수료를 입력해주세요.");
			return;
		}
		
		if ( $("#insert_market_priority").val() == "") {
			alert("우선 순위를 입력해주세요.");
			return;
		}
		
		if ( $("#admin_pass").val() == "" ) {
			alert("관리자 비밀번호를 입력해주세요.");
			return;
		}
		
		var confirm_rst = confirm("마켓명 : " + $("#insert_market_name").val() + "\nBASE_COIN_UNIT : " + $.trim($("#insert_base_coin option:selected").text()) + "\nTARGET_COIN_UNIT : " + $.trim($("#insert_target_coin option:selected").text()) + "\nMARKET_FEE : " + $("#insert_market_fee").val() + " " + $("#market_fee_coin").text() + "\n\n마켓을 등록하시겠습니까?");
				
		if ( confirm_rst == false) {
 			return;
 		} else { 
			var url="/ADM/market_insert_process";
		   	$.ajax({
		   		type:"POST",
		   		url:url,
		   		async:false,
		   		dataType : 'json',
		   		data: {
		   			"BASE_COIN_NUM":$("#insert_base_coin").val(),
		   			"TARGET_COIN_NUM":$("#insert_target_coin").val(),
		   			"BASE_COIN_UNIT":$.trim($("#insert_base_coin option:selected").text()),
		   			"TARGET_COIN_UNIT":$.trim($("#insert_target_coin option:selected").text()),
		   			"MARKET_KIND":$("#insert_market_kind").val(),
		   			"MARKET_MINAMOUNT":$("#insert_market_minamount").val(),
		   			"MARKET_LOWERPRICE":$("#insert_market_lowerprice").val(),
		   			"MARKET_UPPERPRICE":$("#insert_market_upperprice").val(),
		   			"MARKET_FEE":$("#insert_market_fee").val(),
		   			"MARKET_USE":$("#insert_market_use").val(),
		   			"MARKET_PRIORITY":$("#insert_market_priority").val(),
		   			"ADMIN_PASS":$("#admin_pass").val()
		   		},
		   		success:function(obj) { //가져오는 값(변수)
	    			if (obj.ResultCode == "0") {
	    				alert(obj.Data);
	    				$("#popup_mask").hide();
	    				$("#balance_form").hide();
	    				$("#insert_market_wrap").empty();
	    				MarketAdminTable.ajax.reload();
	    			} else if (obj.ResultCode == "1") {
	    				alert(obj.Data);
	    				adminPageload('/ADM/loginPage');
	    			} else {
	    				alert(obj.Data);
	    				return;
	    			}
		   		},
		   		error:function(e) { //500 ERR
		   			//서버내부오류
		   			alert("잠시 후 시도해주세요.");
		   		}
		   	});
		}
	});
});
</script>
</head>
<body>
<div class="marketinsert_wrap" id="marketinsert_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div style="padding-top:35px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="marketinsert_subject">COIN</td>
					<td class="marketinsert_content">
						<div style="width:180px; height:25px; padding-top:5px;">
							<div style="width:60px; display:inline-block;">BASE</div>
							<select id="insert_base_coin" style="width:100px; display:inline-block;">
							  <c:forEach items="${COIN_INFO}" var="COIN_INFO">
							    <option value="${COIN_INFO[0]}">
							        ${COIN_INFO[1]}
							    </option>
							  </c:forEach>
							</select>
						</div>
						<div style="width:180px; height:25px;">
							<span style="width:60px; display:inline-block;">TARGET</span>
							<select id="insert_target_coin" style="width:100px; display:inline-block;">
							  <c:forEach items="${COIN_INFO}" var="COIN_INFO">
							    <option value="${COIN_INFO[0]}">
							        ${COIN_INFO[1]}
							    </option>
							  </c:forEach>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td class="marketinsert_subject">마켓</td>
					<td class="marketinsert_content"><input type="text" disabled style="width:200px;" id="insert_market_name"></td>
				</tr>
				<tr>
					<td class="marketinsert_subject">KIND</td>
					<td class="marketinsert_content">
						<select id="insert_market_kind" style="width:200px; font-size:12px; height:20px;">
							<option value="00">가격범위 없음</option>
							<option value="01">일반</option>
							<option value="02">라이즈 (하한=현재가)</option>
							<option value="03">하한</option>
							<option value="04">하한률</option>
							<option value="05">상한</option>
							<option value="06">상한률</option>
							<option value="07">상하한</option>
							<option value="08">상하한률</option>
							<option value="09">매수만가능</option>
							<option value="10">매도만가능</option>
							<option value="11">거래제한</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="marketinsert_subject">최소거래금액</td>
					<td class="marketinsert_content"><input type="text" style="width:200px;" id="insert_market_minamount"></td>
				</tr>
				<tr>
					<td class="marketinsert_subject">하한가</td>
					<td class="marketinsert_content"><input type="text" style="width:200px;" id="insert_market_lowerprice"></td>
				</tr>
				<tr>
					<td class="marketinsert_subject">상한가</td>
					<td class="marketinsert_content"><input type="text" style="width:200px;" id="insert_market_upperprice"></td>
				</tr>
				<tr>
					<td class="marketinsert_subject">수수료</td>
					<td class="marketinsert_content"><input type="text" style="width:200px;" id="insert_market_fee"><span style="padding-left:10px;"id="market_fee_coin"></span></td>
				</tr>
				<tr>
					<td class="marketinsert_subject">사용여부</td>
					<td class="marketinsert_content">
						<select id="insert_market_use" style="width:200px; font-size:12px; height:20px;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="marketinsert_subject">우선순위</td>
					<td class="marketinsert_content"><input type="text" style="width:200px;" id="insert_market_priority"></td>
				</tr>
				<tr>
					<td class="marketinsert_subject" style="border-bottom:1px solid #bbb;">비밀번호</td>
					<td class="marketinsert_content" style="border-bottom:1px solid #bbb;"><input type="password" id="admin_pass" style="width:200px;"></td>
				</tr>
			</table>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="marketinsert_btn" id="marketinsert_btn">등록</div>
			<div class="marketinsert_close" id="marketinsert_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>