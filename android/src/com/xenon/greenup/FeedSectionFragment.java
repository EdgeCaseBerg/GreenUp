package com.xenon.greenup;

import java.util.ArrayList;

import com.xenon.greenup.api.APIServerInterface;
import com.xenon.greenup.api.Comment;
import com.xenon.greenup.api.CommentPage;

import android.support.v4.app.ListFragment;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class FeedSectionFragment extends ListFragment {
	private final APIServerInterface api = new APIServerInterface();
	private int lastPageLoaded = 1;
	private ArrayList<Comment> comments = new ArrayList<Comment>(60); // Default to having enough space for 3 spaces  

	public FeedSectionFragment(){
	}
	
	public void onCreate(Bundle bundle){
		super.onCreate(bundle);
		CommentPage cp = api.getComments(null,lastPageLoaded );
		this.comments = cp.getCommentsList();
		//Set the adapter
		Activity currentActivity = getActivity();
		//If we have no internet then we will get nothing back from the api
		if(this.comments == null)
			this.comments = new ArrayList<Comment>(60);
		
		//Do feed rendering async or else it will take orders of magnitude longer to render
		new ASYNCLoadTask(this,currentActivity,this.comments).execute();
	}
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, 
        Bundle savedInstanceState) {
    	
        return inflater.inflate(R.layout.feed, container, false);
    }
    
private class ASYNCLoadTask extends AsyncTask<Void,Void,Integer>{
		
		private final Activity act;
		private final ArrayList<Comment> cmts;
		private final FeedSectionFragment fsf;
		
		//Constructor for GET requests
		public ASYNCLoadTask(FeedSectionFragment fsf, Activity a, ArrayList<Comment> c) {
			//apparently I've jumped back to 1982 when variable length matters
			this.act = a;
			this.cmts = c;
			this.fsf = fsf;
		}
		
		@Override
		protected Integer doInBackground(Void...voids) {
			this.fsf.setListAdapter(new CommentAdapter(this.act,this.cmts));
			return 0;
		}
	}

}