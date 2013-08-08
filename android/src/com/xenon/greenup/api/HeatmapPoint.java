package com.xenon.greenup.api;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class HeatmapPoint {
	private double latDegrees;
	private double lonDegrees;
	private int secondsWorked;
	
	public HeatmapPoint(String jsonString) {
		JSONObject object;
		try {
			object = new JSONObject(jsonString);
			this.latDegrees = object.getDouble("latDegrees");
			this.lonDegrees = object.getDouble("lonDegrees");
			this.secondsWorked = object.getInt("secondsWorked");
		}
		catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	public HeatmapPoint(double latDegrees, double lonDegrees, int secondsWorked) {
		this.latDegrees = latDegrees;
		this.lonDegrees = lonDegrees;
		this.secondsWorked = secondsWorked;
	}
	
	/**
	 * @return the latDegree
	 */
	public double getLatDegree() {
		return latDegrees;
	}
	/**
	 * @param latDegree the latDegree to set
	 */
	public void setLatDegree(double latDegree) {
		this.latDegrees = latDegree;
	}
	/**
	 * @return the lonDegree
	 */
	public double getLonDegree() {
		return lonDegrees;
	}
	/**
	 * @param lonDegree the lonDegree to set
	 */
	public void setLonDegree(double lonDegree) {
		this.lonDegrees = lonDegree;
	}
	/**
	 * @return the secondsWorked
	 */
	public int getSecondsWorked() {
		return secondsWorked;
	}
	/**
	 * @param secondsWorked the secondsWorked to set
	 */
	public void setSecondsWorked(int secondsWorked) {
		this.secondsWorked = secondsWorked;
	}
	public JSONObject toJSON() {
	JSONObject json = new JSONObject();
		try {
			json.put("latDegrees",this.latDegrees);
			json.put("lonDegrees",this.lonDegrees);
			json.put("secondsWorked",this.secondsWorked);
			Log.i("newPoint",json.toString());
			return json;
		}
		catch (JSONException e) {
			e.printStackTrace();
			return json;
		}
	}
}