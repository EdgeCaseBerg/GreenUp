package com.xenon.greenup;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Chronometer;
import android.widget.CompoundButton;
import android.widget.ToggleButton;

public class HomeSectionFragment extends Fragment {
	private boolean toggleState = false;
	private long pauseTime = 0L;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

    	View rootview = inflater.inflate(R.layout.start_page, container, false);
    	final  ToggleButton startStopButton = (ToggleButton)rootview.findViewById(R.id.start_stop_button );
    	final Chronometer chrono = (Chronometer)rootview.findViewById(R.id.chronometer1);
    	
    	startStopButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if(!toggleState) { 
					//We have to do this monkey business because chrono uses the base time
					//to count which means you need to keep track of the pauses themselves.
					if( pauseTime == 0L){
						chrono.setBase(SystemClock.elapsedRealtime());
						chrono.start();
					}else{
						chrono.setBase(chrono.getBase() +  SystemClock.elapsedRealtime() - pauseTime);
						chrono.start();
					}
					startStopButton.setBackgroundResource(R.drawable.stop);
					//Fire off some type of request to start the background gps polling service
					//on a completely seperate thread at the very least.
				} else {  
					startStopButton.setBackgroundResource(R.drawable.start);
					pauseTime = SystemClock.elapsedRealtime();
					chrono.stop();
				}
				toggleState = !toggleState;
				
			}
		});

        return rootview;
    }

}