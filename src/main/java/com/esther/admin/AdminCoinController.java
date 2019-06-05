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
import com.conco.concotrade.vo.admin.adminCoinVO;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminVO;
import com.conco.concotrade.vo.admin.noticeVO;

@Controller
public class AdminCoinController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private SqlSession sqlSession;
	
	//코인관리 페이지
	@RequestMapping(value ="/ADM/coin", method = RequestMethod.GET)
	public String admin_coin(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/coin_admin/coin_admin";
		}else{
			model.addAttribute("pageParam", "/ADM/coin");
			return "/admin/main_frame";			 
		}	 
	}
	
	//코인리스트 data
	@RequestMapping(value ="/ADM/coinInfo", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> coinInfo(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		HashMap<String, Object> result = new HashMap<String, Object>();	
		List<coinVO> CoinList = sqlSession.selectList("coin.getAdminCoinList");	
		result.put("draw", 1);
		result.put("data", CoinList);	
		return result;
	}
	
	//coin detail
	@RequestMapping(value = "/ADM/coin_detail/{COIN_NUM}", method=RequestMethod.GET)
	public String coin_detail(@PathVariable("COIN_NUM") int COIN_NUM, HttpSession session, @RequestParam HashMap<String, String>map, Model model) { 
		
		coinVO cvo = new coinVO();
		adminCoinVO acvo = new adminCoinVO();
		
		//관리자 체크
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		cvo.setCOIN_NUM(COIN_NUM);
		cvo = sqlSession.selectOne("coin.getCoinAllInfo", cvo);
		
		model.addAttribute("COIN_NUM", cvo.getCOIN_NUM());
		model.addAttribute("COIN_UNIT", cvo.getCOIN_UNIT());
		model.addAttribute("COIN_DESC", cvo.getCOIN_DESC());
		model.addAttribute("COIN_KIND", cvo.getCOIN_KIND());
		model.addAttribute("COIN_LASTBLOCK", cvo.getCOIN_LASTBLOCK());
		model.addAttribute("COIN_LASTTRANS", cvo.getCOIN_LASTTRANS());
		model.addAttribute("COIN_MINTRANS", cvo.getCOIN_MINTRANS());
		model.addAttribute("COIN_MAXTRANS", cvo.getCOIN_MAXTRANS());
		model.addAttribute("COIN_DAILYTRANS", cvo.getCOIN_DAILYTRANS());
		model.addAttribute("COIN_MONTHTRANS", cvo.getCOIN_MONTHTRANS());
		model.addAttribute("COIN_MINDEPOSIT", cvo.getCOIN_MINDEPOSIT());
		model.addAttribute("COIN_MINCONFIRM", cvo.getCOIN_MINCONFIRM());
		model.addAttribute("COIN_ETC", cvo.getCOIN_ETC());
		model.addAttribute("COIN_ADDR", cvo.getCOIN_ADDR());
		model.addAttribute("COIN_RPCUSE", cvo.getCOIN_RPCUSE());
		model.addAttribute("COIN_REGDATE", cvo.getCOIN_REGDATE());
		model.addAttribute("COIN_MODIDATE", cvo.getCOIN_MODIDATE());
		model.addAttribute("COIN_PRIORITY", cvo.getCOIN_PRIORITY());
		model.addAttribute("COIN_INTERNALTRANS", cvo.getCOIN_INTERNALTRANS());
		
		return "/admin/coin_admin/coin_detail";
	}
	
	//coin insert
	@RequestMapping(value = "/ADM/coin_insert", method=RequestMethod.GET)
	public String coin_insert(HttpSession session, @RequestParam HashMap<String, String>map, Model model) { 
		
		adminVO adminvo = new adminVO();
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
	
		if ( adminvo == null ) {
			return "/admin/loginPage";
		}
				
		return "/admin/coin_admin/coin_insert";
	}
	
	//coin_insert_process
	@RequestMapping(value = "/ADM/coin_insert_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> coin_insert_process(HttpSession session, @RequestParam HashMap<String, String>map, Model model, HttpServletRequest request) {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		coinVO cvo = new coinVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		if ( map.get("COIN_MINCONFIRM") == "" ) {
			String Msg = "최소 컨펌을 입력해주세요.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		if ( map.get("COIN_PRIORITY") == "") {
			String Msg = "우선 순위를 입력해주세요.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		String COIN_NAME = map.get("COIN_NAME");
		String COIN_UNIT = map.get("COIN_UNIT");
		String COIN_DESC = map.get("COIN_DESC");
		String COIN_KIND = map.get("COIN_KIND");
		String COIN_LASTBLOCK = map.get("COIN_LASTBLOCK");
		String COIN_MINTRANS = map.get("COIN_MINTRANS");
		String COIN_MAXTRANS = map.get("COIN_MAXTRANS");
		String COIN_DAILYTRANS = map.get("COIN_DAILYTRANS");
		String COIN_MONTHTRANS = map.get("COIN_MONTHTRANS");
		String COIN_MINDEPOSIT = map.get("COIN_MINDEPOSIT");
		int COIN_MINCONFIRM = Integer.parseInt(map.get("COIN_MINCONFIRM"));
		String COIN_ADDR = map.get("COIN_ADDR");
		String COIN_FEE = map.get("COIN_FEE");
		String COIN_RPCUSE = map.get("COIN_RPCUSE");
		int COIN_PRIORITY = Integer.parseInt(map.get("COIN_PRIORITY"));
		String COIN_ETC = map.get("COIN_ETC");
		String COIN_INTERNALTRANS = map.get("COIN_INTERNALTRANS");
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
		
		//COIN INSERT START
		cvo.setCOIN_NAME(COIN_NAME);
		cvo.setCOIN_UNIT(COIN_UNIT);
		cvo.setCOIN_DESC(COIN_DESC);
		cvo.setCOIN_KIND(COIN_KIND);
		cvo.setCOIN_LASTBLOCK(COIN_LASTBLOCK);
		cvo.setCOIN_MINTRANS(COIN_MINTRANS);
		cvo.setCOIN_MAXTRANS(COIN_MAXTRANS);
		cvo.setCOIN_DAILYTRANS(COIN_DAILYTRANS);
		cvo.setCOIN_MONTHTRANS(COIN_MONTHTRANS);
		cvo.setCOIN_MINDEPOSIT(COIN_MINDEPOSIT);
		cvo.setCOIN_MINCONFIRM(COIN_MINCONFIRM);
		cvo.setCOIN_ADDR(COIN_ADDR);
		cvo.setCOIN_FEE(COIN_FEE);
		cvo.setCOIN_RPCUSE(COIN_RPCUSE);
		cvo.setCOIN_PRIORITY(COIN_PRIORITY);
		cvo.setCOIN_ETC(COIN_ETC);
		cvo.setCOIN_INTERNALTRANS(COIN_INTERNALTRANS);
		
		int insert_result = sqlSession.insert("coin.insertCoinInfo", cvo);
		
		if ( insert_result > 0 ) {
			ahvo.setEXECUTE_KIND("INSERT");
			ahvo.setADMIN_DESC("INSERT COIN SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("INSERT COIN SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

			String Msg = cvo.getCOIN_UNIT() + " 코인이 등록되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
		} else {
			ahvo.setEXECUTE_KIND("INSERT_FAIL");
			ahvo.setADMIN_DESC("INSERT COIN FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("INSERT COIN FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			String Msg = "코인 등록에 실패하였습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//coin_revise
	@RequestMapping(value = "/ADM/coin_revise/{COIN_NUM}", method=RequestMethod.GET)
	public String coin_revise(@PathVariable("COIN_NUM") int COIN_NUM, HttpSession session, @RequestParam HashMap<String, String>map, Model model) { 
		
		adminVO adminvo = new adminVO();
		coinVO cvo = new coinVO();
		
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		if ( adminvo == null ) {
			return "/admin/loginPage";
		}
		
		//coin_num 으로 조회 
		cvo.setCOIN_NUM(COIN_NUM);
		
		cvo = sqlSession.selectOne("coin.getCoinAllInfo", cvo);
		
		if ( cvo == null ) {
			return "/admin/loginPage";
		}
		
		//model 전송
		model.addAttribute("COIN_NAME", cvo.getCOIN_NAME());
		model.addAttribute("COIN_UNIT", cvo.getCOIN_UNIT());
		model.addAttribute("COIN_DESC", cvo.getCOIN_DESC());
		model.addAttribute("COIN_KIND", cvo.getCOIN_KIND());
		model.addAttribute("COIN_LASTBLOCK", cvo.getCOIN_LASTBLOCK());
		model.addAttribute("COIN_MINTRANS", cvo.getCOIN_MINTRANS());
		model.addAttribute("COIN_MAXTRANS", cvo.getCOIN_MAXTRANS());
		model.addAttribute("COIN_DAILYTRANS", cvo.getCOIN_DAILYTRANS());
		model.addAttribute("COIN_MONTHTRANS", cvo.getCOIN_MONTHTRANS());
		model.addAttribute("COIN_MINDEPOSIT", cvo.getCOIN_MINDEPOSIT());
		model.addAttribute("COIN_MINCONFIRM", cvo.getCOIN_MINCONFIRM());
		model.addAttribute("COIN_ADDR", cvo.getCOIN_ADDR());
		model.addAttribute("COIN_FEE", cvo.getCOIN_FEE());
		model.addAttribute("COIN_RPCUSE", cvo.getCOIN_RPCUSE());
		model.addAttribute("COIN_PRIORITY", cvo.getCOIN_PRIORITY());
		model.addAttribute("COIN_ETC", cvo.getCOIN_ETC());
		model.addAttribute("COIN_INTERNALTRANS", cvo.getCOIN_INTERNALTRANS());
		
		return "/admin/coin_admin/coin_revise";
	}
	
	//coin_revise_process
	@RequestMapping(value = "/ADM/coin_revise_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> coin_revise_process(HttpSession session, @RequestParam HashMap<String, String>map, Model model, HttpServletRequest request) {
		
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		coinVO cvo = new coinVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		System.out.println(map.get("COIN_MINCONFIRM"));
		if ( map.get("COIN_MINCONFIRM") == "" ) {
			String Msg = "최소 컨펌을 입력해주세요.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		if ( map.get("COIN_PRIORITY") == "") {
			String Msg = "우선 순위를 입력해주세요.";
			
			result.put("ResultCode","3");
			result.put("Data", Msg);
			return result;
		}
		
		int COIN_NUM = Integer.parseInt(map.get("COIN_NUM"));
		String COIN_NAME = map.get("COIN_NAME");
		String COIN_UNIT = map.get("COIN_UNIT");
		String COIN_DESC = map.get("COIN_DESC");
		String COIN_KIND = map.get("COIN_KIND");
		String COIN_LASTBLOCK = map.get("COIN_LASTBLOCK");
		String COIN_MINTRANS = map.get("COIN_MINTRANS");
		String COIN_MAXTRANS = map.get("COIN_MAXTRANS");
		String COIN_DAILYTRANS = map.get("COIN_DAILYTRANS");
		String COIN_MONTHTRANS = map.get("COIN_MONTHTRANS");
		String COIN_MINDEPOSIT = map.get("COIN_MINDEPOSIT");
		int COIN_MINCONFIRM = Integer.parseInt(map.get("COIN_MINCONFIRM"));
		String COIN_ADDR = map.get("COIN_ADDR");
		String COIN_FEE = map.get("COIN_FEE");
		String COIN_RPCUSE = map.get("COIN_RPCUSE");
		int COIN_PRIORITY = Integer.parseInt(map.get("COIN_PRIORITY"));
		String COIN_ETC = map.get("COIN_ETC");
		String COIN_INTERNALTRANS = map.get("COIN_INTERNALTRANS");
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
		
		//COIN REVISE START
		cvo.setCOIN_NUM(COIN_NUM);
		cvo.setCOIN_NAME(COIN_NAME);
		cvo.setCOIN_UNIT(COIN_UNIT);
		cvo.setCOIN_DESC(COIN_DESC);
		cvo.setCOIN_KIND(COIN_KIND);
		cvo.setCOIN_LASTBLOCK(COIN_LASTBLOCK);
		cvo.setCOIN_MINTRANS(COIN_MINTRANS);
		cvo.setCOIN_MAXTRANS(COIN_MAXTRANS);
		cvo.setCOIN_DAILYTRANS(COIN_DAILYTRANS);
		cvo.setCOIN_MONTHTRANS(COIN_MONTHTRANS);
		cvo.setCOIN_MINDEPOSIT(COIN_MINDEPOSIT);
		cvo.setCOIN_MINCONFIRM(COIN_MINCONFIRM);
		cvo.setCOIN_ADDR(COIN_ADDR);
		cvo.setCOIN_FEE(COIN_FEE);
		cvo.setCOIN_RPCUSE(COIN_RPCUSE);
		cvo.setCOIN_PRIORITY(COIN_PRIORITY);
		cvo.setCOIN_ETC(COIN_ETC);
		cvo.setCOIN_INTERNALTRANS(COIN_INTERNALTRANS);
		
		int insert_result = sqlSession.insert("coin.setCoinInfo", cvo);
		
		if ( insert_result > 0 ) {
			ahvo.setEXECUTE_KIND("UPDATE");
			ahvo.setADMIN_DESC("REVISE COIN SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("REVISE COIN SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

			String Msg = cvo.getCOIN_UNIT() + " 코인이 수정되었습니다.";
			
			result.put("ResultCode", "0");
			result.put("Data", Msg);
			return result;
		} else {
			ahvo.setEXECUTE_KIND("UPDATE FAIL");
			ahvo.setADMIN_DESC("REVISE COIN FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
			
			logger.info("REVISE COIN FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 코인 : " + cvo.getCOIN_NAME() + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
			
			String Msg = "코인 수정에 실패하였습니다.";
			
			result.put("ResultCode", "2");
			result.put("Data", Msg);
			return result;
		}
	}
	
	//현재 회원별 코인 잔액 페이지
	@RequestMapping(value ="/ADM/cur_balance", method = RequestMethod.GET)
	public String cur_balance(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		List<coinVO> cvo = sqlSession.selectList("coin.getAdminCoinList");
		
		//리스트에 어레이넣어서 어레이 처리.
		List<String[]> COIN_LIST = new ArrayList<String[]>();
		
		for ( int i=0; i<cvo.size(); i++) {
			String[] coin = new String[2];
			coin[0] = Integer.toString(cvo.get(i).getCOIN_NUM());
			coin[1] = cvo.get(i).getCOIN_UNIT();
			COIN_LIST.add(coin);
		}
		
		model.addAttribute("COIN_LIST", COIN_LIST);
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/coin_admin/cur_balance";
		}else{
			model.addAttribute("pageParam", "/ADM/cur_balance");
			return "/admin/main_frame";			 
		}	 
	}
	
	//현재 회원별 코인 잔액 리스트
	@RequestMapping(value ="/ADM/cur_balance_data/{COIN_NUM}", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> cur_balance_data( @RequestParam HashMap<String, String> map, @PathVariable("COIN_NUM") int COIN_NUM, HttpSession session, Model model) {
		adminCoinVO cvo = new adminCoinVO();
		
		cvo.setCOIN_NUM(COIN_NUM);
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		
		List<adminCoinVO> CulBalaceData = sqlSession.selectList("coin.getCurBalance", cvo);
		
		result.put("draw", 1);
		result.put("data", CulBalaceData);
		
		return result;
	}
	
	//총 코인 잔액 페이지
	@RequestMapping(value ="/ADM/total_balance", method = RequestMethod.GET)
	public String total_balance(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			
			return "/admin/coin_admin/total_balance";
		}else{
			model.addAttribute("pageParam", "/ADM/total_balance");
			return "/admin/main_frame";			 
		}	 
	}
	
	//현재 회원별 코인 잔액 리스트
	@RequestMapping(value ="/ADM/total_balance_data", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> total_balance_data( @RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<adminCoinVO> TotalBalaceData = sqlSession.selectList("coin.getTotalBalance");
		
		result.put("draw", 1);
		result.put("data", TotalBalaceData);
		
		return result;
	}
}
