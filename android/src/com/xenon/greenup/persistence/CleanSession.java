package com.xenon.greenup.persistence;

import com.google.android.gms.maps.model.LatLng;
import com.xenon.greenup.api.HeatmapPoint;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by josh on 6/1/14.
 */
public class CleanSession {
    private static Map<LatLng, HeatmapPoint> sessionPoints = new HashMap<LatLng, HeatmapPoint>();
    private static long totalSecondsWorked = 0l;
    private static CleanSession instance = null;
    public static boolean active = false;

    protected CleanSession(){}

    public static Collection<HeatmapPoint> getPoints(){
        return sessionPoints.values();
    }

    public static void updateSession(HeatmapPoint point){
        if(sessionPoints.containsKey(point.getLatLng())){
            HeatmapPoint existing = sessionPoints.get(point);
            existing.setSecondsWorked(
                    existing.getSecondsWorked() + point.getSecondsWorked()
            );
            totalSecondsWorked += existing.getSecondsWorked();
        }else{
            sessionPoints.put(point.getLatLng(), point);
            totalSecondsWorked += point.getSecondsWorked();
        }
    }

    public static boolean isEmpty(){
        return sessionPoints.isEmpty();
    }

    public static CleanSession getInstance() {
        if(instance == null){
            instance = new CleanSession();
            return instance;
        }else{
            return instance;
        }
    }

    public static long getTotalSecondsWorked() {
        return totalSecondsWorked;
    }
}
