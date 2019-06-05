<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.coinrevise_wrap {
	background-color:#ffffff;
	width:600px;
	height:600px;
	padding-bottom:40px;
	overflow-y:auto;
}
.coinrevise_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:40px;
}
.coinrevise_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.coinrevise_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:37px;
	background-color:#ffffff;
	text-align:center;
}
.coinrevise_content {
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
.coinrevise_close {
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
.coinrevise_btn {
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
	
	console.log("${TEST}");

	$("#revise_coin_kind").val("${COIN_KIND}");
	$("#revise_coin_rpcuse").val("${COIN_RPCUSE}");
	$("#revise_internaltrans").val("${COIN_INTERNALTRANS}");
	
	$("#coinrevise_btn").on('click', function() {
		
		if ( $("#revise_minconfirm").val() == "") {
			alert("최소 컨펌을 입력해주세요");
			return;
		}
		
		if ( $("#revise_priority").val() == "") {
			alert("우선 순위를 입력해주세요.");
			return;
		}
		
		if ( $("#admin_pass").val() == "" ) {
			alert("관리자 비밀번호를 입력해주세요.");
			return;
		}
		var confirm_rst = confirm("코인명 : " + $("#revise_coin_name").val() + "\nCOIN_UNIT : " + $("#revise_coin_unit").val() + "\n코인을 수정하시겠습니까?");
				
			if ( confirm_rst == false) {
	 			return;
	 		} else { 
				var url="/ADM/coin_revise_process";
			   	$.ajax({
			   		type:"POST",
			   		url:url,
			   		async:false,
			   		dataType : 'json',
			   		data: {
			   			"COIN_NUM":$("#revise_coin_num").val(),
			   			"COIN_NAME":$("#revise_coin_name").val(),
			   			"COIN_UNIT":$("#revise_coin_unit").val(),
			   			"COIN_DESC":$("#revise_coin_desc").val(),
			   			"COIN_KIND":$("#revise_coin_kind").val(),
			   			"COIN_LASTBLOCK":$("#revise_coin_lastblock").val(),
			   			"COIN_MINTRANS":$("#revise_mintrans").val(),
			   			"COIN_MAXTRANS":$("#revise_maxtrans").val(),
			   			"COIN_DAILYTRANS":$("#revise_dailytrans").val(),
			   			"COIN_MONTHTRANS":$("#revise_monthtrans").val(),
			   			"COIN_MINDEPOSIT":$("#revise_mindeposit").val(),
			   			"COIN_MINCONFIRM":$("#revise_minconfirm").val(),
			   			"COIN_ADDR":$("#revise_coinaddr").val(),
			   			"COIN_FEE":$("#revise_coinfee").val(),
			   			"COIN_RPCUSE":$("#revise_coin_rpcuse").val(),
			   			"COIN_PRIORITY":$("#revise_priority").val(),
			   			"COIN_ETC":$("#revise_gasprice").val(),
			   			"COIN_INTERNALTRANS":$("#revise_internaltrans").val(),
			   			"ADMIN_PASS":$("#admin_pass").val()
			   		},
			   		success:function(obj) { //가져오는 값(변수)
		    			if (obj.ResultCode == "0") {
		    				alert(obj.Data);
		    				$("#popup_mask").hide();
		    				$("#balance_form").hide();
		    				$("#insert_notice_wrap").empty();
		    				CoinAdminTable.ajax.reload();
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

	$("#coininsert_close").on('click', function() {
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    	$("#coininsert_wrap").empty();
	});
});
</script>
</head>
<body>
<div class="coinrevise_wrap" id="coinrevise_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div style="padding-top:35px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="coinrevise_subject">COIN_NUM</td>
					<td class="coinrevise_content"><input disabled type="text" style="width:200px;" id="revise_coin_num" value='${COIN_NUM}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">코인명</td>
					<td class="coinrevise_content"><input disabled type="text" style="width:200px;" id="revise_coin_name" value='${COIN_NAME}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">단위</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_coin_unit" value='${COIN_UNIT}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">DESC</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_coin_desc" value='${COIN_DESC}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">KIND</td>
					<td class="coinrevise_content">
						<select id="revise_coin_kind" style="width:200px; font-size:12px; height:20px;">
							<option value="00">전부 입·출금 제한</option>
							<option value="01">KRW 입·출금</option>
							<option value="02">BTC 계열 입·출금</option>
							<option value="03">ETH 계열 입·출금</option>
							<option value="04">기타 계열 입·출금</option>
							<option value="05">KRW 입금</option>
							<option value="06">KRW 출금</option>
							<option value="07">BTC 계열 입금</option>
							<option value="08">BTC 계열 출금</option>
							<option value="09">ETH 계열 입금</option>
							<option value="10">ETH 계열 출금</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="coinrevise_subject">LASTBLOCK</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_coin_lastblock" value='${COIN_LASTBLOCK}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">최소출금액</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_mintrans" value='${COIN_MINTRANS}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">최대출금액</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_maxtrans" value='${COIN_MAXTRANS}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">출금일일한도</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_dailytrans" value='${COIN_DAILYTRANS}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">출금한달한도</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_monthtrans" value='${COIN_MONTHTRANS}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">최소입금액</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_mindeposit" value='${COIN_MINDEPOSIT}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">최소컨펌</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_minconfirm" value='${COIN_MINCONFIRM}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">COIN_ADDR</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_coinaddr" value='${COIN_ADDR}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">수수료</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_coinfee" value='${COIN_FEE}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">COIN_RPCUSE</td>
					<td class="coinrevise_content">
						<select id="revise_coin_rpcuse" style="width:200px;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="coinrevise_subject">우선순위</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_priority" value='${COIN_PRIORITY}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">GasPrice</td>
					<td class="coinrevise_content"><input type="text" style="width:200px;" id="revise_gasprice" value='${COIN_ETC}'></td>
				</tr>
				<tr>
					<td class="coinrevise_subject">내부 전송</td>
					<td class="coinrevise_content">
						<select id="revise_internaltrans" style="width:200px;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="coinrevise_subject" style="border-bottom:1px solid #bbb;">비밀번호</td>
					<td class="coinrevise_content" style="border-bottom:1px solid #bbb;"><input type="password" id="admin_pass" style="width:200px;"></td>
				</tr>
			</table>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="coinrevise_btn" id="coinrevise_btn">수정</div>
			<div class="coinrevise_close" id="coinrevise_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>