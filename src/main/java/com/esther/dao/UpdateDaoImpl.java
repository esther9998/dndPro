package com.esther.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.esther.model.ReservationVO;
@Repository
public class UpdateDaoImpl implements UpdateDao{
	@Autowired
	private SqlSession sqlSession;
	
	private static final String Namespace = "updateMapper";

	@Override
	public int updateOne(ReservationVO vo) throws Exception {
		System.out.println("**********"+sqlSession.selectList(Namespace+".updateOne"));
		return sqlSession.update(Namespace+".updateOne");
	}
	
	
	
}
