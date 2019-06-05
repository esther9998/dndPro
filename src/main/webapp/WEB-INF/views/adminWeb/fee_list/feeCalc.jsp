<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.feeInfo {
	font-size:13px;
	text-align:center;
}
.feeInfo tr {
	height:40px;
}
.feeInfo th, .feeInfo td {
	border:1px solid #ddd;
	border-top:none;
	border-left:none;
	border-right:none;
}
.feeInfo_title th {
	border:1px solid #ddd;
	border-top:none;
	border-left:none;
	border-right:none;
	height:45px;
	border-spacing:0px;
}
.fee_content {
	min-width:130px;
	max-width:130px;
}
.fee_coin {
	width:48px;
}
.fee_right_border {
	border-right:1px solid #dddddd !important;
}
</style>
<script>
var FeeInfoTable = "";
var FeeInfoJSON = "";
$(document).ready( function() {
	
	var now = new Date();
	var year = now.getFullYear();
	var month = now.getMonth()+1;
	
	var date = new Date(year, month-1, 1);

	var set_start_date = new Date(year, now.getMonth()-1, 2).toISOString().slice(0,10);
	var set_end_date = new Date(date -1).toISOString().slice(0,10);
	
	console.log(set_start_date);
	console.log(set_end_date);
	
	//현재시간 한달전/한달끝 셋팅하기
	$("#start_date").val(set_start_date);
	$("#end_date").val(set_end_date);
	
	//수수료 조회
	getFeeList();
	
	//조회 버튼
	$("#SelectFeeList").on('click',function() {
		getFeeList();
	});
});

$(function() {
	//시작 달력
    $( "#start_date" ).datepicker({
   	    dateFormat: 'yy-mm-dd',
   	    prevText: '이전 달',
   	    nextText: '다음 달',
   	    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
   	    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
   	    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
   	    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
   	    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
   	    showMonthAfterYear: true,
   	    yearSuffix: '년',
        showButtonPanel: true, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        changeMonth: true,
        changeYear: true,
        onSelect: function(selected, date) {
        	//현재 선택된 달의 맨마지막날을 end_date에 셋팅
        	
        	//날짜 범위 예외처리
        	$("#end_date").datepicker("option","minDate", selected)
        }
    });
	
	//끝 달력
    $( "#end_date" ).datepicker({
   	    dateFormat: 'yy-mm-dd',
   	    prevText: '이전 달',
   	    nextText: '다음 달',
   	    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
   	    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
   	    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
   	    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
   	    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
   	    showMonthAfterYear: true,
   	    yearSuffix: '년',
        showButtonPanel: true, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        changeMonth: true,
        changeYear: true,
        onSelect: function(selected, date) {
        	//end_date 설정 후 시작날짜가 끝나는날보다 클 경우 예외처리
        }
    });
});

