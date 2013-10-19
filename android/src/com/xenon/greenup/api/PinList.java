package com.xenon.greenup.api;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class PinList {
	
	private ArrayList<Pin> pinList;
	
	public PinList(String jsonString) {
		int i;
		JSONObject object;
		JSONArray pins;
		//Log.i("json string",jsonString);
		this.pinList = new ArrayList<Pin>();
		try {
			object = new JSONObject(jsonString);
			pins = object.getJSONArray("pins");
			for (i = 0; i < pins.length(); i++){
				this.pinList.add(new Pin(pins.getString(i)));
				//Log.i("lat",Double.toString(pinList.get(i).getLatDegrees()));
				//Log.i("lon",Double.toString(pinList.get(i).getLonDegrees()));
				//Log.i("type",pinList.get(i).getType());
				//Log.i("message",pinList.get(i).getMessage());
				//Log.i("addressed",pinList.get(i).isAddressed());
			}
		}
		catch (JSONException e){
			e.printStackTrace();
		}
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
