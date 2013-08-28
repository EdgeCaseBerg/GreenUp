/*
 * Copyright 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.xenon.greenup;

import java.util.ArrayList;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Context;
import android.graphics.Shader.TileMode;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import com.xenon.greenup.api.APIServerInterface;
import com.xenon.greenup.api.Heatmap;
import com.xenon.greenup.api.HeatmapPoint;

public class MainActivity extends FragmentActivity implements ActionBar.TabListener {

    TabsAdapter mTabsAdapter;

    /**
     * The {@link ViewPager} that will display the three primary sections of the app, one at a
     * time.
     */
    ViewPager _ViewPager;
    
    /**
     * getRegularIcon returns the resource id of the icon image for the actionbar tabs.
     * @param index
     * @return The drawable resource id of the image.
     */
    private int getRegularIcon(int index){
    	switch(index){
		case 1:
			return R.drawable.map;
		case 2:
			return R.drawable.comments;
		case 0:
		default:
			return R.drawable.home;
    	}
    }
    
    /**
     * getActiveIcon returns the resource id of the icon image for an active actionbar tab
     * @param index
     * @return The drawable resource id of the active icon
     */
    private int getActiveIcon(int index){
    	switch(index){
		case 1:
			return R.drawable.map_active;
		case 2:
			return R.drawable.comments_active;	
		case 0:
		default:
			return R.drawable.home_active;
    	}
    }
    
    /**
     * sets the actionbar tab icon at position iconToActivate to active.
     * @param iconToActivate The position of the ActionBar.Tab that will be activated
     */
    private void setIconActive(int iconToActivate){
    	final ActionBar actionBar = getActionBar();
    	final ActionBar.Tab tab = actionBar.getTabAt(iconToActivate);
    	
    	tab.setIcon(getActiveIcon(iconToActivate));
    	//Set the other tabs to inactive
    	for(int i=0; i <  3; i++){
    		if(i != iconToActivate){
    			actionBar.getTabAt(i).setIcon(getRegularIcon(i));
    		}
    	}
    	
    	
    }

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Set up the action bar.
        final ActionBar actionBar = getActionBar();
        
        // Specify that the Home/Up button should not be enabled, since there is no hierarchical parent.
        actionBar.setHomeButtonEnabled(false);
        
        //Set the stacked background otherwise we get the gross dark gray color under the icon
        BitmapDrawable background = (BitmapDrawable)getResources().getDrawable(R.drawable.bottom_menu);
        background.setTileModeXY(TileMode.REPEAT,TileMode.MIRROR);
        actionBar.setStackedBackgroundDrawable(background);
        

        // Specify that we will be displaying tabs in the action bar.
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        actionBar.setIcon(R.drawable.bottom_menu);
        
        _ViewPager = (ViewPager) findViewById(R.id.pager);
        mTabsAdapter = new TabsAdapter(this, _ViewPager);
        
        
        // For each of the sections in the app, add a tab to the action bar.
        for (int i = 0; i <  3 && actionBar.getTabCount() < 3 ; i++) {
            // Create a tab with text corresponding to the page title defined by the adapter.
            // Also specify this Activity object, which implements the TabListener interface, as the
            // listener for when this tab is selected.
        	
        	ActionBar.Tab tabToAdd = actionBar.newTab();
        	
        	tabToAdd.setTabListener(this);
        	tabToAdd.setIcon(getRegularIcon(i));
    
            mTabsAdapter.addTab(tabToAdd,Fragment.class, null);
            
        }
        //Set the home page as active since we'll start there:
        this.setIconActive(0);
        
        // Set up the ViewPager, attaching the adapter and setting up a listener for when the
        // user swipes between sections.        
        _ViewPager.setAdapter(mTabsAdapter);
        _ViewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                // When swiping between different app sections, select the corresponding tab.
                // We can also use ActionBar.Tab#select() to do this if we have a reference to the
                // Tab.
            	Log.i("position",""+position);
                actionBar.setSelectedNavigationItem(position);
                actionBar.selectTab(actionBar.getTabAt(position));
                setIconActive(position);
                
            }
        });

        
        //Setting the display to custom will push the action bar to the top
        //which gives us more real estate
        actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
        actionBar.show();
        Log.i("visible",""+_ViewPager.VISIBLE);
     
    }	

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    @Override
    public void onTabSelected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
        // When the given tab is selected, switch to the corresponding page in the ViewPager.
    	Log.i("position",""+tab.getPosition());
        _ViewPager.setCurrentItem(tab.getPosition());
    }

    @Override
    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    /**
     * A dummy fragment representing a section of the app, but that simply displays dummy text.
     */
    public static class DummySectionFragment extends Fragment implements OnClickListener {

        public static final String ARG_SECTION_NUMBER = "section_number";

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_section_dummy, container, false);
            Bundle args = getArguments();
            ((TextView) rootView.findViewById(android.R.id.text1)).setText(
                    getString(R.string.dummy_section_text, args.getInt(ARG_SECTION_NUMBER)));
            Button button = (Button)rootView.findViewById(R.id.testButton);
            button.setOnClickListener(this);
            return rootView;
        }
        
        public void onClick(View v) {
        	Log.i("button","I was clicked!");
        	//CommentPage page = i.getComments("general message",1);
        	Heatmap h = new Heatmap();
        	h.add(new HeatmapPoint(24.53,43.2,120));
        	APIServerInterface.updateHeatmap(h);
        }
    }
    
    public static class TabsAdapter extends FragmentPagerAdapter
    implements ActionBar.TabListener, ViewPager.OnPageChangeListener {
private final Context mContext;
private final ActionBar mActionBar;
private final ViewPager mViewPager;
private final ArrayList<TabInfo> mTabs = new ArrayList<TabInfo>();

static final class TabInfo {
    private final Class<?> clss;
    private final Bundle args;

    TabInfo(Class<?> _class, Bundle _args) {
        clss = _class;
        args = _args;
    }
}

public TabsAdapter(FragmentActivity activity, ViewPager pager) {
    super(activity.getSupportFragmentManager());
    mContext = activity;
    mActionBar = activity.getActionBar();
    mViewPager = pager;
    mViewPager.setAdapter(this);
    mViewPager.setOnPageChangeListener(this);
}

public void addTab(ActionBar.Tab tab, Class<?> clss, Bundle args) {
    TabInfo info = new TabInfo(clss, args);
    tab.setTag(info);
    tab.setTabListener(this);
    mTabs.add(info);
    mActionBar.addTab(tab);
    notifyDataSetChanged();
}

@Override
public int getCount() {
    return mTabs.size();
}

@Override
public Fragment getItem(int position) {
    TabInfo info = mTabs.get(position);
    switch (position) {
    case 0:
		Fragment home = new HomeSectionFragment();
		return home;
    case 1:
		//TODO: Launch MapSectionFragment
		Fragment map = new MapSectionFragment();
		return map;
	case 2:
		//Fragment feed = new FeedSectionFragment();
	    return Fragment.instantiate(mContext, FeedSectionFragment.class.getName(), info.args);
	default:
        // The other sections of the app are dummy placeholders.
	}
    return Fragment.instantiate(mContext, info.clss.getName(), info.args);
}

@Override
public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
}

@Override
public void onPageSelected(int position) {
    mActionBar.setSelectedNavigationItem(position);
}

@Override
public void onPageScrollStateChanged(int state) {
}

@Override
public void onTabSelected(Tab tab, FragmentTransaction ft) {
    Object tag = tab.getTag();
    for (int i=0; i<mTabs.size(); i++) {
        if (mTabs.get(i) == tag) {
            mViewPager.setCurrentItem(i);
        }
    }
    
}

@Override
public void onTabUnselected(Tab tab, FragmentTransaction ft) {
}

@Override
public void onTabReselected(Tab tab, FragmentTransaction ft) {
}
    
    }
}
