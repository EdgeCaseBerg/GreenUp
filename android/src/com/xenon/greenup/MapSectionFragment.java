package com.xenon.greenup;

import java.util.ArrayList;

import android.content.Context;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Spinner;

import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnMapLongClickListener;
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

public class MapSectionFragment extends Fragment implements OnMapLongClickListener,OnClickListener {
	
	private MapView mMapView;
	private Button submitButton,clearButton;
	private EditText messageEntry;
	private RelativeLayout pinLayout;
	private Spinner typeSelect;
	private GoogleMap map;
	private Bundle bundle;
	private LocationManager mLocationManager;
	private Heatmap heatmap;
	private PinList pins;
	private ArrayList<Marker> markers;
	private boolean submitPinMode;
	
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
        
        //Get references to the pin configuration controls and set listeners
        pinLayout = (RelativeLayout)inflatedView.findViewById(R.id.add_pins_layout);
        submitButton = (Button)inflatedView.findViewById(R.id.pin_submit_button);
        clearButton = (Button)inflatedView.findViewById(R.id.pin_clear_button);
        messageEntry = (EditText)inflatedView.findViewById(R.id.edit_message_text);
        submitButton.setOnClickListener(this);
        clearButton.setOnClickListener(this);
        
        //Populate the spinner with choices
        typeSelect = (Spinner)inflatedView.findViewById(R.id.pin_type_selection);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(getActivity(),
                R.array.pin_types, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        typeSelect.setAdapter(adapter);     
        
        //get a reference to the map and the location service and set the listener for the map
        mMapView = (MapView)inflatedView.findViewById(R.id.map);
        mMapView.onCreate(bundle);
        map = mMapView.getMap();
        map.setOnMapLongClickListener(this);
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

	@Override
	public void onMapLongClick(LatLng coords) {	
	}
	
	@Override
	public void onClick(View view) {
		submitPinMode = !submitPinMode;
		if (submitPinMode)
			pinLayout.setVisibility(View.VISIBLE);
		else
			pinLayout.setVisibility(View.INVISIBLE);
	}
	
    private void drawPins() {
    	ArrayList<Pin> pins = this.pins.getPinList();
    	Pin pin;
    	LatLng coords;
    	for(int i = 0; i < pins.size(); i++) {
    		pin = pins.get(i);
    		coords = new LatLng(pin.getLatDegrees(),pin.getLonDegrees());
    		addMarker(coords,pin.getType(),pin.getMessage());
    	}
    }
    
    //Draws a marker, given the coordinates in a LatLng object, plus the title and message to use
    private void addMarker(LatLng coords,String title,String message) {
    	Marker newMarker;
    	MarkerOptions options;
   		options = new MarkerOptions();
		options.position(coords);
		options.snippet(title);
		options.title(message);
		if(title.equalsIgnoreCase("GENERAL MESSAGE"))
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN));
		else if(title.equalsIgnoreCase("HELP NEEDED"))
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_BLUE));
		else if(title.equalsIgnoreCase("TRASH PICKUP"))
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_YELLOW));
		else
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_BLUE));
		newMarker = map.addMarker(options);
		this.markers.add(newMarker);    	
    }
}