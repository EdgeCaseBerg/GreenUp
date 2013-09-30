package com.xenon.greenup;

import java.util.ArrayList;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.widget.DrawerLayout.DrawerListener;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;
import android.widget.Toast;

import com.xenon.greenup.api.APIServerInterface;
import com.xenon.greenup.api.Comment;
import com.xenon.greenup.api.CommentPage;

public class FeedSectionFragment extends ListFragment implements DrawerListener, OnCheckedChangeListener{
	private int lastPageLoaded = 1;
	private DrawerLayout drawer;
	private EditText editText;
	private Switch forumSwitch, generalSwitch, trashSwitch;
	private boolean forumFilterToggle = true;
	private boolean generalFilterToggle = true;
	private boolean trashFilterToggle = true;
	private CommentPage page;
	
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
    	//initialize the drawer listener
    	
    	drawer = (DrawerLayout)rootView.findViewById(R.id.comment_feed);
    	drawer.setDrawerListener(this);
    	
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
    	
    	//initialize the toggle switches
    	forumSwitch = (Switch)rootView.findViewById(R.id.forum_switch);
    	generalSwitch = (Switch)rootView.findViewById(R.id.general_switch);
    	trashSwitch = (Switch)rootView.findViewById(R.id.trash_switch);
		forumSwitch.setChecked(forumFilterToggle);
		generalSwitch.setChecked(generalFilterToggle);
		trashSwitch.setChecked(trashFilterToggle);
		forumSwitch.setOnCheckedChangeListener(this);
		generalSwitch.setOnCheckedChangeListener(this);
		trashSwitch.setOnCheckedChangeListener(this);
       	
    	return rootView;
    }
    
    @Override
    public void onResume(){
    	super.onResume();
    	//if we have a network connection, load the comments from the server
    	
    	if (((MainActivity)getActivity()).isConnected()) { //lisp programmer lost his way....
    		drawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
    		AsyncCommentLoadTask task = new AsyncCommentLoadTask(this,getActivity());
    		task.execute();
    	}
    	else {
    		Toast.makeText(getActivity(), "No network connection :(", Toast.LENGTH_SHORT).show();
    	}
    }
    
	private class AsyncCommentLoadTask extends AsyncTask<Void,Void,Void>{
		
		private final Activity act;
		private ArrayList<Comment> cmts;
		private final FeedSectionFragment fsf;
		private CommentPage page;
		
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
	    	CommentPage cp = APIServerInterface.getComments(null,lastPageLoaded);
	    	this.page = cp;
			this.cmts = this.page.getCommentsList(forumFilterToggle,generalFilterToggle,trashFilterToggle);
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
			this.fsf.page = page;
			drawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
		}
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		if (buttonView == forumSwitch)
			forumFilterToggle = isChecked;
		if (buttonView == generalSwitch)
			generalFilterToggle = isChecked;
		if (buttonView == trashSwitch)
			trashFilterToggle = isChecked;
	}

	@Override
	public void onDrawerClosed(View arg0) {
		ArrayList<Comment> comments = this.page.getCommentsList(forumFilterToggle,generalFilterToggle,trashFilterToggle);
		this.setListAdapter(new CommentAdapter(getActivity(),comments));
	}

	@Override
	public void onDrawerOpened(View view) {
	}

	@Override
	public void onDrawerSlide(View view, float offset) {
	}

	@Override
	public void onDrawerStateChanged(int state) {
	}
}