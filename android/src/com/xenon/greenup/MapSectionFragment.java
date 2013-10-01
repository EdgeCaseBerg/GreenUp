package com.xenon.greenup;

import java.util.ArrayList;

import android.content.Context;
import android.location.LocationManager;
import android.os.AsyncTask;
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
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.xenon.greenup.api.APIServerInterface;
import com.xenon.greenup.api.Heatmap;
import com.xenon.greenup.api.Pin;
import com.xenon.greenup.api.PinList;

public class MapSectionFragment extends Fragment {
	
	private MapView mMapView;
	private GoogleMap map;
	private Bundle bundle;
	private LocationManager mLocationManager;
	private Heatmap heatmap;
	private PinList pins;
	private ArrayList<Marker> markers;
	
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

        mMapView = (MapView)inflatedView.findViewById(R.id.map);
        mMapView.onCreate(bundle);
        map = mMapView.getMap();
        mLocationManager = (LocationManager)getActivity().getSystemService(Context.LOCATION_SERVICE);
        
        //center the camera, use the default coordinates and zoom for now
        CameraUpdate center = CameraUpdateFactory.newLatLng(new LatLng(DEFAULT_LAT,DEFAULT_LON));
        CameraUpdate zoom = CameraUpdateFactory.zoomTo(DEFAULT_ZOOM);
        map.moveCamera(center);
        map.moveCamera(zoom);
        
        markers = new ArrayList<Marker>();
        
        return inflatedView;
    }
    
    @Override
    public void onResume() {
    	super.onResume();
    	mMapView.onResume();
    	new AsyncPinLoadTask(this).execute();
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
    
    private class AsyncPinLoadTask extends AsyncTask<Void,Void,Void> {
		private final MapSectionFragment fragment;
		
		public AsyncPinLoadTask(MapSectionFragment fragment) {
			this.fragment = fragment;
		}
		
		@Override
		protected Void doInBackground(Void...voids) {
			this.fragment.pins = APIServerInterface.getPins(null,null,null,null);
			return null;
		}
		
		@Override
		protected void onPostExecute(Void v) {
			//draw the pins on the map
			drawPins();
		}
    }
    
    private void drawPins() {
    	Marker newMarker;
    	LatLng coords;
    	MarkerOptions options;
    	String pinType,pinMessage;
    	ArrayList<Pin> pins = this.pins.getPinList();
    	for(int i = 0; i < pins.size(); i++) {
    		coords = new LatLng(pins.get(i).getLatDegrees(),pins.get(i).getLonDegrees());
    		pinType = pins.get(i).getType();
    		pinMessage = pins.get(i).getMessage();
    		options = new MarkerOptions();
    		options.position(coords);
    		options.snippet(pinMessage);
    		options.title(pinType);
    		options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE));
    		newMarker = map.addMarker(options);
    		markers.add(newMarker);    	
    	}
    }
}