package de.lauviktor.roboremote;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.InputStream;

public class UpdateActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update);
        TextView changelog = (TextView) findViewById(R.id.tvChangelog);
        TextView tvverupdate = (TextView) findViewById(R.id.tvverupdate);
        Button btnInstallButton = (Button) findViewById(R.id.btnInstall);
        Button btnCancelButton = (Button) findViewById(R.id.btncancel);
        ImageView imageView = (ImageView) findViewById(R.id.imageViewAppPicinUpdate);
        final String PicFile = "http://roboci51.lauviktor.de/pic.png";

        new DownloadImageTask(imageView)
                .execute(PicFile);
        String changelog_edited = lilhelper.changelog.replace("<br>", "\n");
        changelog.setText(changelog_edited);
        tvverupdate.setText(this.getString(R.string.version)+" "+this.getString(R.string.installed)+": "
                +BuildConfig.VERSION_NAME+" "+this.getString(R.string.version)+" "+this.getString(R.string.available)+": "+ lilhelper.onlineAppVer);

        btnInstallButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final update updateApp = new update(UpdateActivity.this);
                updateApp.execute("http://roboci51.lauviktor.de/app-release.apk");
            }
        });
        btnCancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getBaseContext(), R.string.updatecancel,Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }

void animation_fadein(){
        final ImageView imageView = (ImageView) findViewById(R.id.imageViewAppPicinUpdate);
        Animation fadeIn = AnimationUtils.loadAnimation(UpdateActivity.this, R.anim.fade_in);
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
    private class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
        ImageView bmImage;
        private DownloadImageTask(ImageView bmImage) {
            this.bmImage = bmImage;
        }

        protected Bitmap doInBackground(String... urls) {
            String urldisplay = urls[0];
            Bitmap mIcon11 = null;
            try {
                InputStream in = new java.net.URL(urldisplay).openStream();
                mIcon11 = BitmapFactory.decodeStream(in);
            } catch (Exception e) {
                Log.e("Error", e.getMessage());
                e.printStackTrace();
            }
            return mIcon11;
        }
        protected void onPostExecute(Bitmap result) {
            animation_fadein();
            bmImage.setImageBitmap(result);
        }
    }
}
