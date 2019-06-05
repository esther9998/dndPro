package com.conco.concotrade.controller.admin;

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
import com.conco.concotrade.util.Order;
import com.conco.concotrade.util.md5;
import com.conco.concotrade.vo.marketVO;
import com.conco.concotrade.vo.memberVO;
import com.conco.concotrade.vo.orderVO;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminOrderVO;
import com.conco.concotrade.vo.admin.adminVO;

@Controller
public class AdminOrderController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	private MailSend mailSend;
	
	//주문내역 페이지
	@RequestMapping(value="/ADM/OrderList", method = RequestMethod.GET)
	public String OrderList(HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/order_list/orderList";
		}else{
			model.addAttribute("pageParam", "/ADM/OrderList");
			return "/admin/main_frame";			 
		}
	}
	
	//주문내역 데이터
	@RequestMapping(value="/ADM/OrderList_data", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> OrderList_data (HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		List<adminOrderVO> OrderList = sqlSession.selectList("order.Admin_getOrderList");	
		
		if ( OrderList == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		result.put("draw", 1);
		result.put("data", OrderList);
		return result;
	}
	
	//주문취소 페이지
	@RequestMapping(value="/ADM/OrderCancel/{ORDER_NUM}/{BASE}/{TARGET}")
	public String OrderCancel (@PathVariable("BASE") String BASE, @PathVariable("TARGET") String TARGET, @PathVariable("ORDER_NUM") int ORDER_NUM, HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		
		orderVO ovo = new orderVO();
		memberVO mvo = new memberVO();
		
		//관리자 체크
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		//ORDER 정보
		ovo.setORDER_NUM(ORDER_NUM);
		ovo = sqlSession.selectOne("order.getOrderInfo", ovo);

		//멤버 정보 가져
		mvo.setMEMBER_NUM(ovo.getMEMBER_NUM());
		
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		if ( mvo == null ) {
			return null;
		}
		
		//정보들 페이지로 보내기
		model.addAttribute("MEMBER_NUM", mvo.getMEMBER_NUM());
		model.addAttribute("MEMBER_ID", mvo.getMEMBER_ID());
		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("ORDER_NUM", ORDER_NUM);
		model.addAttribute("BASE", BASE);
		model.addAttribute("TARGET", TARGET);
		model.addAttribute("ORDER_KIND", ovo.getORDER_KIND());
		model.addAttribute("ORDER_AMOUNT", ovo.getORDER_AMOUNT());
		model.addAttribute("ORDER_REMAIN", ovo.getORDER_REMAIN());
		model.addAttribute("ORDER_PRICE", ovo.getORDER_PRICE());
		model.addAttribute("ORDER_DATE", ovo.getORDER_DATE());
		
		return "/admin/order_list/orderCancel";
	}
	
	//주문 취소 프로세스
	@RequestMapping(value="/ADM/OrderCancel_Process")
	@ResponseBody
	public HashMap<String, String> ordercancel_process(HttpSession session, @RequestParam HashMap<String, String>map, HttpServletRequest request) {
		marketVO marketvo = new marketVO();
		memberVO mvo = new memberVO();
		adminVO adminvo = new adminVO();
		orderVO ovo = new orderVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		String BASE = map.get("BASE"); //BASE
		String TARGET = map.get("TARGET"); //TARGET
		String ORDER_NUM = map.get("ORDER_NUM"); //ORDER_NUM
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM")); //MEMBER_NUM
		String CANCEL_REASON = map.get("CANCEL_REASON"); //사유
		String ADMIN_PASS = map.get("ADMIN_PASSWORD"); //비밀번호
		String EMAIL_SEND = map.get("EMAIL_SEND"); //confrim;
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg="잘못된 접근입니다.";
			
			result.put("ResultCode", "100");
			result.put("Data", Msg);
			return result;
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		//관리자 비밀번호
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if ( adminvo == null ) {
			String Msg ="잘못된 접근입니다.";
			
			result.put("ResultCode", "9");
			result.put("Data", Msg);
			
			return result;
		}
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			
			return result;
		}
		
		//관리자 레벨 체크
		if ( adminvo.getADMIN_LEVEL() < 2 ) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "3");
			result.put("Data", Msg);
			
			return result;
		}
		
		//MARKET_NUM 가져오기
		marketvo.setBASE_COIN_UNIT(BASE);
		marketvo.setTARGET_COIN_UNIT(TARGET);
		marketvo = sqlSession.selectOne("market.getMarketNum", marketvo);
		
		if ( marketvo == null ) {
			String Msg="잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}

		//MEMBER INFO 가져오기
		mvo.setMEMBER_NUM(MEMBER_NUM);
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		
		if ( mvo == null ) {
			String Msg="잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		//ORDER_NUM 정규식 체크
		String reg = "^\\d*$";
		if(ORDER_NUM==null||!(ORDER_NUM.matches(reg))){
			//error
			String Msg="잘못된 접근입니다.";
			
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			return result;
		}
		
		//ORDER CANCEL 실행
		Order order = new Order(sqlSession);
		ovo.setORDER_NUM(Integer.parseInt(ORDER_NUM));
		ovo.setMARKET_NUM(marketvo.getMARKET_NUM());
		ovo.setMEMBER_NUM(MEMBER_NUM);
		
		int order_result = order.AdminOrderCancel(ovo, CANCEL_REASON);
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
        java.util.Date date = calendar.getTime();
        String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
        
        //주소 가져오기
        String REQEUST_PAGE = request.getRequestURI();
        String EMAIL = adminvo.getADMIN_ID();

		ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
        ahvo.setREQUEST_PAGE(REQEUST_PAGE);
        ahvo.setADMIN_ACCOUNT(EMAIL);
        ahvo.setEXECUTE_DATE(today);
        ahvo.setEXECUTE_REASON(CANCEL_REASON);
        
		if ( order_result >= 0 ) { //성공
		    ahvo.setEXECUTE_KIND("UPDATE");
	        ahvo.setADMIN_DESC("ORDER_CANCEL_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // ORDER_NUM : " + ORDER_NUM + " // MARKET_NUM : " + marketvo.getMARKET_NUM() + " // 시각 : " + today);
	        
	        sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
	        
			logger.info("ORDER_CANCEL_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // ORDER_NUM : " + ORDER_NUM + " // MARKET_NUM : " + marketvo.getMARKET_NUM() + " // 시각 : " + today);
			
			if ( EMAIL_SEND.equals("true")) {
				ovo = sqlSession.selectOne("order.getOrderInfo", ovo);
				marketvo.setMARKET_NAME(BASE+ " / " +TARGET);
				ovo.setBASE_COIN_UNIT(BASE);
				ovo.setTARGET_COIN_UNIT(TARGET);
				
				Mail mail = new Mail(mailSend);
				mail.Order_Cancel_Admin(ovo, mvo, marketvo);
			} 
			
			String Msg="거래가 취소되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
			
		} else if ( order_result == -1 ) {
			ahvo.setEXECUTE_KIND("UPDATE_FAIL");
			ahvo.setADMIN_DESC("ORDER_CANCEL_FAIL -- 잘못된 요청 // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // ORDER_NUM : " + ORDER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.error("ORDER_CANCEL_FAIL -- 잘못된 요청 // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // ORDER_NUM : " + ORDER_NUM + " // 시각 : " + today);
			
			String Msg="잘못된 요청입니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			return result;
			
		} else {
			ahvo.setEXECUTE_KIND("UPDATE_FAIL");
			ahvo.setADMIN_DESC("ORDER_CANCEL_FAIL -- 실패  // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // ORDER_NUM : " + ORDER_NUM + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.error("ORDER_CANCEL_FAIL -- 실패 // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // ORDER_NUM : " + ORDER_NUM + " // 시각 : " + today);
			
			String Msg="오류가 발생하였습니다. \\n주문취소에 실패하였습니다.";
			
			result.put("ResultCode", "5");
			result.put("Data", Msg);
			return result;
		}
	}
}
