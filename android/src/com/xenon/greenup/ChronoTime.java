package com.xenon.greenup;

/**
 * Created by josh on 6/1/14.
 */
public class ChronoTime{
    public long secondsWorked = 0;
    public boolean state = false;
    public long stoppedTime = 0;

    public ChronoTime(long sw, boolean s, long st){
        this.secondsWorked = sw;
        this.state = s;
        this.stoppedTime = st;
    }
}