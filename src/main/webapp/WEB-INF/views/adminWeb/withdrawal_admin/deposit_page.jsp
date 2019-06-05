<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.deposit_wrap {
	background-color:#ffffff;
	width:600px;
	height:650px;
}
.deposit_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:50px;
}
.deposit_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.deposit_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:50px;
	background-color:#ffffff;
	text-align:center;
}
.deposit_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:40px;
	background-color:#fffffff;
}
.deposit_close {
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
.deposit_btn {
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
$(document).ready(function() {
		
	$("#deposit_amount").blur( function () {
		if ( "${COIN_UNIT}" != "KRW") {
			var amount = new Big($("#deposit_amount").val()).toFixed(8);
			$("#deposit_amount").val(amount);
			
		} else {
			var amount = $("#deposit_amount").val().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			$("#deposit_amount").val(amount);
		}
	});
	
	$("#deposit_amount").keydown(function ( key ) {
		if (key.keyCode == 13) {
			if ( "${COIN_UNIT}" != "KRW") {
				var amount = new Big($("#deposit_amount").val()).toFixed(8);
				$("#deposit_amount").val(amount);
			} else {
				var amount = $("#deposit_amount").val().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
				$("#deposit_amount").val(amount);
			}
		}
	});

	$("#deposit_fee").blur( function () {
		if ( "${COIN_UNIT}" != "KRW") {
			var deposit_fee = new Big($("#deposit_fee").val()).toFixed(8);
			$("#deposit_fee").val(deposit_fee);
			
		} else {
			var deposit_fee = $("#deposit_fee").val().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			$("#deposit_fee").val(deposit_fee);
		}
	});
	
	$("#deposit_fee").keydown(function ( key ) {
		if (key.keyCode == 13) {
			if ( "${COIN_UNIT}" != "KRW") {
				var deposit_fee = new Big($("#deposit_fee").val()).toFixed(8);
				$("#deposit_fee").val(deposit_fee);
			} else {
				var amount = $("#deposit_fee").val().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
				$("#deposit_fee").val(deposit_fee);
			}
		}
	});

	$("#deposit_type").on('change', function() {
		if ( $("#deposit_type").val() == "miner" && "${COIN_UNIT}" != "KRW") {
			$(".deposit_wrap").css('height', '830px');
			$("#miner_deposit_form").show();
			
			var dd = new Date();
			var dstr = dd.getFullYear()+"/"+((dd.getMonth()+1)>9?(dd.getMonth()+1):"0"+(dd.getMonth()+1))+"/"+((dd.getDate())>9?(dd.getDate()):"0"+(dd.getDate()))+" "+"마이너 리워드로 인한 입금";
			
			$("#deposit_reason").val(dstr);
		} else {
			$(".deposit_wrap").css('height', '650px');
			$("#miner_deposit_form").hide();
		}
	});
	
	$("#miner_str").on('change', function() {
		var sarray = $("#miner_str").val().replace("	","").replace("	","").replace("	","").split(" ");
		if((sarray[0]>100||sarray[0]<=0)||sarray.length!=5) {
			$("#miner_str").val("");
			return;
		}

		if ( "${COIN_UNIT}" != "KRW") {			
			if(new Big(sarray[1]).cmp(new Big(sarray[3]).add(new Big(sarray[2])))!=0){
				$("#miner_str").val("X");
				return
			}
			var amount = new Big(sarray[3]).toFixed(8);

			var deposit_fee = new Big(sarray[2]).toFixed(8);
			

			$("#deposit_amount").val(amount);
			$("#deposit_fee").val(deposit_fee);
			
		} else {
			var amount =sarray[3].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			$("#deposit_amount").val(amount);
			
			var amount = sarray[2].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			$("#deposit_fee").val(deposit_fee);
		}
		
		$("#miner_count").val(sarray[0]);

	});
});


</script>
</head>
<body>
<div class="deposit_wrap" id="deposit_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div class="deposit_title_form">
			<div class="deposit_title">· ${COIN_UNIT} 입금</div>
		</div>
		<div style="margin-top:30px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="deposit_subject">ID</td>
					<td class="deposit_content">${MEMBER_ID}</td>
				</tr>
				<tr>
					<td class="deposit_subject">이름</td>
					<td class="deposit_content">${MEMBER_NAME}</td>
				</tr>
				<tr>
					<td class="deposit_subject">휴대폰 번호</td>
					<td class="deposit_content">${MEMBER_PHONE}</td>
				</tr>
				<tr>
					<td class="deposit_subject">입금 종류</td>
					<td class="deposit_content">
						<select name="deposit_type" id="deposit_type" style="width:130px; height:25px;">
							<option value="basic">일반입금</option>
							<option value="miner">채굴입금</option>
							<option value="force">강제입금</option>
						</select>
					</td>
				<tr>
					<td class="deposit_subject">잔액</td>
					<td class="deposit_content">${WALLET_BALANCE} <span style="margin-left:5px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="deposit_subject">입금 금액</td>
					<td class="deposit_content"><input type="text" size=21; id="deposit_amount">  <span>${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td colspan="2">
						<table style="width:100%; display:none; border-spacing:0px; font-size:12px;" id="miner_deposit_form">
							<tr>
								<td class="deposit_subject" style="min-width:93px;">수수료</td>
								<td class="deposit_content" style="min-width:93px;"><input type="text" size=21; id="deposit_fee">  <span>${COIN_UNIT}</span></td>
							</tr>
							<tr>
								<td class="deposit_subject">채굴기 대수</td>
								<td class="deposit_content"><input type="text" size=21; id="miner_count"><br><div style="font-size:11px; padding-top:2px;"><input type="checkbox" checked id="miner_email_chk" style="position:relative; top:2px; cursor:pointer;"><label for="miner_email_chk" style="cursor:pointer;">이메일 발송</label></div></td>
							</tr>
							<tr>
								<td class="deposit_subject">문자열 입력<br>(엑셀서식복사)</td>
								<td class="deposit_content"><input type="text" size=21; id="miner_str"></td>
							</tr>
						</table>
					</td>
				</tr>	
				<tr>
					<td class="deposit_subject" style="height:60px;">사유</td>
					<td class="deposit_content" style="height:60px;"><input type=text size=21; id="deposit_reason"><br>
						<span style="font-size:11px; color:red; position:relative; top:3px; font-weight:500;">※ ex) 2017/06/07 사용자 요청에의해 1000KRW 입금</span>
					</td>
				</tr>
				<tr>
					<td class="deposit_subject" style="border-bottom:1px solid #bbb;" >비밀번호</td>
					<td class="deposit_content" style="border-bottom:1px solid #bbb; "><input type="password" size=21; id="admin_password"></td>
				</tr>
			</table>
		</div>
		<div style="margin-top:30px;">
			<div style="font-size:12px; color:red; font-weight:600;">
				<span>※ 입금 명의자의 ID와 이름, 핸드폰번호를 정확히 확인해주시기 바랍니다.</span>
			</div>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="deposit_btn" id="deposit_btn">입금</div>
			<div class="deposit_close" id="deposit_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>