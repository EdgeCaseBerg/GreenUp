package com.xenon.greenup.api;

import java.util.ArrayList;

public class Heatmap {
	
	private float latDegrees;
	private float latOffset;
	private float lonDegrees;
	private float lonOffset;
	private int precision;
	private ArrayList<HeatmapPoint> pointList;
	
	
	/**
	 * @return the latDegrees
	 */
	public float getLatDegrees() {
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
	public float getLatOffset() {
		return latOffset;
	}
	/**
	 * @param latOffset the latOffset to set
	 */
	public void setLatOffset(float latOffset) {
		this.latOffset = latOffset;
	}
	/**
	 * @return the lonDegrees
	 */
	public float getLonDegrees() {
		return lonDegrees;
	}
	/**
	 * @param lonDegrees the lonDegrees to set
	 */
	public void setLonDegrees(float lonDegrees) {
		this.lonDegrees = lonDegrees;
	}
	/**
	 * @return the lonOffset
	 */
	public float getLonOffset() {
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