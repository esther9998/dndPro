package com.esther.controller;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class CalendarController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public ModelAndView reserve(Locale locale, Model model) {
		logger.info("calendar 페이지 >>>>>>>>>>>>>>>>>>>" );
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/calendar");
		
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
