package de.lauviktor.roboremote;

import android.Manifest;
import android.app.NotificationManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Build;
import android.os.CountDownTimer;
import android.os.Environment;
import android.os.Handler;
import android.speech.RecognizerIntent;
import android.speech.tts.TextToSpeech;
import android.support.annotation.NonNull;
import android.support.constraint.ConstraintLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.Switch;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Locale;
import java.util.Scanner;
import android.os.Vibrator;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import static de.lauviktor.roboremote.AudioPlay.mediaPlayer;


public class MainActivity extends AppCompatActivity implements  SensorEventListener, TextToSpeech.OnInitListener{

    private static final int MY_PERMISSIONS_REQUEST = 11;
    private final int REQ_CODE_SPEECH_INPUT = 100;
    boolean speakout =false;
    private TextToSpeech textToSpeech;
    SharedPreferences prefs;

    final String verFile = "http://roboci51.lauviktor.de/version.txt";

    URL url ;
    String TextHolder = "" , TextHolder2 = "";
    BufferedReader bufferReader ;
    private WebSocketClient mWebSocketClient;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //Lässt den Bildschirm dauerhaft an
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        //Deklaration der Variablen
        final ImageView VWRW_speedometer = (ImageView) findViewById(R.id.VWRV_speedometer);
        final ImageView RL_speedometer = (ImageView) findViewById(R.id.RL_speedometer);
        final ImageView VWRW_speedometer_static = (ImageView) findViewById(R.id.VWRV_speedometer_static);
        final EditText stateET = (EditText) findViewById(R.id.statetext);
        final Switch switchLockedControl = (Switch) findViewById(R.id.switchLockedControl);
        final Switch switchSpeech = (Switch) findViewById(R.id.switchSpeech);
        final Switch switchAnalog = (Switch) findViewById(R.id.switchAnalog);
        final Switch switchLight = (Switch) findViewById(R.id.switchLight);
        final Switch switchParkingMode = (Switch) findViewById(R.id.switchParkingMode);
        final SeekBar sbFB = (SeekBar) findViewById(R.id.sbarFB);
        final SeekBar sbLR = (SeekBar) findViewById(R.id.sbarLR);
        final FloatingActionButton spkr = (FloatingActionButton) findViewById(R.id.fabspkrbtn);
        final FloatingActionButton fab_media = (FloatingActionButton) findViewById(R.id.fab_media);
        final FloatingActionButton fab_update = (FloatingActionButton) findViewById(R.id.fab_update);
        final Button btn_scanner = (Button) findViewById(R.id.btn_scanner);
        final TextView tvver = (TextView) findViewById(R.id.tvVer);
        final TextView tvausgabe = (TextView) findViewById(R.id.tvausgabe);
        final ConstraintLayout constraintLayoutConnect2websock = (ConstraintLayout) findViewById(R.id.constraintLayoutConnect2websock);
        final LinearLayout linearLayoutControls = (LinearLayout) findViewById(R.id.linearLayout_controll);
        final LinearLayout linearLayoutConnect = (LinearLayout) findViewById(R.id.linearlayoutConnect);
        final EditText txtIP = (EditText) findViewById(R.id.etIP);
        final EditText txtPort = (EditText) findViewById(R.id.etPort);
        final Button btnCloseCon2websock = (Button) findViewById(R.id.btn_cancelk);
        final Button btnConnect2websock = (Button) findViewById(R.id.btn_conn2websocket);
        final Button btn_connect2 = (Button) findViewById(R.id.btn_connect2);
        final String appver = BuildConfig.VERSION_NAME;
        final TextView tvStateCon = (TextView) findViewById(R.id.tv_conStatus);
        final TextView tv_left0 = (TextView) findViewById(R.id.tv_left0);
        final TextView tv_right0 = (TextView) findViewById(R.id.tv_right0);
        final TextView usermanualtext = (TextView) findViewById(R.id.tvUserManual);
        final ImageView iv_left = (ImageView) findViewById(R.id.iv_left);
        final ImageView iv_right = (ImageView) findViewById(R.id.iv_right);

        final String[] VW_GLOBE = {"VW: 0"};
        final String[] RW_GLOBE = {"RW: 0"};
        final String[] R_GLOBE = {"R: 0"};
        final String[] L_GLOBE = {"L: 0"};

        //Buttons unsichtbar
        fab_update.setVisibility(View.INVISIBLE);
        btn_scanner.setVisibility(View.INVISIBLE);

