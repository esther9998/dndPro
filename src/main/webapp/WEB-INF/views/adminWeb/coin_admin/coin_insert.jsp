<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.coininsert_wrap {
	background-color:#ffffff;
	width:600px;
	height:600px;
	padding-bottom:40px;
	overflow-y:auto;
}
.coininsert_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:40px;
}
.coininsert_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.coininsert_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:37px;
	background-color:#ffffff;
	text-align:center;
}
.coininsert_content {
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
.coininsert_close {
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
.coininsert_btn {
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
	$("#coininsert_btn").on('click', function() {
		
		if ( $("#insert_coin_name").val() == "") {
			alert("코인명을 입력해주세요");
			return;
		}
		
		if ( $("#insert_coin_unit").val() == "") {
			alert("코인 단위를 입력해주세요");
			return;
		}
		
		if ( $("#insert_coin_desc").val() == "") {
			alert("COIN_DESC를 입력해주세요");
			return;
		}
		
		if ( $("#insert_coin_lastblock").val() == "") {
			alert("LastBlock을 입력해주세요");
			return;
		}
		
		if ( $("#insert_mintrans").val() == "") {
			alert("최소 출금액을 입력해주세요");
			return;
		}
		
		if ( $("#insert_maxtrans").val() == "") {
			alert("최대 출금액을 입력해주세요");
			return;
		}
		
		if ( $("#insert_dailytrans").val() == "") {
			alert("출금 일일 한도를 입력해주세요");
			return;
		}
		
		if ( $("#insert_monthtrans").val() == "") {
			alert("출금 한달 한도를 입력해주세요.");
			return;
		}
		
		if ( $("#insert_coinaddr").val() == "") {
			alert("코인 주소를 입력해주세요");
			return;
		}
		
		if ( $("#insert_coinfee").val() == "") {
			alert("수수료를 입력해주세요");
			return;
		}
		
		if ( $("#insert_minconfirm").val() == "") {
			alert("최소 컨펌을 입력해주세요");
			return;
		}
		
		if ( $("#insert_priority").val() == "") {
			alert("우선 순위를 입력해주세요.");
			return;
		}
		
		if ( $("#admin_pass").val() == "" ) {
			alert("관리자 비밀번호를 입력해주세요.");
			return;
		}
		var confirm_rst = confirm("코인명 : " + $("#insert_coin_name").val() + "\nCOIN_UNIT : " + $("#insert_coin_unit").val() + "\n코인을 등록하시겠습니까?");
				
			if ( confirm_rst == false) {
	 			return;
	 		} else { 
				var url="/ADM/coin_insert_process";
			   	$.ajax({
			   		type:"POST",
			   		url:url,
			   		async:false,
			   		dataType : 'json',
			   		data: {
			   			"COIN_NAME":$("#insert_coin_name").val(),
			   			"COIN_UNIT":$("#insert_coin_unit").val(),
			   			"COIN_DESC":$("#insert_coin_desc").val(),
			   			"COIN_KIND":$("#insert_coin_kind").val(),
			   			"COIN_LASTBLOCK":$("#insert_coin_lastblock").val(),
			   			"COIN_MINTRANS":$("#insert_mintrans").val(),
			   			"COIN_MAXTRANS":$("#insert_maxtrans").val(),
			   			"COIN_DAILYTRANS":$("#insert_dailytrans").val(),
			   			"COIN_MONTHTRANS":$("#insert_monthtrans").val(),
			   			"COIN_MINDEPOSIT":$("#insert_mindeposit").val(),
			   			"COIN_MINCONFIRM":$("#insert_minconfirm").val(),
			   			"COIN_ADDR":$("#insert_coinaddr").val(),
			   			"COIN_FEE":$("#insert_coinfee").val(),
			   			"COIN_RPCUSE":$("#insert_coin_rpcuse").val(),
			   			"COIN_PRIORITY":$("#insert_priority").val(),
			   			"COIN_ETC":$("#insert_gasprice").val(),
			   			"COIN_INTERNALTRANS":$("#insert_internaltrans").val(),
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
    	$("#coinrevise_wrap").empty();
	});
});
</script>
</head>
<body>
<div class="coininsert_wrap" id="coininsert_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div style="padding-top:35px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="coininsert_subject">코인명</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_coin_name"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">단위</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_coin_unit"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">DESC</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_coin_desc"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">KIND</td>
					<td class="coininsert_content">
						<select id="insert_coin_kind" style="width:200px; font-size:12px; height:20px;">
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
					<td class="coininsert_subject">LASTBLOCK</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_coin_lastblock"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">최소출금액</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_mintrans"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">최대출금액</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_maxtrans"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">출금일일한도</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_dailytrans"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">출금한달한도</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_monthtrans"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">최소입금액</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_mindeposit"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">최소컨펌</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_minconfirm"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">COIN_ADDR</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_coinaddr"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">수수료</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_coinfee"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">COIN_RPCUSE</td>
					<td class="coininsert_content">
						<select id="insert_coin_rpcuse" style="width:200px;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="coininsert_subject">우선순위</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_priority"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">GasPrice</td>
					<td class="coininsert_content"><input type="text" style="width:200px;" id="insert_gasprice"></td>
				</tr>
				<tr>
					<td class="coininsert_subject">내부 전송</td>
					<td class="coininsert_content">
						<select id="insert_internaltrans" style="width:200px;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="coininsert_subject" style="border-bottom:1px solid #bbb;">비밀번호</td>
					<td class="coininsert_content" style="border-bottom:1px solid #bbb;"><input type="password" id="admin_pass" style="width:200px;"></td>
				</tr>
			</table>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="coininsert_btn" id="coininsert_btn">등록</div>
			<div class="coininsert_close" id="coininsert_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>