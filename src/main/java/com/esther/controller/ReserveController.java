package com.esther.controller;

import java.sql.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.esther.model.ReservationVO;
import com.esther.service.ReservationService;

@Controller
public class ReserveController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/reserve", method = RequestMethod.GET)
	public ModelAndView reserve(Locale locale, Model model) {
		logger.info("갤러리 페이지 >>>>>>>>>>>>>>>>>>>" );
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
			
			
		/*
		 * SimpleDateFormat sdf = new sim
		 * 
		 * Date date=Date.valueOf(); Date dd = vo.setReserv_date(date);
		 * System.out.println(dd);
		 */
		/*
		 * DateFormat df = new SimpleDateFormat("MM-dd-yyyy"); String temp
		 * =(String)formData.get("date"); String fm = df.format(temp); Date date =
		 * Date.valueOf(fm);
		 */


			
			//formData.get("time");
			
			System.out.println("vo: "+vo.toString());
			
			return new ReservationVO();
	}
	
	


	
}
