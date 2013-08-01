package com.xenon.greenup.api;

import java.util.ArrayList;

public class PinList {
	
	private float latDegrees;
	private float latOffset;
	private float lonDegrees;
	private float lonOffset;
	private ArrayList<Pin> pinList;
	
	
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
	 * @return the pinList
	 */
	public ArrayList<Pin> getPinList() {
		return pinList;
	}
	/**
	 * @param pinList the pinList to set
	 */
	public void setPinList(ArrayList<Pin> pinList) {
		this.pinList = pinList;
	}
	
	
}
