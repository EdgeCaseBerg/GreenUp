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

import com.xenon.greenup.util.Storage;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.FragmentTransaction;
import android.content.Context;
import android.graphics.Shader.TileMode;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends FragmentActivity {

    TabsAdapter mTabsAdapter;

    /**
     * The {@link ViewPager} that will display the three primary sections of the app, one at a
     * time.
     */
    ViewPager _ViewPager;
    static long secondsWorked = 0L;
    
    @Override
    public void onStop(){
    	super.onStop();
    	//Save secondsWorked
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
        for (int i = 0; i < 3; i++) {
            // Create a tab with text corresponding to the page title defined by the adapter.
            // Also specify this Activity object, which implements the TabListener interface, as the
            // listener for when this tab is selected.
        	
        	ActionBar.Tab tabToAdd = actionBar.newTab();
        	if (i == 0)
                //Set the home page as active since we'll start there:
        		tabToAdd.setIcon(getActiveIcon(i));
        	else
        		tabToAdd.setIcon(getRegularIcon(i));
            mTabsAdapter.addTab(tabToAdd);
            
        }
        
        //Setting the display to custom will push the action bar to the top
        //which gives us more real estate
        actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
        actionBar.show();
        Log.i("visible",""+_ViewPager.VISIBLE);
     
    }	
    
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
    
    private class TabsAdapter extends FragmentPagerAdapter implements ActionBar.TabListener, ViewPager.OnPageChangeListener {
        private final Context mContext;
        private final ActionBar mActionBar;
        private final ViewPager mViewPager;
        private final ArrayList<ActionBar.Tab> mTabs = new ArrayList<ActionBar.Tab>();
        private final ArrayList<Fragment> mFragments = new ArrayList<Fragment>();


        public TabsAdapter(FragmentActivity activity, ViewPager pager) {
            super(activity.getSupportFragmentManager());
            mContext = activity;
            mActionBar = activity.getActionBar();
            mViewPager = pager;
            mViewPager.setAdapter(this);
            mViewPager.setOnPageChangeListener(this);
            mFragments.add(Fragment.instantiate(mContext, HomeSectionFragment.class.getName()));
            mFragments.add(Fragment.instantiate(mContext, MapSectionFragment.class.getName()));
            mFragments.add(Fragment.instantiate(mContext, FeedSectionFragment.class.getName()));
           
        }
        
        public void addTab(ActionBar.Tab tab) {
            tab.setTabListener(this);
            mTabs.add(tab);
            mActionBar.addTab(tab);
            notifyDataSetChanged();
        }

        @Override
        public int getCount() {
            return mTabs.size();
        }

        @Override
        public Fragment getItem(int position) {
            return mFragments.get(position);   
        }

        @Override
        public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        }

        @Override
        public void onPageSelected(int position) {
        	Log.i("onPageSelected","Setting on pageselected ="+position);
            mActionBar.setSelectedNavigationItem(position);
        }

        @Override
        public void onPageScrollStateChanged(int state) {
        }

        @Override
        public void onTabSelected(Tab tab, FragmentTransaction ft) {
    	    
            for (int i=0; i<mTabs.size(); i++) {
            	if (mTabs.get(i) == tab) {
                	Log.i("onTabSelected","Setting i="+i+" to be mViewPager current item");
                    mViewPager.setCurrentItem(i);
                    mTabs.get(i).setIcon(getActiveIcon(i));
                }
                else
                    mTabs.get(i).setIcon(getRegularIcon(i));
            }
        }

        @Override
        public void onTabUnselected(Tab tab, FragmentTransaction ft) {
        }

        @Override
        public void onTabReselected(Tab tab, FragmentTransaction ft) {
        }
            
    }//endtabadapter

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
        }
        
    }
}
