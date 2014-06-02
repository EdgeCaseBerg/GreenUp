package com.xenon.greenup.persistence;

/**
 * Created by josh on 6/1/14.
 */
public class SQL {
    public static final String DATABASE_NAME = "GREENUP";
    public static final int DATABASE_VERSION = 1;
    public static final String COMMENTS_TABLE = "comments";
    public static final String PINS_TABLE = "pins";
    public static final String HEAT_TABLE = "heat";

    public static final String CREATE_COMMENTS_TABLE = "CREATE TABLE IF NOT EXIST "+ COMMENTS_TABLE +
        " (id INTEGER PRIMARY KEY, message TEXT, type TEXT, timestamp TEXT, pin_id INTEGER)";

    public static final String CREATE_PINS_TABLE = "CREATE TABLE IF NOT EXIST " + PINS_TABLE +
            " (id INTEGER PRIMARY KEY, latDegrees FLOAT, lonDegrees FLOAT, type TEXT, message TEXT, addressed BOOLEAN)";

    public static final String CREATE_HEAT_TABLE = "CREATE TABLE IF NOT EXIST " + HEAT_TABLE +
            " (id INTEGER PRIMARY KEY, latDegrees FLOAT, lonDegrees FLOAT, secondsWorked INTEGER)";

    public static final String SELECT_ALL_HEAT = "SELECT * FROM " + HEAT_TABLE;
    public static final String SELECT_ALL_COMMENTS = "SELECT * FROM " + COMMENTS_TABLE;
    public static final String SELECT_ALL_PINS = "SELECT * FROM " + PINS_TABLE;

}
