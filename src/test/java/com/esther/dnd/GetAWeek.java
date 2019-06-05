package com.esther.dnd;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class GetAWeek {

	
	//현재 날짜 주차

	 	public static String getWeek(){

	 		Calendar c = Calendar.getInstance();
	 		String week = String.valueOf(c.get(Calendar.WEEK_OF_MONTH));
	 		return week;

	 	}
	 	
	 	public static String getSunday(String yyyy,String mm, String wk){

	 		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
	 		Calendar c = Calendar.getInstance();

	 		int y=Integer.parseInt(yyyy);
	 		int m=Integer.parseInt(mm)-1;
	 		int w=Integer.parseInt(wk);

	 		c.set(Calendar.YEAR,y);
	 		c.set(Calendar.MONTH,m);
	 		c.set(Calendar.WEEK_OF_MONTH,w);
	 		c.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
	 		c.add(c.DATE,7);

	 		return formatter.format(c.getTime());

	 	}

	 	//현재 날짜 일요일

	 	public static String getCurSunday(){

	 		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
	 		Calendar c = Calendar.getInstance();

	 		c.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
	 		c.add(c.DATE,7);
	 		return formatter.format(c.getTime());

	 	}
	 	public static String getCurMonday(){
	 		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
	 		Calendar c = Calendar.getInstance();
	 		c.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
	 		return formatter.format(c.getTime());

	 	}

	public static void main(String[] args) {
		
		String rst = getWeek();
		System.out.println(rst);
		String rst2 = getSunday("2019", "06",rst);
		System.out.println(rst2);
		
		String sunday = getCurSunday();
		System.out.println(sunday);
		
		String monday = getCurMonday();
		System.out.println(monday);
		

		//================================
		Date date = new Date();
		String s1=monday;
		String s2=sunday;
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

		//Date타입으로 변경

		Date d1 = null;
		Date d2 = null;
		try {
			d1 = df.parse( s1 );
			d2 = df.parse( s2 );
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Calendar c1 = Calendar.getInstance();
		Calendar c2 = Calendar.getInstance();

		//Calendar 타입으로 변경 add()메소드로 1일씩 추가해 주기위해 변경
		c1.setTime( d1 );
		c2.setTime( d2 );

		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
		List<String>  list = new ArrayList<String>() ;

		while( c1.compareTo( c2 ) !=1 ){
			//출력
			String strDate = sdf.format(c1.getTime());
			list.add(strDate);
			//시작날짜 + 1 일
			  c1.add(Calendar.DATE, 1);
			}
		}
		
}
