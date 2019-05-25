package com.esther.controller;

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
		
		List<ReservationVO> reserv = null;
		try {
			reserv = service.selectAll();
			System.out.println(reserv + "/////////////////됏지?");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        model.addAttribute("reserv", reserv);
		
		return mav;
	}
	@RequestMapping(value = "/calendar/daily", method = RequestMethod.GET)
	public ModelAndView scheduleDay(Locale locale, Model model) {
		logger.info("calendar 페이지 >>>>>>>>>>>>>>>>>>>" );
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/daily");
	
		return mav;
	}
}
