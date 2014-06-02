package com.xenon.greenup.persistence;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.SystemClock;

import com.xenon.greenup.api.HeatmapPoint;

import java.util.List;

import static com.google.common.collect.Lists.newArrayList;

public class Storage extends SQLiteOpenHelper{
    // it's OK to just leave the DB open
    // https://groups.google.com/forum/#!msg/android-developers/nopkaw4UZ9U/cPfPL3uW7nQJ
	private static final String KEY_ID = "pk";
	private static final String SINGLETON_PK = "1";
	private static final String KEY_TIME = "seconds";
	private static final String KEY_CHRONO_STATE = "chronoState";
	private static final String KEY_STOP_TIME = "stopTime";
    private static Storage instance = null;
    private static SQLiteDatabase db;
	
	private Storage(Context context){
		super(context, SQL.DATABASE_NAME, null, SQL.DATABASE_VERSION);
	}

    public static Storage getInstance(Context context){
        if(instance == null){
            instance = new Storage(context);
            return instance;
        }else{
            return instance;
        }
    }
	
	public Storage(Context context, boolean deleteDatabase){
		super(context, SQL.DATABASE_NAME, null, SQL.DATABASE_VERSION);
		context.deleteDatabase(SQL.DATABASE_NAME);
	}

	@Override
	public void onCreate(SQLiteDatabase database){
        this.db = database;
		/*What do we need?
		 *- whether or not the timer should be on. Bool.
		 *- the amount of time worked total. seconds, long.
		 *- the amount of time sent to the server? (no sending to much?)
		 *- the epoch time of pausing (when the app shuts down, save this time
		 *  so that we can compute how much time elapsed between pausing the 
		 *  app and turning it back on, so that we can add secondsWorked while
		 *  
		 */
		db.execSQL(SQL.CREATE_COMMENTS_TABLE);
        db.execSQL(SQL.CREATE_HEAT_TABLE);
        db.execSQL(SQL.CREATE_PINS_TABLE);
		
		ContentValues values = new ContentValues();
		/* For now just test persitent time, otherwise we'd be stored a better key here*/
		values.put(KEY_ID, SINGLETON_PK);
		values.put(KEY_TIME, "0");
		values.put(KEY_CHRONO_STATE, 0);
		values.put(KEY_STOP_TIME, String.valueOf(SystemClock.elapsedRealtime()));
		
//		db.insert(SECONDS_WORKED_TABLE_NAME, null,values);
	}
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion){
		db.execSQL("DROP TABLE IF EXISTS " + SQL.COMMENTS_TABLE);
        db.execSQL("DROP TABLE IF EXISTS " + SQL.PINS_TABLE);
        db.execSQL("DROP TABLE IF EXISTS " + SQL.HEAT_TABLE);
		onCreate(db);
	}

    public Object select(String query){
        Cursor cursor = db.rawQuery(query, null);
        if(query.contains(SQL.HEAT_TABLE)){
            return getHeatmapPoints(cursor);
        }

        return null;
    }

    public void update(String query){

    }

    // this is gross. we've coupled the database with the model field names
    // this cursor thing kinda sux, but doesn't feel like something I can throw
    // around all over the place.
    // it needs a getObject method so I can cast stuff
    // todo: replace with some reflection magic
    private List<HeatmapPoint> getHeatmapPoints(final Cursor cursor){
        List<HeatmapPoint> results = newArrayList();
        if (cursor.moveToFirst()) {
            do {
                results.add( new HeatmapPoint(
                        cursor.getDouble(cursor.getColumnIndexOrThrow("latDegrees")),
                        cursor.getDouble(cursor.getColumnIndexOrThrow("lonDegrees")),
                        cursor.getInt(cursor.getColumnIndexOrThrow("secondsWorked"))
                    )
                );

            } while (cursor.moveToNext());
        }
        return results;
    }

	

}