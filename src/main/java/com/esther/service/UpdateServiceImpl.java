package com.esther.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Repository;

import com.esther.dao.ReservationDao;
import com.esther.dao.UpdateDao;
import com.esther.dao.UpdateDaoImpl;
import com.esther.model.ReservationVO;
@Repository
public class UpdateServiceImpl  implements UpdateService{
	@Inject
	private UpdateDao dao;

	@Override
	public int updateOne(ReservationVO vo) throws Exception {
		// TODO Auto-generated method stub
		return dao.updateOne(vo);
	}


	
}
