package com.xenon.greenup;

import android.content.Context;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Spinner;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnMapClickListener;
import com.google.android.gms.maps.GoogleMap.OnMapLongClickListener;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.TileOverlay;
import com.google.android.gms.maps.model.TileOverlayOptions;
import com.google.maps.android.heatmaps.HeatmapTileProvider;
import com.xenon.greenup.api.APIServerInterface;
import com.xenon.greenup.api.Heatmap;
import com.xenon.greenup.api.HeatmapPoint;
import com.xenon.greenup.api.Pin;
import com.xenon.greenup.api.PinList;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

//import com.google.maps.android.heatmaps.HeatmapTileProvider;

public class MapSectionFragment extends Fragment implements OnMapLongClickListener,OnClickListener,OnItemSelectedListener, OnMapClickListener {
	
	private MapView mMapView;
	private Button submitButton,clearButton,testButton;
	private EditText messageEntry;
	private RelativeLayout pinLayout;
	private Spinner typeSelect;
	private GoogleMap map;
	private TileOverlay heatmapOverlay;
    private HeatmapTileProvider tileProvider;
	private Bundle bundle;
	private LocationManager mLocationManager;
	private Heatmap serverData,testData;
	private PinList pins; //list of pins from the server, pins only added once they're submitted
	private ArrayList<Marker> markers; //references to the map markers representing pins
	private Marker newMarker; //reference to the most recently added marker
	private boolean submitPinMode; //controls whether the additional buttons and stuff are displayed
	private String currentType = "ADMIN"; //the type that is currently selected in the spinner
	
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        //Get references to the pin configuration controls and set listeners
        pinLayout = (RelativeLayout)inflatedView.findViewById(R.id.add_pins_layout);
        submitButton = (Button)inflatedView.findViewById(R.id.pin_submit_button);
        clearButton = (Button)inflatedView.findViewById(R.id.pin_clear_button);
        testButton = (Button)inflatedView.findViewById(R.id.push_points);
        typeSelect = (Spinner)inflatedView.findViewById(R.id.pin_type_selection);
        messageEntry = (EditText)inflatedView.findViewById(R.id.edit_message_text);
        pinLayout.setVisibility(View.INVISIBLE);
        submitButton.setOnClickListener(this);
        clearButton.setOnClickListener(this);
        testButton.setOnClickListener(this);
        typeSelect.setOnItemSelectedListener(this);
        
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
        if(map != null) {
            map.setOnMapLongClickListener(this);
            map.setOnMapClickListener(this); //for the heatmap testing
            mLocationManager = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);

            //center the camera, use the default coordinates and zoom for now
            CameraUpdate center = CameraUpdateFactory.newLatLng(new LatLng(DEFAULT_LAT, DEFAULT_LON));
            CameraUpdate zoom = CameraUpdateFactory.zoomTo(DEFAULT_ZOOM);
            map.moveCamera(center);
            map.moveCamera(zoom);


            //add the heatmap overlay, for now load in data from the resource
            //String jsonString = getStringFromResource(R.raw.heatmap);
            //testData = new Heatmap(jsonString);


            markers = new ArrayList<Marker>();
        }
        
        return inflatedView;
    }
    
    @Override
    public void onResume() {
    	super.onResume();
    	mMapView.onResume();
    	new AsyncPinLoadTask(this).execute();
        new AsyncHeatmapLoadTask(this).execute();
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

    private class AsyncHeatmapLoadTask extends AsyncTask<Void,Void,Void> {
        private final MapSectionFragment fragment;

        public AsyncHeatmapLoadTask(MapSectionFragment fragment) {
            this.fragment = fragment;
        }

        @Override
        protected Void doInBackground(Void...voids) {
            this.fragment.serverData = APIServerInterface.getHeatmap(null,null,null,null,null,null);
            return null;
        }

        @Override
        protected void onPostExecute(Void v) {
            //draw the heatmap on the map
            drawHeatmap();
        }
    }

	@Override
	public void onMapLongClick(LatLng coords) {
		if (!submitPinMode) {
			addMarker(coords,"","");
			this.newMarker.setDraggable(true);
			pinLayout.setVisibility(View.VISIBLE);
			submitPinMode = true;
		}
	}
	
	@Override
	public void onClick(View view) {
		if (view == submitButton) {
			double lat,lon;
			lat = newMarker.getPosition().latitude;
			lon = newMarker.getPosition().longitude;
			String message = messageEntry.getText().toString();
			newMarker.setSnippet(message);
			newMarker.setTitle(this.currentType);
			APIServerInterface.submitPin(lat,lon,this.currentType, message,false);
			newMarker.setDraggable(false);
		}
		else if(view == testButton){
			APIServerInterface.updateHeatmap(testData);
			testData.clear();
		}
		else { //reset everything
			messageEntry.setText("");
			this.currentType = "General Message";
			removeMarker(this.markers.size() - 1);
		}
		pinLayout.setVisibility(View.INVISIBLE);
		submitPinMode = false;
	}
	
	@Override
    public void onItemSelected(AdapterView<?> parent, View view, 
            int pos, long id) {
    	this.currentType = parent.getItemAtPosition(pos).toString();
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {
    }

    private void drawHeatmap() {
        ArrayList<LatLng> points = this.serverData.getAllLatLng();
        tileProvider = new HeatmapTileProvider.Builder().data(points).build();
        heatmapOverlay = map.addTileOverlay(new TileOverlayOptions().tileProvider(tileProvider));
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
		options.snippet(message);
		options.title(title);
		if(title.equalsIgnoreCase("ADMIN"))
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN));
		else if(title.equalsIgnoreCase("MARKER"))
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_BLUE));
		else if(title.equalsIgnoreCase("COMMENT"))
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_YELLOW));
		else
			options.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED));
		newMarker = map.addMarker(options);
		this.newMarker = newMarker;
		this.markers.add(newMarker);    	
    }
    
    //removes a marker and all references to it
    private void removeMarker(int i) {
    	this.markers.get(i).remove();
    	this.markers.remove(i);
    	this.newMarker = null;
    }

    //Add a heatmap point to the testData list when the map area is clicked, for testing only
	@Override
	public void onMapClick(LatLng pos) {
		testData.add(new HeatmapPoint(pos.latitude,pos.longitude,60));
		Log.i("testPoint","Added new test point"+pos.toString());
	}

    private String getStringFromResource(int id) {
        String res;
        StringBuilder sb = new StringBuilder();
        int readByte;
        InputStream in = getResources().openRawResource(id);
        try {
            while ((readByte = in.read()) != -1) {
                sb.append((char)readByte);
            }
            res = sb.toString();
        }
        catch (IOException e) {
            e.printStackTrace();
            res = "";
        }
        return res;
    }
}