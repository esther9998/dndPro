<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.withdraw_wrap {
	background-color:#ffffff;
	width:600px;
	height:700px;
}
.withdraw_title_form {
	position:relative;
	top:30px;
	width:100%;
	height:40px;
}
.withdraw_title {
	font-size:18px;
	color:#ED6E02;
	font-weight:600;
}
.withdraw_subject {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:150px;
	height:37px;
	background-color:#ffffff;
	text-align:center;
}
.withdraw_content {
	border:1px solid #bbb;
	border-left:none;
	border-bottom:none;
	border-right:none;
	width:300px;
	height:37px;
	background-color:#fffffff;
}
.withdraw_close {
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
.withdraw_btn {
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
.withdraw_unit {
	text-align:left;
}
.withdraw_context {
	background-color:transparent;
	border:0px solid #eee;
	text-align:right;
}
</style>

<script>
var Balance = new Big(${WALLET_BALANCE});
var coin_fee = new Big(${COIN_FEE}); //수수료
var MaxWithdraw = Balance.minus(coin_fee);

$(document).ready( function () {
		
	$("#wallet_balance").val(Balance.toFixed(8));
	$("#withdraw_fee").val(coin_fee);
	
	if (Balance.cmp(new Big("0")) == 0 ) {
		$("#withdraw_fee").val("0.00000000");
		$("#withdraw_total").val("0.00000000");
		$("#withdraw_cal").val("0.00000000");
	} else {
		$("#withdraw_total").val("0.00000000");
		$("#withdraw_cal").val("0.00000000");
	}
	
	//분류 바뀔때마다 갱신
	$("#withdraw_type").on('change',function() {
		$("#withdraw_amount").focus();
		$("#withdraw_amount").blur();
	});
	
});

$("#withdraw_amount").keydown(function (key) {
	if(key.keyCode == 13) {
		var value = [];
		   
	   value["getBalance"] = new Big($("#withdraw_amount").val());
	   
   		//정규식 체크하기
		var res = point_chk($("#withdraw_amount").val());
		$("#withdraw_amount").val(res);
		
		if ( res == 0.00000000) {
			$("#withdraw_amount").val(res);
			$("#withdraw_fee").val(res);
			$("#withdraw_total").val(res);
			$("#withdraw_cal").val(res);
			return;
		}
		
		//잔액 0원 일 때,
		if ( Balance.cmp(new Big(0.00000000)) == 0 ) {
			$("#withdraw_amount").val("0.00000000");
			$("#withdraw_fee").val("0.00000000");
			$("#withdraw_total").val("0.00000000");
			$("#withdraw_cal").val("0.00000000");
			return;
		}
		
		//입력금액이 잔액을 초과 했을 시, 잔액만큼 출금 할 수 있도록 변경 후 계산
		if ( value["getBalance"].cmp(MaxWithdraw.toFixed(8)) > 0 ) {
			if ( $("#withdraw_type").val() == "force" ) {
				MaxWithdraw = Balance;
				var result = CalFee("force", value);
				$("#withdraw_fee").val(result["Fee"]);
				$("#withdraw_total").val(result["total"].toFixed(8));
				$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
			} else {
				value["getBalance"] = MaxWithdraw.toFixed(8);
	   	   		
	   			var result = CalFee("CalWith", value);
	   			
	   			$("#withdraw_amount").val(value["getBalance"]);
	   			$("#withdraw_fee").val(result["Fee"].toFixed(8));
	   			$("#withdraw_total").val(result["total"].toFixed(8));
				$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
			}
		} else {
			if ( $("#withdraw_type").val() == "force" ) {
				MaxWithdraw = Balance;
				var result = CalFee("force", value);
				$("#withdraw_fee").val(result["Fee"]);
				$("#withdraw_total").val(result["total"].toFixed(8));
				$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
			} else {
				var result = CalFee("CalWith", value);
	
				$("#withdraw_total").val(result["total"].toFixed(8));
	   			$("#withdraw_fee").val(result["Fee"].toFixed(8));
				$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
			}
   		}	
	}
});

$("#withdraw_amount").blur( function() { 
	var value = [];
	
	value["getBalance"] = new Big($("#withdraw_amount").val());
	
	//정규식 체크하기
	var res = point_chk($("#withdraw_amount").val());
	$("#withdraw_amount").val(res);
	
	if ( res == 0.00000000) {
		$("#withdraw_amount").val(res);
		$("#withdraw_fee").val(res);
		$("#withdraw_total").val(res);
		$("#withdraw_cal").val(res);
		return;
	}

	//잔액 0원 일 때,
	if ( Balance.cmp(new Big(0.00000000)) == 0 ) {
		$("#withdraw_amount").val("0.00000000");
		$("#withdraw_fee").val("0.00000000");
		$("#withdraw_total").val("0.00000000");
		$("#withdraw_cal").val("0.00000000");
		return;
	}
	
	//입력 금액이 잔액을 초과 했을 시, 잔액만큼 출금 할 수 있도록 변경 후 계산
	if (value["getBalance"].cmp(MaxWithdraw.toFixed(8)) > 0 ) {
		
		if ( $("#withdraw_type").val() == "force" ) {
			MaxWithdraw = Balance;
			var result = CalFee("force", value);
			$("#withdraw_fee").val(result["Fee"]);
			$("#withdraw_total").val(result["total"].toFixed(8));
			$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
		} else {
			
			value["getBalance"] = MaxWithdraw.toFixed(8);
	   		
			var result = CalFee("CalWith", value);
			
			$("#withdraw_amount").val(value["getBalance"]);
			$("#withdraw_fee").val(result["Fee"].toFixed(8));
			$("#withdraw_total").val(result["total"].toFixed(8));
			$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
		}
	} else {
		if ( $("#withdraw_type").val() == "force" ) {
			MaxWithdraw = Balance;
			var result = CalFee("force", value);
			$("#withdraw_fee").val(result["Fee"]);
			$("#withdraw_total").val(result["total"].toFixed(8));
			$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
		} else {
			var result = CalFee("CalWith", value);
			$("#withdraw_fee").val(result["Fee"].toFixed(8));
			$("#withdraw_total").val(result["total"].toFixed(8));
			$("#withdraw_cal").val(result["CalBalance"].toFixed(8));
		}				
	}
});

//type MaxWith = 최대 이체 가능 계산
//type CalWith = 출금 후 잔액 계산
function CalFee(type, value) {
	var getBalance = 0; 
	var Fee = 0;
	var MaxBalance = 0; 
	var CalBalance = 0; 
	var total = 0;
	
	if( type == "MaxWith" ) { //default
		
		getBalance = new Big(value["getBalance"]);
		Fee = coin_fee;
		MaxBalance = getBalance.minus(Fee);
		
	} else if ( type == "CalWith") { //
		if (value["getBalance"] == 0 ) {
			getBalance = "0";
			Fee = "0";
			CalBalance="0";
			total="0";
		} else {
			getBalance = new Big(value["getBalance"]);
			Fee = coin_fee;
			CalBalance = Balance.minus(getBalance.add(Fee));
			total = getBalance.add(Fee);
		}
	} else if ( type == "force")  {
		if (value["getBalance"] == 0 ) {
			getBalance = "0";
			Fee = "0";
			CalBalance="0";
			total="0";
		} else {
			getBalance = new Big(value["getBalance"]);
			Fee = '0';
			CalBalance = Balance.minus(getBalance.add(Fee));
			total = getBalance.add(Fee);
		}
	}
	
	var result = [];

	result["getBalance"] = getBalance;
	result["Fee"] = Fee;
	result["total"] = total;
	result["MaxBalance"] = MaxBalance;
	result["CalBalance"] = CalBalance;
	
	return result;
}

//정규식 체크 함수
function point_chk(result) {
	var point_chkv = /^[0-9].[0-9]{8}$/.test(result);
	if (point_chkv == false) {
		var chk_num = parseFloat(result).toFixed(8);
		
		if (chk_num == "NaN") {
			chk_num = (0).toFixed(8);
		} 
		return chk_num;
	}   else {
		var chk_num = result;
		
		return chk_num;
	}
}
</script>
</head>
<body>
<div class="withdraw_wrap" id="withdraw_wrap">
	<div style="position:relative; margin-left:100px; margin-right:100px;">
		<div class="withdraw_title_form">
			<div class="withdraw_title">· ${COIN_UNIT} 출금</div>
		</div>
		<div style="margin-top:30px; ">
			<table style="font-size:12px; border-spacing:0px;" width=400px;>
				<tr>
					<td class="withdraw_subject">ID</td>
					<td class="withdraw_content">${MEMBER_ID}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">이름</td>
					<td class="withdraw_content">${MEMBER_NAME}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">휴대폰 번호</td>
					<td class="withdraw_content">${MEMBER_PHONE}</td>
				</tr>
				<tr>
					<td class="withdraw_subject">분류</td>
					<td class="withdraw_content">
						<select name="withdraw_type" id="withdraw_type" style="width:130px; height:25px;">
							<option value="basic">일반출금</option>
							<option value="force">강제출금</option>
						</select>
					</td>
				<tr>
				<tr>
					<td class="withdraw_subject">잔액</td>
					<td class="withdraw_content"><input disabled type="text" value="${WALLET_BALANCE}" id="wallet_balance" style="background-color:transparent; text-align:right; border:0px solid #eee;"><span style="margin-left:15px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="withdraw_subject">출금 금액</td>
					<td class="withdraw_content"><input type="text" size=21; id="withdraw_amount" style="text-align:right;"><span style="margin-left:5px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="withdraw_subject">출금 수수료</td>
					<td class="withdraw_content"><input disabled type="text" value="" class="withdraw_context" id="withdraw_fee"><span style="margin-left:15px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="withdraw_subject">총 금액</td>
					<td class="withdraw_content"><input disabled type="text" value="" class="withdraw_context" id="withdraw_total"><span style="margin-left:15px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="withdraw_subject">출금 후 잔액</td>
					<td class="withdraw_content"><input disabled type="text" value="" class="withdraw_context" id="withdraw_cal"><span style="margin-left:15px;">${COIN_UNIT}</span></td>
				</tr>
				<tr>
					<td class="withdraw_subject">이체 주소</td>
					<td class="withdraw_content"><input type="text" size=21; id="withdraw_addr"></td>
				</tr>
				<tr>
					<td class="withdraw_subject" style="height:60px;">사유</td>
					<td class="withdraw_content" style="height:60px;"><input type=text size=21; id="withdraw_reason"><br>
						<span style="font-size:11px; color:red; position:relative; top:3px; font-weight:500;">※ ex) 2017/06/07 사용자 요청에 의해 1000KRW 출금</span>
					</td>
				</tr>
				<tr>
					<td class="withdraw_subject" style="border-bottom:1px solid #bbb;" >비밀번호</td>
					<td class="withdraw_content" style="border-bottom:1px solid #bbb; "><input type="password" size=21; id="admin_password"></td>
			</table>
		</div>
		<div style="margin-top:30px;">
			<div style="font-size:12px; color:red; font-weight:600;">
				<span>※ 출금요청 정보를 정확히 확인해주시기 바랍니다.</span>
			</div>
		</div>
		<div style="margin-top:25px; text-align:center;">
			<div class="withdraw_btn" id="withdraw_btn">출금</div>
			<div class="withdraw_close" id="withdraw_close">닫기</div>
		</div>
	</div>
</div>
</body>
</html>