package com.esther.dao;

import java.util.List;

import com.esther.model.ReservationVO;
 
 
public interface ReservationDao {
    
    public List<ReservationVO> selectAll() throws Exception;
}
 


