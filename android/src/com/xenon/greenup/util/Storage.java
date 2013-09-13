package com.xenon.greenup.util;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class Storage extends SQLiteOpenHelper{
	private static final int DATABASE_VERSION = 1;
	private static final String DATABASE_NAME = "GREENUP";
	private static final String KEY_ID = "secondsWorked";
	private static final String KEY_TIME = "time";
	private static final String KEY_CHRONO_STATE = "chronoState";
	private static final String KEY_STOP_TIME = "stopTime";
	private static final String SECONDS_WORKED_TABLE_NAME = "secondsWorked";
	
	public Storage(Context context){
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
		context.deleteDatabase(DATABASE_NAME);
	}
	
	public void onCreate(SQLiteDatabase db){
		
		String create_table = "CREATE TABLE " + SECONDS_WORKED_TABLE_NAME + "(" + KEY_ID + " TEXT PRIMARY KEY," + KEY_TIME + " TEXT," + KEY_CHRONO_STATE  + " TEXT, " + KEY_STOP_TIME + " STRING )";
		db.execSQL(create_table);
		
		ContentValues values = new ContentValues();
		/* For now just test persitent time, otherwise we'd be stored a better key here*/
		values.put(KEY_ID, "1");
		values.put(KEY_TIME, "00:00:00");
		values.put(KEY_CHRONO_STATE, "OFF");
		values.put(KEY_STOP_TIME, "0");
		
		db.insert(SECONDS_WORKED_TABLE_NAME, null,values);
	}
	
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion){
		db.execSQL("DROP TABLE IF EXISTS " + SECONDS_WORKED_TABLE_NAME);
		onCreate(db);
		
	}
	
	
	public void setSecondsWorked(String formattedTime,boolean onOff){
		SQLiteDatabase db = this.getWritableDatabase();
		
		ContentValues values = new ContentValues();
		/* For now just test persitent time, otherwise we'd be stored a better key here*/
		values.put(KEY_ID, "1");
		values.put(KEY_TIME, formattedTime);
		values.put(KEY_CHRONO_STATE,  onOff ? "ON" : "OFF");
		values.put(KEY_STOP_TIME, String.valueOf(System.currentTimeMillis()/1000L));
		
		db.update(SECONDS_WORKED_TABLE_NAME, values, KEY_ID + "= ?", new String[]{KEY_ID});
		db.close();
	}
	public String[] getSecondsWorked(){
		SQLiteDatabase db = this.getReadableDatabase();
		String selectQuery = "SELECT " +  KEY_TIME + "," + KEY_CHRONO_STATE + ", " +  KEY_STOP_TIME + " FROM " + SECONDS_WORKED_TABLE_NAME + " LIMIT 1";
		Cursor cursor = db.rawQuery(selectQuery,null);
		
		if(cursor != null){
			cursor.moveToFirst();
			return new String[]{cursor.getString(0), cursor.getString(1), cursor.getString(2)};
		}
		return null;
		
	}
	
	/* This is an example from a previous project of mine on how to use the storage*/
	/*public List<Task> getAllTasks(){ 
		List<Task> taskList = new ArrayList<Task>();
		String selectQuery = "SELECT * FROM " + table_name;
		SQLiteDatabase db = this.getWritableDatabase();
		Cursor cursor = db.rawQuery(selectQuery,null);
		
		if(cursor.moveToFirst()){
			do{
				Task task = new Task();
				task.setName(cursor.getString(0));
				task.setTime(cursor.getString(1));
				task.setState(cursor.getString(2));
				taskList.add(task);
			}while(cursor.moveToNext());
		}
		
		return taskList;
		
	}
	
	public int getTaskCount(){
		String sq = "SELECT * FROM " + table_name;
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.rawQuery(sq, null);
		cursor.close();
		return cursor.getCount();
	}
	
	public int updateTask(Task task){
		SQLiteDatabase db = this.getWritableDatabase();
		ContentValues values = new ContentValues();
		values.put(KEY_ID,task.getTaskName());
		values.put(KEY_TIME,task.getTime());
		values.put(KEY_STATE,task.getState());
		
		return db.update(table_name, values, KEY_ID + " = ? ", new String[]{task.getTaskName()});
	}
	
	public void deleteTask(Task task){
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(table_name,KEY_ID + " = ?", new String[]{task.getTaskName()});
		db.close();
	}*/
	
	public void closeDatabase(Storage database){
		database.close();
	}
	

}