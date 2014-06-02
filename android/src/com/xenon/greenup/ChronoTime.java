package com.xenon.greenup;

/**
 * Created by josh on 6/1/14.
 */
public class ChronoTime{
    public static long secondsWorked = 0;
    public static boolean state = false;
    public static long stoppedTime = 0;

    public ChronoTime(long sw, boolean s, long st){
        secondsWorked = sw;
        state = s;
        stoppedTime = st;
    }
}