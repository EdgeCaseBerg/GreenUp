package com.xenon.greenup.api;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class Pin {
	
	private double latDegrees;
	private double lonDegrees;
	private String type;
	private String message;
	
	public Pin(String jsonString) {
		JSONObject object;
		try {
			object = new JSONObject(jsonString);
			this.latDegrees = object.getDouble("latDegrees");
			this.lonDegrees = object.getDouble("lonDegrees");
			this.type = object.getString("type");
			this.message = object.getString("message");
		}
		catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public Pin(float latDegrees, float lonDegrees, String type, String message) {
		this.latDegrees = latDegrees;
		this.lonDegrees = lonDegrees;
		this.type = type;
		this.message = message;
	}
	
	/**
	 * @return the latDegrees
	 */
	public double getLatDegrees() {
		return latDegrees;
	}
	/**
	 * @param latDegrees the latDegrees to set
	 */
	public void setLatDegrees(double latDegrees) {
		this.latDegrees = latDegrees;
	}
	/**
	 * @return the lonDegrees
	 */
	public double getLonDegrees() {
		return lonDegrees;
	}
	/**
	 * @param lonDegrees the lonDegrees to set
	 */
	public void setLonDegrees(double lonDegrees) {
		this.lonDegrees = lonDegrees;
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
	
	public JSONObject toJSON() {
		JSONObject json = new JSONObject();
		try {
			json.put("latDegrees",this.latDegrees);
			json.put("lonDegrees",this.lonDegrees);
			json.put("type", this.type);
			json.put("message",this.message);
			Log.i("newPin",json.toString());
			return json;
		}
		catch (JSONException e) {
			e.printStackTrace();
			return json;
		}
	}
}