package com.xenon.greenup.CleanupActivity;

import java.util.Date;

/**
 * Created by ddcjoshuad on 9/15/13.
 * a single clean up event (single log point)
 */
public class CleanupEvent {
    private Date timestamp;
    private Double lat;
    private Double lon;

    public CleanupEvent(Date eventDate, double lat, double lon){
        this.timestamp = eventDate;
        this.lat = lat;
        this.lon = lon;
    }




}
