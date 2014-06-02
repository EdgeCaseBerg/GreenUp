package com.xenon.greenup.api;

/**
 * Created by josh on 6/1/14.
 */
public class LatLon {
    private final double lat;
    private final double lon;
    public LatLon(double latitude, double longitude){
        this.lat = latitude;
        this.lon = longitude;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        LatLon latLon = (LatLon) o;

        if (Double.compare(latLon.lat, lat) != 0) return false;
        if (Double.compare(latLon.lon, lon) != 0) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        temp = Double.doubleToLongBits(lat);
        result = (int) (temp ^ (temp >>> 32));
        temp = Double.doubleToLongBits(lon);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        return result;
    }
}