        //Wenn Connect geklickt wird
            btnConnect2websock.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    if (txtIP.getText().toString().matches("")|txtPort.getText().toString().matches("")){
                        Toast.makeText(getBaseContext(),getString(R.string.correction),Toast.LENGTH_SHORT).show();
                    }else {
                        sbFB.setEnabled(true);
                        sbLR.setEnabled(true);
                        connectWebSocket(txtIP.getText().toString(), txtPort.getText().toString());
                        tvStateCon.setText(getString(R.string.connecting));
                        linearLayoutControls.setVisibility(View.VISIBLE);
                        linearLayoutConnect.setVisibility(View.GONE);

                        tv_left0.setVisibility(View.VISIBLE);
                        tv_right0.setVisibility(View.VISIBLE);
                        iv_left.setVisibility(View.VISIBLE);
                        iv_right.setVisibility(View.VISIBLE);
                        tvausgabe.setVisibility(View.VISIBLE);
                        VWRW_speedometer.setVisibility(View.VISIBLE);
                        VWRW_speedometer_static.setVisibility(View.VISIBLE);
                        RL_speedometer.setVisibility(View.VISIBLE);
                        sbFB.setVisibility(View.VISIBLE);
                        sbLR.setVisibility(View.VISIBLE);

                    }
                }
            });

            //Schließe ConView
            btnCloseCon2websock.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    constraintLayoutConnect2websock.setVisibility(View.GONE);
                    sbFB.setEnabled(false);
                    sbLR.setEnabled(false);
                    btn_scanner.setVisibility(View.VISIBLE);
                    linearLayoutControls.setVisibility(View.GONE);
                    linearLayoutConnect.setVisibility(View.VISIBLE);

                    tv_left0.setVisibility(View.GONE);
                    tv_right0.setVisibility(View.GONE);
                    iv_left.setVisibility(View.GONE);
                    iv_right.setVisibility(View.GONE);
                    tvausgabe.setVisibility(View.GONE);
                    VWRW_speedometer.setVisibility(View.GONE);
                    VWRW_speedometer_static.setVisibility(View.GONE);
                    RL_speedometer.setVisibility(View.GONE);
                    sbFB.setVisibility(View.GONE);
                    sbLR.setVisibility(View.GONE);

                    if ((Build.VERSION.SDK_INT>=Build.VERSION_CODES.N)|(Build.VERSION.SDK_INT==Build.VERSION_CODES.N)){
                        final ImageView backfromsplash = (ImageView) findViewById(R.id.ivsplashback);
                        final ImageView splashlogo = (ImageView) findViewById(R.id.ivsplashlogo);
                        splashlogo.setVisibility(View.GONE);
                        backfromsplash.setVisibility(View.GONE);
                        new GetVersionFileFromServer().execute();
                    }else{
                        if (!lilhelper.alreadyin) {
                            //startanimation
                            animation_fadeout();
                        }

                    }
                }
            });
        //Öffne wieder Connect
        btn_connect2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                linearLayoutConnect.setVisibility(View.GONE);
                constraintLayoutConnect2websock.setVisibility(View.VISIBLE);
            }
        });

        //ruft Update auf
        fab_update.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                //stringcompare(appver,helper1);
                Intent intent = new Intent(MainActivity.this, UpdateActivity.class);
                startActivity(intent);
            }
        });

        //Öffnet Scanner
        btn_scanner.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               Intent intent = new Intent(MainActivity.this, qrreader.class);
                startActivity(intent);
            }
        });

        usermanualtext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, usermanual.class);
                startActivity(intent);
            }
        });

        stateET.setText(R.string.welcometext);
        SensorManager SM = (SensorManager) getSystemService(SENSOR_SERVICE);
        Sensor mySensor = SM.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        SM.registerListener(this, mySensor, SensorManager.SENSOR_DELAY_NORMAL);
        textToSpeech = new TextToSpeech(this, this);
        spkr.setVisibility(View.INVISIBLE);
        fab_media.setVisibility(View.INVISIBLE);
        //Zeigt die Versionsnummer
        tvver.setText("V: "+appver);
        //Klick auf den rosanen FAB Button (mic)
        spkr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (AudioPlay.isplayingAudio){
                    AudioPlay.playback_brake_for_tts();
                    fab_media.setImageResource(android.R.drawable.ic_media_play);
                    askSpeechInput();
                }else if (!textToSpeech.isSpeaking()){
                    askSpeechInput();
                }
            }
        });
        //Klick auf den rosanen FAB Button (fab_media)
        fab_media.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (AudioPlay.isplayingAudio){
                    AudioPlay.pauseAudio();
                    fab_media.setImageResource(android.R.drawable.ic_media_play);
                }else{
                    AudioPlay.releaseAudio();
                    fab_media.setImageResource(android.R.drawable.ic_media_pause);
                }
            }
        });
        //Hilfe speedometer
        VWRW_speedometer.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                Toast.makeText(getBaseContext(),getString(R.string.infospeedometer),Toast.LENGTH_LONG).show();
               if (lilhelper.connectedtoWebsocket){
                   sendMessage(getString(R.string.infospeedometer));
               }

                return false;
            }
        });
        //Hilfe Scanner
        btn_scanner.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                Toast.makeText(getBaseContext(),getString(R.string.infoscan),Toast.LENGTH_LONG).show();
                if (lilhelper.connectedtoWebsocket) {
                    sendMessage(getString(R.string.infoscan));
                }
                return false;
            }
        });

        //Tempomat
        switchLockedControl.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!switchLockedControl.isChecked()) {
                    sbFB.setProgress(50);
                    sbLR.setProgress(50);
                    stateET.setTextSize(18);
                    stateET.setText(R.string.hardcontrol_off);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.hardcontrol_off));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                } else {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.hardcontrol_on);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.hardcontrol_on));
                    }
                    if (switchParkingMode.isChecked()){
                        switchParkingMode.setChecked(false);
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                }
            }
        });
        //Licht
        switchLight.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!switchLight.isChecked()) {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.lightOff);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.lightOff));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                    VWRW_speedometer.setRotation((float) 0);
                } else {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.lightON);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.lightON));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                    VWRW_speedometer.setRotation((float) 230);
                }
            }
        });
        //Parkmodus
        switchParkingMode.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!switchParkingMode.isChecked()) {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.parkingModeOff);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.parkingModeOff));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                } else {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.parkingModeOn);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.parkingModeOn));
                    }
                    if (switchLockedControl.isChecked()){
                        switchLockedControl.setChecked(false);
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                }
            }
        });
        //Sprachsteuerung
        switchSpeech.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!switchSpeech.isChecked()) {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.voicecontrol_off);
                    spkr.setVisibility(View.INVISIBLE);
                    switchAnalog.setVisibility(View.VISIBLE);
                    switchLockedControl.setVisibility(View.VISIBLE);
                    switchParkingMode.setVisibility(View.VISIBLE);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.voicecontrol_off));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                } else {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.voicecontrol_on);
                    spkr.setVisibility(View.VISIBLE);
                    switchAnalog.setVisibility(View.INVISIBLE);
                    switchLockedControl.setVisibility(View.INVISIBLE);
                    switchParkingMode.setVisibility(View.INVISIBLE);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.voicecontrol_on));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                    if (switchParkingMode.isChecked()){
                        switchParkingMode.setChecked(false);
                    }
                }
            }
        });
        //Analoge Steuerung
        switchAnalog.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!switchAnalog.isChecked()) {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.analogcontrol_off);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.analogcontrol_off));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                } else {
                    stateET.setTextSize(18);
                    stateET.setText(R.string.analogcontrol_on);
                    if (lilhelper.connectedtoWebsocket) {
                        sendMessage(getString(R.string.analogcontrol_on));
                    }
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }
                }
            }
        });
        sbFB.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar sbFB, int progress,
                                          boolean fromUser) {
                stateET.setTextSize(20);
                if ((progress < 50)||(progress==50)) {
                    VWRW_speedometer.setRotation((float) ((progress-50)*-4.6));
                    VW_GLOBE[0] = "VW: 0";
                    if (switchParkingMode.isChecked()) {
                        if ((((progress - 50) * -1)/5)<11&&(((progress - 50) * -1)/5)>6){
                            vibrator(50);
                        }
                        RW_GLOBE[0] = "RW: " + String.valueOf(((progress - 50) * -1)/5);
                        if (lilhelper.connectedtoWebsocket) {
                            sendMessage("RW: " + String.valueOf(new DecimalFormat("00").format(((progress - 50) * -1)/5)));
                        }
                    }else {
                        if (((progress - 50) * -1)>44){
                            vibrator(50);
                        }
                        RW_GLOBE[0] = "RW: " + String.valueOf((progress - 50) * -1);
                        if (lilhelper.connectedtoWebsocket) {
                            sendMessage("RW: " + String.valueOf(new DecimalFormat("00").format(((progress - 50) * -1))));
                        }
                    }

                }else {
                    VWRW_speedometer.setRotation((float) ((progress-50)*4.6));
                    RW_GLOBE[0] = "RW: 0";
                    if (switchParkingMode.isChecked()) {
                        if (((progress - 50)/5)<11&&(((progress - 50)/5))>6){
                            vibrator(50);
                        }
                        VW_GLOBE[0] = "VW: " + String.valueOf((progress - 50)/5);
                        if (lilhelper.connectedtoWebsocket){
                            sendMessage("VW: " + String.valueOf(new DecimalFormat("00").format((progress-50)/5)));
                        }
                    }else {
                        if ((progress - 50)>44){
                            vibrator(50);
                        }
                        VW_GLOBE[0] = "VW: " + String.valueOf(progress - 50);
                        if (lilhelper.connectedtoWebsocket){
                            sendMessage("VW: " + String.valueOf(new DecimalFormat("00").format(progress-50)));
                        }
                    }

                }
                stateET.setText(VW_GLOBE[0] + " " + RW_GLOBE[0] + " " + R_GLOBE[0] + " " + L_GLOBE[0]);

            }
            @Override
            public void onStartTrackingTouch(SeekBar sbFB) {

            }
            @Override
            public void onStopTrackingTouch(SeekBar sbFB) {

                if (!switchLockedControl.isChecked()) {
                    sbFB.setProgress(50);
                    if (!lilhelper.welcometaskisactive){
                        welcometext();
                    }else if (lilhelper.connectedtoWebsocket){
                        sendMessage("VR " + String.valueOf(new DecimalFormat("00").format(sbFB.getProgress()-50)));
                    }

                }
            }
        });
        sbLR.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar sbLR, int progress,
                                          boolean fromUser) {
                stateET.setTextSize(20);
                if ((progress < 50)||(progress==50)) {
                    R_GLOBE[0]="R: 0";
                    RL_speedometer.setRotation((float) ((progress-50)*-4.6));
                    L_GLOBE[0] = "L: " + String.valueOf((progress - 50) * -1);
                    if (lilhelper.connectedtoWebsocket){
                        sendMessage("L: " + String.valueOf(new DecimalFormat("00").format((progress-50)*-1)));
                    }
                }else {
                    L_GLOBE[0] = "L: 0";
                    RL_speedometer.setRotation((float) ((progress-50)*4.6));
                    R_GLOBE[0] = "R: " + String.valueOf(progress - 50);
                    if (lilhelper.connectedtoWebsocket){
                        sendMessage("R: " + String.valueOf(new DecimalFormat("00").format(progress-50)));
                    }
                }
                stateET.setText(VW_GLOBE[0]+" "+RW_GLOBE[0]+" "+R_GLOBE[0]+" "+L_GLOBE[0]);
            }
            @Override
            public void onStartTrackingTouch(SeekBar sbLR) {
            }
            @Override
            public void onStopTrackingTouch(final SeekBar sbLR) {
                sbLR.setProgress(50);
                if (!lilhelper.welcometaskisactive){
                    welcometext();
                }else if (lilhelper.connectedtoWebsocket){
                    sendMessage("LR " + String.valueOf(new DecimalFormat("00").format(sbLR.getProgress()-50)));
                }
            }
        });

        //Berechtigungen prüfen
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(new String[]{
                            Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.CAMERA},
                    MY_PERMISSIONS_REQUEST);}}
        @Override
        public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String permissions[], @NonNull int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST:
                if (!(grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    Toast.makeText(getBaseContext(),this.getString(R.string.access_denied),Toast.LENGTH_LONG).show();
                    finish();
                }}}

    // Zeigt google speech input Dialog
    private void askSpeechInput() {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault());
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT,
                this.getString(R.string.googlespeechapitext));
        try {
            startActivityForResult(intent, REQ_CODE_SPEECH_INPUT);
        } catch (ActivityNotFoundException a) {
            Toast.makeText(getBaseContext(),this.getString(R.string.googlespeechapitexterror),Toast.LENGTH_LONG).show();
        }
    }
    // Verarbeitung der Spracheingabe
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        final EditText stateET = (EditText) findViewById(R.id.statetext);
        final SeekBar sbFB = (SeekBar)findViewById(R.id.sbarFB);
        final SeekBar sbLR = (SeekBar)findViewById(R.id.sbarLR);
        final TextView tvSprachausgabe = (TextView) findViewById(R.id.tvausgabe);
        String[] numbs = getResources().getStringArray(R.array.numbs);
        String[] left = getResources().getStringArray(R.array.speechleft);
        String[] whodothemagic = getResources().getStringArray(R.array.whodothemagic);
        String[] scanner = getResources().getStringArray(R.array.scanner);
        String[] websocketsArray = getResources().getStringArray(R.array.websocket);

        switch (requestCode) {
            case REQ_CODE_SPEECH_INPUT: {
                if (resultCode == RESULT_OK && null != data) {
                    ArrayList<String> result = data
                            .getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                    if ((result.get(0)).startsWith(this.getString(R.string.speechforward))) {
                        sbFB.setProgress(50);
                        String con = (result.get(0));
                        con = con.replace(this.getString(R.string.speechforward), "");
                        con = con.replace(" ", "");
                        con = con.replace(numbs[0], numbs[9]);
                        con = con.replace(numbs[1], numbs[10]);
                        con = con.replace(numbs[2], numbs[11]);
                        con = con.replace(numbs[3], numbs[12]);
                        con = con.replace(numbs[4], numbs[13]);
                        con = con.replace(numbs[5], numbs[14]);
                        con = con.replace(numbs[6], numbs[15]);
                        con = con.replace(numbs[7], numbs[16]);
                        con = con.replace(numbs[8], numbs[17]);
                        stateET.setText(con);
                        try {
                            int in = Integer.valueOf(stateET.getText().toString());
                            if (in >= -50 && in <= 50) {
                                sbFB.setProgress(50 + in);
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                if (speakout) {
                                    textToSpeech.speak(result.get(0), TextToSpeech.QUEUE_FLUSH, null);
                                    new Waiter().execute();
                                }
                            } else {
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                wrongInput();
                            }
                        } catch (NumberFormatException e) {
                            String newtext = this.getString(R.string.understood)+" " + result.get(0);
                            tvSprachausgabe.setText(newtext);
                            wrongInput();
                        }

                    } else if ((result.get(0)).startsWith(this.getString(R.string.speechbackward))) {
                        sbFB.setProgress(50);
                        String con = (result.get(0));
                        con = con.replace(this.getString(R.string.speechforward), "");
                        con = con.replace(" ", "");
                        con = con.replace(numbs[0], numbs[9]);
                        con = con.replace(numbs[1], numbs[10]);
                        con = con.replace(numbs[2], numbs[11]);
                        con = con.replace(numbs[3], numbs[12]);
                        con = con.replace(numbs[4], numbs[13]);
                        con = con.replace(numbs[5], numbs[14]);
                        con = con.replace(numbs[6], numbs[15]);
                        con = con.replace(numbs[7], numbs[16]);
                        con = con.replace(numbs[8], numbs[17]);
                        stateET.setText(con);
                        try {
                            int in = Integer.valueOf(stateET.getText().toString());
                            if (in >= -50 && in <= 50) {
                                sbFB.setProgress(50 - in);

                            } else {
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                wrongInput();
                            }
                        } catch (NumberFormatException e) {
                            String newtext = this.getString(R.string.understood)+" " + result.get(0);
                            tvSprachausgabe.setText(newtext);
                            wrongInput();
                        }
                    } else if ((result.get(0)).startsWith(left[0]) || (result.get(0).startsWith(left[1]))) {
                        sbLR.setProgress(50);
                        String con = (result.get(0));
                        con = con.replace(left[0], "");
                        con = con.replace(left[1], "");
                        con = con.replace(" ", "");
                        con = con.replace(numbs[0], numbs[9]);
                        con = con.replace(numbs[1], numbs[10]);
                        con = con.replace(numbs[2], numbs[11]);
                        con = con.replace(numbs[3], numbs[12]);
                        con = con.replace(numbs[4], numbs[13]);
                        con = con.replace(numbs[5], numbs[14]);
                        con = con.replace(numbs[6], numbs[15]);
                        con = con.replace(numbs[7], numbs[16]);
                        con = con.replace(numbs[8], numbs[17]);
                        stateET.setText(con);
                        try {
                            int in = Integer.valueOf(stateET.getText().toString());
                            if (in >= -50 && in <= 50) {
                                sbLR.setProgress(50 - in);
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                if (speakout) {
                                    textToSpeech.speak(result.get(0), TextToSpeech.QUEUE_FLUSH, null);
                                    new Waiter().execute();
                                }
                            } else {
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                wrongInput();
                            }
                        } catch (NumberFormatException e) {
                            String newtext = this.getString(R.string.understood)+" " + result.get(0);
                            tvSprachausgabe.setText(newtext);
                            wrongInput();
                        }

                    } else if ((result.get(0)).startsWith(this.getString(R.string.speechright))) {
                        sbLR.setProgress(50);
                        String con = (result.get(0));
                        con = con.replace(this.getString(R.string.speechright), "");
                        con = con.replace(" ", "");
                        con = con.replace(numbs[0], numbs[9]);
                        con = con.replace(numbs[1], numbs[10]);
                        con = con.replace(numbs[2], numbs[11]);
                        con = con.replace(numbs[3], numbs[12]);
                        con = con.replace(numbs[4], numbs[13]);
                        con = con.replace(numbs[5], numbs[14]);
                        con = con.replace(numbs[6], numbs[15]);
                        con = con.replace(numbs[7], numbs[16]);
                        con = con.replace(numbs[8], numbs[17]);
                        stateET.setText(con);
                        try {
                            int in = Integer.valueOf(stateET.getText().toString());
                            if (in >= -50 && in <= 50) {
                                sbLR.setProgress(50 + in);
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                if (speakout) {
                                    textToSpeech.speak(result.get(0), TextToSpeech.QUEUE_FLUSH, null);
                                    new Waiter().execute();
                                }
                            } else {
                                String newtext = this.getString(R.string.understood)+" " + result.get(0);
                                tvSprachausgabe.setText(newtext);
                                wrongInput();
                            }
                        } catch (NumberFormatException e) {
                            String newtext = this.getString(R.string.understood)+" " + result.get(0);
                            tvSprachausgabe.setText(newtext);
                            wrongInput();
                        }
                    } else if ((result.get(0)).startsWith(this.getString(R.string.speechStop))) {
                        sbFB.setProgress(50);
                        sbLR.setProgress(50);
                        stateET.setTextSize(18);
                        String text = this.getString(R.string.speechStop);
                        stateET.setText(text.toUpperCase());
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                        if (speakout) {
                            textToSpeech.speak(this.getString(R.string.speechStop), TextToSpeech.QUEUE_FLUSH, null);
                            new Waiter().execute();
                        }
                    } else if ((result.get(0)).equals(this.getString(R.string.speechOn))) {
                        speakout = true;
                        stateET.setTextSize(18);
                        stateET.setText(this.getString(R.string.speechisOn));
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                        textToSpeech.speak(this.getString(R.string.speechisOn), TextToSpeech.QUEUE_FLUSH, null);
                        new Waiter().execute();
                    }  else if ((result.get(0)).equals(this.getString(R.string.speechOff))) {
                        speakout = false;
                        stateET.setTextSize(18);
                        stateET.setText(this.getString(R.string.speechisOff));
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                    } else if ((result.get(0)).equals(whodothemagic[0])) {
                        stateET.setTextSize(18);
                        stateET.setText(whodothemagic[1]);
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                        if (speakout) {
                            textToSpeech.speak(whodothemagic[2], TextToSpeech.QUEUE_FLUSH, null);
                            new Waiter().execute();
                        }
                    } else if ((result.get(0)).startsWith(scanner[0])) {
                        stateET.setTextSize(18);
                        stateET.setText(this.getString(R.string.welcometext));
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                        if (speakout) {
                            textToSpeech.speak(scanner[2], TextToSpeech.QUEUE_FLUSH, null);
                            new Waiter().execute();
                        }
                        Intent intent = new Intent(MainActivity.this, qrreader.class);
                        startActivity(intent);
                    }else if ((result.get(0)).startsWith(scanner[1])) {
                        stateET.setTextSize(18);
                        stateET.setText(this.getString(R.string.welcometext));
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                        if (speakout) {
                            textToSpeech.speak(scanner[2], TextToSpeech.QUEUE_FLUSH, null);
                            new Waiter().execute();
                        }
                        Intent intent = new Intent(MainActivity.this, qrreader.class);
                        startActivity(intent);
                    }else if ((result.get(0)).startsWith(websocketsArray[0])|
                            (result.get(0)).startsWith(websocketsArray[1])|
                            (result.get(0)).startsWith(websocketsArray[2])|
                            (result.get(0)).startsWith(websocketsArray[3])) {
                    stateET.setTextSize(18);
                    stateET.setText(websocketsArray[1]);
                    String newtext = this.getString(R.string.understood)+" " + result.get(0);
                    tvSprachausgabe.setText(newtext);
                    if (speakout) {
                        textToSpeech.speak(websocketsArray[1], TextToSpeech.QUEUE_FLUSH, null);
                        new Waiter().execute();
                    }
                    /*Intent intent = new Intent(MainActivity.this, websocket.class);
                    startActivity(intent);*/
                } else {
                        stateET.setTextSize(18);
                        stateET.setText(this.getString(R.string.notAllowed));
                        String newtext = this.getString(R.string.understood)+" " + result.get(0);
                        tvSprachausgabe.setText(newtext);
                        if (speakout) {
                            textToSpeech.speak(this.getString(R.string.wronginputbutunderstood)+" " + result.get(0), TextToSpeech.QUEUE_FLUSH, null);
                            new Waiter().execute();
                        }
                    }
                }
                break;
            }
        }
    }
    //Neigungssensordaten verarbeiten
    @Override
    public void onSensorChanged(SensorEvent event) {
        final Switch switchAnalog = (Switch) findViewById(R.id.switchAnalog);
        final SeekBar sbFB = (SeekBar)findViewById(R.id.sbarFB);
        final SeekBar sbLR = (SeekBar)findViewById(R.id.sbarLR);
        if (!switchAnalog.isChecked()){
            float xval=(event.values[0])*-1*6;
            float yval=(event.values[1])*6;
            int xvalnew = Math.round(xval);
            int yvalnew = Math.round(yval);
            sbFB.setProgress(xvalnew+50);
            sbLR.setProgress(yvalnew+50);
        }
    }

    //Wird bei einer unzulässigen Eingabe aufgerufen
    public void wrongInput(){
    EditText stateET = (EditText) findViewById(R.id.statetext);
    stateET.setTextSize(18);
    stateET.setText(R.string.err1);
    if (speakout) {
        textToSpeech.speak(this.getString(R.string.wronginput), TextToSpeech.QUEUE_FLUSH, null);
        new Waiter().execute();
        }
    }

    //Wenn Bewegungssensor initializiert wird
    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
    @Override
    public void onInit(int status) {
    }


    //Vergleicht zwei strings miteinander für die Updatefunktion
    int stringcompare (String str1, String str2){
        final FloatingActionButton fab_update = (FloatingActionButton) findViewById(R.id.fab_update);
        Scanner s1 = new Scanner(str1);
        Scanner s2 = new Scanner(str2);
        s1.useDelimiter("\\.");
        s2.useDelimiter("\\.");
        while(s1.hasNextInt() && s2.hasNextInt()) {
            int v1 = s1.nextInt();
            int v2 = s2.nextInt();
            if(v1 < v2) {
//                lilhelper.showNotification(MainActivity.this,MainActivity.this.getString(R.string.updateText),MainActivity.this.getString(R.string.app_name));
                fab_update.setVisibility(View.VISIBLE);
                AlertDialog.Builder builder1 = new AlertDialog.Builder(MainActivity.this);
                builder1.setMessage(R.string.updateText);
                builder1.setCancelable(true);

                builder1.setPositiveButton(
                    R.string.install,
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.cancel();
                            Intent upda = new Intent(MainActivity.this, UpdateActivity.class);
                            startActivity(upda);
                        }
                    });
                builder1.setNegativeButton(
                    R.string.cancel,
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.cancel();
                        }
                    });

                AlertDialog alert11 = builder1.create();
                alert11.show();
                return -1;
        }
    }
    return 0;
}


    //Bild einblenden
    void animation_fadein(){
        final ImageView imageView = (ImageView) findViewById(R.id.imageViewBackground);
        Animation fadeIn = AnimationUtils.loadAnimation(MainActivity.this, R.anim.fade_in);
        imageView.startAnimation(fadeIn);

        fadeIn.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }
            @Override
            public void onAnimationEnd(Animation animation) {
            }
            @Override
            public void onAnimationRepeat(Animation animation) {
            }
        });
    }
    //Splash ausblenden
    void animation_fadeout(){
        final ImageView backfromsplash = (ImageView) findViewById(R.id.ivsplashback);
        final ImageView splashlogo = (ImageView) findViewById(R.id.ivsplashlogo);
        Animation fadeOut = AnimationUtils.loadAnimation(MainActivity.this, R.anim.fade_out);
        File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"robowall.jpg");
        if((file.exists())){
            Bitmap bmImg = BitmapFactory.decodeFile(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"robowall.jpg");
            backfromsplash.setImageBitmap(bmImg);
        }else {
            backfromsplash.setImageResource(R.drawable.blanc);
        }
        backfromsplash.startAnimation(fadeOut);

        fadeOut.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                splashlogo.setVisibility(View.VISIBLE);
                backfromsplash.setVisibility(View.VISIBLE);
            }
            @Override
            public void onAnimationEnd(Animation animation) {
                splashlogo.setVisibility(View.GONE);
                backfromsplash.setVisibility(View.GONE);
                //Prüft nach Update
                if (isConnectingToInternet(MainActivity.this)){
                    new GetVersionFileFromServer().execute();
                }
            }
            @Override
            public void onAnimationRepeat(Animation animation) {
            }
        });
    }




    //Prüft Verbindung
    public static boolean isConnectingToInternet(Context context) {
        ConnectivityManager connectivity =
                (ConnectivityManager) context.getSystemService(
                        Context.CONNECTIVITY_SERVICE);
        if (connectivity != null)
        {
            NetworkInfo[] info = connectivity.getAllNetworkInfo();
            if (info != null)
                for (int i = 0; i < info.length; i++)
                    if (info[i].getState() == NetworkInfo.State.CONNECTED)
                    {
                        return true;
                    }
        }
        return false;
    }


    //Holt Versionsdatei vom server
    private class GetVersionFileFromServer extends AsyncTask<Void, Void, Void> {
        @Override
        protected Void doInBackground(Void... params) {
            try {
                url = new URL(verFile);
                bufferReader = new BufferedReader(new InputStreamReader(url.openStream()));
                while ((TextHolder2 = bufferReader.readLine()) != null) {
                    TextHolder="";
                    TextHolder += TextHolder2;
                }
                bufferReader.close();
            } catch (MalformedURLException malformedURLException) {
                // TODO Auto-generated catch block
                malformedURLException.printStackTrace();
                TextHolder = malformedURLException.toString();
            } catch (IOException iOException) {
                // TODO Auto-generated catch block
                iOException.printStackTrace();
                TextHolder = iOException.toString();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Void finalTextHolder) {
            super.onPostExecute(finalTextHolder);
            lilhelper.onlineAppVer=TextHolder;
            new GetChangelogFromServer().execute();
        }
    }


    //Holt Changelog vom server
    private class GetChangelogFromServer extends AsyncTask<Void, Void, Void> {
        BufferedReader bufferReader4changelog ;
        String TextHolder4changelog = "" , TextHolder24changelog = "";
        URL url4changelog ;
        final String changelogFile = "http://roboci51.lauviktor.de/changelog.txt";
        final String helper1 = lilhelper.onlineAppVer;
        final String appver = BuildConfig.VERSION_NAME;

        @Override
        protected Void doInBackground(Void... params) {
            try {
                url4changelog = new URL(changelogFile);
                bufferReader4changelog = new BufferedReader(new InputStreamReader(url4changelog.openStream()));
                while ((TextHolder24changelog = bufferReader4changelog.readLine()) != null) {
                    TextHolder4changelog += TextHolder24changelog;
                }
                bufferReader4changelog.close();
            } catch (MalformedURLException malformedURLException) {
                // TODO Auto-generated catch block
                malformedURLException.printStackTrace();
                TextHolder4changelog = malformedURLException.toString();
            } catch (IOException iOException) {
                // TODO Auto-generated catch block
                iOException.printStackTrace();
                TextHolder4changelog = iOException.toString();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Void finalTextHolder) {
            super.onPostExecute(finalTextHolder);
            lilhelper.changelog=TextHolder4changelog;
            stringcompare(appver,helper1);
        }
    }


//Verbindet zum Websocket
    private void connectWebSocket(String url, String port) {
        final ConstraintLayout constraintLayoutConnect2websock = (ConstraintLayout) findViewById(R.id.constraintLayoutConnect2websock);
        URI uri;
        try {
            uri = new URI("ws://"+url+":"+port+"/");
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }

        mWebSocketClient = new WebSocketClient(uri) {
            //Beim öffnen einer Verbindung
            @Override
            public void onOpen(ServerHandshake serverHandshake) {
                Log.i("Websocket", "Opened");
                lilhelper.connectedtoWebsocket=true;
                mWebSocketClient.send("RoboRemote verbunden");
                mWebSocketClient.send("Brofist");
            }
            //Wenn eine Nachricht eingeht
            @Override
            public void onMessage(final String s) {
                final Button btn_scanner = (Button) findViewById(R.id.btn_scanner);
                final String message = s;
                final TextView tvStateCon = (TextView) findViewById(R.id.tv_conStatus);

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        //Entsperre RoboRemote
                        //Bestätige Verbindung
                        if(message.contains("BrofistIsOk")){
                            //Timer für die Verbindung
                            new CountDownTimer(1000, 1000) {
                                public void onTick(long millisUntilFinished) {
                                }
                                public void onFinish() {
                                    constraintLayoutConnect2websock.setVisibility(View.GONE);
                                    btn_scanner.setVisibility(View.VISIBLE);
                                    if ((Build.VERSION.SDK_INT>=Build.VERSION_CODES.N)|(Build.VERSION.SDK_INT==Build.VERSION_CODES.N)){
                                        final ImageView backfromsplash = (ImageView) findViewById(R.id.ivsplashback);
                                        final ImageView splashlogo = (ImageView) findViewById(R.id.ivsplashlogo);
                                        splashlogo.setVisibility(View.GONE);
                                        backfromsplash.setVisibility(View.GONE);
                                        new GetVersionFileFromServer().execute();
                                    }else{
                                        if (!lilhelper.alreadyin) {
                                            //startanimation
                                            animation_fadeout();
                                        }
                                    }
                                    tvStateCon.setText(getString(R.string.connected));
                                }
                            }.start();
                        }else {
                            Log.i("Websocket", "Connected " + s);
                    }}
                });
            }
            //Wenn eine Verbindung geschlossen wird
            @Override
            public void onClose(int i, String s, boolean b) {
                final TextView tvStateCon = (TextView) findViewById(R.id.tv_conStatus);
                constraintLayoutConnect2websock.setVisibility(View.VISIBLE);
                Log.i("Websocket", "Closed " + s);
                tvStateCon.setText(getString(R.string.connecterror));
                lilhelper.connectedtoWebsocket=false;
            }
            //Wenn ein Fehler auftritt
            @Override
            public void onError(Exception e) {
                final TextView tvStateCon = (TextView) findViewById(R.id.tv_conStatus);
                tvStateCon.setText(getString(R.string.connectionlost));
                constraintLayoutConnect2websock.setVisibility(View.VISIBLE);
                lilhelper.connectedtoWebsocket=false;
                Log.i("Websocket", "Error " + e.getMessage());
            }
        };
        mWebSocketClient.connect();
    }
    //Sendet Nachricht an Server
    public void sendMessage(String msg) {
        mWebSocketClient.send(msg);
    }


    //Wird bei Wiedereintritt aufgerufen
    @Override
    protected void onResume() {
        super.onResume();
        //Erneute Deklaration der Variablen, da wir oben ein Override haben. Variablen sind als final deklariert, damit diese nicht mehr verändert werden können.
        final FloatingActionButton fab_media = (FloatingActionButton) findViewById(R.id.fab_media);
        final ImageView imageViewBackground = (ImageView) findViewById(R.id.imageViewBackground);

        //Hier wird alles geprüft, was mit dem QR-Code Scanner eingescannt werden konnte.
        if (AudioPlay.isplayingAudio){
            fab_media.setVisibility(View.VISIBLE);
            fab_media.setImageResource(android.R.drawable.ic_media_pause);
        }
        //Wenn das Hintergrundbild geändert wurde
        if (lilhelper.bgischanged){
            animation_fadein();
            lilhelper.bgischanged=false;
        }


        //LCD Hintergrundfarbe
        final String LCDCOLOR = "lcdcolor";
        prefs = this.getSharedPreferences("RoboRemoteSettings",MODE_PRIVATE);
        EditText stateET = (EditText) findViewById(R.id.statetext);
        String newcolor =prefs.getString(LCDCOLOR, "#C0C0C0");
        stateET.setBackgroundColor(Color.parseColor(newcolor));


        //Prüfen, ob ein Hintergrundbild verfügbar ist.
        File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"robowall.jpg");
        if((file.exists())&&(!lilhelper.bgischanged)){
            Bitmap bmImg = BitmapFactory.decodeFile(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"robowall.jpg");
            imageViewBackground.setImageBitmap(bmImg);
        }else{
            imageViewBackground.setImageBitmap(null);
        }
        //Prüfe ob Musik abgespielt wird, wenn ja dann soll ein Listener am Ende des Tracks den fab_media Button wieder unsichtbar machen.
        if (AudioPlay.isplayingAudio) {
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    fab_media.setVisibility(View.INVISIBLE);
                    fab_media.setImageResource(android.R.drawable.ic_media_play);
                }
            });
        }
    }
        //Setzt lcdtext zurück
    private void welcometext(){
        final EditText stateET = (EditText) findViewById(R.id.statetext);
        lilhelper.welcometaskisactive=true;
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            public void run() {
                lilhelper.welcometaskisactive=false;
                stateET.setText(R.string.welcometext);}
        }, 3000);
    }

        //Vibration
    public void vibrator(long length) {
        Vibrator v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
        v.vibrate(length);
    }

    //Wartet bis die Sprachausgabe beendet wurde
    private class Waiter extends AsyncTask<Void,Void,Void> {
        final FloatingActionButton fab_media = (FloatingActionButton) findViewById(R.id.fab_media);
        @Override
        protected Void doInBackground(Void... voids) {
            while (textToSpeech.isSpeaking()){
                try{Thread.sleep(1000);}catch (Exception e){
                    Toast.makeText(getBaseContext(),R.string.googlespeechapitexterror,Toast.LENGTH_SHORT).show();
                }
            }
            return null;
        }
        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            if (AudioPlay.playbackbreak){
                AudioPlay.playback_release_from_tts();
                fab_media.setImageResource(android.R.drawable.ic_media_pause);
            }
        }
    }
    //Beim Beenden der App
    @Override
    protected void onDestroy() {
        super.onDestroy();
        //Beim Beenden der App Benachrichtigung schließen
        NotificationManager notificationManager =
                (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        notificationManager.cancel(0);
        //Wenn Musik abgespielt wird, Musik beenden
        if (AudioPlay.isplayingAudio){
            AudioPlay.stopAudio();
        }
        //Schließt Websocket-Verbindung
        mWebSocketClient.getConnection().closeConnection(1,"Close");
    }
}
