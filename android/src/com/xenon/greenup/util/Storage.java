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
	private static final String KEY_STATE = "state";
	private static final String table_name = "heatmap_time";
	
	Storage(Context context){
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
		//context.deleteDatabase(DATABASE_NAME);
	}
	
	public void onCreate(SQLiteDatabase db){
		
		String create_table = "CREATE TABLE " + table_name + "(" + KEY_ID + " TEXT PRIMARY KEY," + KEY_TIME + " TEXT," + KEY_STATE + " TEXT)";
		db.execSQL(create_table);
	}
	
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion){
		db.execSQL("DROP TABLE IF EXISTS " + table_name);
		onCreate(db);
	}
	
	/* This is an example from a previous project of mine on how to use the storage*/
	/*public void addTask(Task task){
		SQLiteDatabase db = this.getWritableDatabase();
		
		ContentValues values = new ContentValues();
		values.put(KEY_ID, task.getTaskName());
		values.put(KEY_TIME, task.getTime());
		values.put(KEY_STATE, task.getState());
		
		db.insert(table_name, null,values);
		db.close();
	}
	
	public Task getTask(String id){
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor cursor = db.query(table_name, new String[] {KEY_ID,KEY_TIME,KEY_STATE},KEY_ID + "?",new String[]{id},null,null,null,null);
		if(cursor != null){
			cursor.moveToFirst();
		}
		Task t = new Task();
		t.setName(cursor.getString(0));
		t.setTime(cursor.getString(1));
		t.setState(cursor.getString(2));
		
		return t;
	}
	
	public List<Task> getAllTasks(){ 
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