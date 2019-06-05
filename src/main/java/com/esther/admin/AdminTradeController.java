package com.conco.concotrade.controller.admin;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.conco.concotrade.controller.HomeController;
import com.conco.concotrade.vo.admin.adminOrderVO;
import com.conco.concotrade.vo.admin.adminTradeVO;
import com.conco.concotrade.vo.admin.adminVO;

@Controller
public class AdminTradeController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	//거래내역 페이지
	@RequestMapping(value="/ADM/TradeList", method = RequestMethod.GET)
	public String TradeList(HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/trade_list/tradeList";
		}else{
			model.addAttribute("pageParam", "/ADM/TradeList");
			return "/admin/main_frame";			 
		}
	}
	
	//거래내역 데이터
	@RequestMapping(value="/ADM/TradeList_data", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> TradeList_data (HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		List<adminTradeVO> TradeList = sqlSession.selectList("trade.Admin_getTradeList");	
		
		if ( TradeList == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		result.put("draw", 1);
		result.put("data", TradeList);
		return result;
	}
}
