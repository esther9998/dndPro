package com.esther.model;

import java.sql.Date;

public class AdminVO {

	
	int admin_idx;
	String admin_id;
	String admin_pw;
	int admin_lebel;
	String admin_email;
	Date admin_register;
	public int getAdmin_idx() {
		return admin_idx;
	}
	public void setAdmin_idx(int admin_idx) {
		this.admin_idx = admin_idx;
	}
	public String getAdmin_id() {
		return admin_id;
	}
	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}
	public String getAdmin_pw() {
		return admin_pw;
	}
	public void setAdmin_pw(String admin_pw) {
		this.admin_pw = admin_pw;
	}
	public int getAdmin_lebel() {
		return admin_lebel;
	}
	public void setAdmin_lebel(int admin_lebel) {
		this.admin_lebel = admin_lebel;
	}
	public String getAdmin_email() {
		return admin_email;
	}
	public void setAdmin_email(String admin_email) {
		this.admin_email = admin_email;
	}
	public Date getAdmin_register() {
		return admin_register;
	}
	public void setAdmin_register(Date admin_register) {
		this.admin_register = admin_register;
	}
	@Override
	public String toString() {
		return "AdminVO [admin_idx=" + admin_idx + ", admin_id=" + admin_id + ", admin_pw=" + admin_pw
				+ ", admin_lebel=" + admin_lebel + ", admin_email=" + admin_email + ", admin_register=" + admin_register
				+ "]";
	}
	
	
	
}
