package com.xenon.greenup.util;

import android.content.Context;

import com.xenon.greenup.ChronoTime;

/**
 * Created by josh on 6/1/14.
 */
public class CommentDAO {
    Storage storage;

    public CommentDAO(Context c){
        this.storage = new Storage(c);
    }

    public ChronoTime getSecondsWorked() {
        return storage.getSecondsWorked();
    }

    public void setSecondsWorked(long gct, boolean b) {
        this.storage.setSecondsWorked(gct, b);
    }
}
