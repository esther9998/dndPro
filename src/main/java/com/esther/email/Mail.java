//package com.esther.email;
//
//import java.net.UnknownHostException;
//import java.util.Calendar;
//
//import com.conco.concotrade.vo.authVO;
//import com.conco.concotrade.vo.loginVO;
//import com.conco.concotrade.vo.marketVO;
//import com.conco.concotrade.vo.memberVO;
//import com.conco.concotrade.vo.orderVO;
//import com.conco.concotrade.vo.registerVO;
//import com.conco.concotrade.vo.withdrawVO;
//import com.conco.concotrade.vo.admin.MinerVO;
//
//
//   public class Mail {   
//   
//      
//      private MailSend mailSend;
//      private String sender;
//      private String from;
//      private String subject;
//      private String to;
//      private String msg;
////      public String password;
//      private String bottom;
//      private String top;
//      private String content;
//      
//      public Mail(MailSend ms){
//         mailSend = ms;
//         
//         sender = "CONCOKOREA";
//         from = "concokorea2016@gmail.com";
//         subject = "코엔코코리아 테스트";
//         to = "tmdgk9554@naver.com";
//         msg = "테스트";   
//         
//    	 top = "<a style='text-decoration:none;' href=https://concokorea.com/loginPage><div style='background-size: 550px 900px; padding-left:20px;'></a>" +
//    			 "<div style='width:100%;height:100%;'>" +
//    			 "<div style='height:80px; padding-top:15px; height:60px;'>" +
//    			 "<a style='text-decoration:none;' href=https://concokorea.com/loginPage><img src='https://concokorea.com/images/common/logo.png'></a>" +
//    			 "</div>" + 
//    			 "<hr style= 'border-width:1px; border-color:#dddddd;'>";  
//
//        
//         bottom = "<hr style= 'border-width:1px; margin-top:10px; border-color:#dddddd;'>" +
//  		 		"<div style='font-family: Helvetica,Arial,sans-serif; font-size:10px; height:250px; color:#2b426b;' >" +
//  		 			"<div style='padding-top:20px; padding-left:20px;'>" +
//		 			"COPYRIGHT ⓒ CONCOKOREA ㅣ서울특별시 송파구 법원로 11길 11 문정현대지식산업센터1-1 B동 1313호<br>" +
//		 			"대표이사 전현풍 ㅣ 사업자등록번호 357-85-00581 ㅣ TEL: 1811-1808 ㅣ E-MAIL: coinandcoin@concokorea.com" +
//  		 			"</div>" +
//  		 		"</div>" +
//  		 	   "</div>" +
//  		 	  "</div>"; 
//      }
//
////      public String IPaddr() throws UnknownHostException {
////         InetAddress address = InetAddress.getLocalHost();
////      
////         String Address = "http://concokorea2016.cafe24.com";
////         System.out.println("#######");
////         return Address;
////      }
//      
//      public String sendMail() {
//         mailSend.sendMail(sender, from, to, subject, msg);
//         return "Sucess";
//      }
//      
//      //회원가입 메일 서비스
//      public void RegisterMail(registerVO vo,authVO authvo) throws UnknownHostException {
//         
////    	 System.out.println("@@@"+lang);
////    	 
////    	 if ( lang.equals("kr")) {
////    		 
////    	 } else if ( lang.equals("en")) {
////    		 
////    	 } else if ( lang.equals("cn")) {
////    		 
////    	 }
//    	 
//         String Address = "concokorea.com"; //인증 도메인
//         subject = "[코엔코코리아] 가입을 환영합니다.";
//         
//    	 content = 	"<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:380px; color:#2b426b;'>" +
//     		 			"<div style= 'padding-top:80px; padding-left:30px;'><br><br>" + 
//     		 				"코엔코코리아 가입을 환영합니다.<br />" +
//     		 				"고객님의 아이디는<b>" + vo.getMEMBER_ID() + "</b>입니다.<br /><br />" +
//     		 				"아래의 링크를 클릭하여 이메일 인증을 완료 해주시기 바랍니다.<br /><br />" +
//     		 				"<a style='text-decoration:none; color:#333439;' href=https://concokorea.com/email_auth/" + authvo.getAUTH_KEY() + "><b>https://concokorea.com/email_auth/" + authvo.getAUTH_KEY() + "</b></a><br/><br/></br><br/><br/></br>" +
//     		 				"코엔코코리아를 이용해주셔서 감사합니다." +
//     		 			"</div>" +
//     		 		"</div>";
//        
//         //local
//        
//         msg = top + content + bottom; 
//         
//         mailSend.sendMail(sender, from, vo.getMEMBER_ID(), subject, msg);   
//      }
//      
//      //임시비밀번호 발급 메일 서비스
//      public void Random_pass_email(loginVO vo, String rand_pass) {
//            
////    	 System.out.println("@@@"+lang);
////     	 
////     	 if ( lang.equals("kr")) {
////     		 
////     	 } else if ( lang.equals("en")) {
////     		 
////     	 } else if ( lang.equals("cn")) {
////     		 
////     	 }
//     	 
//         subject = "[코엔코코리아] 임시비밀번호 발급";
//       
//    	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b;'>" +
//     		 			"<div style= 'padding-top:50px; padding-left:30px;'><br/>" + 
//     		 			"고객님의 임시 비밀번호는 <b>  " + rand_pass+"</b>입니다.<br /><br />" +
//     		 			"아래의 비밀번호로 로그인 하여 비밀번호를 변경해주시기 바랍니다.<br /><br />" +
//     		 			"코엔코코리아를 이용해주셔서 감사합니다." +
//     		 		"</div>" +
//     		 	   "</div>";
//        
//         msg = top +  content + bottom;
//         
//         mailSend.sendMail(sender, from, vo.getMEMBER_ID(), subject, msg);
//      }
//      
//      //회원탈퇴 메일 서비스
//      public void delete_member(memberVO mvo) {
//    	  
//    	  subject = "[코엔코코리아] 회원탈퇴 안내";
//    	  
//    	  content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:15px; height:300px; color:#2b426b;'>" +
//    			  "<div style= 'padding-top:50px; padding-left:30px;'><br/>" + 
//    			  mvo.getMEMBER_NAME() + "님 회원탈퇴가 완료되었습니다.<br /><br />" +
//    			  "그동안 코엔코코리아를 이용해 주셔서 감사합니다.<br /><br/>" +
//    			  "<span style='font-size:15px;'>보다 나은 서비스로 다시 찾아 뵙겠습니다.</span><br /><br />" +
//    			  "</div>" +
//    			  "</div>";
//    	  
//    	  msg = top +  content + bottom;
//    	  
//    	  mailSend.sendMail(sender, from, mvo.getMEMBER_ID(), subject, msg);
//      }
//      
//    //코인 출금 인증 이메일
//      public void Coin_WithdroawAuth(withdrawVO withvo, loginVO lvo) {
//         
////    	 System.out.println("lang");
////    	  
////    	 if ( lang.equals("kr") ) {
////    		 
////    	 } else if ( lang.equals("en")) {
////    		 System.out.println("!EMAIL-EN");
////    	 } else if ( lang.equals("cn")) {
////    		 
////    	 }
//         subject = "[코엔코코리아] " + withvo.getCOIN_UNIT() + " 출금 정보 입니다.";
//    
//    	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b;'>" +
//    			 		"<div style= 'padding-top:50px; padding-left:30px;'><br/>" + 
//    			 		"출금 코인 :  <b>" + withvo.getCOIN_UNIT() + "</b><br/>" +
//    			 		"이체지갑 주소 :  <b>" + withvo.getWITHDRAW_TADDR() + "</b><br />" +
//    			 		"출금 금액 :  <b>" + withvo.getWITHDRAW_AMOUNT() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//    			 		"출금 수수료 :  <b>" + withvo.getWITHDRAW_FEE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
////        			 		"출금 후 잔액 :  <b>" + withvo.getBANKING_BALANCE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//    			 		"출금 요청 시간 :  <b>" + withvo.getWITHDRAW_DATE() + "</b><br/><br/>" + 
//    			 		"출금 정보가 틀렸거나, 문제가 생길시 코엔코코리아 고객센터로 연락주시기 바랍니다. <br/><br/>" + 
//    			 		"아래의 버튼을 클릭하여 출금 인증을 완료 해주시기 바랍니다.<br /><br />" +
//    			 		"<a style='text-decoration:none; color:#333439;' href=https://concokorea.com/WITHDRAW_AUTH/"+ withvo.getWITHDRAW_AUTHCODE() + ">"+ 
//    			 		"<div style='display:inline-block; width:100px; height:30px; color:#3c3c3f; background-color:#f0f0f0; border:2px solid #ddd; -webkit-border-radius: 3px; cursor:pointer; text-align:center; line-height:30px;'>"+
//    			 			"출금 인증 " + 
//    			 		"</div></a>" +
//    			 		"<a style='text-decoration:none; color:#333439;' href=https://concokorea.com/WITHDRAW_AUTH_CANCEL/"+ withvo.getWITHDRAW_AUTHCODE() + ">"+ 
//    			 		"<div style='display:inline-block; margin-left:30px; width:100px; height:30px; color:#3c3c3f; background-color:#f0f0f0; border:2px solid #ddd; -webkit-border-radius: 3px; cursor:pointer; text-align:center; line-height:30px;'>"+
//    			 			"출금 취소 " + 
//    			 		"</div></a><br/><br/>" + 
//    			 		"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
//    			 	"</div>" +
//    			   "</div>";
//         
//         bottom = "<hr style= 'border-width:1px; margin-top:90px; border-color:#dddddd;'>" +
//     		 		"<div style='font-family: Helvetica,Arial,sans-serif; font-size:10px; height:250px; color:#2b426b;' >" +
//     		 			"<div style='padding-top:20px; padding-left:20px;'>" +
//     		 			"COPYRIGHT ⓒ CONCOKOREA ㅣ서울특별시 송파구 법원로 11길 11 문정현대지식산업센터1-1 B동 1313호<br>" +
//     		 			"대표이사 전현풍 ㅣ 사업자등록번호 357-85-00581 ㅣ TEL: 1811-1808 ㅣ E-MAIL: coinandcoin@concokorea.com" +
//     		 			"</div>" +
//     		 		"</div>" +
//     		 	   "</div>" +
//     		 	 "</div>";
//        
//             msg = top + content + bottom;
//
//         mailSend.sendMail(sender, from, lvo.getMEMBER_ID(), subject, msg);
//      }
//      
//      //KRW 출금 인증 이메일
//      public void KRW_WithdroawAuth(withdrawVO withvo, loginVO lvo) {
//         
////    	 System.out.println("lang");
////    	  
////     	 if ( lang.equals("kr") ) {
////     		 
////     	 } else if ( lang.equals("en")) {
////     		 System.out.println("!EMAIL-EN");
////     	 } else if ( lang.equals("cn")) {
////     		 
////     	 }
//     	 
//    	 subject = "[코엔코코리아] " + withvo.getCOIN_UNIT() + " 출금 정보 입니다.";
//
//    	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b'>" +
//     		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
//     		 			"출금 계좌 :  <b>  [  " + withvo.getWITHDRAW_ADDR() + "  ]          " + withvo.getWITHDRAW_TADDR() + " </b><br/>" +
//     		 			"출금 금액 :  <b>" + withvo.getWITHDRAW_AMOUNT() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//     		 			"출금 수수료 :  <b>" + withvo.getWITHDRAW_FEE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
////         		 			"출금 후 잔액 :  <b>" + withvo.getBANKING_BALANCE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//     		 			"출금 요청 시간  :  <b>" + withvo.getWITHDRAW_DATE() + "</b><br /><br />" +
//     		 			"출금 정보가 틀렸거나, 문제가 생길시 코엔코코리아 고객센터로 연락주시기 바랍니다. <br/><br/>" + 
//     		 			"아래의 버튼을 클릭하여 출금 인증을 완료 해주시기 바랍니다.<br /><br />" +
//     		 			"<a style='text-decoration:none; color:#333439;' href=https://concokorea.com/WITHDRAW_AUTH/"+ withvo.getWITHDRAW_AUTHCODE() + ">"+ 
//     		 			"<div style='display:inline-block; width:100px; height:30px; color:#3c3c3f; background-color:#f0f0f0; border:2px solid #ddd; -webkit-border-radius: 3px; cursor:pointer; text-align:center; line-height:30px;'>"+
//     		 				"출금 인증 </div></a>" +
////    		 				"<a style='text-decoration; color:#333439;' href=http://concokorea.com/WITHDRAW_AUTH/"+ withvo.getCOIN_UNIT() + "/" +  withvo.getWITHDRAW_AUTHCODE() + "><b>http://concokorea.com/WITHDRAW_AUTH/"+ withvo.getCOIN_UNIT() + "/" +  withvo.getWITHDRAW_AUTHCODE() +"</b></a><br/><br/>" +
//						"<a style='text-decoration:none; color:#333439;' href=https://concokorea.com/WITHDRAW_AUTH_CANCEL/"+ withvo.getWITHDRAW_AUTHCODE() + ">" +           		 		
//						"<div style='display:inline-block; margin-left:30px; width:100px; height:30px; color:#3c3c3f; background-color:#f0f0f0; border:2px solid #ddd; -webkit-border-radius: 3px; cursor:pointer; text-align:center; line-height:30px;'>"+
//							"출금 취소 " + 
//						"</div></a><br/><br/>" +  
//						"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
//					"</div>" +
//				   "</div>";
//    
//         
//         bottom = "<hr style= 'border-width:1px; margin-top:5l0px; border-color:#dddddd;'>" +
//     		 		"<div style='font-family: Helvetica,Arial,sans-serif; font-size:10px; height:250px; color:#2b426b;' >" +
//     		 			"<div style='padding-top:20px; padding-left:20px;'>" +
//     		 			"COPYRIGHT ⓒ CONCOKOREA ㅣ서울특별시 송파구 법원로 11길 11 문정현대지식산업센터1-1 B동 1313호<br>" +
//     		 			"대표이사 전현풍 ㅣ 사업자등록번호 357-85-00581 ㅣ TEL: 1811-1808 ㅣ E-MAIL: coinandcoin@concokorea.com" +
//     		 			"</div>" +
//     		 		"</div>" +
//     		 	   "</div>" +
//     		 	  "</div>";
//     
//         msg = top + content + bottom;
// 
//
//         mailSend.sendMail(sender, from, lvo.getMEMBER_ID(), subject, msg);
//      }
//      
//      //관리자에 의한 KRW 출금 취소
//      public void KRW_WithdrawCancel_Admin(withdrawVO withvo, memberVO mvo) {
//          
//    	 subject = "[코엔코코리아] " + withvo.getCOIN_UNIT() + " 출금 취소 알림";
//
//     	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b'>" +
//      		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
//      		 			"출금 계좌 :  <b>" + withvo.getWITHDRAW_TADDR() + "   [  " + withvo.getWITHDRAW_ADDR() + "  ]</b><br/>" +
//      		 			"출금 금액 :  <b>" + withvo.getWITHDRAW_AMOUNT() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//      		 			"출금 수수료 :  <b>" + withvo.getWITHDRAW_FEE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
////          		 			"출금 후 잔액 :  <b>" + withvo.getBANKING_BALANCE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//      		 			"출금 요청 시간  :  <b>" + withvo.getWITHDRAW_DATE() + "</b><br /><br />" +
//      		 			"이 출금은 관리자에 의하여 취소되었습니다. <br/><br/>" + 
//      		 			"문의 사항은 코엔코코리아 고객센터로 연락주시기 바랍니다. <br/><br/>" + 
// 						"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
// 					"</div>" +
// 				   "</div>";
//     	 
//          msg = top + content + bottom;
//  
//
//          mailSend.sendMail(sender, from, mvo.getMEMBER_ID(), subject, msg);
//       }
//      
//      //관리자에 의한 COIN 출금 취소
//      public void COIN_WithdrawCancel_Admin(withdrawVO withvo, memberVO mvo) {
//          
//    	  subject = "[코엔코코리아] " + withvo.getCOIN_UNIT() + " 출금 취소 알림";
//
//     	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b'>" +
//      		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
//      		 			"출금 코인 :  <b>" + withvo.getCOIN_UNIT() + "</b><br/>" +
//    			 		"이체지갑 주소 :  <b>" + withvo.getWITHDRAW_TADDR() + "</b><br />" +
//    			 		"출금 금액 :  <b>" + withvo.getWITHDRAW_AMOUNT() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//    			 		"출금 수수료 :  <b>" + withvo.getWITHDRAW_FEE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
////        			 		"출금 후 잔액 :  <b>" + withvo.getBANKING_BALANCE() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//    			 		"출금 요청 시간 :  <b>" + withvo.getWITHDRAW_DATE() + "</b><br/><br/>" + 
//      		 			"이 출금은 관리자에 의하여 취소되었습니다. <br/><br/>" + 
//      		 			"문의 사항은 코엔코코리아 고객센터로 연락주시기 바랍니다. <br/><br/>" + 
// 						"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
// 					"</div>" +
// 				   "</div>";
//     	 
//          msg = top + content + bottom;
//  
//
//          mailSend.sendMail(sender, from, mvo.getMEMBER_ID(), subject, msg);
//       }
//      
//      //관리자에 의한 주문취소
//      public void Order_Cancel_Admin(orderVO ovo, memberVO mvo, marketVO marketvo) {
//          
//    	  String ORDER_KIND = "";
//    	  if ( ovo.getORDER_KIND().equals("31") || ovo.getORDER_KIND().equals("32")) {
//    		  ORDER_KIND = "매수";
//    	  } else if ( ovo.getORDER_KIND().equals("41") || ovo.getORDER_KIND().equals("42")) {
//    		  ORDER_KIND = "매도";
//    	  }
//    	  
//          subject = "[코엔코코리아] " + marketvo.getMARKET_NAME() + " 주문 취소 알림";
//
//     	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:400px; color:#2b426b'>" +
//      		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
//      		 			"마켓 :  <b>" + marketvo.getMARKET_NAME() + "</b><br/>" +
//      		 			"분류  :  <b>" + ORDER_KIND + "</b><br />" +
//      		 			"가격 :  <b>" + ovo.getORDER_PRICE() + " " + ovo.getBASE_COIN_UNIT() + "</b><br />" +
//      		 			"수량 :  <b>" + ovo.getORDER_AMOUNT() + " " + ovo.getTARGET_COIN_UNIT() + "</b><br /><br/><br/>" +
//      		 			"이 주문은 관리자에 의하여 취소되었습니다. <br/><br/>" + 
//      		 			"문의 사항은 코엔코코리아 고객센터로 연락주시기 바랍니다. <br/><br/>" + 
// 						"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
// 					"</div>" +
// 				   "</div>";
//     	 
//          msg = top + content + bottom;
//  
//
//          mailSend.sendMail(sender, from, mvo.getMEMBER_ID(), subject, msg);
//       }
//      
//     //채굴입금 메일
//      public void MinerRewardInfo(MinerVO minervo) {
//    	 
//    	 Calendar cal = Calendar.getInstance();
//    	 
//         subject = "[코엔코코리아] "+(cal.get(Calendar.MONTH)+1) + "월 채굴 입금정보 안내";
//
//     	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:400px; color:#2b426b'>" +
//      		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
//      		 			"채굴 코인 :  <b>" + minervo.getCOIN_UNIT() + "</b><br/>" +
//      		 			"총 채굴 수량 :  <b>" + minervo.getREWARD_TOTAL() + " " + minervo.getCOIN_UNIT() + "</b><br />" +
//      		 			"채굴기 수량 :  <b>" + minervo.getMINER_COUNT() + " 대 </b><br />" +
//      		 			"입금 수량 :  <b>" + minervo.getDEPOSIT_AMOUNT() + " " + minervo.getCOIN_UNIT() + "</b><br />" +
//      		 			"채굴 수수료 :  <b>" + minervo.getREWARD_FEE() + " " + minervo.getCOIN_UNIT() + "</b><br />" +
//      		 			"입금 시각 :  <b>" + minervo.getDEPOSIT_DATE() + "</b><br /><br/><br/>" +
//      		 			cal.get(Calendar.YEAR) +"년 "+(cal.get(Calendar.MONTH)+1) + "월 채굴 입금 안내사항입니다. <br/><br/>" + 
//      		 			"잘못된 정보 또는 문의 사항은 코엔코코리아 고객센터로 연락주시기 바랍니다. <br/><br/>" + 
// 						"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
// 					"</div>" +
// 				   "</div>";
//     	 
//          msg = top + content + bottom;
//  
//
//          mailSend.sendMail(sender, from, minervo.getMEMBER_ID(), subject, msg);
//       }
//      
//      //KRW 출금  완료 이메일
//      public void KRW_withdraw_success(withdrawVO withvo, memberVO mvo) {
//         subject = "[코엔코코리아] KRW 출금 완료";
//
//     	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b'>" +
//      		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
//	      		 			"출금 계좌 :  <b>  [  " + withvo.getWITHDRAW_ADDR() + "  ]          " + withvo.getWITHDRAW_TADDR() + " </b><br/>" +
//	      		 			"출금 금액 :  <b>" + withvo.getWITHDRAW_AMOUNT() + " " + withvo.getCOIN_UNIT() + "</b><br />" +
//	      		 			"출금 요청 시간  :  <b>" + withvo.getWITHDRAW_DATE() + "</b><br /><br />" +
//	      		 			withvo.getCOIN_UNIT() + " 출금이 완료되었습니다. <br/><br/>" + 
//	      		 			"코엔코코리아를 이용해주셔서 감사합니다.<br/><br/>" +
// 						"</div>" +
// 				   "</div>";
//      
//          msg = top + content + bottom;
//
//          mailSend.sendMail(sender, from, mvo.getMEMBER_ID(), subject, msg);
//       }
//      
//      //KRW 출금 요청 관리자 메일
//      public void AdminWithdrawSendMail(int number) {
//          subject = "[코엔코코리아] KRW 출금 요청이 " + number + "건이 있습니다.";
//
//      	 content = "<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:420px; color:#2b426b'>" +
//       		 			"<div style= 'padding-top:40px; padding-left:30px;'><br/>" + 
// 	      		 			"KRW 출금 요청이 " + number + "건이 있습니다.<br/><br/>" + 
// 	      		 			"출금 요청내역을 다시한번 확인 후 처리하시기 바랍니다.<br/><br/>" + 
// 	      		 			"<a href=\"https://concokorea.com/ADM/loginPage\">바로가기</a>" + 
//  						"</div>" +
//  				   "</div>";
//       
//           msg = top + content + bottom;
//
//           mailSend.sendMail(sender, from, "concokorea2016@gmail.com", subject, msg);
////           mailSend.sendMail(sender, from, "kshman94@naver.com", subject, msg);
//      }
//      
//      public void test() {
//      
//         subject = "테스트";
//         
//    	 content = 	"<div style='font-family: Helvetica,Arial,sans-serif; font-size:16px; height:380px; color:#2b426b;'>" +
//     		 			"<div style= 'padding-top:80px; padding-left:30px;'><br><br>" + 
//     		 				"코엔코 코리아 가입을 환영합니다.<br />" +
//     		 				"고객님의 아이디는<b> test </b>입니다.<br /><br />" +
//     		 				"아래의 링크를 클릭하여 접속하여 이메일 인증을 완료 해주시기 바랍니다.<br /><br />" +
//     		 				"<a style='text-decoration:none; color:#333439;' href=https://concokorea.com/email_auth/test"+"><b>https://concokorea.com/email_auth/test"+ "</b></a><br/><br/></br><br/><br/></br>" +
//     		 				"코엔코코리아를 이용해주셔서 감사합니다." +
//     		 			"</div>" +
//     		 		"</div>";
//        
//         //local
//        
//         msg = top + content + bottom; 
//         to = "kshman94@naver.com";
//   
//         mailSend.sendMail(sender, from, to, subject, msg);   
//         }
//   }
//   
//      //회원가입
////      public String testMail() {
////         String subject = "test";
////         String msg = "test입니다.";
////         
////         mailSend.sendMail(sender, from, to, subject, msg);
////         return "Sucess";
////      }
//
//      //비밀번호수정
//      
//      //비밀번호찾기
//      
//      
////}
// 