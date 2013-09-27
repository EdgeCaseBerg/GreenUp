package com.xenon.greenup;

import android.content.Context;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.model.LatLng;

public class MapSectionFragment extends Fragment {
	
	private MapView mMapView;
	private GoogleMap map;
	private Bundle bundle;
	private LocationManager mLocationManager;
	
	//Have Montpelier be the default center point for the map
	private final double DEFAULT_LAT = 44.260059;
	private final double DEFAULT_LON = -72.575387;
	private final int DEFAULT_ZOOM = 9;
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, 
        Bundle savedInstanceState) {
        View inflatedView = inflater.inflate(R.layout.map_page, container, false);

        try {
            MapsInitializer.initialize(getActivity());
        } catch (GooglePlayServicesNotAvailableException e) {
            e.printStackTrace();
        }

        mMapView = (MapView) inflatedView.findViewById(R.id.map);
        mMapView.onCreate(bundle);
        map = mMapView.getMap();
        mLocationManager = (LocationManager)getActivity().getSystemService(Context.LOCATION_SERVICE);
        
        //center the camera, use the default coordinates and zoom for now
        CameraUpdate center = CameraUpdateFactory.newLatLng(new LatLng(DEFAULT_LAT,DEFAULT_LON));
        CameraUpdate zoom = CameraUpdateFactory.zoomTo(DEFAULT_ZOOM);
        map.moveCamera(center);
        map.moveCamera(zoom);
        
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