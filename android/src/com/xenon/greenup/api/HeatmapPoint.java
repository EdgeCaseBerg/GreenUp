package com.xenon.greenup.api;

import org.json.JSONException;
import org.json.JSONObject;

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
	
	
	
}