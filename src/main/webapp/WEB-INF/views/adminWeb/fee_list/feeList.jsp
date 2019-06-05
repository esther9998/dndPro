<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
.feeInfo_wrap table th {
	font-size:13px;
}
.feeInfo_wrap .fee_num, .feeInfo_wrap .coin_unit, .feeInfo_wrap .mem_num, .feeInfo_wrap .mem_name, .feeInfo_wrap .fee_desc, .feeInfo_wrap .fee_date {
	text-align:center;
}

.feeInfo_wrap {
	font-size:12px;
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
.feeSelect_form {
	width:198px;
	position:relative;
	display:inline-block;
	line-height:40px;
	font-size:14px;
	text-align:left;
	margin-left:10px;
	padding-right:20px;
	
}
.feeSelectBox {
	width:130px;
	height:25px;
	margin-left:5px;
	left:-20px;
}
.find_id_form {
	display:inline-block;
}
</style>
<script>
var TransactionInfo = "";
$(document).ready( function() {
	
	$('#feeInfo tbody').off( 'click', 'tr');
	
	feeInfo = $("#feeInfo").DataTable({
		"language": {
   		    "emptyTable": "등록된 수수료 내역이 없습니다.",
   			"zeroRecords": "검색된 수수료 내역이 없습니다.",
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
		    "url": "/ADM/feeList_data",
		    "type": "POST",		 
		    "dataSrc":function(json) { 
	        	for (var i=0; i<json.data.length; i++) {
	        		
	        		json.data[i].FEE_AMOUNT_SHOW = json.data[i].FEE_AMOUNT + " " + json.data[i].COIN_UNIT;
	        	}
	        	return json.data;
		    },
	        error: function (xhr, error, thrown) {
				if (xhr.readyState == 0) {
					return true;
				}
	        }
	    },
		"columns": [
		    { "width": "5%", className:"fee_num", "data": "FEE_NUM"},
		    { "width": "6%", className:"coin_unit", "data": "COIN_UNIT"},
		    { "width": "8%", className:"mem_num", "data": "MEMBER_NUM"},
		    { "width": "10%", className:"mem_name", "data": "MEMBER_NAME" },
		    { "width": "14%", className:"fee_desc", "data": "FEE_DESC"},
		    { "width": "14%", className:"fee_amount", "data": "FEE_AMOUNT", "visible":false},
		    { "width": "14%", className:"fee_amount", "data": "FEE_AMOUNT_SHOW" },
		    { "width": "17%", className:"fee_date", "data": "FEE_DATE" }
		],
		initComplete: function () {
            var coin = this.api().column(1);
            var type = this.api().column(5);
            
			$('#find_input').unbind();
			$('#find_input').bind('keyup', function(e) {
				feeInfo.column($('#find_type').val()).search( this.value ).draw();
			}); 
			
			$('#find_type').bind('change', function(e) {
				feeInfo.column(2).search("").draw();
				feeInfo.column(3).search("").draw();
			}); 
			
            var select = $('<select class="feeSelectBox "><option value="">전체</option>')
            //코인 필터링
            .appendTo('#selectTriggerFilter')
                .on('change', function () {
                   var val = $(this).val();
                   coin.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
                });
            coin.data().unique().sort().each(function (d, j) {
                select.append('<option value="' + d + '">' + d + '</option>');
            });
            
//             var select_type = $('<select class="feeSelectBox "><option value="">전체</option>')
//             .appendTo('#selecttypeFilter')
//             .on('change', function () {
//                var val = $(this).val();
//                console.log("@@"+val);
//                type.search(val ? '^' + $(this).val() + '$' : val, true, false).draw();
//             });
//             type.data().unique().sort().each(function (d, j) {
//             	select_type.append('<option value="' + d + '">' + d + '</option>');
//             });
		}
	});
});

</script>
</head>
<body>
<div class="feeInfo_wrap">
	<div style="position:relative; top:20px;">
		<div style="width:100%; text-align:right;">
			<div id="find_type_form" class="find_id_form">
				<div class="feeSelect_form" id="selectTriggerFilter"><label><b>코인 : </b></label></div>
				<div style="display:inline-block;">
					<select id="find_type" style="width:120px; height:22px; padding-left:8px;">
						<option value="3">이름</option>
						<option value="2">MEMBER_NUM</option>
					</select>
					<div id="find_text" class="find_id_form">
						<input id="find_input" type="text" size=20px; style="margin-left:10px;">
					</div>
				</div>
			</div>
		</div>
		<table id="feeInfo" class="display" cellspacing="0" width="100%;" height="80%;">
		        <thead>
		            <tr style="text-align:left;">
		                <th>번호</th>
		                <th>코인</th>
		                <th>MEMBER<br>NUM</th>
		                <th>이름</th>
		                <th>분류</th>
		                <th>&nbsp;</th>
		                <th>수수료</th>
		                <th>시각</th>
		            </tr>
		        </thead>
		</table>
	</div>
</div>

</body>
</html>