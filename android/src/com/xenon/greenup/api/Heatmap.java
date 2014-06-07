package com.xenon.greenup.api;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.google.android.gms.maps.model.LatLng;

public class Heatmap {
	
	//TODO: Maybe just have this extend ArrayList?
	
	private ArrayList<HeatmapPoint> pointList;
	
	public Heatmap(String jsonString) {
		int i;
		JSONObject object;
		JSONArray points;
		this.pointList = new ArrayList<HeatmapPoint>();
		try {
			object = new JSONObject(jsonString);
			points = object.getJSONArray("grid");
			for (i = 0; i < points.length(); i++){
				this.pointList.add(new HeatmapPoint(points.getString(i)));
				//Log.i("lat",Double.toString(pointList.get(i).getLatDegree()));
				//Log.i("lon",Double.toString(pointList.get(i).getLonDegree()));
				//Log.i("time",Double.toString(pointList.get(i).getSecondsWorked()));
			}
		}
		catch (JSONException e){
			e.printStackTrace();
		}
	}
	
	public Heatmap() {
		this.pointList = new ArrayList<HeatmapPoint>();
	}
	
	public void add(HeatmapPoint point) {
		pointList.add(point);
	}

    public ArrayList<LatLng> getAllLatLng() {
        ArrayList<LatLng> list = new ArrayList<LatLng>();
        for (int i = 0; i < this.pointList.size(); i++) {
            list.add(pointList.get(i).getLatLng());
        }
        return list;
    }
	
	public HeatmapPoint get(int i) {
		return pointList.get(i);
	}
	
	public void clear() {
		pointList.clear();
	}
	
	public JSONArray toJSON() {
		JSONArray list = new JSONArray();
		for (int i = 0; i < pointList.size(); i++) {
			list.put(pointList.get(i).toJSON());
		}
		Log.i("pointList",list.toString());
		return list;
	}
}