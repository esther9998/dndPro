package com.conco.concotrade.controller.admin;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.conco.concotrade.util.md5;
import com.conco.concotrade.vo.coinVO;
import com.conco.concotrade.vo.marketVO;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminVO;

@Controller
public class AdminMarketController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value = "/ADM/market", method = RequestMethod.GET)
	public String admin_market(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/market_admin/market_admin";
		}else{
			model.addAttribute("pageParam", "/ADM/market");
			return "/admin/main_frame";			 
		}	 
	}
	
	//코인리스트 data
	@RequestMapping(value ="/ADM/marketInfo", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> coinInfo(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<marketVO> CoinList = sqlSession.selectList("market.getAdminMarketList");
		
		result.put("draw", 1);
		result.put("data", CoinList);
		
		return result;
	}
	
	//Market Insert
	@RequestMapping(value ="/ADM/market_insert", method = RequestMethod.GET)
	public String market_insert (HttpSession session, @RequestParam HashMap<String, String>map, Model model) {
		
		marketVO mvo = new marketVO();
		
		List<coinVO> cvo = sqlSession.selectList("coin.getAdminCoinList");
		
		//리스트에 어레이넣어서 어레이 처리.
		List<String[]> COIN_INFO = new ArrayList<String[]>();
		
		for ( int i=0; i<cvo.size(); i++) {
			String[] coin = new String[2];
			coin[0] = Integer.toString(cvo.get(i).getCOIN_NUM());
			coin[1] = cvo.get(i).getCOIN_UNIT();
			COIN_INFO.add(coin);
		}
		
		model.addAttribute("COIN_INFO", COIN_INFO);
		
		return "/admin/market_admin/market_insert";
	}
	
	//market_insert_process
	@RequestMapping(value = "/ADM/market_insert_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> market_insert_process(HttpSession session, @RequestParam HashMap<String, String>map, Model model, HttpServletRequest request) {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		marketVO mvo = new marketVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		if ( map.get("MARKET_PRIORITY") == "") {
			String Msg = "우선 순위를 입력해주세요.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		int BASE_COIN_NUM = Integer.parseInt(map.get("BASE_COIN_NUM"));
		int TARGET_COIN_NUM = Integer.parseInt(map.get("TARGET_COIN_NUM"));
		String BASE_COIN_UNIT = map.get("BASE_COIN_UNIT");
		String TARGET_COIN_UNIT = map.get("TARGET_COIN_UNIT");
		String MARKET_KIND = map.get("MARKET_KIND");
		String MARKET_MINAMOUNT = map.get("MARKET_MINAMOUNT");
		String MARKET_LOWERPRICE = map.get("MARKET_LOWERPRICE");
		String MARKET_UPPERPRICE = map.get("MARKET_UPPERPRICE");
		String MARKET_USE = map.get("MARKET_USE");
		String MARKET_FEE = map.get("MARKET_FEE");
		int MARKET_PRIORITY = Integer.parseInt(map.get("MARKET_PRIORITY"));
		String ADMIN_PASS = map.get("ADMIN_PASS");
		
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","1");
			result.put("Data", Msg);
			return result;
		}
		
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","1");
			result.put("Data", Msg);
			return result;
		}
		
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "관리자 비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 2) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		
		//주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String ADMIN_ID = adminvo.getADMIN_ID();

		//==== 관리자 히스토리 셋팅
		ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(ADMIN_ID);
		ahvo.setEXECUTE_DATE(today);
		
		//MARKET INSERT START
		mvo.setBASE_COIN_NUM(BASE_COIN_NUM);
		mvo.setTARGET_COIN_NUM(TARGET_COIN_NUM);
		mvo.setMARKET_KIND(MARKET_KIND);
		mvo.setMARKET_MINAMOUNT(MARKET_MINAMOUNT);
		mvo.setMARKET_LOWERPRICE(MARKET_LOWERPRICE);
		mvo.setMARKET_UPPERPRICE(MARKET_UPPERPRICE);
		mvo.setMARKET_USE(MARKET_USE);
		mvo.setMARKET_FEE(MARKET_FEE);
		mvo.setMARKET_PRIORITY(MARKET_PRIORITY);
		
		int insert_result = sqlSession.insert("market.insertMarketInfo", mvo);
		
		if ( insert_result > 0 ) {
			ahvo.setEXECUTE_KIND("INSERT");
			ahvo.setADMIN_DESC("INSERT MARKET SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + TARGET_COIN_UNIT + " / " + BASE_COIN_UNIT + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("INSERT MARKET SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + TARGET_COIN_UNIT + " / " + BASE_COIN_UNIT + " // 시각 : " + today);

			String Msg = TARGET_COIN_UNIT + " / " + BASE_COIN_UNIT + " 마켓이 등록되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
		} else {
			ahvo.setEXECUTE_KIND("INSERT_FAIL");
			ahvo.setADMIN_DESC("INSERT MARKET FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + TARGET_COIN_UNIT + " / " + BASE_COIN_UNIT + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("INSERT MARKET FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + TARGET_COIN_UNIT + " / " + BASE_COIN_UNIT + " // 시각 : " + today);
			
			String Msg = "마켓 등록에 실패하였습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//market_revise
	@RequestMapping(value = "/ADM/market_revise/{MARKET_NUM}", method=RequestMethod.GET)
	public String market_revise(@PathVariable("MARKET_NUM") int MARKET_NUM, HttpSession session, @RequestParam HashMap<String, String>map, Model model) { 
		
		adminVO adminvo = new adminVO();
		marketVO mvo = new marketVO();
		
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		if ( adminvo == null ) {
			return "/admin/loginPage";
		}
		
		//coin_num 으로 조회 
		mvo.setMARKET_NUM(MARKET_NUM);
		
		mvo = sqlSession.selectOne("market.getMarketUnit", mvo);
		
		if ( mvo == null ) {
			return "/admin/loginPage";
		}
		
		//model 전송
		model.addAttribute("MARKET_NUM", mvo.getMARKET_NUM());
		model.addAttribute("MARKET_NAME", mvo.getTARGET_COIN_UNIT() + " / " + mvo.getBASE_COIN_UNIT());
		model.addAttribute("BASE_COIN_NUM", mvo.getBASE_COIN_NUM());
		model.addAttribute("TARGET_COIN_NUM", mvo.getTARGET_COIN_NUM());
		model.addAttribute("BASE_COIN_UNIT", mvo.getBASE_COIN_UNIT());
		model.addAttribute("TARGET_COIN_UNIT", mvo.getTARGET_COIN_UNIT());
		model.addAttribute("MARKET_KIND", mvo.getMARKET_KIND());
		model.addAttribute("MARKET_MINAMOUNT", mvo.getMARKET_MINAMOUNT());
		model.addAttribute("MARKET_LOWERPRICE", mvo.getMARKET_LOWERPRICE());
		model.addAttribute("MARKET_UPPERPRICE", mvo.getMARKET_UPPERPRICE());
		model.addAttribute("MARKET_USE", mvo.getMARKET_USE());
		model.addAttribute("MARKET_FEE", mvo.getMARKET_FEE());
		model.addAttribute("MARKET_PRIORITY", mvo.getMARKET_PRIORITY());
		
		return "/admin/market_admin/market_revise";
	}
	
	//market_revise_process
	@RequestMapping(value = "/ADM/market_revise_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> market_revise_process(HttpSession session, @RequestParam HashMap<String, String>map, Model model, HttpServletRequest request) {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		marketVO mvo = new marketVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		System.out.println(map.get("MARKET_PRIORITY"));
		if ( map.get("COIN_MINCONFIRM") == "" ) {
			String Msg = "우선 순위를 입력해주세요.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		int MARKET_NUM = Integer.parseInt(map.get("MARKET_NUM"));
		String MARKET_NAME = map.get("MARKET_NAME");
		int BASE_COIN_NUM = Integer.parseInt(map.get("BASE_COIN_NUM"));
		int TARGET_COIN_NUM = Integer.parseInt(map.get("TARGET_COIN_NUM"));
		String MARKET_KIND = map.get("MARKET_KIND");
		String MARKET_MINAMOUNT = map.get("MARKET_MINAMOUNT");
		String MARKET_LOWERPRICE = map.get("MARKET_LOWERPRICE");
		String MARKET_UPPERPRICE = map.get("MARKET_UPPERPRICE");
		String MARKET_USE = map.get("MARKET_USE");
		String MARKET_FEE = map.get("MARKET_FEE");
		int MARKET_PRIORITY = Integer.parseInt(map.get("MARKET_PRIORITY"));
		String ADMIN_PASS = map.get("ADMIN_PASS");
		
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","1");
			result.put("Data", Msg);
			return result;
		}
		
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", ADMIN_MEMBER_NUM);
		
		if ( adminvo == null ) {
			String Msg = "잘못된 접근입니다.";
			
			result.put("ResultCode","1");
			result.put("Data", Msg);
			return result;
		}
		
		
		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "관리자 비밀번호를 잘못입력하였습니다.";
			
			result.put("ResultCode", "4");
			result.put("Data", Msg);
			
			return result;
		}
		
		if ( adminvo.getADMIN_LEVEL() < 2) {
			String Msg = "권한이 없습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
		
		//로그인 날짜 및 account 삽입  insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		
		//주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String ADMIN_ID = adminvo.getADMIN_ID();

		//==== 관리자 히스토리 셋팅
		ahvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(ADMIN_ID);
		ahvo.setEXECUTE_DATE(today);
		
		//MARKET REVISE START
		mvo.setMARKET_NUM(MARKET_NUM);
//		mvo.setBASE_COIN_NUM(BASE_COIN_NUM);
//		mvo.setTARGET_COIN_NUM(TARGET_COIN_NUM);
		mvo.setMARKET_KIND(MARKET_KIND);
		mvo.setMARKET_MINAMOUNT(MARKET_MINAMOUNT);
		mvo.setMARKET_LOWERPRICE(MARKET_LOWERPRICE);
		mvo.setMARKET_UPPERPRICE(MARKET_UPPERPRICE);
		mvo.setMARKET_USE(MARKET_USE);
		mvo.setMARKET_FEE(MARKET_FEE);
		mvo.setMARKET_PRIORITY(MARKET_PRIORITY);
		
		int insert_result = sqlSession.insert("market.setMarketInfo", mvo);
		
		if ( insert_result > 0 ) {
			ahvo.setEXECUTE_KIND("UPDATE");
			ahvo.setADMIN_DESC("REVISE MARKET SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + MARKET_NAME + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("REVISE MARKET SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + MARKET_NAME + " // 시각 : " + today);

			String Msg = MARKET_NAME + " 마켓이 수정되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
		} else {
			ahvo.setEXECUTE_KIND("UPDATE FAIL");
			ahvo.setADMIN_DESC("REVISE MARKET FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + MARKET_NAME + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("REVISE MARKET FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 마켓명 : " + MARKET_NAME + " // 시각 : " + today);
			
			String Msg = "마켓 수정에 실패하였습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
	}
}
