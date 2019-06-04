package com.esther.controller;

import java.sql.Date;
import java.text.Format;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.esther.dnd.GetAWeek;
import com.esther.model.ReservationVO;
import com.esther.service.ReservationService;

@Controller
public class CalendarController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	@Inject
    private ReservationService service;
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public ModelAndView reserve(Locale locale, Model model) {
		logger.info("calendar 페이지 >>>>>>>>>>>>>>>>>>>" );
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/admin/calendar");
		//***************************************************
		//오늘 날짜
				LocalDate ld = LocalDate.now();
				DayOfWeek dayOfWeek = ld.getDayOfWeek();
				System.out.println(dayOfWeek); 
				Date localDate = Date.valueOf(ld); // 비교를 위한 형변환
				String todayDate = localDate.toString();
				
		//***************************************************
		//전체 예약 데이터 가져오기
				List<ReservationVO> data = null;
				try {
					data = service.selectAll();
				} catch (Exception e) {
					e.printStackTrace();
				}
		
		//***************************************************
		//daily
				List<ReservationVO> daily = new ArrayList<ReservationVO>();
		  for (ReservationVO vo : data) { 
			  String reservDate = vo.getReserv_date().toString();
			 if(reservDate.equals( todayDate)) {
				 boolean v = daily.add(vo);
				 System.out.println(vo.toString()+"v:"+v);
			 }else {
				 logger.info("calendar 페이지 - - Daily 데이터 오류" );
			 }
		  
	}
		//***************************************************
		//week - 해당일을 기준으로 
		  GetAWeek getAweek = new GetAWeek();
     	String monday = getAweek.getCurMonday();
     	String sunday = getAweek.getCurSunday();
     	
		  
		//현재 날짜 기준으로 일요일 구하기 



		
		
		//***************************************************
		//month
				
		
		
		
		
		  
		  
		  
		  
		model.addAttribute("daily", daily);
		model.addAttribute("localDate", localDate);
        model.addAttribute("data", data);
		
		return mav;
	}
	/*
	 * @RequestMapping(value = "/calendar/daily", method = RequestMethod.GET) public
	 * ModelAndView scheduleDay(Locale locale, Model model) {
	 * logger.info("calendar 페이지 >>>>>>>>>>>>>>>>>>>" ); ModelAndView mav = new
	 * ModelAndView(); mav.setViewName("/daily");
	 * 
	 * return mav; }
	 */
	
	
	
}
