/*
 * 데이터에 넣을 Time형변환.1
 * String을 받아서 Time으로 리턴줌.  
 * 만약 	"3:30 pm" 	>>	 03:30:00
*/
package com.esther.util;

import java.sql.Time;

public class TimeFormating {

	public static Time transToTime(String bfTime) {
		String newTime  = null;

		// 1.빈칸 없애기   
		String  trimTime = bfTime.replaceAll("\\p{Z}", "");
		
		// 2. pm/ am 나누기 
		if(trimTime.contains("am")){
			// 3. am 일때, Time 형으로 변환후 리턴.
			newTime =  trimTime.replace("am", ":00");
			System.out.println(newTime);
			return Time.valueOf(newTime);
			
		}else if(trimTime.contains("pm")){
			// 4. pm 일때,  12pm외에 다른 시간들은 12를 더해준뒤, Time 형으로 변환후 리턴. 
			String time = trimTime.replace("pm", ":00");
			String[] arr = time.split(":"); // [00] :[00]: [00]
			if(arr[0].contains("12")){
				System.out.println(time);
				return Time.valueOf(time);
			}else{
				int zeroIdx = Integer.valueOf(arr[0])+12;     // 00 + 2
				arr[0] =zeroIdx+"";													 //String 형변환    
				newTime  = arr[0]+":"+arr[1]+":"+arr[2];
				System.out.println(newTime);
				return Time.valueOf(newTime);
			}
		}else{
			System.out.println("유효하지 않은 형식입니다.");
		}
		
		return null;
	}
	

}
