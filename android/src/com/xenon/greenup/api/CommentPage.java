package com.xenon.greenup.api;

import java.util.ArrayList;

public class CommentPage {
	
	private int pageNum;
	private ArrayList<Comment> commentsList;
	private String nextPage;
	private String prevPage;
	
	
	/**
	 * @return the pageNum
	 */
	public int getPageNum() {
		return pageNum;
	}
	/**
	 * @param pageNum the pageNum to set
	 */
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	/**
	 * @return the commentsList
	 */
	public ArrayList<Comment> getCommentsList() {
		return commentsList;
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