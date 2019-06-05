<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.orderInfo_wrap table th {
	font-size:13px;
}

.orderInfo_wrap {
	font-size:13px;
}		    
.orderInfo_wrap .mem_num, .mem_name, .mem_login, .mem_err, .mem_lock, .mem_use, .mem_avail {
	text-align:center;
}
.order_cancel {
	font-size:11px;
	cursor:pointer;
	color:#3377bb;
	font-weight:600;
}
.dataTables_paginate  {
	margin-top:15px;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
	width:30px !important;
	height:30px !important;
	font-size:12px;
}
.find_id_form {
	display:inline-block;
}
.find_name_form {
	margin-left:30px;
	display:inline-block;
}
.find_all_form {
	display:inline-block;
	margin-left:30px;
	cursor:pointer;
}
.orderInfo_wrap .o_kind, .orderInfo_wrap .o_market, .orderInfo_wrap .mem_phone, .orderInfo_wrap .o_trading{
	text-align:center;
}
.base_coin {
	color:#ED6E02;
	font-weight:600;
}
.target_coin {
	color:#161B61;
	font-weight:600;
}
.cancel_coin {
	color:red;
	font-weight:600;
}
.trading_suc {
	color:#3377bb;
	text-align:center;
	font-weight:600;
}
.trading {
	color:#e95c64;
	font-weight:600;
}
.OrderSelect_form {
	width:250px;
	height:40px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	
}
.OrderSelectBox {
	width:140px;
	height:25px;
	margin-left:20px;
	left:-20px;
}
</style>
<script>
var OrderInfoTable = "";
$(document).ready( function() {
	
	$(document).off('click','#orderInfo td #order_cancel');
	$('#orderInfo tbody').off( 'click', 'tr');
	
	OrderInfoTable = $("#orderInfo").DataTable({
		"language": {
   		    "emptyTable": "등록된 주문이 없습니다.",
   			"zeroRecords": "검색된 주문이 없습니다.",
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
// 	    "dom": 'rtipS',
		"dom": 'BrtipS',
	    "retrieve" : true,
	    "ordering": false,
		"autoFill": {
	        update: true
	    },
	    buttons: [
	    	{
	         	text: 'Excel',
	    		extend: 'excelFlash',
	            filename: 'CONCO_주문내역'
	        }
	    ],
		"ajax": {
		    "url": "/ADM/OrderList_data",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].MARKET_NAME = "";
	        		json.data[i].MARKET_KIND = "";
	        		json.data[i].ORDER_PRICE_SHOW = "";
	        		json.data[i].ORDER_AMOUNT_SHOW = "";
	        		json.data[i].ORDER_REMAIN_SHOW = "";
	        		json.data[i].ORDER_CANCEL = ""; 
	        		json.data[i].ORDER_TYPE = "";
	        		json.data[i].ORDER_STATE = "";
	        		json.data[i].ORDER_TRADING = "";
	        		json.data[i].ORDER_KIND_SHOW = "";
	        			
	        		json.data[i].ORDER_PRICE_SHOW = json.data[i].ORDER_PRICE + " " + json.data[i].BASE_COIN_UNIT;
	        		json.data[i].ORDER_AMOUNT_SHOW = json.data[i].ORDER_AMOUNT + " " + json.data[i].TARGET_COIN_UNIT;
	        		json.data[i].ORDER_REMAIN_SHOW = json.data[i].ORDER_REMAIN + " " + json.data[i].TARGET_COIN_UNIT;
	        		
	        		json.data[i].MARKET_NAME = "<label class='base_coin'>"+json.data[i].BASE_COIN_UNIT+"</label>" + " / " + "<label class='target_coin'>"+json.data[i].TARGET_COIN_UNIT+"</label>";
	        		json.data[i].MARKET_KIND = json.data[i].BASE_COIN_UNIT + " / " + json.data[i].TARGET_COIN_UNIT;
	        		
	        		//상태체크 + 주문취소
	        		if ( json.data[i].ORDER_REMAIN > 0 ) {
	        			json.data[i].ORDER_TRADING = "<lable class='trading'>거래중</lable>"
       					json.data[i].ORDER_STATE = "거래중";
	        			if(json.data[i].ORDER_KIND==31||json.data[i].ORDER_KIND==41){
	        				json.data[i].ORDER_CANCEL = "<div id='order_cancel' class='order_cancel'>[ 주문 취소 ]</div>"
	        			}
	        		}else if ( json.data[i].ORDER_REMAIN <= 0 ) {
	        			json.data[i].ORDER_TRADING = "<label class='trading_suc'>거래완료</label>"
        				json.data[i].ORDER_STATE = "거래완료";
	        		} 
	        		
	        		//분류
	        		if ( json.data[i].ORDER_KIND == 31 ) { 
	        			json.data[i].ORDER_KIND_SHOW = "<label class='base_coin'>매수</label>"
		        		json.data[i].ORDER_TYPE = "매수";
	        		}else if ( json.data[i].ORDER_KIND == 41 ){
	        			json.data[i].ORDER_KIND_SHOW = "<label class='target_coin'>매도</label>"
        				json.data[i].ORDER_TYPE = "매도";
	        		}else if ( json.data[i].ORDER_KIND == 32 ){
	        			json.data[i].ORDER_KIND_SHOW = "<label class='cancel_coin'>매수취소</label>"
	        			json.data[i].ORDER_TYPE = "매수취소";
	        			json.data[i].ORDER_TRADING = "<lable class='cancel_coin'>매수취소</lable>"
       					json.data[i].ORDER_STATE = "매수취소";
	        		}else if ( json.data[i].ORDER_KIND == 42 ){
	        			json.data[i].ORDER_KIND_SHOW = "<label class='cancel_coin'>매도취소</label>"
	        			json.data[i].ORDER_TYPE = "매도취소";
	        			json.data[i].ORDER_TRADING = "<lable class='cancel_coin'>매도취소</lable>"
       					json.data[i].ORDER_STATE = "매도취소";
   	        		}
	        	}
	        	return json.data;
		    },
	        error: function (xhr, error, thrown) {
				console.log(xhr);
				console.log(error);
				console.log(thrown);
				if (xhr.readyState == 0) {
					return true;
				}
	        }
	    },
		"columns": [
		    { "width": "5%", className:"mem_num", "data": "MEMBER_NUM"},
		    { "width": "12%", className:"mem_id", "data": "MEMBER_ID" },
		    { "width": "8%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "0%", className:"", "data": "ORDER_NUM" , "visible":false}, //ORDER_NUM
		    { "width": "0%", className:"", "data": "MARKET_NUM" , "visible":false}, // MARKET_NUM
		    { "width": "0%", className:"o_target", "data": "MARKET_KIND", "visible": false}, //MARKET_분류
		    { "width": "0%", className:"", "data": "BASE_COIN_UNIT" , "visible":false}, //BASE_COIN
		    { "width": "0%", className:"", "data": "TARGET_COIN_UNIT" , "visible":false}, //TARGET_COIN
		    { "width": "9%", className:"o_market", "data": "MARKET_NAME"}, //MARKET SHOW
		    { "width": "0%", className:"o_kind", "data": "ORDER_KIND", "visible":false }, //ORDER_KIND 31,41 분류
		    { "width": "6%", className:"o_kind", "data": "ORDER_KIND_SHOW"}, //ORDER_KIND_SHOW
		    { "width": "0%", className:"o_type", "data": "ORDER_TYPE", "visible":false }, //ORDER_KIND SHOW 매수, 매도 분류 
		    { "width": "11%", className:"o_price", "data": "ORDER_PRICE_SHOW" }, //ORDER_PRICE_SHOW
		    { "width": "11%", className:"o_amount", "data": "ORDER_AMOUNT_SHOW" }, //ORDER_AMOUNT_SHOW
		    { "width": "11%", className:"o_reamin", "data": "ORDER_REMAIN_SHOW" }, //ORDER_REMAIN_SHOW
		    { "width": "0%", className:"", "data": "ORDER_STATE", "visible":false }, //ORDER_STATE 분류
		    { "width": "7%", className:"o_trading", "data": "ORDER_TRADING" }, //ORDER_STATE_SHOW
		    { "width": "7%", className:"o_cancel", "data": "ORDER_CANCEL" }, //ORDER_REMAIN_SHOW
		    { "width": "14%", className:"o_date", "data": "ORDER_DATE" } //ORDER_DATE
		],		
	    "initComplete": function(settings, json) {
		
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				OrderInfoTable.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				OrderInfoTable.column(1).search("").draw();
				OrderInfoTable.column(2).search("").draw();
			}); 
			
		 	var market = this.api().column(5);
            var type = this.api().column(11);
            var state = this.api().column(15);
            
            var select = $('<select class="OrderSelectBox"><option value="">전체</option>')
            //마켓 필터링
            .appendTo('#selectTriggerFilter')
                .on('change', function () {
                   var val = $(this).val();
                   market.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
                });
            market.data().unique().sort().each(function (d, j) {
                select.append('<option value="' + d + '">' + d + '</option>');
            });
            
            //타입 필터링
            var type_select = $('<select class="OrderSelectBox"><option value="">전체</option>')
            .appendTo('#selectTypeFilter')
            .on('change', function () {
               var val = $(this).val();
               type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            type.data().unique().sort().each(function (d, j) {
            	type_select.append('<option value="' + d + '">' + d + '</option>');
            });
			
            //상태 필터링
            var state_select = $('<select class="OrderSelectBox"><option value="">전체</option>')
            .appendTo('#selectStateFilter')
            .on('change', function () {
               var val = $(this).val();
               state.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
            });
            state.data().unique().sort().each(function (d, j) {
            	state_select.append('<option value="' + d + '">' + d + '</option>');
            });
		}
	});
	
	 $(document).on('click','#orderInfo td #order_cancel',function(){
    	var row_data = $(this).closest('tr');
	    MEMBER_NUM = OrderInfoTable.row(row_data).data()['MEMBER_NUM'];
	    MEMBER_ID = OrderInfoTable.row(row_data).data()['MEMBER_ID'];
	    MEMBER_NAME = OrderInfoTable.row(row_data).data()['MEMBER_NAME'];
	    ORDER_NUM = OrderInfoTable.row(row_data).data()['ORDER_NUM'];
	    BASE = OrderInfoTable.row(row_data).data()['BASE_COIN_UNIT'];
	    TARGET = OrderInfoTable.row(row_data).data()['TARGET_COIN_UNIT'];
	    MARKET_KIND = OrderInfoTable.row(row_data).data()['MARKET_KIND'];
	    ORDER_PRICE = OrderInfoTable.row(row_data).data()['ORDER_PRICE_SHOW'];
	    ORDER_AMOUNT = OrderInfoTable.row(row_data).data()['ORDER_AMOUNT_SHOW'];
		
	    $("#balance_form").show();
	    $("#popup_mask").show();
	    $("#balance_content").load( "/ADM/OrderCancel/"+ORDER_NUM+"/"+BASE+"/"+TARGET , function() { 
	    	
	    	$("#ordercancel_close").on('click', function() {
	    		$("#balance_form").hide();
	    		$("#ordercancel_wrap").empty();
	    		$("#popup_mask").hide();
	    	});
	    	
	    	$("#ordercancel_btn").on('click', function() {
	    	
	    		if ($("#ordercancel_reason").val() == "" ) {
	    			alert("사유를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    	
	    		if ($("#admin_password").val() == "") {
	    			alert("비밀번호를 입력해주시기 바랍니다.");
	    			return;
	    		}
	    		
				var confirm_rst = confirm("번호 : " + MEMBER_NUM + "\n이름 : " + MEMBER_NAME + "\nID : " + MEMBER_ID + "\n마켓 : " + MARKET_KIND + "\n금액 : "+ORDER_PRICE + "\n수량 : " + ORDER_AMOUNT + "\n\n회원에 대하여 주문취소를 실행하시겠습니까?");
		    	
		    	if ( confirm_rst == false) {
		    		return;
		    	} else {
					var email_confirm = confirm("해당 회원님께 거래 취소에 대한 이메일 전송을 하시겠습니까?");
					
		    		$("#progresspanel").show();   
				    var url = "/ADM/OrderCancel_Process";
				    setTimeout(function(){
				    	$.ajax({
				    		type:"POST",
				    		url:url,
				    		async:false,
				    		dataType : 'json',
				    		data: {
				    			"ORDER_NUM":ORDER_NUM,
				    			"BASE":BASE,
				    			"TARGET":TARGET,
				    			"MEMBER_NUM":MEMBER_NUM,
				    			"CANCEL_REASON":$("#ordercancel_reason").val(),
				    			"ADMIN_PASSWORD":$("#password").val(),
				    			"EMAIL_SEND":email_confirm
				    		},
				    		success:function(obj) { //가져오는 값(변수)
				     			if (obj.ResultCode == "0") {
				     				alert(obj.Data); 
				      				$("#progresspanel").hide();
				    	    		$("#balance_form").hide();	
				    	    		$("#balance_content").empty();
				    	    		$("#popup_mask").hide();
				    	    		OrderInfoTable.ajax.reload(null, false);
				     			} else if (obj.ResultCode == "6") {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				location.href="/ADM/loginPage";
				     			} else {
				     				alert(obj.Data);
				     				$("#progresspanel").hide();
				     				return;
				     			}
				    		},
				    		error:function(e) { //500 ERR
				    			//서버내부오류
				    			alert("잠시 후 시도해주세요.");
				    			$("#progresspanel").hide();
				    			return;
				    		}
				    	});
				    	
				    },1000);
		    	}
	    	});
	    });
	 });
	 
 	$("#Pop_close").on("click", function() {
 		$("#ordercancel_wrap").empty();	
    	$("#balance_form").hide();
    	$('#popup_mask').hide();
 	});
});
	 
</script>
</head>
<body>

<div class="orderInfo_wrap">
	<div style="width:100%; text-align:right;">
		<div id="find_type_form" class="find_id_form">
			<div class="OrderSelect_form" id="selectTriggerFilter"><label><b>마켓 : </b></label></div>
			<div class="OrderSelect_form" id="selectTypeFilter"><label><b>분류 : </b></label></div>
			<div class="OrderSelect_form" id="selectStateFilter"><label><b>상태 : </b></label></div>
			<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
				<option value="2">이름</option>
				<option value="1">ID</option>
			</select>
		</div>
		<div id="find_text" class="find_id_form">
			<input id="find_input" type="text" size=20px; style="margin-left:10px;">
		</div>
	</div>
	<div style="position:relative; top:20px;">
		<table id="orderInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>ID</th>
		                <th>이름</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>&nbsp;</th>
		                <th>마켓</th>
		                <th>&nbsp;</th>
		                <th style="text-align:center;">분류</th>
		                <th>&nbsp;</th>
		                <th>금액</th>
		                <th>수량</th>
		                <th>잔량</th>
		                <th>&nbsp;</th>
		                <th>상태</th>
		                <th>&nbsp;</th>
		                <th style="text-align:center;">시각</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>

</body>
</html>