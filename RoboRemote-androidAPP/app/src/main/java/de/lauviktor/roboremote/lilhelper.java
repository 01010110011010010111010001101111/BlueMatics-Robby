package de.lauviktor.roboremote;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.v4.app.NotificationCompat;
import android.widget.Toast;

import java.io.IOException;

import static android.content.Context.NOTIFICATION_SERVICE;

/**
 * Created by Viktor on 04.10.2017.
 */


 class lilhelper {

    static boolean nobg = false;
    static boolean bgischanged = false;
    static String onlineAppVer="";
    static String changelog="";
    static boolean welcometaskisactive;
    static boolean connectedtoWebsocket=false;
    static boolean alreadyin=false;



    //Benachrichtigung
    //An diese Funktion wird ein Context (Der aktuelle Status der App. Beispiel: Die Funktion wird aus der MainActivity aufgerufen,
    //so muss als Context MainActivity.this angegeben werden).
    //An diese Funktion werden zwei weitere Parameter übergeben, zwei strings. Der erste string ist für den Titel der Benachrichtigung und der zweite string für den Inhalt.
    static void showNotification(Context c, String titel, String subtext) {
        PendingIntent pi = PendingIntent.getActivity(c, 0, new Intent(), PendingIntent.FLAG_UPDATE_CURRENT);
        Notification notification = new NotificationCompat.Builder(c)
                .setTicker(titel)
                .setSmallIcon(android.R.drawable.ic_menu_report_image)
                .setContentTitle(titel)
                .setContentText(subtext)
                .setContentIntent(pi)
                .setAutoCancel(true)
                .setOngoing(true)
                .build();
        NotificationManager notificationManager = (NotificationManager) c.getSystemService(NOTIFICATION_SERVICE);
        notificationManager.notify(0, notification);
    }



    //Diese Funtkion sendet daten an den Server
    public void send(Context c, String val){

    }
}
