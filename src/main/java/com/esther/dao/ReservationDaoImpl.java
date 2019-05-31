package com.esther.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.esther.model.ReservationVO;
@Repository
public class ReservationDaoImpl implements ReservationDao{
	@Autowired
	private SqlSession sqlSession;
	
	private static final String Namespace = "reservationMapper";
	@Override
	public List<ReservationVO> selectAll() throws Exception {
		System.out.println(sqlSession.selectList(Namespace+".selectAll"));
		return sqlSession.selectList(Namespace+".selectAll");
	}
	@Override
	public int insertReserv(ReservationVO vo) throws Exception {
		System.out.println("dat : "+vo);
		//System.out.println(sqlSession.insert(Namespace+".insertReserv"));
		return sqlSession.insert(Namespace+".insertReserv",  vo);
	}
	
}
