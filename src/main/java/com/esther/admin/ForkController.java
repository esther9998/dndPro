package com.conco.concotrade.controller.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.ModelAndView;

import com.conco.concotrade.controller.HomeController;
import com.conco.concotrade.util.UpperCaseStrategy;
import com.conco.concotrade.vo.chartVO;
import com.conco.concotrade.vo.coinVO;
import com.conco.concotrade.vo.forkVO;
import com.conco.concotrade.vo.marketVO;
import com.conco.concotrade.vo.memberVO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class ForkController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private SqlSession sqlSession;
	
	
	
	//테스트 유알엘  https://concokorea.com/ADM/HARDFORK/2/0
		@RequestMapping(value = "/ADM/HARDFORK/{TARGET}/{PAGE_NUM}", method = RequestMethod.GET)
		public ModelAndView fork_data(@PathVariable("TARGET") int TARGET,@PathVariable("PAGE_NUM") int PAGE_NUM, Model model, @RequestParam HashMap<String, Object> map) {

			marketVO mvo = new marketVO();
			mvo.setTARGET_COIN_NUM(TARGET);
			mvo.setPAGE_NUM(PAGE_NUM);
			if(map.get("datetime")!=null){
				mvo.setMARKET_DATE((String) map.get("datetime"));	
			}
		
			ObjectMapper mapper = new ObjectMapper();
			
			mapper.setPropertyNamingStrategy(new UpperCaseStrategy()); 
			int totalcount = sqlSession.selectOne("fork.getMembercountforfork", mvo);
			List<forkVO> cvo = sqlSession.selectList("fork.getListforfork", mvo);
			List<coinVO> CoinList = sqlSession.selectList("coin.getAdminCoinListForHardfork");	

            ModelAndView mv = new ModelAndView();
            mv.setViewName("/admin/admin_account/admin_fork");
            mv.addObject("fork",cvo);
            mv.addObject("page",mvo);
            mv.addObject("coinlist",CoinList);
            mv.addObject("totalcount",totalcount);
            System.out.println(mv);
			try {
				return mv;
			} catch (Exception e) {
				e.printStackTrace();
			}
			return mv;
		}
		
		
		//테스트 유알엘  https://concokorea.com/ADM/HARDFORK/GETMEMBER/2/aa
				@RequestMapping(value = "/ADM/HARDFORK/GETMEMBER/{TARGET}/{MEMBER_NAME}", method = RequestMethod.GET)
				public ModelAndView fork_memberdata(@PathVariable("TARGET") int TARGET,@PathVariable("MEMBER_NAME") String MEMBER_NAME, Model model, @RequestParam HashMap<String, Object> map) {

					marketVO mvo = new marketVO();
				
                    mvo.setMEMBER_NAME(MEMBER_NAME);
					System.out.println("llll"+sqlSession.selectList("fork.getMemberNum", mvo).size());
			        if(sqlSession.selectList("fork.getMemberNum", mvo).size() == 0){

		        	System.out.println("데이터가 없져!");
		        	mvo.setTARGET_COIN_NUM(TARGET);
					mvo.setPAGE_NUM(-2);
					if(map.get("datetime")!=null){
						mvo.setMARKET_DATE((String) map.get("datetime"));	
					}
					System.out.println("MVO"+mvo);		
					ObjectMapper mapper = new ObjectMapper();
					mapper.setPropertyNamingStrategy(new UpperCaseStrategy()); 
					List<forkVO> cvo = sqlSession.selectList("fork.getMemberdataforfork", mvo);
					List<coinVO> CoinList = sqlSession.selectList("coin.getAdminCoinListForHardfork");	

		            ModelAndView mv = new ModelAndView();
		            mv.setViewName("/admin/admin_account/admin_fork");
		            mv.addObject("fork",cvo);
		            mv.addObject("page",mvo);
		            mv.addObject("coinlist",CoinList);
		            return mv;
		            }

			        List<marketVO> mvoList = sqlSession.selectList("fork.getMemberNum", mvo);
			        System.out.println("mvolist수량"+mvoList.size()+"mvomembernum"+mvoList.get(0).getMEMBER_NUM());

			        int[] membernumarrbefore = new int[mvoList.size()];
			        for(int i=0;i<mvoList.size();i++){
			        	membernumarrbefore[i] = mvoList.get(i).getMEMBER_NUM();
			        }
			        mvo.setMembernumarr(membernumarrbefore);
					mvo.setTARGET_COIN_NUM(TARGET);
					mvo.setPAGE_NUM(-1);
					if(map.get("datetime")!=null){
						mvo.setMARKET_DATE((String) map.get("datetime"));	
					}
					System.out.println("MVO"+mvo);		
					ObjectMapper mapper = new ObjectMapper();
					mapper.setPropertyNamingStrategy(new UpperCaseStrategy()); 
					List<forkVO> cvo = sqlSession.selectList("fork.getMemberdataforfork", mvo);
					List<coinVO> CoinList = sqlSession.selectList("coin.getAdminCoinListForHardfork");	

		            ModelAndView mv = new ModelAndView();
		            mv.setViewName("/admin/admin_account/admin_fork");
		            mv.addObject("fork",cvo);
		            mv.addObject("page",mvo);
		            mv.addObject("coinlist",CoinList);
		            System.out.println(mv);
					try {
						return mv;
					} catch (Exception e) {
						e.printStackTrace();
					}
					return mv;
                	
				}
}
