package com.xenon.greenup.util;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.SystemClock;
import android.util.Log;

public class Storage extends SQLiteOpenHelper{
	private static final int DATABASE_VERSION = 1;
	private static final String DATABASE_NAME = "GREENUP";
	private static final String KEY_ID = "pk";
	private static final String SINGLETON_PK = "1";
	private static final String KEY_TIME = "seconds";
	private static final String KEY_CHRONO_STATE = "chronoState";
	private static final String KEY_STOP_TIME = "stopTime";
	private static final String SECONDS_WORKED_TABLE_NAME = "secondsWorked";
	
	public class ChronoTime{
		public long secondsWorked = 0;
		public boolean state = false;
		public long stoppedTime = 0;
		
		public ChronoTime(long sw, boolean s, long st){
			this.secondsWorked = sw;
			this.state = s;
			this.stoppedTime = st;
		}
	}
	
	public Storage(Context context){
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}
	
	public Storage(Context context, boolean deleteDatabase){
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
		context.deleteDatabase(DATABASE_NAME);
	}
	
	public void onCreate(SQLiteDatabase db){
		/*What do we need?
		 *- whether or not the timer should be on. Bool.
		 *- the amount of time worked total. seconds, long.
		 *- the amount of time sent to the server? (no sending to much?)
		 *- the epoch time of pausing (when the app shuts down, save this time
		 *  so that we can compute how much time elapsed between pausing the 
		 *  app and turning it back on, so that we can add secondsWorked while
		 *  
		 */
		String create_table = 	"CREATE TABLE " + SECONDS_WORKED_TABLE_NAME + 
								"(" + KEY_ID + " TEXT PRIMARY KEY," + KEY_TIME + 
								" TEXT," + KEY_CHRONO_STATE  + " INTEGER, " + KEY_STOP_TIME + " TEXT )";
		db.execSQL(create_table);
		
		ContentValues values = new ContentValues();
		/* For now just test persitent time, otherwise we'd be stored a better key here*/
		values.put(KEY_ID, SINGLETON_PK);
		values.put(KEY_TIME, "0");
		values.put(KEY_CHRONO_STATE, 0);
		values.put(KEY_STOP_TIME, String.valueOf(SystemClock.elapsedRealtime()));
		
		db.insert(SECONDS_WORKED_TABLE_NAME, null,values);
		db.close();
	}
	
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion){
		db.execSQL("DROP TABLE IF EXISTS " + SECONDS_WORKED_TABLE_NAME);
		onCreate(db);
		db.close();
	}
	
	
	public void setSecondsWorked(long seconds,boolean onOff){
		SQLiteDatabase db = this.getWritableDatabase();
		
		ContentValues values = new ContentValues();
		/* For now just test persitent time, otherwise we'd be stored a better key here*/
		values.put(KEY_TIME, String.valueOf(seconds));
		values.put(KEY_CHRONO_STATE,  onOff ? 1 : 0 );
		values.put(KEY_STOP_TIME, String.valueOf(SystemClock.elapsedRealtime()));
		Log.i("saveToDB","time: " + seconds + " onOff: " + onOff + " stopTime: " + String.valueOf(SystemClock.elapsedRealtime()));
		db.update(SECONDS_WORKED_TABLE_NAME, values, KEY_ID + "= ?", new String[]{SINGLETON_PK});
		db.close();
	}
	
	public ChronoTime getSecondsWorked(){
		SQLiteDatabase db = this.getReadableDatabase();
		String selectQuery = "SELECT " +  KEY_TIME + "," + KEY_CHRONO_STATE + ", " +  KEY_STOP_TIME + " FROM " + SECONDS_WORKED_TABLE_NAME + " WHERE " + KEY_ID + " = " + SINGLETON_PK;
		Cursor cursor = db.rawQuery(selectQuery,null);
		
		long secWorkd = 0L;
		boolean cState = false;
		long stopped = SystemClock.elapsedRealtime();
		
		if(cursor != null){
			cursor.moveToFirst();
			
			try{
				secWorkd = Long.parseLong(cursor.getString(0));
			}catch(Exception e){/* Die silently and default sw=0*/}
			
			try{
				cState = cursor.getInt(1) == 1 ? true : false;
			}catch(Exception e){/* http://www.youtube.com/watch?v=BX-7BlRc_a0 */}
			
			try{
				stopped = Long.valueOf(cursor.getString(2));
			}catch(Exception e){/* http://www.youtube.com/watch?feature=player_detailpage&v=JWdZEumNRmI#t=50*/}
			cursor.close();
		}
		Log.i("dbLoad","secWorkd: "+secWorkd+" cState: "+cState+" stopped: "+stopped);
		
		
		return new ChronoTime(secWorkd,cState,stopped);
		
	}
	
	public void closeDatabase(Storage database){
		database.close();
	}
	

}