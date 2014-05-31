package com.xenon.greenup.api;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class CommentPage {
	
	private ArrayList<Comment> commentsList;
	private String nextPage;
	private String prevPage;
	
	
	public CommentPage(String jsonString) {
		int i;
		JSONObject object,pageInfo;
		JSONArray comments;
		//Log.i("comment json",jsonString);
		this.commentsList = new ArrayList<Comment>();
		try {
			object = new JSONObject(jsonString);
			pageInfo = object.getJSONObject("page");
			this.prevPage = pageInfo.getString("previous");
			this.nextPage = pageInfo.getString("next");
			Log.i("prevPage",this.prevPage);
			Log.i("nextPage",this.nextPage);
			comments = object.getJSONArray("comments");
			for (i = 0; i < comments.length(); i++){
				this.commentsList.add(new Comment(comments.getString(i)));
				/*
				Log.i("id",Integer.toString(commentsList.get(i).getId()));
				Log.i("type",commentsList.get(i).getType());
				Log.i("message",commentsList.get(i).getMessage());
				Log.i("timestamp",commentsList.get(i).getTimestamp());
				Log.i("pin",Integer.toString(commentsList.get(i).getPin()));
				*/
			}
		}
		catch (JSONException e){
			//No internet causes the string returned to be invalid
			e.printStackTrace();
		}
	}
	
	/**
	 * @return the commentsList
	 */
	public ArrayList<Comment> getCommentsList() {
		return commentsList;
	}
	
	public ArrayList<Comment> getCommentsList(boolean includeForum, boolean includeGeneral, boolean includeTrash) {
		String commentType;
		ArrayList<Comment> filteredList = new ArrayList<Comment>();
		for (int i = 0; i < commentsList.size(); i++) {
			commentType = commentsList.get(i).getType();
			if (commentType.equals("COMMENT") && includeForum)
				filteredList.add(commentsList.get(i));
			if (commentType.equals("ADMIN") && includeGeneral)
				filteredList.add(commentsList.get(i));
			if (commentType.equals("MARKER") && includeTrash)
				filteredList.add(commentsList.get(i));
		}
		return filteredList;
	}
	/**
	 * @param commentsList the commentsList to set
	 */
	public void setCommentsList(ArrayList<Comment> commentsList) {
		this.commentsList = commentsList;
	}
	/**
	 * @return the nextPage
	 */
	public String getNextPage() {
		return nextPage;
	}
	/**
	 * @param nextPage the nextPage to set
	 */
	public void setNextPage(String nextPage) {
		this.nextPage = nextPage;
	}
	/**
	 * @return the prevPage
	 */
	public String getPrevPage() {
		return prevPage;
	}
	/**
	 * @param prevPage the prevPage to set
	 */
	public void setPrevPage(String prevPage) {
		this.prevPage = prevPage;
	}
	
	
	
}