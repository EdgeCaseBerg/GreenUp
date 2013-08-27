package com.xenon.greenup;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ToggleButton;

public class HomeSectionFragment extends Fragment {
	private boolean toggleState = false;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

    	View rootview = inflater.inflate(R.layout.start_page, container, false);
    	final  ToggleButton startStopButton = (ToggleButton)rootview.findViewById(R.id.start_stop_button );

    	startStopButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				if(!toggleState) {  
					startStopButton.setBackgroundResource(R.drawable.stop);
					//Fire off some type of request to start the background gps polling service
					//on a completely seperate thread at the very least.
				} else {  
					startStopButton.setBackgroundResource(R.drawable.start);
				}
				toggleState = !toggleState;
				
			}
		});

        return rootview;
    }

}