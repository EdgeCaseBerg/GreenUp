package com.xenon.greenup.api;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class Pin {
	
	private double latDegrees;
	private double lonDegrees;
	private String type;
	private String message;
	private boolean addressed;
	
	public Pin(String jsonString) {
		JSONObject object;
		try {
			object = new JSONObject(jsonString);
			this.latDegrees = object.getDouble("latDegrees");
			this.lonDegrees = object.getDouble("lonDegrees");
			this.type = object.getString("type");
			this.message = object.getString("message");
			this.addressed = object.getBoolean("addressed");
		}
		catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public Pin(double latDegrees, double lonDegrees, String type, String message, boolean addressed) {
		this.latDegrees = latDegrees;
		this.lonDegrees = lonDegrees;
		this.type = type;
		this.message = message;
		this.addressed = addressed;
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
	 * @return the addressed flag
	 */
	public boolean isAddressed() {
		return this.addressed;
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
			json.put("addressed", this.addressed);
			Log.i("newPin",json.toString());
			return json;
		}
		catch (JSONException e) {
			e.printStackTrace();
			return json;
		}
	}
}