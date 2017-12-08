package de.lauviktor.roboremote;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.PowerManager;
import android.support.v7.app.AppCompatActivity;
import android.widget.Toast;

import com.google.zxing.Result;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

public class qrreader extends AppCompatActivity implements ZXingScannerView.ResultHandler {


    final String LCDCOLOR = "lcdcolor";


    private ZXingScannerView mScannerView;
    ProgressDialog mProgressDialog;
    SharedPreferences prefs;
    SharedPreferences.Editor prefseditor;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrreader);


        mScannerView = new ZXingScannerView(qrreader.this);
        setContentView(mScannerView);
        mScannerView.setResultHandler(qrreader.this);
        mScannerView.startCamera();

        prefs = this.getSharedPreferences("RoboRemoteSettings", MODE_PRIVATE);
        prefseditor = prefs.edit();

        mProgressDialog = new ProgressDialog(qrreader.this);
        mProgressDialog.setMessage("Download...");
        mProgressDialog.setIndeterminate(true);
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        mProgressDialog.setCancelable(true);
    }


    private class DownloadTaskBackground extends AsyncTask<String, Integer, String> {

        private Context context;
        private PowerManager.WakeLock mWakeLock;
        DownloadTaskBackground(Context context) {
        this.context = context;
    }

    @Override
    protected String doInBackground(String... sUrl) {
        InputStream input = null;
        OutputStream output = null;
        HttpURLConnection connection = null;
        try {
            URL url = new URL(sUrl[0]);
            connection = (HttpURLConnection) url.openConnection();
            connection.connect();
            if (connection.getResponseCode() != HttpURLConnection.HTTP_OK) {
                return "Server returned HTTP " + connection.getResponseCode()
                        + " " + connection.getResponseMessage();
            }
            int fileLength = connection.getContentLength();
            File file;
            String PATH = (Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"robowall.jpg");
            file = new File(PATH);
            if (file.exists()){
                file.delete();
            }
            input = connection.getInputStream();
            output = new FileOutputStream(file);


            byte data[] = new byte[4096];
            long total = 0;
            int count;
            while ((count = input.read(data)) != -1) {
                if (isCancelled()) {
                    input.close();
                    return null;
                }
                total += count;
                if (fileLength > 0)
                    publishProgress((int) (total * 100 / fileLength));
                output.write(data, 0, count);
            }
        } catch (Exception e) {
            return e.toString();
        } finally {
            try {
                if (output != null)
                    output.close();
                if (input != null)
                    input.close();
            } catch (IOException ignored) {
            }
            if (connection != null)
                connection.disconnect();
        }
        return null;
    }
    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        mWakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK,
                getClass().getName());
        mWakeLock.acquire();
        mProgressDialog.show();
    }

    @Override
    protected void onProgressUpdate(Integer... progress) {
        super.onProgressUpdate(progress);
        mProgressDialog.setIndeterminate(false);
        mProgressDialog.setMax(100);
        mProgressDialog.setProgress(progress[0]);
    }

    @Override
    protected void onPostExecute(String result) {
        mWakeLock.release();
        mProgressDialog.dismiss();
        if (result != null)
            Toast.makeText(context,"Download error: "+result, Toast.LENGTH_LONG).show();
        else
            Toast.makeText(context,"Download abgeschlossen", Toast.LENGTH_SHORT).show();
        finish();
    }}

    @Override
    public void handleResult(Result result) {
        if ((result.toString().contains(".apk"))&&(result.toString().contains("roboci51"))) {
            final update updateApp = new update(qrreader.this);
            updateApp.execute(result.toString());
            mProgressDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    updateApp.cancel(true);
                }
            });
        } else if((result.toString().contains(".mp3"))||(result.toString().contains(".mid"))){

            if (AudioPlay.isplayingAudio){
                AudioPlay.stopAudio();
            }
            AudioPlay.playAudio(qrreader.this, Uri.parse(result.toString()));
            finish();

        }else if((result.toString().contains("LCDC"))){
            String res2 =result.toString().substring(4);
            prefseditor.putString(LCDCOLOR,res2);
            prefseditor.apply();
            finish();

        }else if((result.toString().contains("WALL.STYLE"))){
            final DownloadTaskBackground downloadTaskBackground = new DownloadTaskBackground(qrreader.this);
            downloadTaskBackground.execute(result.toString());
            lilhelper.nobg=false;
            lilhelper.bgischanged=true;

            mProgressDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    downloadTaskBackground.cancel(true);
                }
            });

        }else if((result.toString().contains("deletewall"))){
            File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"robowall.jpg");
            if(file.exists()){
                file.delete();
                Toast.makeText(getBaseContext(), "Das Hintergrundbild wurde gelöscht.", Toast.LENGTH_SHORT).show();
            }else {
                Toast.makeText(getBaseContext(), "Es ist kein Hintergrundbild vorhanden.", Toast.LENGTH_SHORT).show();
            }
            finish();
        } else {
            Toast.makeText(getBaseContext(), "code unzulässig", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        mScannerView.stopCamera();
        finish();
    }
}


