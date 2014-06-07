package com.xenon.greenup.persistence;

<<<<<<< HEAD
import android.widget.Chronometer;

=======
import com.google.android.gms.maps.model.LatLng;
>>>>>>> 93a380a176c2ec4e93ea8a25e39bb024968d6e10
import com.xenon.greenup.api.HeatmapPoint;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by josh on 6/1/14.
 */
public class CleanSession implements Chronometer.OnChronometerTickListener {
    private static Map<LatLon, HeatmapPoint> sessionPoints = new HashMap<LatLon, HeatmapPoint>();
    private static long totalSecondsWorked = 0l;
    private static CleanSession instance = null;
    public static boolean active = false;
    private static Chronometer.OnChronometerTickListener listener;

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

    public static String getTimeWorkedString(){
        String results = "";
        int hours = 00;
        int mins = 00;
        int secs = 00;

        if(totalSecondsWorked == 0){
            return "00:00:00";
        }

        hours = (totalSecondsWorked - ())
    }

    @Override
    public void onChronometerTick(Chronometer chronometer) {
        totalSecondsWorked += 1;
    }
}
