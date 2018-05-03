package com.yl.ffmpeg4android;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

import java.io.File;

/**
 * 截取gif动图
 * <p>
 * Created by yangle on 2018/3/26.
 * Website：http://www.yangle.tech
 */

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    static {
        System.loadLibrary("ffmpeg");
    }

    private ImageView ivGif;
    private Button btnConvert;
    private ProgressDialog progressDialog;
    // 设备根目录路径
    private String path = Environment.getExternalStorageDirectory().getAbsolutePath();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ivGif = findViewById(R.id.iv_gif);
        btnConvert = findViewById(R.id.btn_convert);
        btnConvert.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        // 截取视频的前100帧
        final String cmd = "ffmpeg -i " + path + "/video.mp4 -vframes 100 -y -f gif -s 480×320 " + path + "/video_100.gif";
        // 显示loading
        progressDialog = new ProgressDialog(this);
        progressDialog.setTitle("截取中...");
        progressDialog.show();

        new Thread() {
            @Override
            public void run() {
                super.run();
                // 执行指令
                int a  = cmdRun(cmd);
                Log.i("执行命令",a+"");

                // 隐藏loading
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progressDialog.dismiss();
                        progressDialog = null;

                        // 显示gif
                        Glide.with(MainActivity.this)
                                .load(new File(path + "/video_100.gif"))
                                .into(ivGif);
                    }
                });
            }
        }.start();
    }

    /**
     * 以空格分割指令，生成String类型的数组
     *
     * @param cmd 指令
     * @return 执行code
     */
    private int cmdRun(String cmd) {
        String regulation = "[ \\t]+";
        final String[] split = cmd.split(regulation);
        return run(split);
    }

    /**
     * ffmpeg_cmd中定义的run方法
     *
     * @param cmd 指令
     * @return 执行code
     */
    public native int run(String[] cmd);
}
