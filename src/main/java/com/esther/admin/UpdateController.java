package com.esther.admin;


	import java.util.Map;

	import javax.inject.Inject;
	import javax.servlet.http.HttpServletRequest;
	import javax.xml.ws.RequestWrapper;

	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.ResponseBody;

import com.esther.model.ReservationVO;
import com.esther.service.ReservationService;
import com.esther.service.UpdateService;


	@Controller
		public class UpdateController {
		@Inject
	    private UpdateService service;
		
		@RequestMapping(value = "/updateStatus", method = RequestMethod.POST)
		@ResponseBody
		public int updateStatus(@RequestBody Map data,HttpServletRequest httpRequest){
			System.out.println("어드민  컨트롤에서 출력"+data);
			ReservationVO vo = new ReservationVO();
			String convertIdx  = (String) data.get("idx");
			String convertVal  = (String) data.get("val");
			System.out.println(convertIdx+ "...."+convertVal);
			int updateIdx = Integer.parseInt(convertIdx.trim());
			int updateVal = Integer.parseInt(convertVal.trim());
			System.out.println(updateIdx+ "...."+updateVal);
			vo.setReserv_idx(updateIdx);
			vo.setReserv_status(updateVal);
			
			try {
				int result = service.updateOne(vo); 
			return result;
			}catch (Exception e) {
				System.out.println( "업데이트 디비 오류" + e);
				return 0;
			}
		}
	}

