package com.xenon.greenup;

import java.util.ArrayList;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

import com.xenon.greenup.api.APIServerInterface;
import com.xenon.greenup.api.Comment;
import com.xenon.greenup.api.CommentPage;

public class FeedSectionFragment extends ListFragment {//implements ListView.OnItemClickListener {
	private int lastPageLoaded = 1;
	private EditText editText;
	private Switch forumSwitch, generalSwitch, trashSwitch;
	private boolean forumFilterToggle = false;
	private boolean generalFilterToggle = false;
	private boolean trashFilterToggle = false;
	
	public FeedSectionFragment(){
	}
	
	public void onCreate(Bundle bundle){
		super.onCreate(bundle);
	}
	
    @Override
    /**
     * Called when the android needs to create the view, simply inflates the layout
     */
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    		
    	View rootView = inflater.inflate(R.layout.feed, container, false);
    	editText =  (EditText)rootView.findViewById(R.id.text_entry_comments);
    	editText.setOnEditorActionListener(new OnEditorActionListener() {
    	    @Override
    	    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
    	        boolean handled = false;
    	        if (actionId == EditorInfo.IME_ACTION_SEND) {
    	            //Log.i("text","i send!");
    	            APIServerInterface.submitComments("forum", editText.getText().toString(), 0);
    	            handled = true;
    	        }
    	        return handled;
    	    }
    	});
       	return rootView;
    }
    
    @Override
    public void onResume(){
    	super.onResume();
		new AsyncCommentLoadTask(this,getActivity()).execute();
    }
    
	private class AsyncCommentLoadTask extends AsyncTask<Void,Void,Void>{
		
		private final Activity act;
		private ArrayList<Comment> cmts;
		private final FeedSectionFragment fsf;
		
		/**
		 * AsyncCommentLoadTask is the default constructor to create an asynchronous task
		 * to load the arrayadapter as well as render the view for the comment feed. 
		 * @param fsf An instance of the FeedSectionFragment that the adapter to load from belongs to
		 * @param a The activity which is running the FeedSectionFragment instance
		 * @param c The list of comments which we will bind to an arrayadapter that will populate the feeds view
		 */
		public AsyncCommentLoadTask(FeedSectionFragment fsf, Activity a) {
			//apparently I've jumped back to 1982 when variable length matters
			this.act = a;
			this.fsf = fsf;
		}
		
		@Override
		/**
		 * The actual task to execute when this class is created and execute() is called. 
		 * Sets the list adapter of the FeedSectionFragment to be a CommentAdapter loaded with
		 * the activity stored within the class at construction time with the comments
		 * passed at construction time.
		 */
		protected Void doInBackground(Void...voids) {
	    	CommentPage cp = APIServerInterface.getComments(null,lastPageLoaded );
			this.cmts = cp.getCommentsList();
			if(this.cmts == null)
				this.cmts = new ArrayList<Comment>(60);
			//Java makes no sense. It requires the capital version of Void because there simply
			//must be something returned and you have to use java's bastard children, the wrapper 
			//types instead of primitives because it's an async task. But yet, the primitive
			//keyword null is apparent a Void type (although returning void is wrong). 
			//sense, this makes none.
			return null;
		}
		
		@Override
		protected void onPostExecute(Void v) {
			this.fsf.setListAdapter(new CommentAdapter(this.act,this.cmts));
		}
	}
}