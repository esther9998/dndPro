package com.conco.concotrade.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import com.conco.concotrade.email.Mail;
import com.conco.concotrade.email.MailSend;
import com.conco.concotrade.util.Banking;
import com.conco.concotrade.util.CParam;
import com.conco.concotrade.util.Random_pass;
import com.conco.concotrade.util.md5;
import com.conco.concotrade.vo.bankingVO;
import com.conco.concotrade.vo.coinVO;
import com.conco.concotrade.vo.feeVO;
import com.conco.concotrade.vo.loginVO;
import com.conco.concotrade.vo.memberVO;
import com.conco.concotrade.vo.walletVO;
import com.conco.concotrade.vo.withdrawVO;
import com.conco.concotrade.vo.admin.MinerVO;
import com.conco.concotrade.vo.admin.adminHistoryVO;
import com.conco.concotrade.vo.admin.adminVO;
import com.conco.concotrade.vo.admin.walletInfoVO;
import com.google.gson.JsonObject;
import com.nitinsurana.bitcoinlitecoin.rpcconnector.CryptoCurrencyRPC;

@Controller
public class WithdrawalController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private MailSend mailSend;

	// 입출금 관리 페이지
	@RequestMapping(value = "/ADM/withdrawal_admin", method = RequestMethod.GET)
	public String withdraw_admin(@RequestParam HashMap<String, String> map, HttpSession session, Model model) {

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		if (map.get("pageParam") != null && map.get("pageParam").equals("true")) {

			return "/admin/withdrawal_admin/withdrawal_admin";
		} else {
			model.addAttribute("pageParam", "/ADM/withdrawal_admin");
			return "/admin/main_frame";
		}
	}

	// 입출금 관리 -> 입금
	@RequestMapping(value = "/ADM/deposit/{MEMBER_NUM}/{COIN_NUM}", method = RequestMethod.GET)
	public String krw_deposit(@PathVariable("MEMBER_NUM") int MEMBER_NUM, @PathVariable("COIN_NUM") int COIN_NUM,
			HttpSession session, Model model, HttpServletResponse res) throws IOException {

		memberVO mvo = new memberVO();
		walletVO wvo = new walletVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}

		mvo.setMEMBER_NUM(MEMBER_NUM);
		// 회원 정보 가져오기
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo == null) {
			return null;
		}
		wvo.setCOIN_NUM(COIN_NUM);
		wvo.setMEMBER_NUM(MEMBER_NUM);
		wvo = sqlSession.selectOne("wallet.getCoinBalance", wvo);

		if (wvo == null) {
			return null;
		}

		// session.setAttribute("BALANCE_MEMBER_NUM", MEMBER_NUM);
		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("MEMBER_ID", mvo.getMEMBER_ID());
		model.addAttribute("MEMBER_PHONE", mvo.getMEMBER_PHONE());
		model.addAttribute("MEMBER_NUM", mvo.getMEMBER_NUM());
		model.addAttribute("WALLET_BALANCE", wvo.getWALLET_BALANCE());
		model.addAttribute("COIN_NUM", wvo.getCOIN_NUM());
		model.addAttribute("COIN_UNIT", wvo.getCOIN_UNIT());

		return "/admin/withdrawal_admin/deposit_page";

	}

	// 입금 프로세스
	@RequestMapping(value = "/ADM/deposit_process", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> deposit_process(HttpSession session, Model model,
			@RequestParam HashMap<String, String> map, HttpServletRequest request) {
		memberVO mvo = new memberVO();
		adminVO adminvo = new adminVO();
		coinVO cvo = new coinVO();
		adminHistoryVO ahvo = new adminHistoryVO();
		MinerVO minervo = new MinerVO();

		HashMap<String, Object> result = new HashMap<String, Object>();

		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		int COIN_NUM = Integer.parseInt(map.get("COIN_NUM"));
		String DEPOSIT_AMOUNT = map.get("DEPOSIT_AMOUNT"); // 입력받은 값
		String DEPOSIT_REASON = map.get("DEPOSIT_REASON"); // 사유
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");

		// basic = 일반입금
		// miner = 채굴입금
		// force = 강제입금
		String DEPOSIT_TYPE = map.get("DEPOSIT_TYPE");

		System.out.println(DEPOSIT_REASON);
		System.out.println(DEPOSIT_AMOUNT);
		System.out.println(DEPOSIT_TYPE);

		// ADMIN CHECK
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "100");
			result.put("Data", Msg);

			return result;
		}

		adminvo = (adminVO) session.getAttribute("ADMIN_MEMBER_NUM");

		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());

		if (adminvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "9");
			result.put("Data", Msg);

			return result;
		}

		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";

			result.put("ResultCode", "8");
			result.put("Data", Msg);

			return result;
		}

		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();

		if (adminvo.getADMIN_LEVEL() < 2) {
			String Msg = "권한이 없습니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}

		// MEMBER_LOCK CHECK
		mvo.setMEMBER_NUM(MEMBER_NUM);

		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo.getMEMBER_LOCK().equals("Y")) {
			String Msg = "잠긴 계정입니다.";

			result.put("ResultCode", "3");
			result.put("Data", Msg);

			return result;
		}

		// MEMBER_USE 체크
		if (mvo.getMEMBER_USE().equals("N")) {
			String Msg = "회원 탈퇴된 계정입니다.";

			result.put("ResultCoode", "4");
			result.put("Data", Msg);

			return result;
		}

		// 관리자 ADMIN_HISTROY 정보들
		// 로그인 날짜 및 account 삽입 insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));

		// 주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String EMAIL = adminvo.getADMIN_ID();

		ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(EMAIL);
		ahvo.setEXECUTE_DATE(today);
		ahvo.setEXECUTE_REASON(DEPOSIT_REASON); // 사유

		// KRW 일경우
		if (COIN_NUM == 1) {

			String reg = "^\\d*(\\.?\\d{0,0})$";
			if (!(DEPOSIT_AMOUNT.matches(reg))) {
				// error
				String Msg = "입력값이 잘못되었습니다.";

				result.put("ResultCoode", "4");
				result.put("Data", Msg);

				return result;
			}

			Banking bk = new Banking(sqlSession);
			bankingVO bvo = new bankingVO();

			cvo.setCOIN_NUM(COIN_NUM);
			// COIN_NUMBER 가져와서 COIN_INFO SELECT
			cvo = sqlSession.selectOne("coin.getCoinInfo", cvo);
			// COIN_KIND로 KRW / 나머지 분기점
			if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW)
					|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW_WITHDRAW_ONLY)) {
				logger.info("KRW_DEPOSIT_START // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // MEMBER_NUM : "
						+ MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // 시각 : " + today);

				if (DEPOSIT_TYPE.equals("force")) {
					// KRW 강제입금
					bvo.setBANKING_AMOUNT(DEPOSIT_AMOUNT);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("KRW_FORCE_DEPOSIT / " + DEPOSIT_REASON);
					bvo.setBANKING_KIND(CParam.DEPOSIT_FORCE);
					bvo.setMEMBER_NUM(MEMBER_NUM);
					int r = bk.deposit(bvo);

					if (r < 0) {
						ahvo.setEXECUTE_KIND("INSERT_FAIL");
						ahvo.setADMIN_DESC("KRW_FORCE_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error("KRW_FORCE_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // 시각 : " + today);

						String Msg = "입금에 실패하였습니다.";

						result.put("ResultCode", "5");
						result.put("Data", Msg);

						return result;
					} else {
						ahvo.setEXECUTE_KIND("INSERT");
						ahvo.setADMIN_DESC("KRW_FORCE_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ r + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.info("KRW_FORCE_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ r + " // 시각 : " + today);

						String Msg = "입금이 정상적으로 처리되었습니다.";

						result.put("ResultCode", "0");
						result.put("Data", Msg);

						return result;
					}
				} else {
					// KRW 입금
					// Cparam.DEPOSIT_BANKING
					bvo.setBANKING_AMOUNT(DEPOSIT_AMOUNT);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("KRW_DEPOSIT / " + DEPOSIT_REASON);
					bvo.setBANKING_KIND(CParam.DEPOSIT_BANKING);
					bvo.setMEMBER_NUM(MEMBER_NUM);
					int r = bk.deposit(bvo);

					if (r < 0) {
						ahvo.setEXECUTE_KIND("INSERT_FAIL");
						ahvo.setADMIN_DESC("KRW_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error("KRW_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // 시각 : "
								+ today);

						String Msg = "입금에 실패하였습니다.";

						result.put("ResultCode", "5");
						result.put("Data", Msg);

						return result;
					} else {
						ahvo.setEXECUTE_KIND("INSERT");
						ahvo.setADMIN_DESC("KRW_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ r + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.info("KRW_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ r + " // 시각 : " + today);

						String Msg = "입금이 정상적으로 처리되었습니다.";

						result.put("ResultCode", "0");
						result.put("Data", Msg);

						return result;
					}
				}
			} else { // 잘못된접근

				String Msg = "잘못된 접근입니다.";

				result.put("ResultCode", "10");
				result.put("Data", Msg);

				return result;
			}
		} else {

			String reg = "^\\d*(\\.?\\d{0,8})$";
			if (!(DEPOSIT_AMOUNT.matches(reg))) {
				// error
				String Msg = "입력값이 잘못되었습니다.";

				result.put("ResultCoode", "4");
				result.put("Data", Msg);

				return result;
			}

			// COIN 입금
			Banking bk = new Banking(sqlSession);
			bankingVO bvo = new bankingVO();

			cvo.setCOIN_NUM(COIN_NUM);

			// COIN_NUMBER 가져와서 COIN_INFO SELECT
			cvo = sqlSession.selectOne("coin.getCoinInfo", cvo);

			// KRW일경우 에러처리
			if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW)
					|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW_WITHDRAW_ONLY)) {
				logger.error(cvo.getCOIN_UNIT() + "_DEPOSIT_FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
						+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // 시각 : " + today);

				String Msg = "잘못된 접근입니다.";

				result.put("ResultCode", "10");
				result.put("Data", Msg);

				return result;
			} else {
				// 채굴입금
				if (DEPOSIT_TYPE.equals("miner")) {
					BigDecimal reward_total;

					String reward_fee = map.get("REWARD_FEE");
					String miner_count = map.get("MINER_COUNT");
					String EMAIL_SEND = map.get("EMAIL_SEND");
					
					System.out.println("#############"+EMAIL_SEND);
					reward_total = new BigDecimal(DEPOSIT_AMOUNT).add(new BigDecimal(reward_fee));

					// 채굴입금 메일 셋팅
					minervo.setCOIN_UNIT(cvo.getCOIN_UNIT());
					minervo.setMEMBER_ID(mvo.getMEMBER_ID());
					minervo.setDEPOSIT_AMOUNT(DEPOSIT_AMOUNT);
					minervo.setREWARD_FEE(reward_fee);
					minervo.setREWARD_TOTAL(reward_total.toPlainString());
					// minervo.setDEPOSIT_DATE(today);
					minervo.setMINER_COUNT(miner_count);

					bvo.setBANKING_AMOUNT(DEPOSIT_AMOUNT);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("MINER_REWARD_DEPOSIT/" + DEPOSIT_REASON);
					bvo.setBANKING_KIND(CParam.DEPOSIT_MINER_REWARD); // 마이너보상
					bvo.setMEMBER_NUM(MEMBER_NUM);
					int r = bk.deposit(bvo);

					// 입금 시각 가져오기
					bvo.setBANKING_NUM(r);
					bvo = sqlSession.selectOne("banking.getBankingDate", bvo);

					minervo.setDEPOSIT_DATE(bvo.getBANKING_DATE());
					if (r < 0) {

						ahvo.setEXECUTE_KIND("INSERT_FAIL");
						ahvo.setADMIN_DESC(cvo.getCOIN_UNIT()
								+ "_MINER_REWARD_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error(cvo.getCOIN_UNIT()
								+ "_MINER_REWARD_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // 시각 : " + today);

						String Msg = "입금에 실패하였습니다.";

						result.put("ResultCode", "5");
						result.put("Data", Msg);

						return result;
					} else {
						ahvo.setEXECUTE_KIND("INSERT");
						ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_MINER_REWARD_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // BANKING_NUM : " + r + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.info(cvo.getCOIN_UNIT() + "_MINER_REWARD_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // BANKING_NUM : " + r + " // 시각 : " + today);

						String Msg = "입금이 정상적으로 처리되었습니다.";

						result.put("ResultCode", "0");
						result.put("Data", Msg);
						
						if (EMAIL_SEND.equals("true")) {
							Mail mail = new Mail(mailSend);
							mail.MinerRewardInfo(minervo);
						}

						return result;
					}
				} else if (DEPOSIT_TYPE.equals("force")) {
					// 코인 강제 입금
					bvo.setBANKING_AMOUNT(DEPOSIT_AMOUNT);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("COIN_FORCE_DEPOSIT/" + DEPOSIT_REASON);
					bvo.setBANKING_KIND(CParam.DEPOSIT_FORCE);
					bvo.setMEMBER_NUM(MEMBER_NUM);
					int r = bk.deposit(bvo);

					if (r < 0) {
						ahvo.setEXECUTE_KIND("INSERT_FAIL");
						ahvo.setADMIN_DESC(
								cvo.getCOIN_UNIT() + "_FORCE_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
										+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : "
										+ COIN_NUM + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error(
								cvo.getCOIN_UNIT() + "_FORCE_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
										+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : "
										+ COIN_NUM + " // 시각 : " + today);

						String Msg = "입금에 실패하였습니다.";

						result.put("ResultCode", "5");
						result.put("Data", Msg);

						return result;
					} else {

						ahvo.setEXECUTE_KIND("INSERT");
						ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_FORCE_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // BANKING_NUM : " + r + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.info(cvo.getCOIN_UNIT() + "_FORCE_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // BANKING_NUM : " + r + " // 시각 : " + today);

						String Msg = "입금이 정상적으로 처리되었습니다.";

						result.put("ResultCode", "0");
						result.put("Data", Msg);

						return result;
					}
				} else {
					// Cparam.DEPOSIT_BANKING
					bvo.setBANKING_AMOUNT(DEPOSIT_AMOUNT);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("COIN_DEPOSIT/" + DEPOSIT_REASON);
					bvo.setBANKING_KIND(CParam.DEPOSIT_BANKING);
					bvo.setMEMBER_NUM(MEMBER_NUM);
					int r = bk.deposit(bvo);

					if (r < 0) {

						ahvo.setEXECUTE_KIND("INSERT_FAIL");
						ahvo.setADMIN_DESC(
								cvo.getCOIN_UNIT() + "_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
										+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : "
										+ COIN_NUM + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error(cvo.getCOIN_UNIT() + "_DEPOSIT_FAIL // BANKING_NUM < 0 // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // 시각 : " + today);

						String Msg = "입금에 실패하였습니다.";

						result.put("ResultCode", "5");
						result.put("Data", Msg);

						return result;
					} else {

						ahvo.setEXECUTE_KIND("INSERT");
						ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // BANKING_NUM : " + r + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.info(cvo.getCOIN_UNIT() + "_DEPOSIT_SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ r + " // 시각 : " + today);

						String Msg = "입금이 정상적으로 처리되었습니다.";

						result.put("ResultCode", "0");
						result.put("Data", Msg);

						return result;
					}
				}
			}
		}
	}

	// 출금 요청 내역 페이지
	@RequestMapping(value = "/ADM/req_withdrawPage", method = RequestMethod.GET)
	public String req_withdrawPage(@RequestParam HashMap<String, String> map, HttpSession session, Model model)
			throws IOException {

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		if (map.get("pageParam") != null && map.get("pageParam").equals("true")) {

			return "/admin/request_withdraw/request_withdrawList";
		} else {
			model.addAttribute("pageParam", "/ADM/req_withdrawPage");
			return "/admin/main_frame";
		}
	}

	// 인증 대기중인 목록
	@RequestMapping(value = "/ADM/withdrawList_wait", method = RequestMethod.GET)
	public String withdrawList_wait(@RequestParam HashMap<String, String> map, HttpSession session, Model model)
			throws IOException {

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		if (map.get("pageParam") != null && map.get("pageParam").equals("true")) {

			return "/admin/request_withdraw/withdrawList_wait";
		} else {
			model.addAttribute("pageParam", "/ADM/withdrawList_wait");
			return "/admin/main_frame";
		}
	}

	// 출금 완료 목록
	@RequestMapping(value = "/ADM/withdrawList_success", method = RequestMethod.GET)
	public String withdrawList_success(@RequestParam HashMap<String, String> map, HttpSession session, Model model)
			throws IOException {

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		if (map.get("pageParam") != null && map.get("pageParam").equals("true")) {

			return "/admin/request_withdraw/withdrawList_success";
		} else {
			model.addAttribute("pageParam", "/ADM/withdrawList_success");
			return "/admin/main_frame";
		}
	}

	// 출금 요청 데이터테이블
	// TYPE = 1 -> 출금 요청 목록
	// TYPE = 2 -> 인증 대기중인 목록
	// TYPE = 3 -> 출금 완료 목록
	@RequestMapping(value = "/ADM/req_withdrawList/{TYPE}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> req_withdrawList(@PathVariable("TYPE") String TYPE, HttpSession session, Model model,
			HttpServletResponse res) throws IOException {

		withdrawVO withvo = new withdrawVO();

		HashMap<String, Object> result = new HashMap<String, Object>();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return null;
		}

		if (TYPE.equals("1")) {
			// 출금 요청 목록
			List<withdrawVO> req_withdrawList = sqlSession.selectList("wallet.getReq_WithdrawList");

			if (req_withdrawList == null) {
				return null;
			}

			for (int i = 0; i < req_withdrawList.size(); i++) {
				System.out.println(req_withdrawList.get(i).getWITHDRAW_ADDR());
			}
			result.put("draw", 1);
			result.put("data", req_withdrawList);
			return result;

		} else if (TYPE.equals("2")) {
			// 인증 대기중인 목록
			List<withdrawVO> withdrawList_wait = sqlSession.selectList("wallet.getReq_Withdraw_Wait");

			if (withdrawList_wait == null) {
				return null;
			}

			result.put("draw", 1);
			result.put("data", withdrawList_wait);
			return result;

		} else {
			// 출금 완료 목록
			List<withdrawVO> withdrawList_success = sqlSession.selectList("wallet.getReq_Withdraw_Success");

			if (withdrawList_success == null) {
				return null;
			}
			result.put("draw", 1);
			result.put("data", withdrawList_success);
			return result;
		}
	}

	// 출금요청 -> 출금
	@RequestMapping(value = "/ADM/withdrawPage/{MEMBER_NUM}/{BANKING_NUM}", method = RequestMethod.GET)
	public String withdrawPage(@PathVariable("MEMBER_NUM") int MEMBER_NUM, @PathVariable("BANKING_NUM") int BANKING_NUM,
			HttpSession session, Model model, @RequestParam HashMap<String, String> map) {

		memberVO mvo = new memberVO();
		withdrawVO withvo = new withdrawVO();
		walletVO wvo = new walletVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "admin/loginPage";
		}

		mvo.setMEMBER_NUM(MEMBER_NUM);

		// 회원 정보 가져오기
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo == null) {
			return null;
		}

		withvo.setBANKING_NUM(BANKING_NUM);
		withvo.setMEMBER_NUM(MEMBER_NUM);

		withvo = sqlSession.selectOne("wallet.getWithdralInfo", withvo);

		if (withvo == null) {
			return null;
		}

		wvo.setMEMBER_NUM(MEMBER_NUM);
		wvo.setCOIN_NUM(withvo.getCOIN_NUM());

		wvo = sqlSession.selectOne("wallet.getCoinBalance", wvo);

		if (wvo == null) {
			return null;
		}
		model.addAttribute("MEMBER_ID", MEMBER_NUM);
		model.addAttribute("MEMBER_ID", BANKING_NUM);
		model.addAttribute("MEMBER_ID", mvo.getMEMBER_ID());
		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("MEMBER_PHONE", mvo.getMEMBER_PHONE());
		model.addAttribute("WITHDRAW_ADDR", withvo.getWITHDRAW_ADDR());
		model.addAttribute("WITHDRAW_TADDR", withvo.getWITHDRAW_TADDR());
		model.addAttribute("BANKING_AMOUNT", withvo.getBANKING_AMOUNT());
		model.addAttribute("WITHDRAW_AMOUNT", withvo.getWITHDRAW_AMOUNT());
		model.addAttribute("BANKING_BALANCE", withvo.getBANKING_BALANCE());
		model.addAttribute("WITHDRAW_DATE", withvo.getWITHDRAW_DATE());
		model.addAttribute("WALLET_BALANCE", wvo.getWALLET_BALANCE());

		return "/admin/request_withdraw/withdraw_page";
	}

	// 출금요청 -> 출금 프로세스
	@RequestMapping(value = "/ADM/req_withdraw_process", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> req_withdraw_process(@RequestParam HashMap<String, String> map, HttpSession session,
			Model model, HttpServletRequest request) {

		memberVO mvo = new memberVO();
		withdrawVO withvo = new withdrawVO();
		adminVO adminvo = new adminVO();
		adminHistoryVO ahvo = new adminHistoryVO();

		HashMap<String, Object> result = new HashMap<String, Object>();

		// admin check
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "100");
			result.put("Data", Msg);

			return result;
		}

		adminvo = (adminVO) session.getAttribute("ADMIN_MEMBER_NUM");

		// 비밀번호 체크
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");

		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());

		if (adminvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "9");
			result.put("Data", Msg);

			return result;
		}

		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";

			result.put("ResultCode", "8");
			result.put("Data", Msg);

			return result;
		}

		if (adminvo.getADMIN_LEVEL() < 2) {
			String Msg = "권한이 없습니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}

		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		int BANKING_NUM = Integer.parseInt(map.get("BANKING_NUM"));
		String WITHDRAW_REASON = map.get("WITHDRAW_REASON"); // 사유
		BigDecimal BANKING_BALANCE = new BigDecimal(map.get("BANKING_BALANCE"));
		BigDecimal WITHDRAW_TOTAL = new BigDecimal(map.get("WITHDRAW_TOTAL")); // 수수료와금액더한값

		// MEMBER_LOCK 체크
		mvo.setMEMBER_NUM(MEMBER_NUM);

		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo.getMEMBER_LOCK().equals("Y")) {
			String Msg = "잠긴 계정입니다.";

			result.put("ResultCode", "3");
			result.put("Data", Msg);

			return result;
		}

		// MEMBER_USE 체크
		if (mvo.getMEMBER_USE().equals("N")) {
			String Msg = "회원 탈퇴된 계정입니다.";

			result.put("ResultCoode", "4");
			result.put("Data", Msg);

			return result;
		}
		// STATE == 73 체크
		withvo.setMEMBER_NUM(MEMBER_NUM);
		withvo.setBANKING_NUM(BANKING_NUM);

		withvo = sqlSession.selectOne("wallet.getWithdralInfo", withvo);

		if (withvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "8");
			result.put("Data", Msg);

			return result;
		}

		// 입력된 값과 비교
		// 얼만큼 차이가 날 때 정지 시킬지?
		BigDecimal DB_BANKING_AMOUNT = new BigDecimal(withvo.getBANKING_AMOUNT()).setScale(8, RoundingMode.FLOOR);
		BigDecimal DB_BANKING_BALANCE = new BigDecimal(withvo.getBANKING_BALANCE()).setScale(8, RoundingMode.FLOOR);
		BigDecimal BANKING_AMOUNT_LIMIT = DB_BANKING_AMOUNT.add(new BigDecimal(100));
		BigDecimal BANKING_BALANCE_LIMIT = DB_BANKING_BALANCE.add(new BigDecimal(100));

		if (DB_BANKING_AMOUNT.compareTo(WITHDRAW_TOTAL) > 0 || DB_BANKING_AMOUNT.compareTo(WITHDRAW_TOTAL) < 0) {
			if (WITHDRAW_TOTAL.compareTo(BANKING_AMOUNT_LIMIT) > 0) {

				String Msg = "잘못된 사용자 입니다. \n출금을 취소해주시기 바랍니다. \n사유:잘못된 사용자";

				result.put("ResultCode", "9");
				result.put("Data", Msg);

				return result;

			}
		}

		if (DB_BANKING_BALANCE.compareTo(BANKING_BALANCE) > 0 || BANKING_BALANCE.compareTo(BANKING_BALANCE) < 0) {
			if (WITHDRAW_TOTAL.compareTo(BANKING_BALANCE_LIMIT) > 0) {
				String Msg = "잘못된 사용자 입니다. \n출금을 취소해주시기 바랍니다. \n사유:잘못된 사용자";

				result.put("ResultCode", "9");
				result.put("Data", Msg);

				return result;
			}
		}

		if (withvo.getWITHDRAW_STATE().equals("71")) {
			String Msg = "이메일 인증 대기 중입니다.";

			result.put("ResultCode", "5");
			result.put("Data", Msg);

			return result;
		}

		if (withvo.getWITHDRAW_STATE().equals("72")) {
			String Msg = "인증이 취소된 출금입니다.";

			result.put("ResultCode", "6");
			result.put("Data", Msg);

			return result;
		}

		if (withvo.getWITHDRAW_STATE().equals("74")) {
			String Msg = "이미 처리된 출금입니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}

		// 로그인 날짜 및 account 삽입 insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));

		// 주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String EMAIL = adminvo.getADMIN_ID();

		// ahvo 값들 셋팅
		ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(EMAIL);
		ahvo.setEXECUTE_DATE(today);
		ahvo.setEXECUTE_REASON(WITHDRAW_REASON); // 사유

		// KRW가 맞는지 체크
		coinVO cvo = sqlSession.selectOne("coin.getCoinInfo", withvo.getCOIN_NUM());

		if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW)|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW_WITHDRAW_ONLY)) {
			logger.info("KRW_WITHDRAW_START // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // MEMBER_NUM : "+ MEMBER_NUM + " // 시각 : " + today);

			if (withvo.getWITHDRAW_STATE().equals(CParam.TRANS_SUBMIT)) {
				// BANKIN_NUM 이용해서 CParam.COMPLETE UPDATE
				withvo.setWITHDRAW_STATE(CParam.TRANS_COMPLETE); // 완료

				int rst = sqlSession.update("wallet.setAuthUpdate_Button", withvo);

				if (rst > 0) {
					// 어드민 로그
					ahvo.setEXECUTE_KIND("UPDATE");
					ahvo.setADMIN_DESC("KRW_WITHDRAW_UPDATE_SUCCESS //  WITHDRAW_STATE : " + CParam.TRANS_COMPLETE+ " // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM+ " // BANKING_NUM : " + BANKING_NUM + " // 시각 : " + today);

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					// 사유
					withvo.setWITHDRAW_DESC(WITHDRAW_REASON);
					withvo.setBANKING_NUM(BANKING_NUM);
					withvo.setMEMBER_NUM(MEMBER_NUM);
					sqlSession.update("wallet.setWithdrawDESC", withvo);

					logger.info("KRW_WITHDRAW_UPDATE_SUCCESS //  WITHDRAW_STATE : " + CParam.TRANS_COMPLETE+ " // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM+ " // BANKING_NUM : " + BANKING_NUM + " // 시각 : " + today);

					String Msg = "출금 요청이 완료되었습니다.";

					// feebook에등록[출금수수료]
					feeVO fvo = new feeVO();
					String fee = new BigDecimal(cvo.getCOIN_FEE()).toPlainString();
					fvo.setCOIN_NUM(cvo.getCOIN_NUM());
					fvo.setFEE_AMOUNT(fee);
					fvo.setBANKING_NUM(BANKING_NUM);
					fvo.setMEMBER_NUM(MEMBER_NUM);
					fvo.setFEE_DESC("TRANS_WITHDRAW");
					sqlSession.insert("banking.insertBankingFee", fvo);

					//출금완료 메일 보내기
					Mail mail = new Mail(mailSend);
					mail.KRW_withdraw_success(withvo, mvo);
					
					result.put("ResultCode", "0");
					result.put("Data", Msg);

					return result;
				} else {
					ahvo.setEXECUTE_KIND("UPDATE_FAIL");
					ahvo.setADMIN_DESC("KRW_WITHDRAW_UPDATE_FAIL // WITHDRAW_STATE : " + CParam.TRANS_SUBMIT
							+ " //// ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM
							+ " // BANKING_NUM : " + BANKING_NUM + " // 시각 : " + today);

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.error("KRW_WITHDRAW_UPDATE_FAIL // WITHDRAW_STATE : " + CParam.TRANS_SUBMIT
							+ " //// ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM
							+ " // BANKING_NUM : " + BANKING_NUM + " // 시각 : " + today);

					String Msg = "출금 요청이 실패하였습니다. \n잠시 후 시도해주세요.";

					result.put("ResultCode", "5");
					result.put("Data", Msg);

					return result;
				}
			} else {
				String Msg = "잘못된 접근입니다. \nERROR_STATE";

				result.put("ResultCode", "6");
				result.put("Data", Msg);

				return result;
			}
		} else {
			// 코인 출금 시

			// coin_kind
			// 잔액과 금액 비교
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}
	}

	// 출금요청 -> 출금 취소 페이지
	@RequestMapping(value = "/ADM/withdraw_cancelPage/{MEMBER_NUM}/{BANKING_NUM}", method = RequestMethod.GET)
	public String withdraw_cancelPage(@PathVariable("MEMBER_NUM") int MEMBER_NUM,
			@PathVariable("BANKING_NUM") int BANKING_NUM, HttpSession session, Model model,
			@RequestParam HashMap<String, String> map) {

		memberVO mvo = new memberVO();
		withdrawVO withvo = new withdrawVO();
		walletVO wvo = new walletVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "admin/loginPage";
		}

		mvo.setMEMBER_NUM(MEMBER_NUM);

		// 회원 정보 가져오기
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo == null) {
			return null;
		}

		withvo.setBANKING_NUM(BANKING_NUM);
		withvo.setMEMBER_NUM(MEMBER_NUM);

		withvo = sqlSession.selectOne("wallet.getWithdralInfo", withvo);

		if (withvo == null) {
			return null;
		}

		wvo.setMEMBER_NUM(MEMBER_NUM);
		wvo.setCOIN_NUM(withvo.getCOIN_NUM());

		wvo = sqlSession.selectOne("wallet.getCoinBalance", wvo);

		if (wvo == null) {
			return null;
		}

		model.addAttribute("MEMBER_ID", MEMBER_NUM);
		model.addAttribute("MEMBER_ID", BANKING_NUM);
		model.addAttribute("MEMBER_ID", mvo.getMEMBER_ID());
		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("MEMBER_PHONE", mvo.getMEMBER_PHONE());
		model.addAttribute("WITHDRAW_ADDR", withvo.getWITHDRAW_ADDR());
		model.addAttribute("WITHDRAW_TADDR", withvo.getWITHDRAW_TADDR());
		model.addAttribute("BANKING_AMOUNT", withvo.getBANKING_AMOUNT());
		model.addAttribute("WITHDRAW_AMOUNT", withvo.getWITHDRAW_AMOUNT());
		model.addAttribute("BANKING_BALANCE", withvo.getBANKING_BALANCE());
		model.addAttribute("WITHDRAW_DATE", withvo.getWITHDRAW_DATE());
		model.addAttribute("WALLET_BALANCE", wvo.getWALLET_BALANCE());

		return "/admin/request_withdraw/withdraw_cancel_page";
	}

	// 출금 요청 -> 출금취소 프로세스
	@RequestMapping(value = "/ADM/withdraw_cancel_process", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> withdraw_cancel_process(@RequestParam HashMap<String, String> map,
			HttpSession session, Model model, HttpServletRequest request) {

		adminVO adminvo = new adminVO();
		withdrawVO withvo = new withdrawVO();
		walletVO wvo = new walletVO();
		memberVO mvo = new memberVO();
		adminHistoryVO ahvo = new adminHistoryVO();

		HashMap<String, Object> result = new HashMap<String, Object>();

		// admin check
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "100");
			result.put("Data", Msg);

			return result;
		}

		adminvo = (adminVO) session.getAttribute("ADMIN_MEMBER_NUM");

		// 비밀번호 체크
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");

		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());

		if (adminvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "9");
			result.put("Data", Msg);

			return result;
		}

		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";

			result.put("ResultCode", "8");
			result.put("Data", Msg);

			return result;
		}

		if (adminvo.getADMIN_LEVEL() < 2) {
			String Msg = "권한이 없습니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}

		int ADMIN_MEMBER_NUM = adminvo.getADMIN_MEMBER_NUM();
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));
		int BANKING_NUM = Integer.parseInt(map.get("BANKING_NUM"));
		String WITHDRAW_CANCEL_REASON = map.get("WITHDRAW_CANCEL_REASON");

		mvo.setMEMBER_NUM(MEMBER_NUM);

		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo.getMEMBER_LOCK().equals("Y")) {
			String Msg = "잠긴 계정입니다.";

			result.put("ResultCode", "2");
			result.put("Data", Msg);

			return result;
		}
		// MEMBER_USE 체크

		if (mvo.getMEMBER_USE().equals("N")) {
			String Msg = "회원 탈퇴된 계정입니다.";

			result.put("ResultCoode", "3");
			result.put("Data", Msg);

			return result;
		}

		withvo.setBANKING_NUM(BANKING_NUM);
		withvo.setMEMBER_NUM(MEMBER_NUM);

		withvo = sqlSession.selectOne("wallet.getWithdralInfo", withvo);
		
		if (withvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "4");
			result.put("Data", Msg);

			return result;
		}

		if (withvo.getWITHDRAW_STATE().equals("72")) {
			String Msg = "인증이 취소된 출금입니다.";

			result.put("ResultCode", "6");
			result.put("Data", Msg);

			return result;
		}

		if (withvo.getWITHDRAW_STATE().equals("74")) {
			String Msg = "이미 처리된 출금입니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}

		// 로그인 날짜 및 account 삽입 insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));

		// 주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String EMAIL = adminvo.getADMIN_ID();

		// avo 값들 셋팅
		ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(EMAIL);
		ahvo.setEXECUTE_DATE(today);
		ahvo.setEXECUTE_REASON(WITHDRAW_CANCEL_REASON);

		coinVO cvo = sqlSession.selectOne("coin.getCoinInfo", withvo.getCOIN_NUM());

		// KRW 일경우 인증완료/인증대기중 때 출금 취소 가능
		if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW)
				|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW_WITHDRAW_ONLY)) {
			if (withvo.getWITHDRAW_STATE().equals(CParam.TRANS_READY)
					|| withvo.getWITHDRAW_STATE().equals(CParam.TRANS_SUBMIT)) {

				// 출금 취소 입금 BANKING_KIND = "15" 변경
				withvo.setBANKING_KIND(CParam.DEPOSIT_TRANS_CANCEL_REFUND);
				sqlSession.update("wallet.setBankingKind", withvo);

				// 인증 취소 STATE 변경
				withvo.setWITHDRAW_STATE(CParam.TRANS_CANCEL); // 인증취소
				withvo.setBANKING_NUM(BANKING_NUM); // 뱅킹 넘버

				int rst = sqlSession.update("wallet.setAuthUpdate_Button", withvo);
				if (rst <= 0) {
					String Msg = "잠시 후 시도해주세요.";

					result.put("ResultCode", "6");
					result.put("Data", Msg);

					return result;
				}

				// 출금 금액 가져오기
				withvo.setBANKING_NUM(BANKING_NUM);
				withvo.setMEMBER_NUM(MEMBER_NUM);

				BigDecimal BANKING_AMOUNT = new BigDecimal(withvo.getWITHDRAW_AMOUNT()); // 출금 금액
				BigDecimal WITHDRAW_FEE = new BigDecimal(withvo.getCOIN_FEE()); // 출금 수수료
				int COIN_NUM = (Integer) withvo.getCOIN_NUM(); // 코인넘버

				// 지갑 잔액 가져오기 (출금 된 상태)
				wvo.setCOIN_NUM(COIN_NUM);
				wvo.setMEMBER_NUM(MEMBER_NUM);
				int i = 0;
				while (true) {

					walletVO wallet = sqlSession.selectOne("wallet.getBalance", wvo);

					if (wallet == null) {
						String Msg = "잘못된 접근입니다.";

						result.put("ResultCode", "7");
						result.put("Data", Msg);

						return result;
					}
					wvo.setWALLET_OBALANCE(wallet.getWALLET_BALANCE());

					BigDecimal WALLET_BALANCE = new BigDecimal(wallet.getWALLET_BALANCE());
					BigDecimal NEW_BALANCE = WALLET_BALANCE.add(BANKING_AMOUNT.add(WITHDRAW_FEE)); // 출금된 후 잔액 + 금액 = 지갑 잔액

					// 지갑 잔액 변경 및 이유 update
					withvo.setWITHDRAW_DESC(WITHDRAW_CANCEL_REASON);
					withvo.setBANKING_NUM(BANKING_NUM);
					withvo.setMEMBER_NUM(MEMBER_NUM);
					wvo.setWALLET_BALANCE(NEW_BALANCE.toPlainString());

					sqlSession.update("wallet.setWithdrawDESC", withvo);
					int w_result = sqlSession.update("wallet.updateWallet", wvo);

					if (w_result > 0) {
						ahvo.setEXECUTE_KIND("UPDATE");
						ahvo.setADMIN_DESC("KRW_WITHDRAW_CANCEL_UPDATE SUCCESS // ADMIN_MEMBER_NUM : "
								+ ADMIN_MEMBER_NUM + " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM
								+ " // BANKING_NUM : " + BANKING_NUM + " // 시각 : " + new Date());

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.info("KRW_WITHDRAW_CANCEL_UPDATE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ BANKING_NUM + " // 시각 : " + new Date());

						// 메일 보내기
						Mail mail = new Mail(mailSend);
						mail.KRW_WithdrawCancel_Admin(withvo, mvo);

						String Msg = "출금요청이 취소되었습니다.";

						result.put("ResultCode", "0");
						result.put("Data", Msg);

						return result;

					}

					if (i > 10) {
						ahvo.setEXECUTE_KIND("UPDATE_FAIL");
						ahvo.setADMIN_DESC("KRW_WITHDRAW_CANCEL_UPDATE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ BANKING_NUM + " // 시각 : " + new Date());

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error("KRW_WITHDRAW_CANCEL_UPDATE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
								+ BANKING_NUM + " // 시각 : " + new Date());
						String Msg = "출금 취소가 실패하였습니다. 잠시 후 시도해주세요.";

						result.put("ResultCode", "8");
						result.put("Data", Msg);

						return result;
					}
					i++;
				}
			} else {
				String Msg = "이미 처리가 된 요청입니다.";

				result.put("ResultCode", "5");
				result.put("Data", Msg);

				return result;
			}
		} else { // 코인 출금 취소
			if (!withvo.getWITHDRAW_STATE().equals(CParam.TRANS_READY)) {
				String Msg = "이미 처리가 된 요청입니다.";

				result.put("ResultCode", "5");
				result.put("Data", Msg);

				return result;
			}

			// 출금 취소 입금 BANKING_KIND = "15" 변경
			withvo.setBANKING_KIND(CParam.DEPOSIT_TRANS_CANCEL_REFUND);
			sqlSession.update("wallet.setBankingKind", withvo);

			// 인증 취소 STATE 변경
			withvo.setWITHDRAW_STATE(CParam.TRANS_CANCEL); // 인증취소
			withvo.setBANKING_NUM(BANKING_NUM); // 뱅킹 넘버

			int rst = sqlSession.update("wallet.setAuthUpdate_Button", withvo);
			if (rst <= 0) {
				String Msg = "잠시 후 시도해주세요.";

				result.put("ResultCode", "6");
				result.put("Data", Msg);

				return result;
			}

			// 출금 금액 가져오기
			withvo.setBANKING_NUM(BANKING_NUM);
			withvo.setMEMBER_NUM(MEMBER_NUM);

			BigDecimal BANKING_AMOUNT = new BigDecimal(withvo.getWITHDRAW_AMOUNT()); // 출금
																						// 금액
			BigDecimal WITHDRAW_FEE = new BigDecimal(withvo.getWITHDRAW_FEE()); // 출금
																				// 수수료
			int COIN_NUM = (Integer) withvo.getCOIN_NUM(); // 코인넘버

			// 지갑 잔액 가져오기 (출금 된 상태)
			wvo.setCOIN_NUM(COIN_NUM);
			wvo.setMEMBER_NUM(MEMBER_NUM);
			int i = 0;
			while (true) {

				walletVO wallet = sqlSession.selectOne("wallet.getBalance", wvo);

				if (wallet == null) {
					String Msg = "잘못된 접근입니다.";

					result.put("ResultCode", "7");
					result.put("Data", Msg);

					return result;
				}
				wvo.setWALLET_OBALANCE(wallet.getWALLET_BALANCE());

				BigDecimal WALLET_BALANCE = new BigDecimal(wallet.getWALLET_BALANCE());
				BigDecimal NEW_BALANCE = WALLET_BALANCE.add(BANKING_AMOUNT.add(WITHDRAW_FEE)); // 출금된 후 잔액 + 금액 =지갑잔액

				// 지갑 잔액 변경
				wvo.setWALLET_BALANCE(NEW_BALANCE.toPlainString());
				int w_result = sqlSession.update("wallet.updateWallet", wvo);

				if (w_result > 0) {
					ahvo.setEXECUTE_KIND("UPDATE");
					ahvo.setADMIN_DESC("COIN_WITHDRAW_CANCEL_UPDATE SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
							+ BANKING_NUM + " // 시각 : " + new Date());

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.info("COIN_WALLET_WITHDRAW_CANCEL SUCCESS // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
							+ BANKING_NUM + " // 시각 : " + new Date());

					// 메일 보내기
					Mail mail = new Mail(mailSend);
					mail.COIN_WithdrawCancel_Admin(withvo, mvo);

					String Msg = "출금요청이 취소되었습니다.";

					result.put("ResultCode", "0");
					result.put("Data", Msg);

					return result;

				}

				if (i > 10) {
					ahvo.setEXECUTE_KIND("UPDATE_FAIL");
					ahvo.setADMIN_DESC("COIN_WITHDRAW_CANCEL_UPDATE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
							+ BANKING_NUM + " // 시각 : " + new Date());

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.error("COIN_WITHDRAW_CANCEL_UPDATE FAIL // ADMIN_MEMBER_NUM : " + ADMIN_MEMBER_NUM
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // COIN_NUM : " + COIN_NUM + " // BANKING_NUM : "
							+ BANKING_NUM + " // 시각 : " + new Date());
					String Msg = "출금 취소가 실패하였습니다. 잠시 후 시도해주세요.";

					result.put("ResultCode", "8");
					result.put("Data", Msg);

					return result;
				}
				i++;
			}
		}
	}

	// 출금요청 -> 지갑보기
	@RequestMapping(value = "/ADM/req_withdraw_addr/{MEMBER_NUM}/{BANKING_NUM}", method = RequestMethod.GET)
	public String wallet_addrPage(@PathVariable("MEMBER_NUM") int MEMBER_NUM,
			@PathVariable("BANKING_NUM") int BANKING_NUM, HttpSession session, Model model, HttpServletResponse res)
			throws IOException {

		memberVO mvo = new memberVO();
		withdrawVO withvo = new withdrawVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			res.sendRedirect("/ADM/loginPage");
			return "/admin/loginPage";
		}

		mvo.setMEMBER_NUM(MEMBER_NUM);
		withvo.setMEMBER_NUM(MEMBER_NUM);
		withvo.setBANKING_NUM(BANKING_NUM);

		// 회원 정보 가져오기
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);

		if (mvo == null) {
			return null;
		}

		withvo = sqlSession.selectOne("wallet.getWithdralInfo", withvo);

		if (withvo == null) {
			return null;
		}

		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("WITHDRAW_TADDR", withvo.getWITHDRAW_TADDR());

		return "/admin/request_withdraw/withdraw_addrPage";
	}

	// 입출금관리 -> 입출금 내역
	@RequestMapping(value = "/ADM/admin_withdrawal_ListPage/{COIN_NUM}/{MEMBER_NUM}", method = RequestMethod.GET)
	public String krw_withdrawalListsPage(@PathVariable("COIN_NUM") int COIN_NUM,
			@PathVariable("MEMBER_NUM") int MEMBER_NUM, HttpSession session, Model model, HttpServletResponse res,
			HashMap<String, String> map) {

		withdrawVO withvo = new withdrawVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/ADM/loginPage";
		}

		withvo.setMEMBER_NUM(MEMBER_NUM);

		model.addAttribute("COIN_NUM", COIN_NUM);
		model.addAttribute("MEMBER_NUM", MEMBER_NUM);

		return "/admin/withdrawal_admin/admin_withdrawList";

	}

	// 입출금관리 -> 입출금 목록
	@RequestMapping(value = "/ADM/admin_withdrawalList/{COIN_NUM}/{MEMBER_NUM}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> coin_withdrawalList(@PathVariable("COIN_NUM") int COIN_NUM,
			@PathVariable("MEMBER_NUM") int MEMBER_NUM, HttpSession session, Model model, HttpServletResponse res,
			HashMap<String, String> map) throws IOException {

		withdrawVO withvo = new withdrawVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			res.sendRedirect("/ADM/loginPage");
			return null;
		}

		HashMap<String, Object> result = new HashMap<String, Object>();

		withvo.setMEMBER_NUM(MEMBER_NUM);

		// KRW 일경우
		if (COIN_NUM == 1) {
			withvo.setCOIN_NUM(COIN_NUM);

			List<withdrawVO> type_withdrawalList = sqlSession.selectList("wallet.type_withdrawalList", withvo);

			if (type_withdrawalList == null) {
				return null;
			}

			result.put("draw", 1);
			result.put("data", type_withdrawalList);
			return result;
		} else {
			// 코인일 경우
			withvo.setCOIN_NUM(COIN_NUM);

			// 지갑 정보 리스트 형태로 보내기
			List<withdrawVO> type_withdrawalList = sqlSession.selectList("wallet.type_withdrawalList", withvo);

			if (type_withdrawalList == null) {
				return null;
			}
			result.put("draw", 1);
			result.put("data", type_withdrawalList);
			return result;
		}
	}

	// 입출금 관리 -> 코인 입출금 리스트
	@RequestMapping(value = "/ADM/walletInfoList", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> userinfo_datalaod(@RequestParam HashMap<String, String> map, HttpSession session,
			Model model) {

		memberVO mvo = new memberVO();

		HashMap<String, Object> result = new HashMap<String, Object>();

		List<walletInfoVO> walletInfoList = sqlSession.selectList("admin.getWalletInfo");

		result.put("draw", 1);
		result.put("data", walletInfoList);

		return result;
	}

	// 입출금관리 -> 출금 페이지
	@RequestMapping(value = "/ADM/withdraw/{MEMBER_NUM}/{COIN_NUM}", method = RequestMethod.GET)
	public String withdraw(@PathVariable("COIN_NUM") int COIN_NUM, @PathVariable("MEMBER_NUM") int MEMBER_NUM,
			@RequestParam HashMap<String, String> map, HttpSession session, Model model, HttpServletResponse res)
			throws IOException {

		coinVO cvo = new coinVO();
		memberVO mvo = new memberVO();
		walletVO wvo = new walletVO();

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			res.sendRedirect("/ADM/loginPage");
			return null;
		}

		mvo.setMEMBER_NUM(MEMBER_NUM);
		wvo.setMEMBER_NUM(MEMBER_NUM);
		wvo.setCOIN_NUM(COIN_NUM);
		cvo.setCOIN_NUM(COIN_NUM);

		// 멤버 정보 가져오기
		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		if (mvo == null) {
			return null;
		}

		// 코인정보 가져오기
		cvo = sqlSession.selectOne("coin.getCoinInfo", cvo);
		if (cvo == null) {
			return null;
		}

		// 잔액 가져오기
		// wvo = sqlSession.selectOne("wallet.getBalance", wvo);
		// if ( wvo == null ) {
		// return null;
		// }

		// 잔액 및 출금한도 등등 가져오기
		wvo.setCOIN_UNIT(cvo.getCOIN_UNIT());

		// 쿼리문 돌려서 UNIT에 맞는 KIND 가져오기
		HashMap<String, Object> getWithInfo = sqlSession.selectOne("wallet.getWithInfo", wvo);

		model.addAttribute("MEMBER_ID", mvo.getMEMBER_ID());
		model.addAttribute("MEMBER_NAME", mvo.getMEMBER_NAME());
		model.addAttribute("MEMBER_PHONE", mvo.getMEMBER_PHONE());
		model.addAttribute("MEMBER_NUM", mvo.getMEMBER_NUM());
		model.addAttribute("COIN_UNIT", cvo.getCOIN_UNIT());
		model.addAttribute("COIN_NUM", cvo.getCOIN_NUM());
		model.addAttribute("COIN_FEE", getWithInfo.get("COIN_FEE"));
		model.addAttribute("COIN_MINTRANS", getWithInfo.get("COIN_MINTRANS"));
		model.addAttribute("WALLET_BALANCE", getWithInfo.get("WALLET_BALANCE"));

		// KRW 일경우
		if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW)
				|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW_WITHDRAW_ONLY)) {
			return "/admin/withdrawal_admin/krw_withdraw_page";
		} else {
			// 코인일 경우
			return "/admin/withdrawal_admin/coin_withdraw_page";
		}
	}

	@RequestMapping(value = "/ADM/withdraw_process/{MEMBER_NUM}/{COIN_NUM}", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> withdraw_process(@RequestParam HashMap<String, String> map,
			@PathVariable("COIN_NUM") int COIN_NUM, @PathVariable("MEMBER_NUM") int MEMBER_NUM, HttpSession session,
			HttpServletResponse res, HttpServletRequest request) throws IOException {

		memberVO mvo = new memberVO();
		walletVO wvo = new walletVO();
		adminVO adminvo = new adminVO();
		coinVO cvo = new coinVO();
		withdrawVO withvo = new withdrawVO();
		bankingVO bvo = new bankingVO();
		loginVO lvo = new loginVO();
		adminHistoryVO ahvo = new adminHistoryVO();

		HashMap<String, String> result = new HashMap<String, String>();

		// 관리자 체크
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "100");
			result.put("Data", Msg);

			return result;
		}

		adminvo = (adminVO) session.getAttribute("ADMIN_MEMBER_NUM");
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");

		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());

		if (adminvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "9");
			result.put("Data", Msg);

			return result;
		}

		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";

			result.put("ResultCode", "8");
			result.put("Data", Msg);

			return result;
		}

		// 관리자 레벨 체크
		if (adminvo.getADMIN_LEVEL() < 2) {
			String Msg = "권한이 없습니다.";

			result.put("ResultCode", "3");
			result.put("Data", Msg);

			return result;
		}

		// 멤버 정보 가져오기
		mvo.setMEMBER_NUM(MEMBER_NUM);

		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		if (mvo == null) {
			return null;
		}

		wvo.setCOIN_NUM(COIN_NUM);
		wvo.setMEMBER_NUM(MEMBER_NUM);

		// 지갑 잔액 가져오기
		wvo = sqlSession.selectOne("wallet.getBalance", wvo);

		if (wvo == null) {
			String Msg = "WALLET_ERROR // 잘못된 접근입니다.";

			result.put("ResultCode", "2");
			result.put("Data", Msg);

			return result;
		}

		// 로그인 날짜 및 account 삽입 insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));

		// 주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String EMAIL = adminvo.getADMIN_ID();

		// avo 값들 셋팅
		ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(EMAIL);
		ahvo.setEXECUTE_DATE(today);

		// 관리자는 한도 체크안하고 넘어가는게 맞다고 생각함.
		// 코인 정보 가져오기
		withvo.setCOIN_NUM(COIN_NUM);

		// basic = 일반출금
		// force = 강제출금
		String WITHDRAW_TYPE = map.get("WITHDRAW_TYPE");

		System.out.println("###" + WITHDRAW_TYPE);

		cvo = sqlSession.selectOne("coin.getCoinInfo", withvo.getCOIN_NUM());
		Banking bk = new Banking(sqlSession);

		// KRW 일경우
		if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW)
				|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_KRW_WITHDRAW_ONLY)) {

			String withdraw_amount = map.get("withdraw_amount"); // 금액
			String withdraw_fee = map.get("withdraw_fee"); // 수수료
			String withdraw_total = map.get("withdraw_total"); // 총액
			String withdraw_bank = map.get("withdraw_bank"); // 은행
			String withdraw_account = map.get("withdraw_account"); // 계좌
			String withdraw_reason = map.get("WITHDRAW_REASON"); // 사유
			// 잔액과 ajax 받은 값 비교

			String reg = "^\\d*(\\.?\\d{0,0})$";
			if (!(withdraw_amount.matches(reg) && withdraw_fee.matches(reg) && withdraw_total.matches(reg))) {
				// error
				String Msg = "입력값이 잘못되었습니다.";

				result.put("ResultCode", "4");
				result.put("Data", Msg);

				return result;
			}

			BigDecimal withcal = new BigDecimal(withdraw_total); // 입력한 총액 값
			BigDecimal wallet_balance = new BigDecimal(wvo.getWALLET_BALANCE()); // 지갑
																					// 잔액

			// 입력한 총액 값이 잔액보다 클 경우 1
			if (withcal.compareTo(wallet_balance) > 0) {
				String Msg = "잔액이 부족합니다.";

				result.put("ResultCode", "4");
				result.put("Data", Msg);

				return result;
			}

			if (WITHDRAW_TYPE.equals("force")) {
				// 강제 출금
				// banking_num 생성
				// banking_num <= 0 일경우 실패
				bvo.setBANKING_AMOUNT(withdraw_total);
				bvo.setCOIN_NUM(cvo.getCOIN_NUM());
				bvo.setBANKING_DESC("WITHDRAW / " + withdraw_reason);
				bvo.setBANKING_KIND(CParam.WITHDRAW_FORCE);
				bvo.setMEMBER_NUM(MEMBER_NUM);

				int r = bk.withdraw(bvo);

				if (r <= 0) {

					logger.error("KRW_WITHDRAW_FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
							+ " // BAKING_NUM : NONE // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					String Msg = "출금에 실패하였습니다.";

					result.put("ResultCode", "5");
					result.put("Data", Msg);

					return result;
				}

				// 정보들 디비 삽입
				// address = bank, taddress = account
				withvo.setCOIN_NUM(cvo.getCOIN_NUM());
				withvo.setBANKING_NUM(r);
				withvo.setWITHDRAW_AMOUNT(withdraw_amount); // 수량
				withvo.setWITHDRAW_FEE(withdraw_fee); // 수수료
				withvo.setWITHDRAW_ADDR(withdraw_bank);
				withvo.setWITHDRAW_TADDR(withdraw_account);
				withvo.setWITHDRAW_DESC(withdraw_reason); // 사유
				withvo.setWITHDRAW_STATE(CParam.TRANS_COMPLETE); // 출금완료
				// 인증완료 후에 출금요청내역에서 출금완료 이용하기.
				withvo.setBANKING_BALANCE(wallet_balance.toPlainString()); // 출금후
																			// 잔액
				withvo.setMEMBER_NUM(MEMBER_NUM);

				withvo.setCOIN_UNIT(cvo.getCOIN_UNIT()); // 출금 코인
				ahvo.setEXECUTE_REASON(withdraw_reason); // 사유

				int withdraw_result = sqlSession.insert("wallet.setWithdrawInfo", withvo);

				if (withdraw_result <= 0) {
					ahvo.setEXECUTE_KIND("UPDATE_FAIL");
					ahvo.setADMIN_DESC("KRW_FORCE_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
							+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.error("KRW_FORCE_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
							+ " // BAKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
							+ " // 시각 : " + today);
					String Msg = "출금에 실패하였습니다.";

					result.put("ResultCode", "7");
					result.put("Data", Msg);

					return result;
				}

				ahvo.setEXECUTE_KIND("UPDATE");
				ahvo.setADMIN_DESC("KRW_FORCE_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
						+ " // BANKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
						+ " // 시각 : " + today);

				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

				logger.info("KRW_FORCE_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
						+ " // BANKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
						+ " // 시각 : " + today);

				String Msg = "출금이 완료되었습니다.";

				result.put("ResultCode", "0");
				result.put("Data", Msg);

				return result;
			} else {
				// banking_num 생성
				// banking_num <= 0 일경우 실패
				bvo.setBANKING_AMOUNT(withdraw_total);
				bvo.setCOIN_NUM(cvo.getCOIN_NUM());
				bvo.setBANKING_DESC("WITHDRAW / " + withdraw_reason);
				bvo.setBANKING_KIND(CParam.WITHDRAW_BANKING);
				bvo.setMEMBER_NUM(MEMBER_NUM);

				int r = bk.withdraw(bvo);

				if (r <= 0) {

					logger.error("KRW_WITHDRAW_FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
							+ " // BAKING_NUM : NONE // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					String Msg = "출금에 실패하였습니다.";

					result.put("ResultCode", "5");
					result.put("Data", Msg);

					return result;
				}

				// 유저 EMAIL 가져오기
				String user_email = mvo.getMEMBER_ID();

				lvo.setMEMBER_ID(user_email);

				// 출금 인증 AUTH코드 생성
				while (true) {
					String AUTH = Random_pass.randomWithAuth();

					if (AUTH == null) {
						String Msg = "인증코드를 생성하지 못했습니다.<br> 잠시 후 시도해주세요.";

						result.put("ResultCode", "6");
						result.put("Data", Msg);

						return result;
					}

					withvo.setWITHDRAW_AUTHCODE(AUTH); // AUTH Setting
					withvo.setMEMBER_NUM(MEMBER_NUM); // MEMBER_NUM Setting

					int FindWithNum = sqlSession.selectOne("wallet.findWithNum", withvo);
					if (FindWithNum == 0)
						break;
				}

				// 정보들 디비 삽입
				// address = bank, taddress = account
				withvo.setCOIN_NUM(cvo.getCOIN_NUM());
				withvo.setBANKING_NUM(r);
				withvo.setWITHDRAW_AMOUNT(withdraw_amount); // 수량
				withvo.setWITHDRAW_FEE(withdraw_fee); // 수수료
				withvo.setWITHDRAW_ADDR(withdraw_bank);
				withvo.setWITHDRAW_TADDR(withdraw_account);
				withvo.setWITHDRAW_DESC(withdraw_reason); // 사유
				withvo.setWITHDRAW_STATE(CParam.TRANS_READY); // 인증 대기중
				withvo.setBANKING_BALANCE(wallet_balance.toPlainString()); // 출금후
																			// 잔액
				withvo.setCOIN_UNIT(cvo.getCOIN_UNIT()); // 출금 코인
				ahvo.setEXECUTE_REASON(withdraw_reason);// 사유

				int withdraw_result = sqlSession.insert("wallet.setWithdrawInfo", withvo);

				if (withdraw_result <= 0) {
					ahvo.setEXECUTE_KIND("UPDATE_FAIL");
					ahvo.setADMIN_DESC("KRW_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
							+ " // BAKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
							+ " // 시각 : " + today);

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.error("KRW_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
							+ " // BAKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
							+ " // 시각 : " + today);
					String Msg = "출금에 실패하였습니다.";

					result.put("ResultCode", "7");
					result.put("Data", Msg);

					return result;
				}

				// 날짜 가져오기
				String WITHDRAW_DATE = sqlSession.selectOne("wallet.getWithdralDate", withvo);
				withvo.setWITHDRAW_DATE(WITHDRAW_DATE);

				// 메일 보내기
				Mail mail = new Mail(mailSend);
				mail.KRW_WithdroawAuth(withvo, lvo);

				ahvo.setEXECUTE_KIND("UPDATE");
				ahvo.setADMIN_DESC("KRW_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
						+ " // BANKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
						+ " // 시각 : " + today);

				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

				logger.info("KRW_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
						+ " // BANKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM
						+ " // 시각 : " + today);

				String Msg = "사용자의 이메일로 출금 인증 메일을 전송하였습니다.\n메일을 확인하여 출금 인증을 완료 하셔야 출금이 진행됩니다.";

				result.put("ResultCode", "0");
				result.put("Data", Msg);

				return result;
			}
		} else {
			// 코인일 경우

//			if (cvo.getCOIN_RPCUSE().equals("N")) {
//				String Msg = "출금할 수 없는 코인입니다.";
//
//				result.put("ResultCode", "8");
//				result.put("Data", Msg);
//
//				return result;
//			}

			String withdraw_amount = map.get("withdraw_amount"); // 금액
			String withdraw_fee = map.get("withdraw_fee"); // 수수료
			String withdraw_total = map.get("withdraw_total"); // 총액
			String withdraw_addr = map.get("withdraw_addr"); // 계좌
			String withdraw_reason = map.get("WITHDRAW_REASON"); // 사유

			String reg = "^\\d*(\\.?\\d{0,8})$";
			if (!(withdraw_amount.matches(reg))) {
				// error
				String Msg = "입력값이 잘못되었습니다.";

				result.put("ResultCode", "4");
				result.put("Data", Msg);

				return result;
			}

			// 잔액과 ajax 받은 값 비교
			BigDecimal withcal = new BigDecimal(withdraw_total); // 입력한 총액 값
			BigDecimal wallet_balance = new BigDecimal(wvo.getWALLET_BALANCE()); // 지갑
																					// 잔액

			// 입력한 총액 값이 잔액보다 클 경우 1
			if (withcal.compareTo(wallet_balance) > 0) {
				String Msg = "잔액이 부족합니다.";

				result.put("ResultCode", "8");
				result.put("Data", Msg);

				return result;
			}

			// ================= 7월31일 마이너리워드 ETH 테스트
			// ===============================
			if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_ETH)
					|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_ETH_WITHDRAW_ONLY)) {
				// 강제출금
				// RPC 통하지 않고 디비만 수정
				if (WITHDRAW_TYPE.equals("force")) {
					bvo.setBANKING_AMOUNT(withdraw_total);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("FORCE_WITHDRAW / " + withdraw_reason);
					bvo.setBANKING_KIND(CParam.WITHDRAW_FORCE);
					bvo.setMEMBER_NUM(MEMBER_NUM);

					int r = bk.withdraw(bvo);

					if (r <= 0) {
						logger.error(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_FAIL // ADMIN_MEMBER_NUM : "
								+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : NONE // MEMBER_NUM : " + MEMBER_NUM
								+ " // 시각 : " + today);

						String Msg = "출금에 실패하였습니다.";

						result.put("ResultCode", "9");
						result.put("Data", Msg);

						return result;
					}

					// 정보들 디비 삽입
					// address = bank, taddress = account
					withvo.setCOIN_NUM(cvo.getCOIN_NUM());
					withvo.setBANKING_NUM(r);
					withvo.setWITHDRAW_AMOUNT(withdraw_amount); // 수량
					withvo.setWITHDRAW_FEE(withdraw_fee); // 수수료
					withvo.setWITHDRAW_TADDR(withdraw_addr); // 이체주소
					withvo.setWITHDRAW_DESC(withdraw_reason); // 사유
					withvo.setWITHDRAW_STATE(CParam.TRANS_COMPLETE); // 출금완료
					withvo.setBANKING_BALANCE(wallet_balance.toPlainString()); // 출금후잔액
					withvo.setMEMBER_NUM(MEMBER_NUM);

					withvo.setCOIN_UNIT(cvo.getCOIN_UNIT()); // 출금 코인
					ahvo.setEXECUTE_REASON(withdraw_reason); // 사유

					int withdraw_result = sqlSession.insert("wallet.setWithdrawInfo", withvo);

					if (withdraw_result <= 0) {
						ahvo.setEXECUTE_KIND("UPDATE_FAIL");
						ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
								+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
								+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
						String Msg = "출금에 실패하였습니다.";

						result.put("ResultCode", "9");
						result.put("Data", Msg);

						return result;
					}

					ahvo.setEXECUTE_KIND("UPDATE");
					ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : "
							+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + withvo.getBANKING_NUM()
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.info(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : "
							+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + withvo.getBANKING_NUM()
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					String Msg = "출금이 완료되었습니다.";

					result.put("ResultCode", "0");
					result.put("Data", Msg);

					return result;
				} else {
					
					if (cvo.getCOIN_RPCUSE().equals("N")) {
						String Msg = "출금할 수 없는 코인입니다.";

						result.put("ResultCode", "8");
						result.put("Data", Msg);

						return result;
					}
					
					// 일반 출금일 때,
					String Msg = "잘못된 접근입니다.";

					result.put("ResultCode", "9");
					result.put("Data", Msg);

					return result;
				}
			} else if (cvo.getCOIN_KIND().equals(CParam.COIN_KIND_BTC)
					|| cvo.getCOIN_KIND().equals(CParam.COIN_KIND_BTC_WITHDRAW_ONLY)) {

				// 강제출금
				// RPC 통하지 않고 디비만 수정
				if (WITHDRAW_TYPE.equals("force")) {
					bvo.setBANKING_AMOUNT(withdraw_total);
					bvo.setCOIN_NUM(cvo.getCOIN_NUM());
					bvo.setBANKING_DESC("FORCE_WITHDRAW / " + withdraw_reason);
					bvo.setBANKING_KIND(CParam.WITHDRAW_FORCE);
					bvo.setMEMBER_NUM(MEMBER_NUM);

					int r = bk.withdraw(bvo);

					if (r <= 0) {
						logger.error(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_FAIL // ADMIN_MEMBER_NUM : "
								+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : NONE // MEMBER_NUM : " + MEMBER_NUM
								+ " // 시각 : " + today);

						String Msg = "출금에 실패하였습니다.";

						result.put("ResultCode", "9");
						result.put("Data", Msg);

						return result;
					}

					// 정보들 디비 삽입
					// address = bank, taddress = account
					withvo.setCOIN_NUM(cvo.getCOIN_NUM());
					withvo.setBANKING_NUM(r);
					withvo.setWITHDRAW_AMOUNT(withdraw_amount); // 수량
					withvo.setWITHDRAW_FEE(withdraw_fee); // 수수료
					withvo.setWITHDRAW_TADDR(withdraw_addr); // 이체주소
					withvo.setWITHDRAW_DESC(withdraw_reason); // 사유
					withvo.setWITHDRAW_STATE(CParam.TRANS_COMPLETE); // 출금완료
					withvo.setBANKING_BALANCE(wallet_balance.toPlainString()); // 출금후
																				// 잔액
					withvo.setMEMBER_NUM(MEMBER_NUM);

					withvo.setCOIN_UNIT(cvo.getCOIN_UNIT()); // 출금 코인
					ahvo.setEXECUTE_REASON(withdraw_reason); // 사유

					int withdraw_result = sqlSession.insert("wallet.setWithdrawInfo", withvo);

					if (withdraw_result <= 0) {
						ahvo.setEXECUTE_KIND("UPDATE_FAIL");
						ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
								+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

						sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

						logger.error(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
								+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
								+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
						String Msg = "출금에 실패하였습니다.";

						result.put("ResultCode", "9");
						result.put("Data", Msg);

						return result;
					}

					ahvo.setEXECUTE_KIND("UPDATE");
					ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : "
							+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + withvo.getBANKING_NUM()
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

					logger.info(cvo.getCOIN_UNIT() + "_FORCE_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : "
							+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + withvo.getBANKING_NUM()
							+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

					String Msg = "출금이 완료되었습니다.";

					result.put("ResultCode", "0");
					result.put("Data", Msg);

					return result;
				}
				
				if (cvo.getCOIN_RPCUSE().equals("N")) {
					String Msg = "출금할 수 없는 코인입니다.";

					result.put("ResultCode", "8");
					result.put("Data", Msg);

					return result;
				}
				
				CryptoCurrencyRPC crpc = new CryptoCurrencyRPC(cvo.getCOIN_ID(), cvo.getCOIN_PASS(), cvo.getCOIN_RPC(),
						cvo.getCOIN_RPCPORT());
				if (crpc.isConnected() == false) {
					logger.error("RPC[" + cvo.getCOIN_UNIT() + "] Connect Fail. Connect is " + crpc.isConnected() + ". "
							+ new Date());
					// Msg = "정보를 가져올 수 없습니다.";
					String Msg = "오류가 발생하였습니다.";

					result.put("ResultCode", "4");
					result.put("Data", Msg);
					return result;
				}

				JsonObject jo = crpc.validateAddressDetail(withdraw_addr);
				boolean isValid = jo.get("isvalid").getAsBoolean();
				if (!isValid) {
					String Msg = "주소가 잘못입력되었습니다.";

					result.put("ResultCode", "5");
					result.put("Data", Msg);
					return result;
				}

				boolean isMine = jo.get("ismine").getAsBoolean();
				if (isMine) {
					String Msg = "출금할 수 없는 주소입니다.";

					result.put("ResultCode", "6");
					result.put("Data", Msg);
					return result;
				}

				BigDecimal RPCBalance = crpc.getBalance("CONCO");
				if (RPCBalance.compareTo(withcal) < 0) {
					String Msg = "오류가 발생하였습니다.";

					result.put("ResultCode", "7");
					result.put("Data", Msg);
					return result;
				}
			} else {
				String Msg = "잘못된 접근입니다.";

				result.put("ResultCode", "8");
				result.put("Data", Msg);
				return result;
			}

			// banking_num 생성
			// banking_num <= 0 일경우 실패
			bvo.setBANKING_AMOUNT(withdraw_total);
			bvo.setCOIN_NUM(cvo.getCOIN_NUM());
			bvo.setBANKING_DESC("WITHDRAW / " + withdraw_reason);
			bvo.setBANKING_KIND(CParam.WITHDRAW_BANKING);
			bvo.setMEMBER_NUM(MEMBER_NUM);

			int r = bk.withdraw(bvo);

			if (r <= 0) {
				logger.error(
						cvo.getCOIN_UNIT() + "_WITHDRAW_FAIL // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
								+ " // BAKING_NUM : NONE // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

				String Msg = "출금에 실패하였습니다.";

				result.put("ResultCode", "9");
				result.put("Data", Msg);

				return result;
			}

			// 유저 EMAIL 가져오기
			String user_email = mvo.getMEMBER_ID();

			lvo.setMEMBER_ID(user_email);

			// 출금 인증 AUTH코드 생성
			while (true) {
				String AUTH = Random_pass.randomWithAuth();

				if (AUTH == null) {
					String Msg = "인증코드를 생성하지 못했습니다.<br> 잠시 후 시도해주세요.";

					result.put("ResultCode", "6");
					result.put("Data", Msg);

					return result;
				}

				withvo.setWITHDRAW_AUTHCODE(AUTH); // AUTH Setting
				withvo.setMEMBER_NUM(MEMBER_NUM); // MEMBER_NUM Setting

				int FindWithNum = sqlSession.selectOne("wallet.findWithNum", withvo);
				if (FindWithNum == 0)
					break;
			}

			// 정보들 디비 삽입
			// address = bank, taddress = account
			withvo.setCOIN_NUM(cvo.getCOIN_NUM());
			withvo.setBANKING_NUM(r);
			withvo.setWITHDRAW_AMOUNT(withdraw_amount); // 수량
			withvo.setWITHDRAW_FEE(withdraw_fee); // 수수료
			withvo.setWITHDRAW_TADDR(withdraw_addr); // 이체주소
			withvo.setWITHDRAW_DESC(withdraw_reason); // 사유
			withvo.setWITHDRAW_STATE(CParam.TRANS_READY); // 인증 대기중
			withvo.setBANKING_BALANCE(wallet_balance.toPlainString()); // 출금후 잔액
			withvo.setCOIN_UNIT(cvo.getCOIN_UNIT()); // 출금 코인
			ahvo.setEXECUTE_REASON(withdraw_reason); // 사유

			int withdraw_result = sqlSession.insert("wallet.setWithdrawInfo", withvo);

			if (withdraw_result <= 0) {
				ahvo.setEXECUTE_KIND("UPDATE_FAIL");
				ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
						+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
						+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

				sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

				logger.error(cvo.getCOIN_UNIT() + "_WITHDRAW_INSERT_FAIL // ADMIN_MEMBER_NUM : "
						+ adminvo.getADMIN_MEMBER_NUM() + " // BAKING_NUM : " + withvo.getBANKING_NUM()
						+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);
				String Msg = "출금에 실패하였습니다.";

				result.put("ResultCode", "9");
				result.put("Data", Msg);

				return result;
			}

			// 날짜 가져오기
			String WITHDRAW_DATE = sqlSession.selectOne("wallet.getWithdralDate", withvo);
			withvo.setWITHDRAW_DATE(WITHDRAW_DATE);

			// 메일 보내기
			Mail mail = new Mail(mailSend);
			mail.Coin_WithdroawAuth(withvo, lvo);

			ahvo.setEXECUTE_KIND("UPDATE");
			ahvo.setADMIN_DESC(cvo.getCOIN_UNIT() + "_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : "
					+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + withvo.getBANKING_NUM()
					+ " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : " + today);

			sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

			logger.info(cvo.getCOIN_UNIT() + "_WITHDRAW_SUCCESS // ADMIN_MEMBER_NUM : " + adminvo.getADMIN_MEMBER_NUM()
					+ " // BANKING_NUM : " + withvo.getBANKING_NUM() + " // MEMBER_NUM : " + MEMBER_NUM + " // 시각 : "
					+ today);

			String Msg = "사용자의 이메일로 출금 인증 메일을 전송하였습니다.\n메일을 확인하여 출금 인증을 완료 하셔야 출금이 진행됩니다.";

			result.put("ResultCode", "0");
			result.put("Data", Msg);

			return result;
		}
	}

	// 입출금 내역 페이지
	@RequestMapping(value = "/ADM/withdrawal_List", method = RequestMethod.GET)
	public String ADM_withdrawal_List(HttpSession session, @RequestParam HashMap<String, String> map, Model model) {

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		if (map.get("pageParam") != null && map.get("pageParam").equals("true")) {
			return "/admin/withdrawal_list/withdrawal_list";
		} else {
			model.addAttribute("pageParam", "/ADM/withdrawal_List");
			return "/admin/main_frame";
		}
	}

	// 입출금 내역 데이터
	@RequestMapping(value = "/ADM/withdrawal_ListData", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> withdrawal_ListData(HttpSession session, Model model,
			@RequestParam HashMap<String, String> map) {

		List<withdrawVO> withdrawalList = sqlSession.selectList("wallet.Admin_getWithdrawalList");

		if (withdrawalList == null) {
			return null;
		}

		HashMap<String, Object> result = new HashMap<String, Object>();

		result.put("draw", 1);
		result.put("data", withdrawalList);
		return result;
	}

	// 출금 이메일 재전송
	@RequestMapping(value = "/ADM/withdraw_resend_email", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, String> withdraw_resend_email(HttpSession session, Model model,
			@RequestParam HashMap<String, String> map, HttpServletRequest request) {

		adminVO adminvo = new adminVO();
		memberVO mvo = new memberVO();
		withdrawVO withvo = new withdrawVO();
		loginVO lvo = new loginVO();
		adminHistoryVO ahvo = new adminHistoryVO();

		HashMap<String, String> result = new HashMap<String, String>();

		int BANKING_NUM = Integer.parseInt(map.get("BANKING_NUM"));
		int MEMBER_NUM = Integer.parseInt(map.get("MEMBER_NUM"));

		// 관리자 체크
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "100");
			result.put("Data", Msg);

			return result;
		}

		adminvo = (adminVO) session.getAttribute("ADMIN_MEMBER_NUM");
		String ADMIN_PASS = map.get("ADMIN_PASSWORD");

		adminvo = sqlSession.selectOne("admin.getAdminInfo", adminvo.getADMIN_MEMBER_NUM());

		if (adminvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "9");
			result.put("Data", Msg);

			return result;
		}

		if (!adminvo.getADMIN_PASS().equals(md5.testMD5(ADMIN_PASS))) {
			String Msg = "비밀번호를 잘못입력하였습니다.";

			result.put("ResultCode", "8");
			result.put("Data", Msg);

			return result;
		}

		// 관리자 레벨 체크
		if (adminvo.getADMIN_LEVEL() < 1) {
			String Msg = "권한이 없습니다.";

			result.put("ResultCode", "3");
			result.put("Data", Msg);

			return result;
		}

		// BANKING_NUM 으로 WITHDRAW_REQUEST 출금정보 조회
		withvo.setBANKING_NUM(BANKING_NUM);
		withvo.setMEMBER_NUM(MEMBER_NUM);

		withvo = sqlSession.selectOne("wallet.getWithdralInfo", withvo);

		if (withvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "4");
			result.put("Data", Msg);

			return result;
		}
		// WITHDRAW_STATE 체크 ( 이메일 인증 대기중이 아니면 에러 )
		if (!withvo.getWITHDRAW_STATE().equals("71")) {
			String Msg = "이미 처리된 출금 입니다.";

			result.put("ResultCode", "5");
			result.put("Data", Msg);

			return result;
		}

		// 출금 인증 AUTH 코드 생성
		while (true) {
			String AUTH = Random_pass.randomWithAuth();

			if (AUTH == null) {
				String Msg = "인증코드를 생성하지 못했습니다.<br> 잠시 후 시도해주세요.";

				result.put("ResultCode", "5");
				result.put("Data", Msg);

				return result;
			}

			withvo.setWITHDRAW_AUTHCODE(AUTH); // AUTH Setting
			withvo.setMEMBER_NUM(MEMBER_NUM); // MEMBER_NUM Setting

			int FindWithNum = sqlSession.selectOne("wallet.findWithNum", withvo);
			if (FindWithNum == 0)
				break;
		}

		// AUTH코드 업데이트
		System.out.println("####" + withvo.getWITHDRAW_AUTHCODE());
		int set_auth_rst = sqlSession.update("wallet.setAuthCode", withvo);

		if (set_auth_rst <= 0) {
			String Msg = "AUTHCODE 업데이트에 실패하였습니다.";

			result.put("ResultCode", "6");
			result.put("Data", Msg);

			return result;
		}
		// 멤버 정보 가져오기
		mvo.setMEMBER_NUM(MEMBER_NUM);

		mvo = sqlSession.selectOne("admin.getMemberInfo", mvo);
		if (mvo == null) {
			String Msg = "잘못된 접근입니다.";

			result.put("ResultCode", "7");
			result.put("Data", Msg);

			return result;
		}

		// 관리자 History Insert
		// 로그인 날짜 및 account 삽입 insert
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));

		// 주소 가져오기
		String REQEUST_PAGE = request.getRequestURI();
		String EMAIL = adminvo.getADMIN_ID();

		// avo 값들 셋팅
		// DB insert admin
		ahvo.setADMIN_MEMBER_NUM(adminvo.getADMIN_MEMBER_NUM());
		ahvo.setREQUEST_PAGE(REQEUST_PAGE);
		ahvo.setADMIN_ACCOUNT(EMAIL);
		ahvo.setEXECUTE_DATE(today);

		String WITHDRAW_DATE = sqlSession.selectOne("wallet.getWithdralDate", withvo);
		System.out.println(WITHDRAW_DATE);
		withvo.setWITHDRAW_DATE(WITHDRAW_DATE);
		lvo.setMEMBER_ID(mvo.getMEMBER_ID());

		// KRW 일경우
		if (withvo.getCOIN_NUM() == 1) {
			// 이메일 전송
			Mail mail = new Mail(mailSend);
			mail.KRW_WithdroawAuth(withvo, lvo);
		} else {
			// COIN 일경우
			// 이메일 전송
			Mail mail = new Mail(mailSend);
			mail.Coin_WithdroawAuth(withvo, lvo);
		}

		ahvo.setEXECUTE_KIND("UPDATE");
		ahvo.setADMIN_DESC(withvo.getCOIN_UNIT() + " WITHDRAW AUTHCODE EMAIL RESEND SUCCESS // ADMIN_MEMBER_NUM : "
				+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + BANKING_NUM + "// AUTHCODE : "
				+ withvo.getWITHDRAW_AUTHCODE() + " // 시각 : " + today);

		sqlSession.insert("admin.insertADMIN_HISTORY", ahvo);

		ahvo.setADMIN_DESC(withvo.getCOIN_UNIT() + " WITHDRAW AUTHCODE EMAIL RESEND SUCCESS // ADMIN_MEMBER_NUM : "
				+ adminvo.getADMIN_MEMBER_NUM() + " // BANKING_NUM : " + BANKING_NUM + "// AUTHCODE : "
				+ withvo.getWITHDRAW_AUTHCODE() + " // 시각 : " + today);

		String Msg = "해당 회원님께 출금 이메일 재전송이 완료되었습니다.";

		result.put("ResultCode", "0");
		result.put("Data", Msg);

		return result;
	}

	// 출금 내역 페이지
	@RequestMapping(value = "/ADM/withdrawList", method = RequestMethod.GET)
	public String withdraw_List(HttpSession session, @RequestParam HashMap<String, String> map, Model model) {

		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		if (map.get("pageParam") != null && map.get("pageParam").equals("true")) {
			return "/admin/request_withdraw/withdrawList";
		} else {
			model.addAttribute("pageParam", "/ADM/withdrawList");
			return "/admin/main_frame";
		}
	}

	// 입출금 내역 데이터
	@RequestMapping(value = "/ADM/withdrawlist_data", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> withdrawlist_data(HttpSession session, Model model,@RequestParam HashMap<String, String> map) {

		List<withdrawVO> withdrawList = sqlSession.selectList("wallet.Admin_getWithdrawList");

		if (withdrawList == null) {
			return null;
		}

		HashMap<String, Object> result = new HashMap<String, Object>();

		result.put("draw", 1);
		result.put("data", withdrawList);
		return result;
	}
	
	@RequestMapping(value ="/ADM/withdraw_request_chk", method = RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> withdraw_request_chk(HttpSession session, Model model,@RequestParam HashMap<String, String> map) {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		//어드민 체크
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			String Msg = "잘못된 접근입니다. \n다시 로그인 해주시기 바랍니다.";

			result.put("ResultCode", "100");
			result.put("Data", Msg);

			return result;
		}
		
		//request withdraw 조회
		List<withdrawVO> withdraw_request_chk = sqlSession.selectList("wallet.getWithdrawAlarm");
		
		if ( withdraw_request_chk == null || withdraw_request_chk.size() == 0) {
			
			String Msg = "";
			result.put("ResultCode", "1");
			result.put("Data", Msg);
			
			return result;
		}
		
		String Msg = String.valueOf(withdraw_request_chk.size());
		result.put("ResultCode", "0");
		result.put("Data", Msg);
		
		return result;
	}
	
	//출금요청 -> 입출금내역 페이지
	@RequestMapping(value = "/ADM/reqWithdrawalList_page/{COIN_NUM}/{MEMBER_NUM}", method = RequestMethod.GET)
	public String reqWithdrawalList_page(HttpSession session, Model model,@RequestParam HashMap<String, String> map, @PathVariable("COIN_NUM") int COIN_NUM, @PathVariable("MEMBER_NUM") int MEMBER_NUM) {

		model.addAttribute("COIN_NUM", COIN_NUM);
		model.addAttribute("MEMBER_NUM", MEMBER_NUM);
		
		if ((adminVO) session.getAttribute("ADMIN_MEMBER_NUM") == null) {
			return "/admin/loginPage";
		}

		return "/admin/request_withdraw/req_withdrawal_list";
	}
	
	//출금 요청 -> 입출금내역 리스트
	@RequestMapping(value = "/ADM/reqWithdrawalList_data/{COIN_NUM}/{MEMBER_NUM}", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> reqWithdrawalList_data(HttpSession session, Model model,@RequestParam HashMap<String, String> map, @PathVariable("COIN_NUM") int COIN_NUM, @PathVariable("MEMBER_NUM") int MEMBER_NUM) {
		withdrawVO withvo = new withdrawVO();
		
		withvo.setCOIN_NUM(COIN_NUM);
		withvo.setMEMBER_NUM(MEMBER_NUM);
		
		List<withdrawVO> withdrawalList = sqlSession.selectList("wallet.getReqWithdrawalList", withvo);

		if (withdrawalList == null) {
			return null;
		}

		HashMap<String, Object> result = new HashMap<String, Object>();

		result.put("draw", 1);
		result.put("data", withdrawalList);
		return result;
	}
}
