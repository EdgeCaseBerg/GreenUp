package com.xenon.greenup.heatmap;

import android.util.Log;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Tile;
import com.google.android.gms.maps.model.TileProvider;

/*
 * This class provides the requested tiles for the heatmap overlay 
 */
public class HeatmapOverlayProvider implements TileProvider {

	private MapView mapView;
	private GoogleMap map;
	private int height,width;
	
	
	public HeatmapOverlayProvider(MapView view, GoogleMap map) {
		this.mapView = view;
		this.map = map;
		this.height = this.mapView.getHeight();
		this.width = this.mapView.getWidth();
	}
	
	@Override
	public Tile getTile(int x, int y, int zoom) { 
		Log.i("coordinates","x: "+x+" y: "+y);
		LatLngBounds mapPosition = map.getProjection().getVisibleRegion().latLngBounds;
		return NO_TILE;
	}
}