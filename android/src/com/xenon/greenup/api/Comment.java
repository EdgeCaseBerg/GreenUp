package com.xenon.greenup.api;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class Comment {
	
	private int id;
	private String type; //either "forum", "general" or "trash"
	private String message;
	private String timestamp;
	private long pin;
	
	public Comment(String jsonString) {
		JSONObject object;
		try {
			object = new JSONObject(jsonString);
			this.id = object.getInt("id");
			this.type = object.getString("type");
			this.message = object.getString("message");
			this.timestamp = object.getString("timestamp");
			String pinString = object.getString("pin");
			this.pin = pinString.equals("") ? 0 : Long.parseLong(pinString); //hack
		}
		catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public Comment(String type, String message, int pin) {
		this.type = type;
		this.message = message;
		this.pin = pin;
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
	public long getPin() {
		return pin;
	}
	/**
	 * @param pin the pin to set
	 */
	public void setPin(int pin) {
		this.pin = pin;
	}
	
	public JSONObject toJSON() {
		JSONObject json = new JSONObject();
		try {
			json.put("type",this.type);
			json.put("message",this.message);
			if (this.pin != 0)
				json.put("pin",this.pin);
			//Log.i("newComment",json.toString());
			return json;
		}
		catch (JSONException e) {
			e.printStackTrace();
			return json;
		}
	}
}