function getFeeList() {
	//현재 존재하는 tr 제거 후 실행
	$("#feeInfo").html("");
	
	var url="/ADM/CalcFeeList_data";
	$.ajax({
		type:"POST",
		url:url,
		dataType:"JSON",
		data: {
			"START_DATE":$("#start_date").val(),
			"END_DATE":$("#end_date").val()
		},
		success:function(data) {
			
			for(var i=0; i<data.data.length; i++) {
				

				
				data.data[i].TRADE_TOTAL_INCOME = ""; //거래 총 수입
				data.data[i].BANKING_TOTAL_INCOME = ""; //뱅킹 총 수입
				data.data[i].TOTAL_INCOME = ""; //총 수입
				data.data[i].TOTAL_EXPENSE = ""; //총 지출
				data.data[i].TOTAL_SUM = ""; //총 합계
				
// 				거래 총 수입 계산 = 거래수입 + 거래지출
        		data.data[i].TRADE_TOTAL_INCOME = new Big(data.data[i].TRADEFEE_INCOME).add(new Big(data.data[i].TRADEFEE_EXPENSE)).round(8,0);
        		
//         		입출금 총 수입계산 = 입출금 수입 + 입출금지출
        		data.data[i].BANKING_TOTAL_INCOME = new Big(data.data[i].BANKINGFEE_INCOME).add(new Big(data.data[i].BANKINGFEE_EXPENSE)).round(8,0);
        		
//         		총 수익 계산 = 거래수입 + 입출금 수입
        		data.data[i].TOTAL_INCOME = new Big(data.data[i].TRADEFEE_INCOME).add(new Big(data.data[i].BANKINGFEE_INCOME)).round(8,0);
        		
//         		총 지출 계산 = 거래 지출 + 입출금 지출
        		data.data[i].TOTAL_EXPENSE = new Big(data.data[i].TRADEFEE_EXPENSE).add(new Big(data.data[i].BANKINGFEE_EXPENSE)).round(8,0);
        		
//         		총 합계 = 총 수익 + 총 지출
				data.data[i].TOTAL_SUM = new Big(data.data[i].TOTAL_INCOME).add(new Big(data.data[i].TOTAL_EXPENSE)).round(8,0);
				
				//나머지 8자리 이후 버림.
				data.data[i].TRADEFEE_INCOME_SHOW = new Big(data.data[i].TRADEFEE_INCOME).round(8,0);
				data.data[i].TRADEFEE_EXPENSE_SHOW = new Big(data.data[i].TRADEFEE_EXPENSE).round(8,0);
				data.data[i].BANKINGFEE_INCOME_SHOW = new Big(data.data[i].BANKINGFEE_INCOME).round(8,0);
				data.data[i].BANKINGFEE_EXPENSE_SHOW = new Big(data.data[i].BANKINGFEE_EXPENSE).round(8,0);
				
		
				$("#feeInfo").append(
					"<tr><td>" + "<span style='display:none;'>"+data.data[i].COIN_NUM + "</span>"+ "</td><td class='fee_coin fee_right_border'>" + data.data[i].COIN_UNIT + "</td>"+
					"<td class='fee_content' style='width:145px; min-width:145px; max-width:145px;'>" + data.data[i].TRADEFEE_INCOME_SHOW + "</td><td class='fee_content' style='width:143px; max-width:143px; min-width:143px;'>" + data.data[i].TRADEFEE_EXPENSE_SHOW + "</td><td class='fee_content fee_right_border' style='width:142px; max-width:142px; min-width:142px;'>" + data.data[i].TRADE_TOTAL_INCOME + "</td>" + 
					"<td class='fee_content'>" + data.data[i].BANKINGFEE_INCOME_SHOW + "</td><td class='fee_content'>" + data.data[i].BANKINGFEE_EXPENSE_SHOW + "</td><td class='fee_content fee_right_border' style='width:140px; max-width:140px; min-width:140px;'>" + data.data[i].BANKING_TOTAL_INCOME + "</td>" +
					"<td class='fee_content'>" + data.data[i].TOTAL_INCOME + "</td><td class='fee_content'>" + data.data[i].TOTAL_EXPENSE + "</td><td class='fee_content'>" + data.data[i].TOTAL_SUM + "</td></tr>"
				);
			}
		},
		error:function() {
			alert("실패");
		}
	});
}

</script>
</head>
<body>

<div class="feeInfo_wrap">
	<div style="position:relative; top:20px;">
	<div>
		<input type="text" id="start_date" style="width:90px; height:20px; text-align:center;"> ~ <input type="text" id="end_date" style="width:90px; height:20px; text-align:center;">
		<div id="SelectFeeList" style="display:inline-block; margin-left:15px; border:1px solid #aaaaaa; width:50px; text-align:center; background-color:#dddddd; height:25px; line-height:25px; cursor:pointer; font-size:12px; letter-spacing:2px;">조회</div>
	</div>
		<table id="feeInfo_title" class="feeInfo_title" cellspacing="0" style="width:100%; font-size:13px; padding-top:15px;">
			<thead>
	            <tr style="text-align:left;">
	                <th style="width:50px; border-top:1px solid #ddd; background-color: #f7f7f7;" class="fee_right_border"></th>
	                <th style="width:145px; border-top:1px solid #ddd; background-color: #f7f7f7;" colspan="3" align="center" class="fee_right_border">거래</th>
	                <th style="width:145px; border-top:1px solid #ddd; background-color: #f7f7f7;" colspan="3" align="center" class="fee_right_border">입·출금</th>
	                <th style="width:145px; border-top:1px solid #ddd; background-color: #f7f7f7;" colspan="3" align="center">총계</th>
	            </tr>
	            <tr style="text-align:center;">
	                <th style="width:52px; background-color: #f7f7f7; height:30px;" class="fee_right_border">코인</th>
	                <th style="width:153px; background-color: #f7f7f7; height:30px;" class="fee_right_border">거래수입</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px;" class="fee_right_border">거래지출</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px;" class="fee_right_border">거래총수입</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px;" class="fee_right_border">입출금수입</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px;" class="fee_right_border">입출금지출</th>
	                <th style="width:144px; background-color: #f7f7f7; height:30px;" class="fee_right_border">입출금총수입</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px;" class="fee_right_border">총수입</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px;" class="fee_right_border">총지출</th>
	                <th style="width:145px; background-color: #f7f7f7; height:30px; border-right:none !important;" class="fee_right_border">합계</th>
	            </tr>
	        </thead>
		</table>
		<table id="feeInfo" class="feeInfo" cellspacing="0" width="100%;" height="80%;">
		</table>
	</div>
</div>

</body>
</html>