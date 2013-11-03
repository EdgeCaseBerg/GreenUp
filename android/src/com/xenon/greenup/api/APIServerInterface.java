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
	//TODO: Refactor
	
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
		if(type != null) {sb.append("type=" + type);}
		if((Integer)page != null) {sb.append("&page=" + page);}
		sb.append("type=" + type + "&" + "page=" + page);
		String response = sendRequest(sb.toString(),"GET");
		return new CommentPage(response);
	}
	
	//Retrieves a page of comments with no regard for the type
	public static CommentPage getAllComments(int page){
		StringBuilder sb = new StringBuilder(); sb.append(BASE_URL).append("/comments?").append("page=").append(page);
		String response = sendRequest(sb.toString(),"GET");
		return new CommentPage(response);
	}
	
	//Submits a comment (POST), the pin is optional.
	public static void submitComment(String type, String message, int pin) {
		Comment newComment = new Comment(type, message, pin);
		String data = newComment.toJSON().toString();
		String url = new StringBuilder(BASE_URL + "/comments").toString();
		sendRequestWithData(url,"POST",data);
	}
	
	//Deletes the comment with the given ID
	public static void deleteComment(int commentID) {
		String url = BASE_URL + "/comments?id=" + commentID;
		String response = sendRequest(url,"DELETE");
	}
	
	//Get a list of heatmap points for the specified coordinates, all parameters are optional (??)
	public static Heatmap getHeatmap(float latDegrees, float latOffset, float lonDegrees, float lonOffset, int precision, boolean raw){
		StringBuilder sb = new StringBuilder(BASE_URL + "/heatmap?");
		
		//Wrapper class casting is neccesary to compare to null (damn java)
		if((Float)latDegrees != null) { sb.append("latDegrees=" + latDegrees); }
		if((Float)latOffset != null)  { sb.append("&latOffset=" + latOffset); }
		if((Float)lonDegrees != null) { sb.append("&lonDegrees=" + lonDegrees); }
		if((Float)lonOffset != null)  { sb.append("&lonOffset=" + lonOffset); }
		if((Integer)precision != null)  { sb.append("&precision=" + precision); }
		if((Boolean)raw != null) {sb.append("&raw="+ raw);}
		//If my oneline if's offend you feel free to change them. If Java was a good language and supported
		//free standing ternary statements I would have used those. But no, it demands an assignment.
		
		String response = sendRequest(sb.toString(),"GET");
		return new Heatmap(response);
	}
	
	//Submit a heatmap point (PUT)
	public static void updateHeatmap(Heatmap h){
		String data = h.toJSON().toString();
		String url = new StringBuilder(BASE_URL + "/heatmap").toString();
		sendRequestWithData(url,"PUT",data);
	}
	
	//Get a list of pins, all parameters are optional
	public static PinList getPins(Double latDegrees, Integer latOffset, Double lonDegrees, Integer lonOffset){
		StringBuilder sb = new StringBuilder(BASE_URL + "/pins?");
		//Wrapper class casting is neccesary to compare to null (Java is silly like that)
		if((Double)latDegrees != null) { sb.append(("latDegrees=")).append(latDegrees); }
		if((Integer)latOffset != null)  { sb.append("&latOffset=").append(latOffset); }
		if((Double)lonDegrees != null) { sb.append("&lonDegrees=").append(lonDegrees); }
		if((Integer)lonOffset != null)  { sb.append("&lonOffset=").append(lonOffset); }

		String response = sendRequest(sb.toString(),"GET");
		return new PinList(response);
	}
	
	//Submit a pin (POST)
	public static void submitPin(double latDegrees, double lonDegrees, String type, String message,boolean addressed){
		Pin pin = new Pin(latDegrees,lonDegrees,type,message,addressed);
		String data = pin.toJSON().toString();
		String url = new StringBuilder(BASE_URL + "/pins").toString();
		sendRequestWithData(url,"POST",data);		
	}
	
	//Set the 'addressed' flag of a pin
	public static void setAddressed(int pinID,boolean addressed) {
		String url = BASE_URL + "/pins?id=" + pinID;
		String data = "{\"adressed\" : " + addressed + "}";
		sendRequestWithData(url,"PUT",data);
	}
	
	//Deletes the pin with the given ID
	public static void deletePin(int pinID) {
		String url = BASE_URL + "/pins?id=" + pinID;
		String response = sendRequest(url,"DELETE");;
	}
	
	public static int testConnection(){
		sendRequest(BASE_URL,"GET");
		return 0;
	}
	
	private static void sendRequestWithData(String url, String method, String data) {
		SubmitTask request = new SubmitTask(url,method,data);
		request.execute();
		String response;
		try {
			response = request.get();
		}
		catch (Exception e) {
			e.printStackTrace();
			response = "Error, see stack trace";
		}
		//Log.i("response",response);
	}
	
	private static String sendRequest(String url, String method) {
		String response;
		try {
			response = HTTPTransaction(url,method,null);
		}
		catch (Exception e) {
			e.printStackTrace();
			response = "Error, see stack trace";
		}
		//Log.i("response",response);
		return response;
	}

	private static class SubmitTask extends AsyncTask<Void,Void,String> {
		
		private String url;
		private String data;
		private String method;
		
		public SubmitTask(String url,String method, String data) {
			this.url = url;
			this.method = method;
			this.data = data;
		}
		
		@Override
		protected String doInBackground(Void...voids) {
			return HTTPTransaction(url,method,data);
		}
	}
	

	
	private static String HTTPTransaction(String url,String method, String data) {
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
			response = "Error, see stack trace";
		}
		Log.i("HTTP response",response);
		return response;
	}
}
