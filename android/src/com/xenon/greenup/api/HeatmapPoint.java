package com.xenon.greenup.api;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

public class HeatmapPoint {
    private final double latDegrees;
    private final double lonDegrees;
    private final LatLon latLon;
    private int secondsWorked;

    public HeatmapPoint(double latDegrees, double lonDegrees){
        this.latDegrees = latDegrees;
        this.lonDegrees = lonDegrees;
        this.latLon = new LatLon(latDegrees, lonDegrees);
    }

    public HeatmapPoint(String jsonString) throws JSONException {
        JSONObject object;
        object = new JSONObject(jsonString);
        this.latDegrees = object.getDouble("latDegrees");
        this.lonDegrees = object.getDouble("lonDegrees");
        this.latLon = new LatLon(lonDegrees,latDegrees);
        this.secondsWorked = object.getInt("secondsWorked");

    }

    public HeatmapPoint(double latDegrees, double lonDegrees, int secondsWorked) {
        this.latDegrees = latDegrees;
        this.lonDegrees = lonDegrees;
        this.latLon = new LatLon(lonDegrees,latDegrees);
        this.secondsWorked = secondsWorked;
    }

    /**
     * @return the latDegree
     */
    public double getLatDegree() {
        return latDegrees;
    }
    /**
     * @return the lonDegree
     */
    public double getLonDegree() {
        return lonDegrees;
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

    public LatLon getLatLon() {
        return latLon;
    }
}