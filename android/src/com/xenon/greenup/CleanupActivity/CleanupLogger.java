package com.xenon.greenup.CleanupActivity;

import android.util.Log;

import java.util.ArrayList;
import java.util.Stack;

/**
 * Created by ddcjoshuad on 9/15/13.
 * Singleton class for maintaining the clean-up logging
 */
public class CleanupLogger {
    private static CleanupLogger logger = new CleanupLogger();
    private Stack<CleanupEvent> eventsList = new Stack<CleanupEvent>();
    private boolean isLogging = false;

    private CleanupLogger(){}

    static public CleanupLogger getInstance(){
        return logger;
    }

    public void toggleLogging(){
        Log.v("cleanup logger", "logging active");
        if(this.isLogging){
            this.isLogging = false;
        }else{
            this.isLogging = true;
        }
    }

    public boolean isLogging(){
        return this.isLogging;
    }


}
