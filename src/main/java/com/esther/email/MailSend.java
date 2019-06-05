package com.conco.concotrade.email;

import java.io.UnsupportedEncodingException;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.MailSender;
import org.springframework.mail.javamail.JavaMailSender;

public class MailSend {
   private JavaMailSender mailSender;
 
   public void setMailSender(JavaMailSender mailSender) {
      this.mailSender = mailSender;
   }
 
   public int sendMail(String sender, String from, String to, String subject, String msg) {

        MimeMessage message = mailSender.createMimeMessage();

        try {
         message.setSubject(subject);
         message.setHeader("content-Type", "text/html; charset=UTF-8");
         message.setHeader("Content-Transfer-Encoding", "quoted-printable");         
         message.setContent(msg, "text/html; charset=UTF-8");
         message.setFrom(new InternetAddress(from, sender, "UTF-8"));
         message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
           mailSender.send(message); 

      } catch (MessagingException e) {
         //e.printStackTrace();
    	  
         return -1;
      } catch (UnsupportedEncodingException e) {
         e.printStackTrace();
         return -1;
      }
       
      return 0;
   }
}