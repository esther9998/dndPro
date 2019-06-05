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
import com.conco.concotrade.vo.admin.adminTransactionVO;
import com.conco.concotrade.vo.admin.adminVO;

@Controller
public class transactionController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;

	@RequestMapping(value="/ADM/transaction_List", method = RequestMethod.GET)
	public String FeeList(HttpSession session, @RequestParam HashMap<String, String>map, Model model) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/transactions_list/transactions_list";
		}else{
			model.addAttribute("pageParam", "/ADM/transaction_List");
			return "/admin/main_frame";			 
		}
	}
	
	@RequestMapping(value="/ADM/transaction_List_data", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> FeeList_data(HttpSession session, Model model, @RequestParam HashMap<String, String>map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		List<adminTransactionVO> TransactionList = sqlSession.selectList("admin.getTransaction");	
		
		if ( TransactionList == null ) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		result.put("draw", 1);
		result.put("data", TransactionList);
		return result;
	}
}
