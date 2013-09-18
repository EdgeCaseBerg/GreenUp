package com.xenon.greenup;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.xenon.greenup.CleanupActivity.CleanupLogger;

public class HomeSectionFragment extends Fragment implements View.OnClickListener {
    public static CleanupLogger cleanupLogger = CleanupLogger.getInstance();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, 
        Bundle savedInstanceState) {
        Log.v("working", "inflating home section fragment");
        View rootView = inflater.inflate(R.layout.fragment_section_dummy, container, false);
        Button button = (Button)rootView.findViewById(R.id.startStop);
        button.setOnClickListener(this);
        return rootView;
    }

    @Override
    public void onClick(View view) {
        Log.i("startStop", "clicked");
        cleanupLogger.toggleLogging();
        Button clickedButton = (Button) view;
        if(cleanupLogger.isLogging()){
            clickedButton.setText("Stop Cleaning");
        }else{
            clickedButton.setText("Start Cleaning");
        }
    }
}