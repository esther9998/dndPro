package com.conco.concotrade.controller.admin;

import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.conco.concotrade.controller.HomeController;
import com.conco.concotrade.email.Mail;
import com.conco.concotrade.email.MailSend;
import com.conco.concotrade.util.Random_pass;
import com.conco.concotrade.util.md5;
import com.conco.concotrade.vo.authVO;
import com.conco.concotrade.vo.memberVO;
import com.conco.concotrade.vo.registerVO;
import com.conco.concotrade.vo.userVO;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminVO;

@Controller
public class MemberController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	private MailSend mailSend;
	
	//회원 조회 페이지
	@RequestMapping(value = "/ADM/member", method = RequestMethod.GET)
	public String userinfo(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/member_search/member_info";
		}else{
			model.addAttribute("pageParam", "/ADM/member");
			return "/admin/main_frame";			 
		}	
	}
	
	//회원조회 -> 멤버 정보 가져오기
	@RequestMapping(value = "/ADM/memberInfo", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> userinfo_datalaod(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		memberVO mvo = new memberVO();
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<memberVO> MemberList = sqlSession.selectList("admin.getMemberList");
		
		result.put("draw", 1);
		result.put("data", MemberList);
		
		return result;
	}
	
	// 회원조회 -> 이메일 재전송 프로세스
	@RequestMapping(value = "/ADM/email_resend_process", method = RequestMethod.POST) 
	@ResponseBody
	public HashMap<String, String> email_resend_proces(@RequestParam HashMap<String, String> map, HttpSession session, HttpServletRequest request) throws UnknownHostException {
		
		memberVO mvo = new memberVO();
		registerVO rvo = new registerVO();
		authVO avo = new authVO();
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		//ajax 받은 값
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");

		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
				
			result.put("ResultCode", "100");
			result.put("Data", Msg);
			
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null ) {
			String Msg ="잘못된 접근입니다.";
			
			result.put("ResultCode", "9");
			result.put("Data", Msg);
			
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "8");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 1 ) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "7");
			result.put("Data", Msg);
			
			return result;
		}
		
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		
		mvo.setMEMBER_NUM(MEMBER_NUM);
		//회원 정보 가져오기
		
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		
		if ( mvo == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			
			return result;
		}
		//회원탈퇴 계정인지 체크
		if (! mvo.getMEMBER_USE().equals("Y")) {
			String Msg = "회원 탈퇴 계정입니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			
			return result;
		}
		//AVAIL == N 인지 체크
		if ( mvo.getAUTH_AVAIL().equals("N")) {
			
			while (true) {
				//AUTHCODE 생성
				String AUTH = Random_pass.randomEmail();
				
				avo.setAUTH_KEY(AUTH);
				avo.setMEMBER_NUM(MEMBER_NUM);
				
				int FindRegNum = sqlSession.selectOne("register.getRegAuthCode", avo);
	
				if (AUTH == null) {
					String Msg = "인증코드를 생성하지 못했습니다.\n 잠시 후 시도해주세요.";
	
					result.put("ResultCode", "3");
					result.put("Data", Msg);
	
					return result;
				}
	
				if (FindRegNum == 0)
					break;
			}
			
			//업데이트
	        int rst = sqlSession.update("admin.setAuthKey", avo);
	        
        	//로그인 날짜 및 account 삽입  insert
    		Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
            
            //주소 가져오기
            String REQEUST_PAGE = request.getRequestURI();
            String EMAIL = adminvo.getADMIN_ID();
            
            //avo 값들 셋팅
            //DB insert admin
            ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
            ahvo.setREQUEST_PAGE(REQEUST_PAGE);
            ahvo.setADMIN_ACCOUNT(EMAIL);
            ahvo.setEXECUTE_DATE(today);
            
	        if ( rst > 0 ) {
	        	//이메일 전송
	        	Mail mail = new Mail(mailSend);
	        	
	        	rvo.setMEMBER_ID(mvo.getMEMBER_ID());
	        	
	        	mail.RegisterMail(rvo, avo);
	        	
	        	ahvo.setEXECUTE_KIND("UPDATE");
	            ahvo.setADMIN_DESC("EMAIL RESEND SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
	        	logger.info("EMAIL RESEND SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				String Msg = "가입하신 이메일로 인증코드를 발송하였습니다.";
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				return result;
				
	        } else {
	        	
	        	ahvo.setEXECUTE_KIND("UPDATE_FAIL");
	        	ahvo.setADMIN_DESC("EMAIL RESEND FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
	        	
	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
		            
	        	logger.error("EMAIL RESEND FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				String Msg = "이메일 전송 에러. 잠시 후 시도해주세요.";
				result.put("ResultCode", "4");
				result.put("Data", Msg);
				return result;
	        }
	        
		} else {
			String Msg = "이메일 인증이 완료된 계정입니다.";
			result.put("ResultCode", "5");
			result.put("Data", Msg);
			return result;
		}
		
	}

	
	//회원 관리 페이지
	@RequestMapping(value = "/ADM/member_admin", method = RequestMethod.GET)
	public String member_admin(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/member_admin/member_admin";
		}else{
			model.addAttribute("pageParam", "/ADM/member_admin");
			return "/admin/main_frame";			 
		}	
	}
	
	//회원 탈퇴 페이지
	@RequestMapping(value = "/ADM/member_delete/{MEMBER_NUM}", method = RequestMethod.GET)
	public String member_delete(@PathVariable("MEMBER_NUM") int MEMBER_NUM, @RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		model.addAttribute("MEMBER_NUM", MEMBER_NUM);	
		
		return "/admin/member_admin/member_delete";
	
	}
	
	//회원관리 -> 에러 초기화 프로세스
	@RequestMapping(value = "/ADM/err_reset", method = RequestMethod.POST) 
	@ResponseBody
	public HashMap<String, String> err_reset(@RequestParam HashMap<String, String> map, HttpSession session, HttpServletRequest request) throws UnknownHostException {
		
		memberVO mvo = new memberVO();
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
				
			result.put("ResultCode", "100");
			result.put("Data", Msg);
			
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null ) {
			String Msg ="잘못된 접근입니다.";
			
			result.put("ResultCode", "9");
			result.put("Data", Msg);
			
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "8");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 1 ) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		//ajax 받은 값
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		
		mvo.setMEMBER_NUM(MEMBER_NUM);
		//회원 정보 가져오기
		
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		
		if ( mvo == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( mvo.getMEMBER_ERR().equals("0")) {
			String Msg = "에러 횟수가 0 입니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			
			return result;
		} else {
			
			//에러 카운트 0으로 업데이트
			int rst = sqlSession.update("admin.setErrCount", mvo);

        	//로그인 날짜 및 account 삽입  insert
    		Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
            
            //주소 가져오기
            String REQEUST_PAGE = request.getRequestURI();
            String EMAIL = adminvo.getADMIN_ID();
            
            //avo 값들 셋팅
            //DB insert admin
            ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
            ahvo.setREQUEST_PAGE(REQEUST_PAGE);
            ahvo.setADMIN_ACCOUNT(EMAIL);
            ahvo.setEXECUTE_DATE(today);
            
			if ( rst > 0 ) {
				
	            ahvo.setEXECUTE_KIND("UPDATE");
	            ahvo.setADMIN_DESC("ErrCount UPDATE SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
				// 로그	
				logger.info("ErrCount UPDATE SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				
				String Msg = "에러 횟수가 초기화 되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				
				return result;
			} else {
				
				ahvo.setEXECUTE_KIND("UPDATE_FAIL");
	            ahvo.setADMIN_DESC("ErrCount UPDATE FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
		        
	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
				logger.error("ErrCount UPDATE FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today );
				
				String Msg = "에러 초기화 실패하였습니다. \n잠시 후 시도해주세요.";
				
				result.put("ResultCode", "3");
				result.put("Data", Msg);
				
				return result;
			}
		}
	}
	
	//회원관리 -> 계정 잠금 및 해제 프로세스
	@RequestMapping(value = "/ADM/lock_set", method = RequestMethod.POST) 
	@ResponseBody
	public HashMap<String, String> lock_set(@RequestParam HashMap<String, String> map, HttpSession session, HttpServletRequest request) throws UnknownHostException {
		
		memberVO mvo = new memberVO();
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
				
			result.put("ResultCode", "100");
			result.put("Data", Msg);
			
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null ) {
			String Msg ="잘못된 접근입니다.";
			
			result.put("ResultCode", "9");
			result.put("Data", Msg);
			
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "8");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 1 ) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "7");
			result.put("Data", Msg);
			
			return result;
		}
		
		//ajax 받은 값
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		
		mvo.setMEMBER_NUM(MEMBER_NUM);
		//회원 정보 가져오기
		
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		
		if ( mvo == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			
			return result;
		}
		
		//잠금 설정
		if ( mvo.getMEMBER_LOCK().equals("N")) {
			
			mvo.setMEMBER_LOCK("Y");
			
			int rst = sqlSession.update("admin.setLock", mvo);
			
			//로그인 날짜 및 account 삽입  insert
    		Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
            
            //주소 가져오기
            String REQEUST_PAGE = request.getRequestURI();
            String EMAIL = adminvo.getADMIN_ID();
            
            //avo 값들 셋팅
            //DB insert admin
            ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
            ahvo.setREQUEST_PAGE(REQEUST_PAGE);
            ahvo.setADMIN_ACCOUNT(EMAIL);
            ahvo.setEXECUTE_DATE(today);
            
			if ( rst > 0 ) {
				
				ahvo.setEXECUTE_KIND("UPDATE");
	            ahvo.setADMIN_DESC("UPDATE LOCK SETTING SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
				logger.info("UPDATE LOCK SETTING SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				
				String Msg = "잠금 설정이 완료되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				
				return result;
			} else {
				
				ahvo.setEXECUTE_KIND("UPDATE_FAIL");
	            ahvo.setADMIN_DESC("UPDATE LOCK SETTING FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
				logger.error("UPDATE LOCK SETTING FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				
				String Msg = "잠금 설정 실패하였습니다. \n잠시 후 시도해주세요.";
				
				result.put("ResultCode", "2");
				result.put("Data", Msg);
				
				return result;
			}
		} else {
		//잠금 해제
			mvo.setMEMBER_LOCK("N");
			
			int rst = sqlSession.update("admin.setLock", mvo);
			
			//로그인 날짜 및 account 삽입  insert
    		Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
            
            //주소 가져오기
            String REQEUST_PAGE = request.getRequestURI();
            String EMAIL = adminvo.getADMIN_ID();
            
            //avo 값들 셋팅
            //DB insert admin
            ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
            ahvo.setREQUEST_PAGE(REQEUST_PAGE);
            ahvo.setADMIN_ACCOUNT(EMAIL);
            ahvo.setEXECUTE_DATE(today);
            
			if ( rst > 0 ) {
				
				ahvo.setEXECUTE_KIND("UPDATE");
	            ahvo.setADMIN_DESC("UPDATE LOCK CANCEL SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
				logger.info("UPDATE LOCK CANCEL SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				
				String Msg = "잠금이 해제 되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				
				return result;
			} else {
				
				ahvo.setEXECUTE_KIND("UPDATE_FAIL");
	            ahvo.setADMIN_DESC("UPDATE LOCK CANCEL FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

	            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	            
				logger.error("UPDATE LOCK CANCEL FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				
				String Msg = "잠금 해제 실패하였습니다. \n잠시 후 시도해주세요.";
				
				result.put("ResultCode", "2");
				result.put("Data", Msg);
				
				return result;
			}
		}
	}
	
	//회원관리 -> 회원 탈퇴 프로세스
	@RequestMapping(value = "/ADM/delete_member", method = RequestMethod.POST) 
	@ResponseBody
	public HashMap<String, String> adm_delete_member(@RequestParam HashMap<String, String> map, HttpSession session, HttpServletRequest request) {
		
		//admin 로그인 확인
		memberVO mvo = new memberVO();
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
				
			result.put("ResultCode", "100");
			result.put("Data", Msg);
			
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null ) {
			String Msg ="잘못된 접근입니다.";
			
			result.put("ResultCode", "9");
			result.put("Data", Msg);
			
			return result;
		}
		
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "8");
			result.put("Data", Msg);
			
			return result;
		}

		if ( adminvo.getADMIN_LEVEL() < 2 ) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "7");
			result.put("Data", Msg);
			
			return result;
		}
		//ajax 받은 값
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		String DELETE_REASON = map.get("DELETE_REASON"); //사유
		
		mvo.setMEMBER_NUM(MEMBER_NUM);
		
		//거래중 체크하기
		int remain_chk = sqlSession.selectOne("wallet.getOrderChk", mvo);
		
		if ( remain_chk > 0 ) {
			String Msg = "거래 중인 금액이 남아있습니다. ";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			
			return result;
		}
		
		//출금 대기중 체크하기
		int withdraw_chk = sqlSession.selectOne("wallet.getWithdrawChk", mvo);
		
		if ( withdraw_chk > 0 ) {
			String Msg = "출금 대기중인 코인이 있습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			
			return result;
		
		}
		
		//지갑 잔액 체크하기
		int balance_chk = sqlSession.selectOne("wallet.getBalanceChk", mvo);
		
		if ( balance_chk > 0 ) {
			String Msg = "잔액이 남아있습니다.";
			
			result.put("ResultCode", "3");
			result.put("Data", Msg);
			
			return result;
			
		}

		// MEMBER_USE = N, LOGIN_DATE = 현재시각 UPDATE
		int delete_result = sqlSession.update("admin.setDeleteMember", mvo);
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
        java.util.Date date = calendar.getTime();
        String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
        
        //주소 가져오기
        String REQEUST_PAGE = request.getRequestURI();
        String EMAIL = adminvo.getADMIN_ID();
        
        //avo 값들 셋팅
        //DB insert admin
        ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
        ahvo.setREQUEST_PAGE(REQEUST_PAGE);
        ahvo.setADMIN_ACCOUNT(EMAIL);
        ahvo.setEXECUTE_DATE(today);
        
		if ( delete_result > 0 ) {
			
			ahvo.setEXECUTE_KIND("UPDATE");
            ahvo.setADMIN_DESC("UPDATE MEMBER_DELETE SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
            
			logger.info("UPDATE MEMBER_DELETE SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
			
			//회원 정보 가져오기
			mvo = sqlSession.selectOne("login.getMemberInfo", mvo);
			
			//메일 보내기		
			Mail mail = new Mail(mailSend);
			mail.delete_member(mvo);
			
			String Msg = "회원탈퇴가 완료되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			
			return result;
		} else {
			
			ahvo.setEXECUTE_KIND("UPDATE_FAIL");
            ahvo.setADMIN_DESC("UPDATE MEMBER_DELETE FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

            sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
            
			logger.error("UPDATE MEMBER_DELETE FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
			String Msg = "회원탈퇴에 실패하였습니다. /n잠시 후 시도해주세요.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
	}
}
