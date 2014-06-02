package com.xenon.greenup.persistence;

import android.content.Context;

/**
 * Created by josh on 6/1/14.
 */
public class CommentDAO {
    private Storage storage;

    public CommentDAO(Context c){
        this.storage = Storage.getInstance(c);
    }

}
