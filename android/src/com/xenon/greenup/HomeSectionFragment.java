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
    	
    	/* The chronometer starts off with a minimal 0:00 timer. Which is great, unless 
    	 * you're going for a uniform look between all applications and really want to 
    	 * have one specific format for all timers. Which we do. So here's the default:
    	 */
    	chrono.setText("00:00:00"); /* Once storage implemented set this accordingly */
    	
    	startStopButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if(!toggleState) { 
					//We have to do this monkey business because chrono uses the base time
					//to count which means you need to keep track of the pauses themselves.
					if( pauseTime == 0L){
						chrono.setBase(SystemClock.elapsedRealtime());
						chrono.start();
						MainActivity.secondsWorked = 0; /* Or set this from perstence*/
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
					MainActivity.secondsWorked += chrono.getBase() + SystemClock.elapsedRealtime() - pauseTime;
					chrono.stop();
				}
				toggleState = !toggleState;
				
			}
		});
    	
    	chrono.setOnChronometerTickListener(new Chronometer.OnChronometerTickListener() {
    		/*Welcome to hell. 
    		 * The chronometer defaults to the minimal number of 0's with a minimum of 3.
    		 * So that means until you hit 10 minutes, your chronometer is just 4 characters 
    		 * long. Which is great unless you DONT want your whole UI to shift around whenever
    		 * someone happens to work a little bit longer. 
    		 */ 
	        public void onChronometerTick(Chronometer chronometer) {
	            CharSequence text = chronometer.getText();
	            if (text.length() == 4) {
	            	chronometer.setText("00:0"+text);
	            }else if (text.length()  == 5) {
	                chronometer.setText("00:"+text);
	            } else if (text.length() == 7) {
	                chronometer.setText("0"+text);
	            }
	            /* This function might be a good place to check for the last time sent
	             * To the heatmap and fire off the async task to do so.
	             * */
	        }
	    });

        return rootview;
    }

}