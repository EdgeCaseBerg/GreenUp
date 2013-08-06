package com.xenon.greenup.api;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

public class Heatmap {
	
	private double latDegrees;
	private double latOffset;
	private double lonDegrees;
	private double lonOffset;
	private int precision;
	private ArrayList<HeatmapPoint> pointList;
	
	public Heatmap(String jsonString) {
		int i;
		JSONArray points;
		try {
			points = new JSONArray(jsonString);
			this.pointList = new ArrayList<HeatmapPoint>();
			for (i = 0; i < points.length(); i++){
				this.pointList.add(new HeatmapPoint(points.getString(i)));
				Log.i("lat",Double.toString(pointList.get(i).getLatDegree()));
				Log.i("lon",Double.toString(pointList.get(i).getLonDegree()));
				Log.i("time",Double.toString(pointList.get(i).getSecondsWorked()));
			}
		}
		catch (JSONException e){
			e.printStackTrace();
		}
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
	public void setLatDegrees(float latDegrees) {
		this.latDegrees = latDegrees;
	}
	/**
	 * @return the latOffset
	 */
	public double getLatOffset() {
		return latOffset;
	}
	/**
	 * @param latOffset the latOffset to set
	 */
	public void setLatOffset(double latOffset) {
		this.latOffset = latOffset;
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
	 * @return the lonOffset
	 */
	public double getLonOffset() {
		return lonOffset;
	}
	/**
	 * @param lonOffset the lonOffset to set
	 */
	public void setLonOffset(float lonOffset) {
		this.lonOffset = lonOffset;
	}
	/**
	 * @return the precision
	 */
	public int getPrecision() {
		return precision;
	}
	/**
	 * @param precision the precision to set
	 */
	public void setPrecision(int precision) {
		this.precision = precision;
	}
	/**
	 * @return the pointList
	 */
	public ArrayList<HeatmapPoint> getPointList() {
		return pointList;
	}
	/**
	 * @param pointList the pointList to set
	 */
	public void setPointList(ArrayList<HeatmapPoint> pointList) {
		this.pointList = pointList;
	}
	
	
}