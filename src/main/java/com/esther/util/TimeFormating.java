package com.esther.util;

import java.sql.Time;

public class TimeFormating {

	public static Time transToTime(String bfTime) {
		String newTime  = null;
		System.out.println("============"+ bfTime);
		if(bfTime.contains("am")){
			newTime =  bfTime.replace("am", ":00");
			return Time.valueOf(newTime.toString());
			
		}else if(bfTime.contains("pm")){
			String time = bfTime.replace("pm", ":00");
			String[] arr = time.split(":"); // [00] :[00]: [00]
			int zeroIdx = Integer.valueOf( arr[0])+12; // 00 + 12
			System.out.println("1111111+"+zeroIdx);
			arr[0] =zeroIdx+""; //String으로 변환
			newTime  = arr[0]+":"+arr[1]+":"+arr[2];
			newTime.trim();
			System.out.println(arr[0]+arr[1]+arr[2]);
			System.out.println(newTime);
			return Time.valueOf(newTime.toString());
		}else{
			System.out.println("유효하지 않은 형식입니다.");
		}
		
		return null;
	}
	
}
