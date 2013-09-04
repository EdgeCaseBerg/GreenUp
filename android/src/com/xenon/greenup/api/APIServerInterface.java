package com.xenon.greenup.api;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import android.os.AsyncTask;
import android.util.Log;

public final class APIServerInterface {
	
	
	private static final String BASE_URL = "https://greenupapp.appspot.com/api";
	
	//Class to serve as the main interface to the API server
	//The application will invoke methods defined here to perform 
	// the various requests
	
	//TODO: Make it display a toast notification when an exception is thrown
	
	//this isn't strictly necessary, but it'll prevent the class from being instantiated
	private APIServerInterface(){};
	
	//Retrieves a page of comments from the server, the type and page number are optional
	public static CommentPage getComments(String type, int page) {
		if(type == null || type.equals(""))
			return getAllComments(page);
		try {
			type = URLEncoder.encode(type, "UTF-8");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		StringBuilder sb = new StringBuilder(BASE_URL + "/comments?");
		sb.append("type=" + type + "&" + "page=" + page);
		String response = sendRequest(sb.toString());
		return new CommentPage(response);
	}
	
	//Retrieves a page of comments with no regard for the type
	public static CommentPage getAllComments(int page){
		StringBuilder sb = new StringBuilder(); sb.append(BASE_URL).append("/comments?").append("page=").append(page);
		String response = sendRequest(sb.toString());
		return new CommentPage(response);
	}
	
	//Submits a comment (POST), the pin is optional.  Returns an integer status code (codes TBD)
	public static void submitComments(String type, String message, int pin) {
		Comment newComment = new Comment(type, message, pin);
		String data = newComment.toJSON().toString();
		String url = new StringBuilder(BASE_URL + "/comments").toString();
		sendRequestWithData(url,"POST",data);
	}
	
	//Get a list of heatmap points for the specified coordinates, all parameters are optional (??)
	public static Heatmap getHeatmap(float latDegrees, float latOffset, float lonDegrees, float lonOffset, int precision){
		StringBuilder sb = new StringBuilder(BASE_URL + "/heatmap?");
		
		//Wrapper class casting is neccesary to compare to null (damn java)
		if((Float)latDegrees != null) { sb.append(("latDegrees=")).append(latDegrees); }
		if((Float)latOffset != null)  { sb.append("&latOffset=").append(latOffset); }
		if((Float)lonDegrees != null) { sb.append("&lonDegrees=").append(lonDegrees); }
		if((Float)lonOffset != null)  { sb.append("&lonOffset=").append(lonOffset); }
		if((Integer)precision != null)  { sb.append("&precision=").append(precision); }
		//If my oneline if's offend you feel free to change them. If Java was a good language and supported
		//free standing ternary statements I would have used those. But no, it demands an assignment.
		
		String response = sendRequest(sb.toString());
		return new Heatmap(response);
	}
	
	//Submit a heatmap point (PUT)
	public static void updateHeatmap(Heatmap h){
		String data = h.toJSON().toString();
		String url = new StringBuilder(BASE_URL + "/heatmap").toString();
		sendRequestWithData(url,"PUT",data);
	}
	
	//Get a list of pins, all parameters are optional
	public static PinList getPins(float latDegrees, float latOffset, float lonDegrees, float lonOffset){
		StringBuilder sb = new StringBuilder(BASE_URL + "/pins?");
		//Wrapper class casting is neccesary to compare to null (Java is silly like that)
		if((Float)latDegrees != null) { sb.append(("latDegrees=")).append(latDegrees); }
		if((Float)latOffset != null)  { sb.append("&latOffset=").append(latOffset); }
		if((Float)lonDegrees != null) { sb.append("&lonDegrees=").append(lonDegrees); }
		if((Float)lonOffset != null)  { sb.append("&lonOffset=").append(lonOffset); }
		
		String response = sendRequest(sb.toString());
		return new PinList(response);
	}
	
	//Submit a pin (POST)
	public static void submitPin(float latDegrees, float lonDegrees, String type, String message){
		Pin pin = new Pin(latDegrees,lonDegrees,type,message);
		String data = pin.toJSON().toString();
		String url = new StringBuilder(BASE_URL + "/pins").toString();
		sendRequestWithData(url,"PUT",data);		
	}
	
	public static int testConnection(){
		sendRequest(BASE_URL);
		return 0;
	}
	
	private static void sendRequestWithData(String url, String method, String data) {
		APIRequestTask request = new APIRequestTask(url,method,data);
		String response;
		try {
			response = request.get();
		}
		catch (Exception e) {
			e.printStackTrace();
			response = "Error, see stack trace";
		}
		Log.i("response",response);
	}
	
	private static String sendRequest(String url) {
		APIRequestTask request = new APIRequestTask(url);
		String response;
		try {
			response = request.get();
		}
		catch (Exception e) {
			e.printStackTrace();
			response = "Error, see stack trace";
		}
		Log.i("response",response);
		return response;
	}
	
	private static class APIRequestTask {
		
		private String url;
		private String data;
		private String method;
		
		//Constructor for GET requests
		public APIRequestTask(String url) {
			this.url = url;
			this.method = "GET";
		}
		
		//Constructor for POST and PUT requests
		public APIRequestTask(String url,String method,String data) {
			this.url = url;
			this.data = data;
			this.method = method;
		}
		
		//Where the magic happens...
		protected String get() {
			String response;
			URL urlObject;
			try {
				urlObject = new URL(url);
				HttpURLConnection connection = (HttpURLConnection)urlObject.openConnection();
				connection.setRequestMethod(method);
				if (data != null) {
					connection.setDoOutput(true);
					int length = data.length();
					connection.setFixedLengthStreamingMode(length);
					OutputStream out = connection.getOutputStream();
					out.write(data.toString().getBytes());
				}
				InputStreamReader reader = new InputStreamReader(connection.getInputStream());
				StringBuilder sb = new StringBuilder();
				
				int readByte;
				while ((readByte = reader.read()) != -1) {
					sb.append((char)readByte);
				}
				response = sb.toString();
			}
			catch(IOException e) {
				e.printStackTrace();
				response = "Error occurred, see stack trace";
			}
			return response;
		}
	}
}