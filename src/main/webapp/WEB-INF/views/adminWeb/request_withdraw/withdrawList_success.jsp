<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.req_withdrawList_wrap table th {
	font-size:13px;
}
.req_withdrawList_wrap table td {
	font-size:12px;
}
.req_withdrawList_wrap {
	font-size:13px;
	letter-spacing:1px;
	font-weight:500;
}
.dataTables_paginate  {
	margin-top:15px;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
	width:30px !important;
	height:30px !important;
	font-size:12px;
}
.auth_wait {
	color:#de8187;
}
.auth_suc {
	color:#3377bb;
}
.withdraw_btn {
	color:#ED6E02;
	font-size:11px;
	font-weight:600;
	cursor:pointer;
}
.withdraw_data {
	color:#272fa6;
}
.with_suc {
	color:red;
	font-weight:600;
}
.find_id_form {
	display:inline-block;
}
.member_num{
	text-align:center;
}
.find_coin_form {
	display:inline-block;
}
.CoinSelect_form {
	width:250px;
	height:22px;
	position:relative;
	display:inline-block;
	line-height:22px;
	font-size:12px;
	text-align:left;
	margin-left:10px;
}
.CoinSelectBox{
	width:150px;
	height:100%;
	line-height:20px;
}
.TypeSelectBox{
	width:150px;
	height:100%;
	line-height:20px;
}
.withdraw_cancel_btn {
	color:#647fe3;
	cursor:pointer;
}
.wallet_address_btn {
	cursor:pointer;
}

.withdraw_type_form {
	width:100px;
	height:40px;
	broder:1px solid #aacef4;
}

