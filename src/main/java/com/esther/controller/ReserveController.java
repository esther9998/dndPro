package com.esther.controller;

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

import com.esther.dnd.DateFormating;
import com.esther.model.ReservationVO;

@Controller
public class ReserveController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	@Inject
	DateFormating dateFormating;
	
	@RequestMapping(value = "/reserve", method = RequestMethod.GET)
	public ModelAndView reserve(Locale locale, Model model) {
		logger.info("갤러리 페이지 >>>>>>>>>>>>>>>>>>>" );
		System.out.println("머야야야야야");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/reserve");
 
		return mav;
	}
	
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
			dateFormating.transformDate((String)formData.get("date"));
		
		


			
			//formData.get("time");
			
			System.out.println("vo: "+vo.toString());
			
			return new ReservationVO();
	}
	
	


	
}
