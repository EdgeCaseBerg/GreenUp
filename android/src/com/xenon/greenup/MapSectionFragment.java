package com.xenon.greenup;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;

public class MapSectionFragment extends Fragment {
	
	private MapView mMapView;
	private Bundle bundle;
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, 
        Bundle savedInstanceState) {
        View inflatedView = inflater.inflate(R.layout.map_page, container, false);

        try {
            MapsInitializer.initialize(getActivity());
        } catch (GooglePlayServicesNotAvailableException e) {
            e.printStackTrace();
        	// TODO handle this situation
        }

        mMapView = (MapView) inflatedView.findViewById(R.id.map);
        mMapView.onCreate(bundle);

        return inflatedView;
    }
    
    @Override
    public void onResume() {
    	super.onResume();
    	mMapView.onResume();
    }
    
    @Override
    public void onPause() {
    	super.onPause();
    	mMapView.onPause();
    }
    
    @Override
    public void onDestroy() {
    	super.onDestroy();
    	mMapView.onDestroy();
    
    }
    
    @Override
    public void onLowMemory() {
    	super.onLowMemory();
    	mMapView.onLowMemory();
    }
    
    @Override
    public void onSaveInstanceState(Bundle args) {
    	super.onSaveInstanceState(args);
    	mMapView.onSaveInstanceState(args);
    }
}