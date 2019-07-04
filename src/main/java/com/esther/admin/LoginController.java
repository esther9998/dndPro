package com.esther.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.esther.model.AdminVO;
import com.esther.model.ReservationVO;

@Controller
public class LoginController {
	
	@Autowired
	private SqlSession sqlSession;
	
	
	//캘린더 임시 페이지
			@RequestMapping(value="/admin/temp")
			public ModelAndView tempCal(ReservationVO  vo, HttpSession session, HttpServletResponse res, @RequestParam Map<String, String> map ) throws IOException {
				ModelAndView mav = new ModelAndView();
					mav.setViewName("/calendar/themes");
					List<ReservationVO> rstVo = new ArrayList<>();
					rstVo = sqlSession.selectList("reservationMapper.selectAll", vo);
					
					mav.addObject("reserveList", rstVo);
					return mav;
				
			}
	
		//로그인 페이지
		@RequestMapping(value="/admin/loginPage")
		public ModelAndView admin_loginPage(HttpSession session, HttpServletResponse res, @RequestParam Map<String, String> map ) throws IOException {
			ModelAndView mav = new ModelAndView();
				mav.setViewName("/admin/loginPage");
				return mav;
			
		}
		//로그인 체크 
		@RequestMapping(value="/admin_chk", method = RequestMethod.POST)
		public @ResponseBody AdminVO admin_loginChk(HttpSession session, HttpServletResponse res, @RequestParam Map<String, String> map ) throws IOException {
			AdminVO vo  = new AdminVO();
			
			vo.setAdmin_id(map.get("id"));
			vo.setAdmin_pw(map.get("pw"));
			
			AdminVO rst =null;
			//데이터값 조회 
			rst = sqlSession.selectOne("adminMapper.selectAdmin", vo);
			if(rst != null){
				session.setAttribute("admin_seesion", vo.getAdmin_id());
				Object ss = session.getAttribute("admin_seesion");
				System.out.println("------  session --------"+ ss);
				return rst;
			}else{
				Object ss = session.getAttribute("admin_seesion");
				System.out.println("------  session 없어야 --------"+ ss);
				return null;
			}
			
		}
}
