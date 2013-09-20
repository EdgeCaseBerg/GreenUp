package com.xenon.greenup;

import com.xenon.greenup.util.Storage;
import com.xenon.greenup.util.Storage.ChronoTime;

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
	private boolean chronoState =  false; /*  Is the chronometer supposed to be starting in an on or off state*/
	protected static long currentTime = 0;
	
	@Override
	public void onCreate(Bundle bundle){
		super.onCreate(bundle);
	}
	
	@Override
	public void onPause(){
		super.onPause();
    	final Storage database = new Storage( this.getActivity() ); 
    	database.setSecondsWorked( HomeSectionFragment.currentTime, chronoState);
	}
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

    	View rootview = inflater.inflate(R.layout.start_page, container, false);
    	final  ToggleButton startStopButton = (ToggleButton)rootview.findViewById(R.id.start_stop_button );
    	final Chronometer chrono = (Chronometer)rootview.findViewById(R.id.chronometer1);
    	
    	/* The chronometer starts off with a minimal 0:00 timer. Which is great, unless 
    	 * you're going for a uniform look between all applications and really want to 
    	 * have one specific format for all timers. Which we do. So here's the default:
    	 */
    	chrono.setActivated(chronoState);		
    	if(HomeSectionFragment.currentTime == 0){
    		/* current==0  => we should load from the db */
    		final Storage database = new Storage( this.getActivity() );
    		ChronoTime ct = database.getSecondsWorked();
    		
    		chrono.setActivated(ct.state);
    		toggleState = ct.state;
    		if(toggleState){
    			chrono.setBase(ct.stoppedTime);
    			chrono.start();
    			chronoState = true;
    			startStopButton.setBackgroundResource(R.drawable.stop);	
    		}else{
    			chrono.setBase(System.currentTimeMillis()/1000L);
    			chrono.stop();
        		startStopButton.setBackgroundResource(R.drawable.start);
        		chronoState = false;
    		}
    		
    	  	
  			HomeSectionFragment.currentTime = ct.secondsWorked;
  			
    		chrono.setText(getChronoString()); 
    	}else{
    		chrono.setText(getChronoString()); /* Once storage implemented set this accordingly */
    	}
    	
    	startStopButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if(!toggleState) { 
					//We have to do this monkey business because chrono uses the base time
					//to count which means you need to keep track of the pauses themselves.
					if( pauseTime == 0L){
						chrono.setBase(SystemClock.elapsedRealtime());
						chrono.start();
						chronoState = true;
						MainActivity.secondsWorked = 0; /* Or set this from perstence*/
					}else{
						chrono.setBase(chrono.getBase() +  SystemClock.elapsedRealtime() - pauseTime);
						chrono.start();
						chronoState = true;
					}
					startStopButton.setBackgroundResource(R.drawable.stop);
					//Fire off some type of request to start the background gps polling service
					//on a completely seperate thread at the very least.
				} else {  
					startStopButton.setBackgroundResource(R.drawable.start);
					pauseTime = SystemClock.elapsedRealtime();
					MainActivity.secondsWorked += chrono.getBase() + SystemClock.elapsedRealtime() - pauseTime;
					chrono.stop();
					chronoState = false;
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
	            Log.i("time","Is this still beating on the map page? " + HomeSectionFragment.currentTime);
	            HomeSectionFragment.currentTime = getChronoTime(chronometer.getText().toString());
	        }
	    });

        return rootview;
    }
    
	public long getChronoTime(String timeForm){
		//The chronometer doesn't actually have a 'getTime' function. So here's one
		String[] pieces = timeForm.split(":");
	
		long t=0;
		for(int i= pieces.length-1; i >= 0; i-- ){
			try{
				long temp = Long.parseLong(pieces[i]);
				t += temp * (temp == 0  ? 0 :  Math.pow(60,pieces.length - i -1)); 
			}catch(Exception e){
				//Fuck off chronometer for being a piece of shit that doesn't work! 
				//What do we got?
				Log.i("stupidChrono:",pieces[i]);
			}
		}
		return t;
	}
	
	public String getChronoString(){
		long hours = HomeSectionFragment.currentTime/3600;
		long minutes = HomeSectionFragment.currentTime/60 - hours*60;
		long seconds = HomeSectionFragment.currentTime - minutes*60 - hours*3600;
		StringBuilder sb = new StringBuilder();
		sb.append(hours > 10 ? "" : "0").append(hours).append(":");
		sb.append(minutes > 10 ? "" : "0").append(minutes).append(":");
		sb.append(seconds > 10 ? "" : "0").append(seconds);
		Log.i("getChronoString",sb.toString());
		return sb.toString();
	}

}