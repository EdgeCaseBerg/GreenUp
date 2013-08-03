package com.xenon.greenup.api;

import org.json.JSONException;
import org.json.JSONObject;

public class Comment {
	
	private int id;
	private String type; //either "forum", "needs" or "message"
	private String message;
	private String timestamp;
	private int pin;
	
	public Comment(String jsonString) {
		JSONObject object;
		try {
			object = new JSONObject(jsonString);
			this.id = object.getInt("id");
			this.type = object.getString("type");
			this.message = object.getString("message");
			this.timestamp = object.getString("timestamp");
			String pinString = object.getString("pin");
			this.pin = pinString.equals("") ? 0 : Integer.parseInt(pinString); //hack
		}
		catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}
	/**
	 * @param message the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
	}
	/**
	 * @return the timestamp
	 */
	public String getTimestamp() {
		return timestamp;
	}
	/**
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}
	/**
	 * @return the pin
	 */
	public int getPin() {
		return pin;
	}
	/**
	 * @param pin the pin to set
	 */
	public void setPin(int pin) {
		this.pin = pin;
	}
	
	
}