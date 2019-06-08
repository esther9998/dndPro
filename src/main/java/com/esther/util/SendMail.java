package com.esther.util;
	import javax.mail.*;
	import javax.mail.internet.InternetAddress;
	import javax.mail.internet.MimeMessage;

import com.esther.model.ReservationVO;

import java.util.Properties;
	public class SendMail {
	    
	    public  String sendmail(ReservationVO vo){
	    	final String username="webtask365";
	    	final String password="qwer123!@";
	    	
	        
	        Properties props = new Properties(); 
	        props.put("mail.smtp.user",username); 
	        props.put("mail.smtp.password", password);
	        props.put("mail.smtp.host", "smtp.gmail.com"); 
	        props.put("mail.smtp.port", "25"); 
	        props.put("mail.debug", "true"); 
	        props.put("mail.smtp.auth", "true"); 
	        props.put("mail.smtp.starttls.enable","true"); 
	        props.put("mail.smtp.EnableSSL.enable","true");
	        props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");   
	        props.setProperty("mail.smtp.socketFactory.fallback", "false");   
	        props.setProperty("mail.smtp.port", "465");   
	        props.setProperty("mail.smtp.socketFactory.port", "465"); 
	    
	        Session session = Session.getInstance(props, new javax.mail.Authenticator() { 
	        protected PasswordAuthentication getPasswordAuthentication() { 
	        return new PasswordAuthentication(username, password); 
	        }});
	        
	        
	        try{
	            Message message = new MimeMessage(session); 
	            message.setFrom(new InternetAddress("webtask365@gmail.com", "웹태스크365 고객서비스 "));
	            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(vo.getReserv_email())); 
	            message.setSubject("Morock booking confirmation ");
	            message.setText("Dear,"   
	       //     message.setContent("Dear, customer"
	            		+ "\n\n Thank you for the booking. "
	            		+ "\n\n The booking detail is here."
	            		+ "\n\n Name :  " +vo.getReserv_name()
	            		+ "\n\n Date : " + vo.getReserv_date()
	            		+ "\n\n Time : "+ vo.getReserv_time()
	            		+ "\n\n Persons : "+ vo.getReserv_persons()
	            		+ "\n\n We looking forward our cutomer taste our meal.");
	            		//+ "text/html; charset=utf-8");//글내용을 html타입 charset설정
	            
	            Transport.send(message); 
	            System.out.println("SEND");
	            
	        } catch(Exception e){
	        	e.printStackTrace();
	        	return "예약확인 이메일 전송 실패 ";
	        }
			return "예약확인 이메일 전송";
	    }    
	    
	}


