package com.xenon.greenup.persistence;

import android.content.Context;
import android.util.Log;

import com.xenon.greenup.api.HeatmapPoint;

import java.util.Collection;
import java.util.List;

/**
 * Created by josh on 6/1/14.
 */
public class HeatmapDAO {
    private Storage storage;

    public HeatmapDAO(Context c){
        this.storage = Storage.getInstance(c);
    }

    public void insertPoint(HeatmapPoint hp){

    }

    public void insertPoints(Collection<HeatmapPoint> points){

    }

    public List<HeatmapPoint> getAllPoints(){
        return (List<HeatmapPoint>) storage.select(SQL.SELECT_ALL_HEAT);
    }

    public void flushSessionToDisk(CleanSession session){
        if(!session.isEmpty()) {
            insertPoints(session.getPoints());
        }else{
            Log.w("[WARN]", "Empty session, did not flush to disk");
        }
    }

//
//    public void setSecondsWorked(long seconds,boolean onOff){
//        SQLiteDatabase db = this.getWritableDatabase();
//
//        ContentValues values = new ContentValues();
//		/* For now just test persitent time, otherwise we'd be stored a better key here*/
//        values.put(KEY_TIME, String.valueOf(seconds));
//        values.put(KEY_CHRONO_STATE,  onOff ? 1 : 0 );
//        values.put(KEY_STOP_TIME, String.valueOf(SystemClock.elapsedRealtime()));
//        Log.i("saveToDB", "time: " + seconds + " onOff: " + onOff + " stopTime: " + String.valueOf(SystemClock.elapsedRealtime()));
//        db.update(SECONDS_WORKED_TABLE_NAME, values, KEY_ID + "= ?", new String[]{SINGLETON_PK});
//    }
//
//    public ChronoTime getSecondsWorked(){
//        SQLiteDatabase db = this.getReadableDatabase();
//        String selectQuery = "SELECT " +  KEY_TIME + "," + KEY_CHRONO_STATE + ", " +  KEY_STOP_TIME + " FROM " + SECONDS_WORKED_TABLE_NAME + " WHERE " + KEY_ID + " = " + SINGLETON_PK;
//        Cursor cursor = db.rawQuery(selectQuery,null);
//
//        long secWorkd = 0L;
//        boolean cState = false;
//        long stopped = SystemClock.elapsedRealtime();
//
//        if(cursor != null){
//            cursor.moveToFirst();
//
//            try{
//                secWorkd = Long.parseLong(cursor.getString(0));
//            }catch(Exception e){/* Die silently and default sw=0*/}
//
//            try{
//                cState = cursor.getInt(1) == 1 ? true : false;
//            }catch(Exception e){/* http://www.youtube.com/watch?v=BX-7BlRc_a0 */}
//
//            try{
//                stopped = Long.valueOf(cursor.getString(2));
//            }catch(Exception e){/* http://www.youtube.com/watch?feature=player_detailpage&v=JWdZEumNRmI#t=50*/}
//        }
//        Log.i("dbLoad","secWorkd: "+secWorkd+" cState: "+cState+" stopped: "+stopped);
//
//
//        return new ChronoTime(secWorkd,cState,stopped);
//
//    }

}
