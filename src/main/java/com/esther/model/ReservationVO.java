package com.esther.model;

import java.sql.Date;
import java.sql.Time;

public class ReservationVO {
	
	String reserv_name;
	String reserv_phone;
	String reserv_email;
	Date reserv_date;
	Time reserv_time;
	Date reserv_register;
	String reserv_status;
	
	public String getReserv_name() {
		return reserv_name;
	}
	public void setReserv_name(String reserv_name) {
		this.reserv_name = reserv_name;
	}
	public String getReserv_phone() {
		return reserv_phone;
	}
	public void setReserv_phone(String reserv_phone) {
		this.reserv_phone = reserv_phone;
	}
	public String getReserv_email() {
		return reserv_email;
	}
	public void setReserv_email(String reserv_email) {
		this.reserv_email = reserv_email;
	}
	public Date getReserv_date() {
		return reserv_date;
	}
	public void setReserv_date(Date reserv_date) {
		this.reserv_date = reserv_date;
	}
	public Time getReserv_time() {
		return reserv_time;
	}
	public void setReserv_time(Time reserv_time) {
		this.reserv_time = reserv_time;
	}
	public Date getReserv_register() {
		return reserv_register;
	}
	public void setReserv_register(Date reserv_register) {
		this.reserv_register = reserv_register;
	}
	public String getReserv_status() {
		return reserv_status;
	}
	public void setReserv_status(String reserv_status) {
		this.reserv_status = reserv_status;
	}
	
	@Override
	public String toString() {
		return "Reservation [reserv_name=" + reserv_name + ", reserv_phone=" + reserv_phone + ", reserv_email="
				+ reserv_email + ", reserv_date=" + reserv_date + ", reserv_time=" + reserv_time + ", reserv_register="
				+ reserv_register + ", reserv_status=" + reserv_status + "]";
	}
	
}
