package com.conco.concotrade.controller.admin;

import java.io.IOException;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.conco.concotrade.controller.HomeController;
import com.conco.concotrade.email.MailSend;
import com.conco.concotrade.util.md5;
import com.conco.concotrade.vo.loginHistroyVO;
import com.conco.concotrade.vo.loginVO;
import com.conco.concotrade.vo.memberVO;
import com.conco.concotrade.vo.registerVO;
import com.conco.concotrade.vo.userVO;
import com.conco.concotrade.vo.walletVO;
import com.conco.concotrade.vo.withdrawVO;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminVO;

import eu.bitwalker.useragentutils.UserAgent;

@Controller
public class AdminController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	private MailSend mailSend;
	
	//로그인 페이지
	@RequestMapping(value="/ADM/loginPage", method = RequestMethod.GET)
	public String admin_loginPage(HttpSession session, HttpServletResponse res) throws IOException {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {			
			return "/admin/loginPage";
		}else{
			res.sendRedirect("/ADM");
			return "/error/access";
		}
		
	}
	@RequestMapping(value = "/ADM/login_success", method = RequestMethod.GET, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> login_success(HttpSession session, HttpServletRequest request) {
		HashMap<String, String> result = new HashMap<String, String>();
		
		loginHistroyVO loginvo = new loginHistroyVO();
		userVO uservo = new userVO();
		loginVO lvo = new loginVO();
		adminVO avo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		String EMAIL = (String)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		lvo.setMEMBER_ID(EMAIL);
		avo.setADMIN_ID(EMAIL);
		
		//관리자 ROLE 체크
		HashMap<String, String> adm_role_chk = sqlSession.selectOne("admin.adm_role_chk", avo);
		
		if ( adm_role_chk  == null ) {
			String Msg = "잘못된 접근입니다.";
			
    		result.put("ResultCode", "3");
    		result.put("Data", Msg);
    		
    		return result;
		}
		
		//IP 가져오기
		String ip_result = "";
    	try {
    		ip_result = request.getHeader("X-FORWARDED-FOR");
    		
    		if (ip_result == null) {
    			ip_result = request.getRemoteAddr();
    		}
    		
    	} catch (Exception err) {
    		ip_result = "Unknown";
    	}
    	
    	//브라우저 정보 확인하기
		UserAgent userAgent = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
    	
		String user_info = (String) userAgent.toString();
		//브라우저 가져오기
		String user_browser = userAgent.getBrowser().getName() + userAgent.getBrowserVersion();
		//OS 가져오기
		String user_os = (String) userAgent.getOperatingSystem().toString();
		
		loginvo.setLOGIN_IP(ip_result);
		loginvo.setLOGIN_INFO(user_info);
		loginvo.setLOGIN_BROWSER(user_browser);
		loginvo.setLOGIN_OS(user_os);
		loginvo.setLOGIN_ID(EMAIL);
		
    	int LOGIN_TYPE = 0;
		    	
		if ( adm_role_chk.get("MEMBER_ROLE").equals("ROLE_ADMIN")) {
			System.out.println("ADMIN");
			
			
			//ADMIN_MEMBER_NUM 가져오기
			avo = sqlSession.selectOne("admin.getADMIN_INFO", avo);
			//ADMIN_MEMBER_NUM 세션 등록
			
			int ADMIN_MEMBER_NUM = avo.getADMIN_MEMBER_NUM();
			
			session.setAttribute("ADMIN_MEMBER_NUM", avo);
			
			//로그인 날짜 및 account 삽입  insert
    		Calendar calendar = Calendar.getInstance();
            java.util.Date date = calendar.getTime();
            String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
            
            //주소 가져오기
            String REQEUST_PAGE = request.getRequestURI();

            //avo 값들 셋팅
            //DB insert admin
            ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
            ahvo.setEXECUTE_KIND("INSERT");
            ahvo.setREQUEST_PAGE(REQEUST_PAGE);
            ahvo.setADMIN_ACCOUNT(EMAIL);
            ahvo.setADMIN_DESC("LOGIN_SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM);
            ahvo.setEXECUTE_DATE(today);

            int rst = sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
            
            if ( rst > 0) {
            	//로그인 Date 삽입
            	avo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
            	avo.setADMIN_LOGINDATE(today);
            	
            	sqlSession.update("admin.admin_setLoginDate", avo);
            	
            	logger.info("ADMIN LOGIN SUCCESS / ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 시각 : " + today);
            	
                LOGIN_TYPE  = 5;
    			loginvo.setLOGIN_TYPE(LOGIN_TYPE);
    			
    			sqlSession.insert("login.login_history", loginvo);
    			
    			String Msg = "ADMIN 로그인 성공";
        		result.put("ResultCode", "0");
        		result.put("Data", Msg);
    			return result;
            } else {
            	String Msg = "로그인 에러";
            	result.put("ResultCode", "2");
        		result.put("Data", Msg);
    			return result;
            }
		} else {
			
            LOGIN_TYPE  = 4;
			loginvo.setLOGIN_TYPE(LOGIN_TYPE);
			
			sqlSession.insert("login.login_history", loginvo);
			
			String Msg = "관리자 외에 접근할 수 없습니다.";
			result.put("ResultCode", "4");
    		result.put("Data", Msg);
			return result;
	}
}
	

	//LOGIN_TYPE 	
	//관리자 페이지 로그인 시도 = 4
	//로그인 성공 = 5
	//존재하지 않는 ID = 6
	//비밀번호 틀릴시 = 7
	@RequestMapping(value = "/ADM/loginPage_fail", method = RequestMethod.GET, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> login_fail(HttpSession session, HttpServletRequest request) throws JsonParseException, JsonMappingException, IOException {
		System.out.println(request.getHeader("X-Forwarded-Proto"));
		HashMap<String, String> result = new HashMap<String, String>();
		AuthenticationException e = (AuthenticationException)session.getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
		
		loginVO vo = new loginVO();
		loginHistroyVO loginvo = new loginHistroyVO();

		//json 객체 가져오기
		ObjectMapper mapper = new ObjectMapper();
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap = mapper.readValue(e.getMessage(), new TypeReference<Map<String, String>>(){});
		
		//resultMap 널 처리
		String CODE = resultMap.get("code");
		String MSG = resultMap.get("msg");
		
		//IP 가져오기
		String ip_result = "";
    	try {
    		ip_result = request.getHeader("X-FORWARDED-FOR");
    		
    		if (ip_result == null) {
    			ip_result = request.getRemoteAddr();
    		}
    		
    	} catch (Exception err) {
    		ip_result = "Unknown";
    	}
    	
    	//브라우저 정보 확인하기
		UserAgent userAgent = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
    	
		String user_info = (String) userAgent.toString();
		//브라우저 가져오기
		String user_browser = userAgent.getBrowser().getName() + userAgent.getBrowserVersion();
		//OS 가져오기
		String user_os = (String) userAgent.getOperatingSystem().toString();
		
		loginvo.setLOGIN_IP(ip_result);
		loginvo.setLOGIN_INFO(user_info);
		loginvo.setLOGIN_BROWSER(user_browser);
		loginvo.setLOGIN_OS(user_os);
		
    	int LOGIN_TYPE = 0;
		//존재하지 않는 아이디
		if(CODE.equals("1")) {
			LOGIN_TYPE  = 6;
			loginvo.setLOGIN_COUNT(0);
			loginvo.setLOGIN_TYPE(LOGIN_TYPE);

			sqlSession.insert("login.login_history", loginvo);
			
			result.put("ResultCode", "1");
			result.put("Data", MSG);
			return result;
		}
		
		//입력한 정보가 잘못되었습니다.
		if (CODE.equals("2")) {
			LOGIN_TYPE = 7;
			String COUNT = resultMap.get("count");
			String EMAIL = resultMap.get("email");
			
			loginvo.setLOGIN_ID(EMAIL);
			loginvo.setLOGIN_TYPE(LOGIN_TYPE);
			loginvo.setLOGIN_COUNT(0);
			
			sqlSession.insert("login.login_history", loginvo);

			result.put("ResultCode", "2");
			result.put("Data", MSG);
			return result;
		}
		
		//관리자 이외에 로그인
		if (CODE.equals("7")) {
			LOGIN_TYPE = 8;
			String COUNT = resultMap.get("count");
			String EMAIL = resultMap.get("email");
			
			loginvo.setLOGIN_ID(EMAIL);
			loginvo.setLOGIN_TYPE(LOGIN_TYPE);
			loginvo.setLOGIN_COUNT(0);
			
			sqlSession.insert("login.login_history", loginvo);

			result.put("ResultCode", "2");
			result.put("Data", MSG);
			return result;
		}
		return result;
	}

	
	//메인 배경
	@RequestMapping(value="/ADM/main_frame", method = RequestMethod.GET)
	public String admin_main(HttpSession session, Model model ) {
		return "/admin/main_frame";
	}

	//지갑 잔액 페이지
	@RequestMapping(value="/ADM/balance/{MEMBER_NUM}", method = RequestMethod.GET)
	public String balancePage(@PathVariable("MEMBER_NUM") int MEMBER_NUM, HttpSession session, Model model, HttpServletResponse res) throws IOException {
		
		memberVO mvo = new memberVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			res.sendRedirect("/ADM/loginPage");
			return "/admin/loginPage";
		}
		
		mvo.setMEMBER_NUM(MEMBER_NUM);
		//회원 정보 가져오기
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		
		if ( mvo == null) {
			return null;
		}
		
		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("MEMBER_NUM", MEMBER_NUM);
		
		return "/admin/balance_info";
	}
	
	//지갑 잔액 데이터테이블
	@RequestMapping(value="/ADM/balanceList/{MEMBER_NUM}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public  HashMap<String, Object> balanceList(Model model, @PathVariable("MEMBER_NUM") int MEMBER_NUM, @RequestParam HashMap<String, Object> map, HttpSession session) {
			
			walletVO wvo = new walletVO();
			
			wvo.setMEMBER_NUM(MEMBER_NUM);

			//지갑 정보 리스트 형태로 보내기
			List<walletVO> walletListVO = sqlSession.selectList("wallet.getWalletList", wvo);	
			
			if ( walletListVO == null ) {
				return null;
			}
			HashMap<String, Object> result = new HashMap<String, Object>();
			
			result.put("draw", 1);
			result.put("data", walletListVO);
			return result;
	}
	
	//지갑 주소 데이터테이블
	@RequestMapping(value="/ADM/wallet_addressList/{MEMBER_NUM}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public  HashMap<String, Object> wallet_addressList(Model model, @PathVariable("MEMBER_NUM") int MEMBER_NUM, @RequestParam HashMap<String, Object> map, HttpSession session) {
		
		walletVO wvo = new walletVO();
		
		wvo.setMEMBER_NUM(MEMBER_NUM);
		
		//지갑 정보 리스트 형태로 보내기
		List<walletVO> wallet_addrList = sqlSession.selectList("wallet.getWallet_Addr", wvo);	
		
		if ( wallet_addrList == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
	
		result.put("draw", 1);
		result.put("data", wallet_addrList);
		return result;
	}
	
	//출금정보만 데이터테이블 -> 지갑에 포함.
	@RequestMapping(value="/ADM/withdrawList/{MEMBER_NUM}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public  HashMap<String, Object> withdrawList(Model model, @PathVariable("MEMBER_NUM") int MEMBER_NUM, @RequestParam HashMap<String, Object> map, HttpSession session) {
	
		withdrawVO withvo = new withdrawVO();
		
		withvo.setMEMBER_NUM(MEMBER_NUM);

		List<withdrawVO> withdrawListVO = sqlSession.selectList("wallet.getAdmin_withdraw", withvo);	
		
		if ( withdrawListVO == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		session.removeAttribute("BALANCE_MEMBER_NUM");
		
		result.put("draw", 1);
		result.put("data", withdrawListVO);
		return result;
	}
	
	@RequestMapping(value="/ADM/pwd_chk", method = RequestMethod.GET)
	public String pwd_chk(Model model, HttpSession session) {
		
		return "/admin/pwd_chk";
	}
	
	//관리자 계정 조회
	@RequestMapping(value="/ADM/admin", method=RequestMethod.GET )
	public String admin(@RequestParam HashMap<String, String>map, Model model, HttpSession session) {
	
		adminVO adminvo = new adminVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		model.addAttribute("ADMIN_LEVEL", adminvo.getADMIN_LEVEL());
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/admin_account/admin_info";
		}else{
			model.addAttribute("pageParam", "/ADM/admin");
			return "/admin/main_frame";			 
		}	
	}
	
	//관리자 계정 데이터
	@RequestMapping(value = "/ADM/adminInfo", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> adminInfo(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
	
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<adminVO> AdminList = sqlSession.selectList("admin.getAdminList");
		
		result.put("draw", 1);
		result.put("data", AdminList);
		
		return result;
	}
	
	//관리자 수정
	@RequestMapping(value="/ADM/admin_revise", method=RequestMethod.GET )
	public String admin_revise(@RequestParam HashMap<String, String>map, Model model, HttpSession session) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/admin_account/admin_revise";
		}else{
			model.addAttribute("pageParam", "/ADM/admin_revise");
			return "/admin/main_frame";			 
		}	
	}
	
	//권한 변경 페이지
	@RequestMapping(value="/ADM/change_level", method=RequestMethod.GET)
	public String change_level(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		return "/admin/admin_account/change_level";
	}
	
	//권한 변경 프로세스
	@RequestMapping(value="/ADM/change_level_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> change_level_process(HttpSession session, @RequestParam HashMap<String, String>map, HttpServletRequest request) throws UnknownHostException {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();

		//ajax 받은 값
		int TARGET_ADMIN_MEMBER_NUM = Integer.parseInt(map.get("ADMIN_MEMBER_NUM"));
		int CHANGE_ADMIN_LEVEL = Integer.parseInt(map.get("ADMIN_LEVEL"));
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		String ADMIN_ID = adminvo.getADMIN_ID();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		//권한 체크
		if ( adminvo.getADMIN_LEVEL() < 3) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		//설정 변경 START
		adminvo = sqlSession.selectOne("admin.getAdminInfo", TARGET_ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "5");
			result.put("Data", Msg);
			return result;
		}
		
		//회원 탈퇴 체크
		if ( adminvo.getADMIN_USE() == "N") {
			String Msg = "회원탈퇴된 계정입니다.";
			
			result.put("ResultCode", "6");
			result.put("Data", Msg);
			return result;
		}
		
		//관리권한이 같을 시
		if ( adminvo.getADMIN_LEVEL() == CHANGE_ADMIN_LEVEL ) {
			String Msg = "현재 관리권한이 " + CHANGE_ADMIN_LEVEL + " 입니다.";
			
			result.put("ResultCode", "8");
			result.put("Data", Msg);
			
			return result;
		}
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		
		//주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		
		//avo 값들 셋팅
		//DB insert admin
		ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(ADMIN_ID);
		ahvo.setEXECUTE_DATE(today);
		
		adminvo.setADMIN_LEVEL(CHANGE_ADMIN_LEVEL);
		
		int level_rst = sqlSession.update("admin.setAdminLevel", adminvo);
		if ( level_rst > 0 ) {
			
			ahvo.setEXECUTE_KIND("UPDATE");
			ahvo.setADMIN_DESC("UPDATE ADMIN LEVEL SUCCESS // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경된 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // LEVEL : " +CHANGE_ADMIN_LEVEL+ " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("UPDATE ADMIN LEVEL SUCCESS // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경된 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // LEVEL : " +CHANGE_ADMIN_LEVEL+ " // 시각 : " + today);
			
			String Msg = "관리권한 변경이 완료되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			
			return result;
		} else {
			
			ahvo.setEXECUTE_KIND("UPDATE_FAIL");
			ahvo.setADMIN_DESC("UPDATE ADMIN LEVEL FAIL // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경할 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.error("UPDATE ADMIN LEVEL FAIL // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경할 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			String Msg = "관리권한 변경이 실패하였습니다.";
			
			result.put("ResultCode", "7");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//비밀번호 변경 페이지
	@RequestMapping(value="/ADM/change_password", method=RequestMethod.GET)
	public String change_password(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		return "/admin/admin_account/change_password";
	}
	
	//관리자 비밀번호 변경 프로세스
	@RequestMapping(value="/ADM/change_password_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> change_password_process(HttpSession session, @RequestParam HashMap<String, String>map, HttpServletRequest request) throws UnknownHostException {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();

		//ajax 받은 값
		int TARGET_ADMIN_MEMBER_NUM = Integer.parseInt(map.get("ADMIN_MEMBER_NUM"));
		String CHANGE_ADMIN_PASSWORD = map.get("CHANGE_PASSWORD"); //변경할 비밀번호
		String CUR_ADMIN_PASSWORD = map.get("CUR_PASSWORD"); //현재 비밀번호
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		String ADMIN_ID = adminvo.getADMIN_ID();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "관리자 비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		//권한 체크
		if ( adminvo.getADMIN_LEVEL() < 3) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		//비밀번호 변경 START
		adminvo = sqlSession.selectOne("admin.getAdminInfo", TARGET_ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "5");
			result.put("Data", Msg);
			return result;
		}
		
		//회원 탈퇴 체크
		if ( adminvo.getADMIN_USE() == "N") {
			String Msg = "회원탈퇴된 계정입니다.";
			
			result.put("ResultCode", "6");
			result.put("Data", Msg);
			return result;
		}
		
		//현재 비밀번호 체크
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(CUR_ADMIN_PASSWORD))) {
			String Msg="현재 비밀번호가 다릅니다.";
			
			result.put("ResultCode", "9");
			result.put("Data", Msg);
			return result;
		}
		
		//비밀번호가 전에와 같을 시
		if ( adminvo.getADMIN_PASS().equals(md5.testMD5(CHANGE_ADMIN_PASSWORD))) {
			String Msg = "현재 비밀번호와 변경하실 비밀번호가 같습니다.";
			
			result.put("ResultCode", "8");
			result.put("Data", Msg);
			
			return result;
		}
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		
		//주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		
		//avo 값들 셋팅
		//DB insert admin
		ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(ADMIN_ID);
		ahvo.setEXECUTE_DATE(today);
		
		adminvo.setADMIN_PASS(CHANGE_ADMIN_PASSWORD);
		int rst = sqlSession.update("admin.setAdminPass", adminvo);
		if ( rst > 0 ) {
			ahvo.setEXECUTE_KIND("UPDATE");
			ahvo.setADMIN_DESC("CHANGE ADMIN PASSWORD SUCCESS // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경된 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("CHANGE ADMIN PASSWORD SUCCESS // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경된 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			String Msg = "비밀번호 변경이 완료되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			
			return result;
		} else {
			
			ahvo.setEXECUTE_KIND("UPDATE_FAIL");
			ahvo.setADMIN_DESC("CHANGE ADMIN PASSWORD FAIL // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경할 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.error("CHANGE ADMIN PASSWORD FAIL // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 변경할 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			String Msg = "비밀번호 변경이 실패하였습니다.";
			
			result.put("ResultCode", "7");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//관리자 회원탈퇴 페이지
	@RequestMapping(value="/ADM/delete_admin", method=RequestMethod.GET)
	public String delete_admin(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		return "/admin/admin_account/delete_admin";
	}
	
	//관리자 회원탈퇴 프로세스
	@RequestMapping(value="/ADM/delete_admin_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> delete_admin_process(HttpSession session, @RequestParam HashMap<String, String>map, HttpServletRequest request) throws UnknownHostException {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();

		//ajax 받은 값
		int TARGET_ADMIN_MEMBER_NUM = Integer.parseInt(map.get("ADMIN_MEMBER_NUM"));
		String DELETE_REASON = map.get("DELETE_REASON");
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		String ADMIN_ID = adminvo.getADMIN_ID();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		//권한 체크
		if ( adminvo.getADMIN_LEVEL() < 3) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		//회원탈퇴 START
		adminvo = sqlSession.selectOne("admin.getAdminInfo", TARGET_ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "5");
			result.put("Data", Msg);
			return result;
		}
		
		//회원 탈퇴 체크
		if ( adminvo.getADMIN_USE() == "N") {
			String Msg = "회원탈퇴된 계정입니다.";
			
			result.put("ResultCode", "6");
			result.put("Data", Msg);
			return result;
		}
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		
		//주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		
		//avo 값들 셋팅
		//DB insert admin
		ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(ADMIN_ID);
		ahvo.setEXECUTE_DATE(today);
		ahvo.setEXECUTE_REASON(DELETE_REASON); //사유
		
		int delete_rst = sqlSession.update("admin.setAdminDelete", adminvo);
		if ( delete_rst > 0 ) {
			
			ahvo.setEXECUTE_KIND("UPDATE");
			ahvo.setADMIN_DESC("UPDATE ADMIN DELETE SUCCESS // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 탈퇴된 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("UPDATE ADMIN DELETE SUCCESS // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 탈퇴된 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			String Msg = "회원탈퇴가 완료되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			
			return result;
		} else {
			
			ahvo.setEXECUTE_KIND("UPDATE_FAIL");
			ahvo.setADMIN_DESC("UPDATE ADMIN DELETE FAIL // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 탈퇴할 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.error("UPDATE ADMIN DELETE FAIL // 실행한 관리자 : " + ADMIN_MEMBER_NUM + " // 탈퇴할 관리자 : " + TARGET_ADMIN_MEMBER_NUM + " // 시각 : " + today);
			
			String Msg = "회원탈퇴가 실패하였습니다.";
			
			result.put("ResultCode", "7");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//관리자 회원 등록
	@RequestMapping(value="/ADM/add_admin", method=RequestMethod.GET)
	public String add_admin(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		return "/admin/admin_account/add_admin";
	}
	
	//관리자 회원 등록 프로세스
	@RequestMapping(value="/ADM/add_amin_process", method=RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> add_admin_process(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		return result;
	}
	
	//관리자 아이디 중복 확인
	@RequestMapping(value="/ADM/id_chk_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> id_chk_process(HttpSession session, @RequestParam HashMap<String, String> map ) {
		
		adminVO adminvo = new adminVO();
		registerVO rvo = new registerVO();
		
		String ADMIN_ID = map.get("ADMIN_ID");
		
		HashMap<String, String> result = new HashMap<String, String>();

		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg="잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","2");
			result.put("Data", Msg);
			return result;
		}
		
		//권한 체크
		if ( adminvo.getADMIN_LEVEL() < 3) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "3");
			result.put("Data", Msg);
			return result;
		}
		
		//중복 체크 START
		adminvo.setADMIN_ID(ADMIN_ID);
		rvo.setMEMBER_ID(ADMIN_ID);
		//MEMBER테이블에서 조회
		//ADMIN_MEMBER 에서 조회 
		int member_rst = sqlSession.selectOne("register.chk_email", rvo);
		int admin_rst = sqlSession.selectOne("admin.chk_email", adminvo);
		
		if ( member_rst > 0 || admin_rst > 0 ) {
			String Msg = "이미 사용중인 아이디입니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		} else {
			//없을 시 통과
			
			String Msg="사용 가능한 아이디 입니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//관리자 정보 수정 페이지
	@RequestMapping(value="/ADM/change_adminInfo/{ADMIN_MEMBER_NUM}", method=RequestMethod.GET)
	public String change_adminInfo(@PathVariable("ADMIN_MEMBER_NUM") int TARGET_ADMIN_MEMBER_NUM, HttpSession session, Model model) {
	
		adminVO adminvo = new adminVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		//관리자 정보 가져오기
		adminvo.setADMIN_MEMBER_NUM(TARGET_ADMIN_MEMBER_NUM);
		
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null) {
			return null;
		}
		
		model.addAttribute("TARGER_ADMIN_MEMBER_NUM", adminvo.getADMIN_MEMBER_NUM());
		model.addAttribute("ADMIN_ID", adminvo.getADMIN_ID());
		model.addAttribute("ADMIN_NAME", adminvo.getADMIN_NAME());
		model.addAttribute("ADMIN_LEVEL", adminvo.getADMIN_LEVEL());
		
		return "/admin/admin_account/change_adminInfo";
	}
	
	//관리자 정보 수정 프로세스
	@RequestMapping(value="/ADM/change_adminInfo_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> change_adminInfo_process(HttpSession session, @RequestParam HashMap<String, String>map ) {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();

		//ajax 받은 값
		int TARGET_ADMIN_MEMBER_NUM = Integer.parseInt(map.get("ADMIN_MEMBER_NUM"));
		int ADMIN_LEVEL = Integer.parseInt(map.get("ADMIN_LEVEL"));
		String CHANGE_PASS = map.get("CHANGE_PASSWORD");
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		System.out.println(CHANGE_PASS);
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		String ADMIN_ID = adminvo.getADMIN_ID();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "관리자 비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 3) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo.setADMIN_MEMBER_NUM(TARGET_ADMIN_MEMBER_NUM); //변경될 사용자
		adminvo.setADMIN_LEVEL(ADMIN_LEVEL); //관리권한 
		//수정 START
		//레벨만 수정시
		if (CHANGE_PASS.equals("")) { 
			int rst = sqlSession.update("admin.setAdminLevel", adminvo);
			
			if ( rst > 0 ) {
				String Msg="관리자 정보 수정이 완료되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				return result;
			} else {
				String Msg="관리자 정보 수정 실패하였습니다.";
				
				result.put("ResultCode", "5");
				result.put("Data", Msg);
				return result;
			}
		} else {
			//비밀번호 , 레벨 수정시
			adminvo.setADMIN_PASS(CHANGE_PASS); //비밀번호 
			int rst = sqlSession.update("admin.setAdminPass", adminvo);
			
			if ( rst > 0 ) {
				String Msg="수정이 완료되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				return result;
			} else {
				String Msg="관리자 정보 수정 실패하였습니다.";
				
				result.put("ResultCode", "5");
				result.put("Data", Msg);
				return result;
			}
		}
	}
	
	//관리자 추가 프로세스
	@RequestMapping(value="/ADM/insert_admin_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> insert_admin_process(HttpSession session, @RequestParam HashMap<String, String>map, HttpServletRequest request ) {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		registerVO rvo = new registerVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		//ajax 받은 값
		String TARGET_ADMIN_ID = map.get("TARGET_ADMIN_ID");
		String TARGET_ADMIN_NAME = map.get("TARGET_ADMIN_NAME");
		String TARGET_ADMIN_PASSWORD = map.get("TARGET_ADMIN_PASSWORD");
		String TARGET_ADMIN_PASSWORD_CHK = map.get("TARGET_ADMIN_PASSWORD_CHK");
		int TARGET_ADMIN_LEVEL = Integer.parseInt(map.get("TARGET_ADMIN_LEVEL"));
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "관리자 비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 3) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		//아이디 중복 체크
		String ADMIN_ID = adminvo.getADMIN_ID();
		adminvo.setADMIN_ID(TARGET_ADMIN_ID);
		rvo.setMEMBER_ID(TARGET_ADMIN_ID);
		//MEMBER테이블에서 조회
		//ADMIN_MEMBER 에서 조회 
		int member_rst = sqlSession.selectOne("register.chk_email", rvo);
		int admin_rst = sqlSession.selectOne("admin.chk_email", adminvo);
		
		if ( member_rst > 0 || admin_rst > 0 ) {
			String Msg = "이미 사용중인 아이디입니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			return result;
		}
		
		//비밀번호 같은지 체크
		if ( !TARGET_ADMIN_PASSWORD.equals(TARGET_ADMIN_PASSWORD_CHK)) {
			String Msg = "비밀번호와 비밀번호 확인이 일치하지 않습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			return result;
		}
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		
		//주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		
		//======== insert Start
		adminvo.setADMIN_ID(TARGET_ADMIN_ID);
		adminvo.setADMIN_NAME(TARGET_ADMIN_NAME);
		adminvo.setADMIN_PASS(TARGET_ADMIN_PASSWORD);
		adminvo.setADMIN_LEVEL(TARGET_ADMIN_LEVEL);
		
		ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(ADMIN_ID);
		ahvo.setEXECUTE_DATE(today);
		
		int add_admin_rst = sqlSession.insert("admin.insertAdmin", adminvo);
		
		if ( add_admin_rst > 0 ) {
			ahvo.setEXECUTE_KIND("INSERT");
			ahvo.setADMIN_DESC("INSERT ADMIN SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // TARGET_ADMIN_MEMBER_ID : " + adminvo.getADMIN_ID() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("INSERT ADMIN SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // TARGET_ADMIN_MEMBER_ID : " + adminvo.getADMIN_ID() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			String Msg = "관리자 등록이 완료되었습니다.";
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
		} else {
			ahvo.setEXECUTE_KIND("INSERT_FAIL");
			ahvo.setADMIN_DESC("INSERT ADMIN FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " TARGET_ADMIN_MEMBER_ID : " + adminvo.getADMIN_ID() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("INSERT ADMIN FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // TARGET_ADMIN_MEMBER_ID : " + adminvo.getADMIN_ID() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			String Msg = "관리자 등록이 실패하였습니다.";
			result.put("ResultCode", "5");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//권한체크
	//TYPE = 1 -> 레벨 2이상만 접속가능
	//TYPE = 2 -> 레벨 3이상만 접속가능
	@RequestMapping(value="/ADM/level_chk/{TYPE}", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> level_chk(@PathVariable("TYPE") String TYPE, HttpSession session, @RequestParam HashMap<String, String>map) { 
	
		adminVO adminvo = new adminVO();

		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","1");
			result.put("Data", Msg);
			return result;
		}
		
		//레벨이 1.5 이상인 사람만 접속가능
				if (TYPE.equals("10")) {
					System.out.println(adminvo.getADMIN_LEVEL());
					if ( adminvo.getADMIN_LEVEL() < 1.5) {
						String Msg = "권한이 없습니다.";
			
						result.put("ResultCode", "2");
						result.put("Data", Msg);
						return result;
					}
//					glasofk rlatmdgk!
				
					result.put("ResultCode", "0");
					return result;
				}
	
		//레벨이 2 이상인 사람만 접속가능
		if (TYPE.equals("1")) {
			if ( adminvo.getADMIN_LEVEL() < 2) {
				String Msg = "권한이 없습니다.";
				
				result.put("ResultCode", "2");
				result.put("Data", Msg);
				return result;
			}
//			glasofk rlatmdgk!
			
			result.put("ResultCode", "0");
			return result;
		}
		
		//레벨이 3인사람만 접속가능
		if (TYPE.equals("2")) {
			if ( adminvo.getADMIN_LEVEL() < 3) {
				String Msg = "권한이 없습니다.";
				
				result.put("ResultCode", "2");
				result.put("Data", Msg);
				return result;
			}
			
			result.put("ResultCode", "0");
			return result;
		}
		
		return result;
	}
	
	//이용내역 페이지
	@RequestMapping(value="/ADM/admin_history",  method=RequestMethod.GET)
	public String admin_history (HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		adminVO adminvo = new adminVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/admin_account/admin_history";
		}else{
			model.addAttribute("pageParam", "/ADM/admin_history");
			return "/admin/main_frame";			 
		}	
	}
	
	//이용내역 리스트
	@RequestMapping(value="/ADM/adminHistory_data",  method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> adminHistory_data(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<adminVO> AdminHistory = sqlSession.selectList("admin.getAdminHistory");
		
		result.put("draw", 1);
		result.put("data", AdminHistory);
		
		return result;
	}
	
	//로그인 내역
	@RequestMapping(value="/ADM/login_history", method=RequestMethod.GET)
	public String loginHistory (HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		adminVO adminvo = new adminVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/admin_account/login_history";
		}else{
			model.addAttribute("pageParam", "/ADM/login_history");
			return "/admin/main_frame";			 
		}	
	}
	
	//로그인 내역 리스트
	@RequestMapping(value="/ADM/loginHistory_data",  method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> loginHistory_data(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<adminVO> LoginHistory = sqlSession.selectList("admin.getLoginHistory");
		
		result.put("draw", 1);
		result.put("data", LoginHistory);
		
		return result;
	}
	
	
}
