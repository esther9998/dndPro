<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/JavaScript" src="/js/jquery-3.1.1.min.js"></script>
<script type="text/JavaScript" src="/js/jquery.history.js"></script>
<script language="javascript" type="text/javascript" src="/js/common.js"></script>
<link rel="stylesheet" type="text/css" href="/css/dataTables.css">
<link rel="stylesheet" type="text/css" href="/css/datatables_min.css">
<link rel="stylesheet" type="text/css" href="/css/jquery_ui.css">
<script type="text/JavaScript" src="/js/dataTables.js"></script>
<script type="text/JavaScript" src="/js/datatables_button.js"></script>
<script type="text/JavaScript" src="/js/datatables_flash.js"></script>
<script type="text/JavaScript"
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script type="text/JavaScript"
	src="https://cdn.rawgit.com/bpampuch/pdfmake/0.1.27/build/pdfmake.min.js"></script>
<script type="text/JavaScript"
	src="https://cdn.rawgit.com/bpampuch/pdfmake/0.1.27/build/vfs_fonts.js"></script>
<script type="text/JavaScript"
	src="https://cdn.datatables.net/buttons/1.3.1/js/buttons.html5.min.js"></script>
<script type="text/JavaScript"
	src="https://cdn.datatables.net/buttons/1.3.1/js/buttons.print.min.js"></script>
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js"
	charset="utf-8"></script>
<script type="text/JavaScript" src="/js/Big.js"></script>
<script type="text/JavaScript" src="/js/jquery_ui.js"></script>
<script language="javascript" type="text/javascript"
	src="/js/adminCommon.js"></script>
<link rel="shortcut icon" href="/images/favicon.png" type="image/x-icon">
<link rel="icon" href="/images/favicon.ico" type="image/x-icon">
<title>관리자</title>
<style>
.wrap {
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0px;
	left: 0px;
	margin: 0 auto;
	overflow-y: auto;
	min-width: 1450px;
}

.admin_Index {
	width: 100%;
	height: 100%;
	background-color: #ffffff;
}

.admin_IndexForm {
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0px;
	left: 0px;
	margin: 0 auto;
	overflow-y: auto;
}

.admin_header {
	width: 100%;
	height: 60px;
}

.admin_header_wrap {
	position: relative;
	margin-top: 5px;
	left: 50%;
	margin-left: -700px;
	width: 1350px;
	height: 100%;
}

.menubar_wrap {
	width: 100%;
	margin-top: 10px;
	background-color: rgba(43, 51, 78, 0.8);
	color: #ffffff;
	text-align: center;
}

.menubar_form {
	position: relative;
	left: 50%;
	margin-left: -700px;
	width: 1350px;
	height: 100%;
}

.menubar_frame {
	display: inline-block;
	width: 129px;
	height: 100%;
	line-height: 40px;
	text-align: center;
	font-size: 12px;
	letter-spacing: 2px;
	cursor: pointer;
}

.menubar_frame:hover {
	background-color: rgba(92, 108, 160, 0.8);
}

.content_form {
	width: 100%;
	height: 100%;
	position: relative;
}

.content {
	position: relative;
	left: 50%;
	margin-left: -700px;
	top: 30px;
	width: 1350px;
	padding-bottom: 100px;
	background-color: #fff;
}

ss
.logo {
	position: relative;
	margin: 18px 0 0 15px;
	width: 250px;
	height: 100%;
	cursor: pointer;
}

.bottom {
	width: 100%;
	height: 40%;
}

.bottom_wrap {
	position: relative;
	width: 1350px;
	left: 50%;
	margin-left: -700px;
	top: 20px;
	background-color: #aa0000;
}

.mask {
	background-color: #DDDDDD;
	opacity: 0.7;
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
}

.popup_mask {
	background-color: #DDDDDD;
	opacity: 0.7;
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	display: none;
}

.progresspanel {
	display: none;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 100%;
	z-index: 10000000;
}

.progress {
	width: 100px;
	height: 50px;
	top: 300px;
	position: absolute;
	left: 50%;
	top: 50%;
	margin-left: -50px;
	margin-top: -100px;
}

