package com.esther.dnd;
import java.sql.DriverManager;

import org.junit.Test;

import java.sql.Connection;

public class mariadbTest{

	private static final String DRIVER = "com.mysql.jdbc.Driver";
	private static final String URL = "jdbc:mysql://183.111.199.157:3306/reservation01";
	//jdbc:mysql:주소:포트/DB명
	private static final String USER = "dndex";
	private static final String PW = "sther84!";
	//Root 비밀번호
	
	@Test
	public void testConnection() throws Exception{
		Class.forName(DRIVER);
		try(Connection con = DriverManager.getConnection(URL, USER, PW)){
			System.out.println(con);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}