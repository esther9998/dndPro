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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.conco.concotrade.controller.HomeController;
import com.conco.concotrade.vo.admin.adminFeeVO;
import com.conco.concotrade.vo.admin.adminVO;

@Controller
public class AdminFeeController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
		
	@Autowired
	private SqlSession sqlSession;

	//수수료 정산
	@RequestMapping(value="/ADM/CalFee", method = RequestMethod.GET)
	public String CalFee(HttpSession session, @RequestParam HashMap<String, String>map, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/fee_list/feeCalc";
		}else{
			model.addAttribute("pageParam", "/ADM/CalFee");
			return "/admin/main_frame";			 
		}
	}
	
	//수수료 정산 데이터
	@RequestMapping(value="/ADM/CalcFeeList_data", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> CalcFeeList_data(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		adminFeeVO afvo = new adminFeeVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		String START_DATE = map.get("START_DATE");
		String END_DATE = map.get("END_DATE");
		
		afvo.setSTART_DATE(START_DATE);
		afvo.setEND_DATE(END_DATE);
		
		List<adminFeeVO> CalcFeeList = sqlSession.selectList("fee.getCalcFeeList", afvo);	
		
		if ( CalcFeeList == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
//		result.put("draw", 1);
		result.put("data", CalcFeeList);
		return result;
	}
	
	//수수료 내역
	@RequestMapping(value="/ADM/FeeList", method = RequestMethod.GET)
	public String FeeList(HttpSession session, @RequestParam HashMap<String, String>map, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/fee_list/feeList";
		}else{
			model.addAttribute("pageParam", "/ADM/FeeList");
			return "/admin/main_frame";			 
		}
	}
	
	//수수료 내역 데이터
	@RequestMapping(value="/ADM/feeList_data", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> feeList_data(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		adminFeeVO afvo = new adminFeeVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		List<adminFeeVO> FeeList = sqlSession.selectList("fee.getFeeList", afvo);	
		
		if ( FeeList == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		result.put("draw", 1);
		result.put("data", FeeList);
		return result;
	}
}
