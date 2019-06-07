package com.esther.controller;

import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.esther.model.ReservationVO;
import com.esther.service.ReservationService;
import com.esther.util.DateFormating;
import com.esther.util.TimeFormating;

@Controller
public class ReserveController {
	@Inject
    private ReservationService service;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/reserve", method = RequestMethod.GET)
	public ModelAndView reserve(Locale locale, Model model) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/reserve");
 
		return mav;
	}
	
	//예약 등록
	@RequestMapping(value = "/reservedInfo", method = RequestMethod.POST)
	@ResponseBody
	public ReservationVO   reservedInfo(@RequestBody Map formData,HttpServletRequest httpRequest){
		logger.info("ajax 예약 reservedInfo>>>>>>>>>>>>>>>>>>>" );
			System.out.println("컨트롤에서 출력"+formData);
			ReservationVO vo = new ReservationVO();
			
			vo.setReserv_name((String)formData.get("name"));
			vo.setReserv_phone((String)formData.get("phone"));
			vo.setReserv_email((String)formData.get("email"));
			vo.setReserv_persons(Integer.valueOf((String) formData.get("persons")));
			//데이트 형변환 
			String strDate = (String) formData.get("date");
			Date date = DateFormating.transformDate(strDate);
			vo.setReserv_date(date);
			//타임 형변
			String strTime = (String) formData.get("time");
			Time time = TimeFormating.transToTime(strTime);
			vo.setReserv_time(time);
			System.out.println("vo: "+vo.toString());
			
			
			try {
				int result = service.insertReserv(vo);
				System.out.println("결과가 1이면 성공= "+result);
			} catch (Exception e) {
				System.out.println("컨트롤러에서 에러"+vo.toString());
				e.printStackTrace();
			}
	        
			
			return new ReservationVO();
	}
	
}