.address_btn_show{
	display:none;	
	height:25px; 
	line-height:25px;
	text-align:center;
/* 	padding-left:10px; */
/* 	padding-right:10px; */
	z-index:10;
	background-color:#dddddd; 
}
.address_btn {
	position:relative;
}
.address_btn:hover .address_btn_show {
	display:block;
	position:absolute;
	left:0px;
	top:-5px;
	font-weight:600;
}
.banking_kind_show {
	text-align:center;
}
</style>
<script>
var RequestWithdrawTable = "";
$(document).ready(function() { 
	
	$(document).off('click','#req_withdrawList td #wallet_address_btn');
	$(document).off('click','#Pop_close');
	
	$('#req_withdrawList tbody').off( 'click', 'tr');
	
	RequestWithdrawTable = $("#req_withdrawList").DataTable({

    "language": {
  		    "emptyTable": "입·출금 내역이 없습니다.",
  		 	"zeroRecords": "검색된 내역이 없습니다.",
        paginate:
        {
            previous: "<",
            next: ">",
        }
    },
    "serverSide": false,
    "info": false,
    "searching": true,
    "paging" : true,
    "lengthChange": false,
    "pageLength": 20,
    "Filter": true,
    "dom": 'rtipS',
    "retrieve" : true,
    "ordering": false,
	"autoFill": {
        update: true
    },
	"ajax": {
	    "url": "/ADM/req_withdrawList/3",
	    "type": "POST",  	
	    "dataType": 'json',
        error: function (xhr, error, thrown) {
			console.log(xhr);
			console.log(error);
			console.log(thrown);
			if (xhr.readyState == 0) {
				return true;
			}
        },
        "dataSrc":function (json ) {
		    
        	for (var i = 0; i < json.data.length; i++) {
        		
 				json.data[i].BANKING_KIND_SHOW = "";
	        	json.data[i].WITHDRAW_PROGRESS = "";
				json.data[i].WITHDRAW__BUTTON = "";
				json.data[i].WITHDRAW_CANCEL = "";
				
        		if ( json.data[i].BANKING_KIND == "22" || json.data[i].BANKING_KIND == "24" || json.data[i].BANKING_KIND == "25") {
        			json.data[i].BANKING_KIND_SHOW = "<label class='withdraw_data' style='font-size:11px;'>출금</label>";
    				json.data[i].BANKING_KIND = "출금";
        		}  else if ( json.data[i].BANKING_KIND == "26") {
        			json.data[i].BANKING_KIND_SHOW = "<label class='withdraw_data' style='font-size:11px;'>강제출금</label>";
    				json.data[i].BANKING_KIND = "강제출금";
        		}
        		
        		//취소버튼
        		if (json.data[i].COIN_UNIT == "KRW") {
        			if ( json.data[i].WITHDRAW_STATE == "71" || json.data[i].WITHDRAW_STATE == "73" ) {
        				json.data[i].WITHDRAW_CANCEL = "<span class='withdraw_cancel_btn' id='withdraw_cancel_btn'> [ 취소 ] </span>";
        			}
        		} 
        		
        		 if ( json.data[i].WITHDRAW_STATE == "74" ) {
        			json.data[i].WITHDRAW_PROGRESS = "<label class='with_suc'>출금완료</label>";
       				json.data[i].WITHDRAW_STATE = "출금완료"
        		}
        		
        		if (json.data[i].COIN_UNIT != "KRW") {
        			json.data[i].WITHDRAW_TADDR = "<div id='wallet_address_btn' class='address_btn' title="+ json.data[i].WITHDRAW_TADDR + ">"+number_chk(json.data[i].WITHDRAW_TADDR) + "<div class='address_btn_show'>" + json.data[i].WITHDRAW_TADDR + "</div>" + "</div> ";
        		}
        		
        		if (json.data[i].COIN_UNIT == "KRW") {
        			json.data[i].BANKING_AMOUNT = numberWithCommas(json.data[i].BANKING_AMOUNT);
        		}
        		
        		json.data[i].BANKING_DATE_SHOW = json.data[i].BANKING_DATE + "<br>" + json.data[i].WITHDRAW_MDATE;
        	}
        	
        	return json.data;
	        
        }
    },
    "columns": [
        { "width": "5%", className:"member_num", "data": "MEMBER_NUM"},
        { "width": "0%", className:"banking_num", "data": "BANKING_NUM",  "visible": false },
        { "width": "0%", className:"banking_kind", "data": "BANKING_KIND", "visible":false},
        { "width": "7%", className:"banking_kind_show", "data": "BANKING_KIND_SHOW" },
        { "width": "8%", className:"type", "data": "MEMBER_ID"},
        { "width": "7%", className:"type", "data": "MEMBER_NAME"},
        { "width": "8%", className:"type", "data": "MEMBER_PHONE"},
        { "width": "5%", className:"kind", "data": "COIN_UNIT"},
//         { "width": "5%", className:"kind", "data": "BANKING_TYPE"},
        { "width": "7%", className:"kind", "data": "WITHDRAW_ADDR"},
        { "width": "11%", className:"kind", "data": "WITHDRAW_TADDR"},
        { "width": "10%", className:"amount", "data": "BANKING_AMOUNT" },
        { "width": "12%", className:"balance", "data": "BANKING_BALANCE" },
        { "width": "0%", className:"balance", "data": "WITHDRAW_STATE", "visible": false },
        { "width": "0%", className:"fee", "data": "WITHDRAW_PROGRESS",  "visible": false },
        { "width": "13%", className:"date", "data": "BANKING_DATE_SHOW" },
	],
	  initComplete: function () {
          var column_type="10";
//           var coin_type="";
//           var coin_val = "";
		  var coin = this.api().column(7);
		  var type = this.api().column(2);
			
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				RequestWithdrawTable.column($('#find_type').val()).search( this.value ).draw();
			});
			
			$('#find_type').bind('change', function(e) {
				RequestWithdrawTable.column(4).search("").draw();
				RequestWithdrawTable.column(5).search("").draw();
				RequestWithdrawTable.column(6).search("").draw();
			}); 
			
            //코인 필터링
            var coin_select = $('<select class="CoinSelectBox"><option value="">전체</option>')
            .appendTo('#selectStateFilter')
            .on('change', function () {
               var val = $(this).val();
               coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            coin.data().unique().sort().each(function (d, j) {
            	coin_select.append('<option value="' + d + '">' + d + '</option>');
            });
            
            //BANIING 타입 필터링
            var banking_type = $('<select class="TypeSelectBox"><option value="">전체</option>')
            .appendTo('#selectTypeFilter')
            .on('change', function () {
               var val = $(this).val();
               type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            type.data().unique().sort().each(function (d, j) {
            	banking_type.append('<option value="' + d + '">' + d + '</option>');
            });
   		}
    
	});
	
	//지갑주소
	$(document).on('click','#req_withdrawList td #wallet_address_btn',function(){
    	var row_data = $(this).closest('tr');
	    MEMBER_NUM = RequestWithdrawTable.row(row_data).data()['MEMBER_NUM'];
	    BANKING_NUM = RequestWithdrawTable.row(row_data).data()['BANKING_NUM'];
	    
	    $('#popup_mask').show();
	    
	    $('#balance_form').show();
	    
	    $("#balance_content").load( "/ADM/req_withdraw_addr/"+MEMBER_NUM+"/"+BANKING_NUM , function() {
	    	
	    });
	});
	
 	$("#Pop_close").on("click", function() {
 		$("#withdraw_wrap").empty();	
 		$("#withdraw_address").empty();	
 		$("#balance_wrap").empty();	
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
    });
});

function number_chk(param) {
	var param_rst = "";
	if ( param != undefined) {
		param_rst = param.substr(0,15) + "...";
	} else {
		param_rst = "";		
	}
	return param_rst;
}
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
</script>
</head>
<body>
<div class="req_withdrawList_wrap" id="req_withdrawList_wrap">
	<div style="display:inline-block; width:100%;" id="withdraw_auth_type">
<!-- 		<input type="radio" id="withdraw_auth_success" name="auth_success" checked="checked"><label for="withdraw_auth_success" style="margin-right:-5px;">출금요청 내역</label> -->
<!-- 		<input type="radio" id="withdraw_auth_wait" name="auth_success"><label for="withdraw_auth_wait">인증대기중인 목록</label> -->
<!-- 		<input type="radio" id="withdraw_success" name="auth_success" ><label for="withdraw_success" style="margin-left:-6px;" >출금완료 목록</label> -->
		
		<div style="display:inline-block; text-align:right; position:relative; right:0px; width:100%;">
			<div class="CoinSelect_form" id="selectStateFilter"><label><b>코인 : </b></label></div>
			<div class="CoinSelect_form" id="selectTypeFilter"><label><b>분류 : </b></label></div>
			<div id="find_type_form" class="find_id_form">
				<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
					<option value="5">이름</option>
					<option value="4">ID</option>
					<option value="6">핸드폰 번호</option>
				</select>
			</div>
			<div id="find_text" class="find_id_form">
				<input id="find_input" type="text" size=20px; style="margin-left:10px;">
			</div>
		</div>
	</div>
	<table id="req_withdrawList" class="display" cellspacing="0" height="100%" style="width:100%; margin-top:20px;">
		<thead>
			<tr style="text-align:left">
                <th>번호</th> 
                <th>&nbsp;</th> 
                <th>&nbsp;</th> 
                <th>분류</th>
                <th>아이디</th> 
                <th>이름</th> 
                <th>핸드폰 번호</th> 
                <th>코인</th> 
                <th>은헁</th> 
                <th>계좌</th> 
<!--                 <th>분류</th> -->
                <th>금액</th>
                <th>잔액</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>시각</th>
			</tr>
		</thead>
	</table>
</div>
</body>
</html>