.logout {
	width: 100px;
	height: 30px;
	border: 1px solid #aaaaaa;
	position: absolute;
	top: 20px;
	right: 0px;
	border-radius: 3px;
	text-align: center;
	line-height: 30px;
	cursor: pointer;
	color: #555555;
	font-size: 13px;
	letter-spacing: 2px;
}

.balance_form {
	position: absolute;
	top: 130px;
	left: 550px;
	display: none;
	z-index: 10;
	border: 2px solid #bbb;
}

.Pop_close {
	background-color: #bbb;
	color: #fff;
	font-size: 16px;
	padding-right: 20px;
	height: 30px;
	line-height: 30px;
}

.menubar_frame_sub {
	display: none;
	position: absolute;
	color: #ffffff;
}

.menubar_sub {
	width: 129px;
	height: 40px;
	background-color: rgba(43, 51, 78, 0.8);
	font-size: 12px;
}

.menubar_frame_subfrom {
	width: 100%;
	position: absolute;
	z-index: 10;
}

.menubar_sub:hover {
	background-color: rgba(91, 104, 151, 1);
}

.menubar_frame:hover .menubar_frame_sub {
	background-color: rgba(92, 108, 160, 0.8);
	display: block;
}
</style>

<script>
	var ADMIN_LEVEL = "${ADMIN_LEVEL}";
	$(document).ready(function() {

		$('#user_info').off('click');
		$('#user_admin').off('click');
		$('#withdrawal_List').off('click');
		$('#withdrawal_admin').off('click');
		$('#withdrawList_req').off('click');
		$('#withdrawList_wait').off('click');
		$('#withdrawList_suc').off('click');
		$('#menubar_orderList').off('click');
		$('#menubar_tradeList').off('click');
		$('#logout').off('click');
		$('#logo').off('click');
		$("#notice_add").off('click');

		//회원 
		$("#user_info_form").on('click', function() {
			var url = "/ADM/level_chk/10"; // 권한 레벨 1.5 일 경우의 예외처리
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/member");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//회원 조회
		$("#user_info").on('click', function() {
			var url = "/ADM/level_chk/10";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/member");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//회원 관리
		$("#user_admin").on('click', function() {
			var url = "/ADM/level_chk/10";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/member_admin");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//입출금 
		$("#withdrawal_Listfrom").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/withdrawal_List");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//입출금 내역
		$("#withdrawal_List").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/withdrawal_List");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//입출금 관리
		$("#withdrawal_admin").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/withdrawal_admin");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//출금
		$("#withdrawList_req_form").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/req_withdrawPage");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//출금 요청
		$("#withdrawList_req").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/req_withdrawPage");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//인증대기중
		$("#withdrawList_wait").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/withdrawList_wait");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//출금 완료
		$("#withdrawList_suc").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/withdrawList_success");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//출금 내역
		$("#withdrawList").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/withdrawList");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//주문 내역
		$("#menubar_orderList").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/OrderList");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//거래 내역
		$("#menubar_tradeList").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/TradeList");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//수수료 내역
		$("#menubar_feeList").on('click', function() {			
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/FeeList");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//수수료 정산
		$("#menubar_feecalc").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/CalFee");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//트렌젝션 내역
		$("#menubar_transaction").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/transaction_List");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//코인관리
		$("#menubar_coin").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/coin");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});
		
		//현재 코인 잔액
		$("#menubar_cur_balance").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/cur_balance");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});
		
		//총 코인 잔액
		$("#menubar_total_balance").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/total_balance");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//마켓관리
		$("#menubar_market").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/market");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//관리자 계정 TYPE = 1 
		$("#menubar_admin").on('click', function() {
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/admin");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//관리자 이용내역 TYPE = 2 
		$("#admin_history").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/admin_history");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		//공지관리 레벨 3이상만 접근가능
		$("#admin_notice").on('click', function() {
			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/admin_notice");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		
		$("#conco_board").on('click', function() {
			
/* 			var url = "/ADM/level_chk/2";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/admin_board");
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			}); */
			
			adminPageload("/ADM/admin_board");
			
		});
		$("#fork_board").on('click', function() {
			
			 			 var url = "/ADM/level_chk/2";
						$.ajax({
							type : "POST",
							url : url,
							async : false,
							dataType : 'json',
							success : function(obj) { //가져오는 값(변수)
								if (obj.ResultCode == "0") {
									/* adminPageload("/ADM/admin_fork"); */
									location.href = "https://concokorea.com/ADM/HARDFORK/2/0";
								} else if (obj.ResultCode == "1") {
									alert(obj.Data);
									location.href = "/ADM/loginPage";
								} else {
									alert(obj.Data);
									return;
								}
							},
							error : function(e) { //500 ERR
								//서버내부오류
								alert("잠시 후 시도해주세요.");
								location.href = "/ADM/loginPage";
							}
						});  
						
						
						
		});
		//로그인 내역
		$("#login_hisotry").on('click', function() {		
			var url = "/ADM/level_chk/1";
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				dataType : 'json',
				success : function(obj) { //가져오는 값(변수)
					if (obj.ResultCode == "0") {
						adminPageload("/ADM/login_history")
					} else if (obj.ResultCode == "1") {
						alert(obj.Data);
						location.href = "/ADM/loginPage";
					} else {
						alert(obj.Data);
						return;
					}
				},
				error : function(e) { //500 ERR
					//서버내부오류
					alert("잠시 후 시도해주세요.");
					location.href = "/ADM/loginPage";
				}
			});
		});

		$("#logo").on('click', function() {
			adminPageload("/ADM/admin_board");
		});

		$("#logout").on('click', function() {
			location.replace("/ADM/logout");
		});

		//출금요청알림
		if (Notification.permission !== "granted")
			Notification.requestPermission();

		notifyAdmin();

		adminPageload("${pageParam}");

	});


	function notifyAdmin() {
		$.ajax({
			type : "POST",
			url : "/ADM/withdraw_request_chk",
			async : false,
			dataType : 'json',
			success : function(obj) { //가져오는 값(변수)
				if (obj.ResultCode == "0") {
					var notification = noti('관리자 알림 메세지',"KRW 출금 요청이 " + obj.Data + " 건이 있습니다.",true);
					if(notification!=null){
						notification.onclick = function () {
							//window.focus 가능 ? 
							adminPageload("/ADM/req_withdrawPage");
							notification.close();
						};
						setTimeout(notification.close.bind(notification),10000); 
					}
				    setTimeout(notifyAdmin, 30000);
				} else if ( obj.ResultCode == "1") {
					return;
				} else if ( obj.ResultCode == "100"){
					alert(obj.Data);
					location.href = "/ADM/loginPage";
				}
			},
			error : function(e) { //500 ERR
				//서버내부오류
				alert("잠시 후 시도해주세요.");
				location.href = "/ADM/loginPage";
			}
		});
	}
</script>
</head>
<body>
	<audio id="messageAlarm" controls style="display:none;">
		<source src="/js/alarm.mp3" type="audio/ogg">
	</audio>
	<div class="wrap">
		<div class="admin_Index">
			<div class="admin_IndexForm">
				<div class="admin_header">
					<div class="admin_header_wrap">
						<div class="logo" id="logo">
							<img src="/images/common/logo.png" style="cursor: pointer;">
						</div>
						<div class="logout" id="logout">LOGOUT</div>
					</div>
				</div>
				<div class="menubar_wrap">
					<div class="menubar_form">
						<div class="menubar_frame">
							<div class="menubar_userinfo">
								<div id="user_info_form" style="width: 100%; height: 100%;">
									<span>회원 관리</span>
								</div>
								<div class="menubar_frame_subfrom">
									<div class="menubar_frame_sub" id="menuber_user_sub">
										<div class="menubar_sub" id="user_info">
											<span>회원 정보</span>
										</div>
										<div class="menubar_sub" id="user_admin">
											<span>회원 관리</span>
										</div>
										<div class="menubar_sub" id="user_admin">
											<span>회원 인증</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="menubar_withdrawal_List">
								<div id="withdrawal_Listfrom" style="width: 100%; height: 100%;">
									<span>입·출금 내역</span>
								</div>
								<div class="menubar_frame_subfrom">
									<div class="menubar_frame_sub" id="menuber_user_sub">
										<div class="menubar_sub" id="withdrawal_List">
											<span>입·출금 내역</span>
										</div>
										<div class="menubar_sub" id="withdrawal_admin">
											<span>입·출금 관리</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="menubar_withdrawal_request">
								<div id="withdrawList_req_form"
									style="width: 100%; height: 100%;">
									<span>출금 관리</span>
								</div>
								<div class="menubar_frame_subfrom">
									<div class="menubar_frame_sub" id="menuber_user_sub">
										<div class="menubar_sub" id="withdrawList_wait">
											<span>인증대기중 내역</span>
										</div>
										<div class="menubar_sub" id="withdrawList_req">
											<span>출금요청 내역</span>
										</div>
										<div class="menubar_sub" id="withdrawList_suc">
											<span>출금완료 내역</span>
										</div>
										<div class="menubar_sub" id="withdrawList">
											<span>출금 내역</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- 						<div class="menubar_frame"> -->
						<!-- 							<div class="menubar_withdrawal_admin" id="withdrawal_admin"><span>입·출금 관리</span></div> -->
						<!-- 						</div> -->
						<div class="menubar_frame">
							<div class="menubar_orderList" id="menubar_orderList">
								<span>주문 내역</span>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="menubar_tradeList" id="menubar_tradeList">
								<span>거래 내역</span>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="menubar_feeList" id="menubar_feeList">
								<span>수수료 내역</span>
							</div>
							<div class="menubar_frame_subfrom">
								<div class="menubar_frame_sub" id="menuber_user_sub">
									<div class="menubar_sub" id="menubar_feecalc">
										<span>수수료 정산</span>
									</div>
								</div>
							</div>
						</div>
						<!-- 						<div class="menubar_frame"> -->
						<!-- 							<div class="menubar_transaction" id="menubar_transaction"><span>트렌젝션 내역</span></div> -->
						<!-- 						</div> -->
						<!-- 						<div class="menubar_frame"> -->
						<!-- 							<div class="menubar_coin" id="menubar_coin"><span>코인 관리</span></div> -->
						<!-- 						</div> -->
						<div class="menubar_frame">
							<div class="menubar_coin">
								<div id="menubar_coin" style="width: 100%; height: 100%;">
									<span>코인 관리</span>
								</div>
								<div class="menubar_frame_subfrom">
									<div class="menubar_frame_sub" id="menuber_user_sub">
										<div class="menubar_sub" id="menubar_transaction">
											<span>트렌젝션 내역</span>
										</div>
										<div class="menubar_sub" id="menubar_cur_balance">
											<span>회원 코인 잔액</span>
										</div>
										<div class="menubar_sub" id="menubar_total_balance">
											<span>총 코인 잔액</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="menubar_market" id="menubar_market">
								<span>마켓 관리</span>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="menubar_withdrawal_request">
								<div id=menubar_admin style="width: 100%; height: 100%;">
									<span>관리자 계정</span>
								</div>
								<div class="menubar_frame_subfrom">
									<div class="menubar_frame_sub" id="menuber_user_sub">
										<div class="menubar_sub" id="admin_history">
											<span>이용 내역</span>
										</div>
										<div class="menubar_sub" id="admin_notice">
											<span>공지 관리</span>
										</div>
										<div class="menubar_sub" id="conco_board">
											<span>게시판 관리</span>
										</div>
										<div class="menubar_sub" id="fork_board">
											<span>포크 관리</span>
										</div>
										<div class="menubar_sub" id="login_hisotry">
											<span>로그인 내역</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="menubar_frame">
							<div class="" id="menubar_">
								<span>지점 관리</span>
							</div>
						</div>
					</div>
				</div>
				<div class="content_form">
					<div class="content" id="content"></div>
				</div>
			</div>
		</div>
	</div>

	<div class="balance_form" id="balance_form">
		<div class="" id="balance">
			<div class="Pop_close">
				<span style="cursor: pointer; position: absolute; right: 20px;"
					id="Pop_close">X</span>
			</div>
			<div id="balance_content"></div>
		</div>
	</div>
</body>

<div id="progresspanel" class="progresspanel">
	<div id="mask" class="mask">&nbsp;</div>
	<div id="progess" class="progress">
		<img src="/images/login/progress.gif" style="height: 100px;" />
	</div>
</div>
<div id="popup_mask" class="popup_mask">&nbsp;</div>
</html>