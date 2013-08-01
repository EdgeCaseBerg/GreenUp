package com.xenon.greenup.api;

public class Pin {
	
	private float latDegrees;
	private float lonDegrees;
	private String type;
	private String message;
	
	
	
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
	
	
}