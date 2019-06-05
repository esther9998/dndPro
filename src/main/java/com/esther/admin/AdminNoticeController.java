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
import com.conco.concotrade.util.md5;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminVO;
import com.conco.concotrade.vo.admin.noticeVO;

@Controller
public class AdminNoticeController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	//공지사항 페이지
	@RequestMapping(value="/ADM/admin_notice",  method=RequestMethod.GET)
	public String admin_notice (HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		adminVO adminvo = new adminVO();
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");
		//관리자 체크
		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());
		
		if(map.get("pageParam") != null && map.get("pageParam").equals("true")){
			return "/admin/admin_account/admin_notice";
		}else{
			model.addAttribute("pageParam", "/ADM/admin_notice");
			return "/admin/main_frame";			 
		}	
	}
	

	
	//공지사항 등록 페이지
	@RequestMapping(value="/ADM/insert_notice_page",  method=RequestMethod.GET)
	public String insert_notice (HttpSession session, Model model, @RequestParam HashMap<String, String> map) {
		
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}
		return "/admin/admin_account/insert_notice";
	}
	
	//공지사항 insert process
	@RequestMapping(value="/ADM/insert_notice_process", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> insert_notice_process(HttpSession session, Model model, @RequestParam HashMap<String, String>map, HttpServletRequest request ) {

		adminVO adminvo = new adminVO();
		noticeVO nvo = new noticeVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		//ajax 값
		String notice_type  = map.get("notice_type");
		String start_date  = map.get("start_date");
		String end_date  = map.get("end_date");
		String notice_title  = map.get("notice_title");
		String notice_content  = map.get("notice_content");
		String notice_use = map.get("notice_use");
		String ADMIN_PASS = map.get("admin_password");
		
		System.out.println("################");
		System.out.println(notice_type);
		System.out.println(start_date);
		System.out.println(end_date);
		System.out.println(notice_title);
		System.out.println(notice_content);
		
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
		
		if ( notice_type.equals("03")) {
			nvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
			nvo.setNOTICE_TYPE(notice_type);
			nvo.setSTART_DATE(start_date);
			nvo.setEND_DATE(end_date);
			nvo.setNOTICE_TITLE(notice_title);
			nvo.setNOTICE_CONTENT(notice_content);
			nvo.setNOTICE_USE(notice_use);
			
			int insert_notice_result = sqlSession.insert("notice.insert_notice_popup", nvo);
			
			if (insert_notice_result > 0 ) {
				ahvo.setEXECUTE_KIND("INSERT");
				ahvo.setADMIN_DESC("INSERT NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
				
				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
				
				logger.info("INSERT NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

				String Msg = "공지사항이 등록되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				return result;
				
			} else {
				ahvo.setEXECUTE_KIND("INSERT_FAIL");
				ahvo.setADMIN_DESC("INSERT NOTICE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
				
				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
				
				logger.info("INSERT NOTICE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
				
				String Msg = "공지사항 등록에 실패하였습니다.";
				
				result.put("ResultCode", "2");
				result.put("Data", Msg);
				return result;
			}
		} else {
			nvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
			nvo.setNOTICE_TYPE(notice_type);
			nvo.setNOTICE_TITLE(notice_title);
			nvo.setNOTICE_CONTENT(notice_content);
			nvo.setNOTICE_USE(notice_use);
			
			int insert_notice_result = sqlSession.insert("notice.insert_notice", nvo);
			
			if (insert_notice_result > 0 ) {
				ahvo.setEXECUTE_KIND("INSERT");
				ahvo.setADMIN_DESC("INSERT NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
				
				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
				
				logger.info("INSERT NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

				String Msg = "공지사항이 등록되었습니다.";
				
				result.put("ResultCode", "0");
				result.put("Data", Msg);
				return result;
			} else {
				ahvo.setEXECUTE_KIND("INSERT_FAIL");
				ahvo.setADMIN_DESC("INSERT NOTICE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
				
				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
				
				logger.info("INSERT NOTICE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
				
				String Msg = "공지사항 등록에 실패하였습니다.";
				
				result.put("ResultCode", "2");
				result.put("Data", Msg);
				return result;
			}
		}
	}

	//공지사항 update process
		@RequestMapping(value="/ADM/update_notice_process", method=RequestMethod.POST)
		@ResponseBody
		public HashMap<String, String> update_notice_process(HttpSession session, Model model, @RequestParam HashMap<String, String>map, HttpServletRequest request ) {

			adminVO adminvo = new adminVO();
			noticeVO nvo = new noticeVO();
			adminHistoryVO ahvo = new adminHistoryVO();
			
			HashMap<String, String> result = new HashMap<String, String>();
			
			//ajax 값
			String notice_type  = map.get("notice_type");
			String start_date  = map.get("start_date");
			String end_date  = map.get("end_date");
			String notice_title  = map.get("notice_title");
			String notice_content  = map.get("notice_content");
			int notice_num = Integer.parseInt(map.get("notice_num"));
			String notice_use = map.get("notice_use");
			String ADMIN_PASS = map.get("admin_password");
			
			System.out.println("################");
			System.out.println(notice_type);
			System.out.println(start_date);
			System.out.println(end_date);
			System.out.println(notice_title);
			System.out.println(notice_content);
			
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
			
			if ( notice_type.equals("03")) {
				nvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
				nvo.setNOTICE_TYPE(notice_type);
				nvo.setSTART_DATE(start_date);
				nvo.setEND_DATE(end_date);
				nvo.setNOTICE_TITLE(notice_title);
				nvo.setNOTICE_CONTENT(notice_content);
				nvo.setNOTICE_USE(notice_use);
				nvo.setNOTICE_NUM(notice_num);
				
				int update_notice_result = sqlSession.update("notice.update_notice_popup", nvo);
				
				if (update_notice_result > 0 ) {
					ahvo.setEXECUTE_KIND("UPDATE");
					ahvo.setADMIN_DESC("UPDATE NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
					
					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
					
					logger.info("UPDATE NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

					String Msg = "공지사항이 수정되었습니다.";
					
					result.put("ResultCode", "0");
					result.put("Data", Msg);
					return result;
				} else {
					ahvo.setEXECUTE_KIND("UPDATE_FAIL");
					ahvo.setADMIN_DESC("UPDATE_FAIL NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
					
					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
					
					logger.info("UPDATE_FAIL NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

					String Msg = "공지사항 수정을 실패하였습니다.";
					
					result.put("ResultCode", "2");
					result.put("Data", Msg);
					return result;
				}
			} else {
				nvo.setADMIN_MEMBER_NUM(ADMIN_MEMBER_NUM);
				nvo.setNOTICE_TYPE(notice_type);
				nvo.setNOTICE_TITLE(notice_title);
				nvo.setNOTICE_CONTENT(notice_content);
				nvo.setNOTICE_USE(notice_use);
				nvo.setNOTICE_NUM(notice_num);
				
				int update_notice_result = sqlSession.update("notice.update_notice", nvo);
				
				if (update_notice_result > 0 ) {
					ahvo.setEXECUTE_KIND("UPDATE");
					ahvo.setADMIN_DESC("UPDATE NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
					
					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
					
					logger.info("UPDATE NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

					String Msg = "공지사항이 수정되었습니다.";
					
					result.put("ResultCode", "0");
					result.put("Data", Msg);
					return result;
				} else {
					ahvo.setEXECUTE_KIND("UPDATE_FAIL");
					ahvo.setADMIN_DESC("UPDATE_FAIL NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);
					
					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);
					
					logger.info("UPDATE_FAIL NOTICE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // 이름 : " + adminvo.getADMIN_NAME() + " // 시각 : " + today);

					String Msg = "공지사항 수정을 실패하였습니다.";
					
					result.put("ResultCode", "2");
					result.put("Data", Msg);
					return result;
				}
			}
		}
		
	//관리자 공지사항 data
	@RequestMapping(value="/ADM/getNoticeInfo", method=RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> noticeInfo_data(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		if ( (adminVO)session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		List<noticeVO> noticeList = sqlSession.selectList("notice.Admin_getNoticeList");
		
		result.put("draw", 1);
		result.put("data", noticeList);
		
		return result;
	}
	
	//관리자 공지사항 수정 페이지
	@RequestMapping(value="/ADM/revise_notice/{NOTICE_NUM}", method=RequestMethod.GET)
	public String revise_notice(@PathVariable("NOTICE_NUM") int NOTICE_NUM, @RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		adminVO adminvo = new adminVO();
		noticeVO nvo = new noticeVO();
		
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		if ( adminvo == null ) {
			return "/admin/loginPage";
		}
		
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();

		nvo.setNOTICE_NUM(NOTICE_NUM);
		
		//공지사항 정보 가져오기
		nvo = sqlSession.selectOne("notice.getNoticeInfo", nvo);
		
		if ( nvo == null ) {
			return null;
		}
		
		//팝업일 때
		if ( nvo.getNOTICE_TYPE().equals("03")) {
			model.addAttribute("NOTICE_TITLE", nvo.getNOTICE_TITLE().replace("\n", ""));
			model.addAttribute("NOTICE_CONTENT", nvo.getNOTICE_CONTENT().replace("\n", ""));
			model.addAttribute("NOTICE_TYPE", nvo.getNOTICE_TYPE());
			model.addAttribute("START_DATE", nvo.getSTART_DATE());
			model.addAttribute("END_DATE", nvo.getEND_DATE());
			model.addAttribute("NOTICE_NUM", nvo.getNOTICE_NUM());
			model.addAttribute("NOTICE_USE", nvo.getNOTICE_USE());
		} else {
		//그외
			model.addAttribute("NOTICE_TITLE", nvo.getNOTICE_TITLE().replace("\n", ""));
			model.addAttribute("NOTICE_CONTENT", nvo.getNOTICE_CONTENT().replace("\n", ""));
			model.addAttribute("NOTICE_TYPE", nvo.getNOTICE_TYPE());
			model.addAttribute("NOTICE_NUM", nvo.getNOTICE_NUM());
			model.addAttribute("NOTICE_USE", nvo.getNOTICE_USE());
		}
		
		return "/admin/admin_account/notice_revise_page";
	}
	
	//관리자 공지사항 수정 페이지
	@RequestMapping(value="/ADM/read_notice/{NOTICE_NUM}", method=RequestMethod.GET)
	public String read_notice(@PathVariable("NOTICE_NUM") int NOTICE_NUM, @RequestParam HashMap<String, String> map, HttpSession session, Model model) {
		
		adminVO adminvo = new adminVO();
		noticeVO nvo = new noticeVO();
		
		//관리자 체크
		adminvo = (adminVO)session.getAttribute("ADMIN_MEMBER_NUM");

		if ( adminvo == null ) {
			return "/admin/loginPage";
		}
		
		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();

		nvo.setNOTICE_NUM(NOTICE_NUM);
		
		//공지사항 정보 가져오기
		nvo = sqlSession.selectOne("notice.getNoticeInfo", nvo);
		
		if ( nvo == null ) {
			return null;
		}

		//팝업일 때
		if ( nvo.getNOTICE_TYPE().equals("03")) {
			model.addAttribute("ADMIN_MEMBER_NUM", nvo.getADMIN_MEMBER_NUM());
			model.addAttribute("NOTICE_TITLE", nvo.getNOTICE_TITLE().replace("\n", ""));
			model.addAttribute("NOTICE_CONTENT", nvo.getNOTICE_CONTENT().replace("\n", ""));
			model.addAttribute("NOTICE_TYPE", nvo.getNOTICE_TYPE());
			model.addAttribute("START_DATE", nvo.getSTART_DATE());
			model.addAttribute("END_DATE", nvo.getEND_DATE());
			model.addAttribute("NOTICE_NUM", nvo.getNOTICE_NUM());
			model.addAttribute("NOTICE_USE", nvo.getNOTICE_USE());
		} else {
		//그외
			model.addAttribute("ADMIN_MEMBER_NUM", nvo.getADMIN_MEMBER_NUM());
			model.addAttribute("NOTICE_TITLE", nvo.getNOTICE_TITLE().replace("\n", ""));
			model.addAttribute("NOTICE_CONTENT", nvo.getNOTICE_CONTENT().replace("\n", ""));
			model.addAttribute("NOTICE_TYPE", nvo.getNOTICE_TYPE());
			model.addAttribute("NOTICE_NUM", nvo.getNOTICE_NUM());
			model.addAttribute("NOTICE_USE", nvo.getNOTICE_USE());
		}
		
		return "/admin/admin_account/notice_read_page";
	}
}