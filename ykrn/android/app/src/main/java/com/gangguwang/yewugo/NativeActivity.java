package com.gangguwang.yewugo;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;
import android.text.TextUtils;

import com.youku.cloud.player.YoukuPlayerConfig;
import com.youku.cloud.player.YoukuPlayerView;
import com.youku.cloud.utils.Logger;
import com.youku.cloud.module.PlayerErrorInfo;
import com.youku.cloud.player.PlayerListener;
import com.youku.cloud.player.VideoDefinition;
import com.youku.cloud.utils.ValidateUtil;
import com.youku.download.DownInfo;


public class NativeActivity extends AppCompatActivity {

    private YoukuPlayerView youkuPlayerView;
    private String vid="XMzA1NzYwMTQxNg==";
    private String password="";
    private boolean local = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native);
        // Intent mIntent=getIntent();
        // if(mIntent!=null) {
        //     Toast.makeText(this,"请求参数："+mIntent.getStringExtra("params"),Toast.LENGTH_SHORT).show();;
        // }
        // Button btn_two=(Button)this.findViewById(R.id.btn_two);
        // //btn_two.setVisibility(View.GONE); //隐藏按钮
        // btn_two.setOnClickListener(new View.OnClickListener() {
        //     @Override
        //     public void onClick(View v) {
        //         Intent mIntent=new Intent(NativeActivity.this,MainActivity.class);
        //         mIntent.putExtra("data","你是123...");
        //         NativeActivity.this.startActivity(mIntent);
        //         NativeActivity.this.finish();
        //     }
        // });
        youkuPlayerView = (YoukuPlayerView)findViewById(R.id.baseview);
        // 初始化播放器
        youkuPlayerView.attachActivity(this);
        youkuPlayerView.setPreferVideoDefinition(VideoDefinition.VIDEO_HD);
        youkuPlayerView.setPlayerListener(new MyPlayerListener());
        youkuPlayerView.setShowFullBtn(true);
        autoplayvideo();
        initEvent();
    }

    private void autoplayvideo() {
        if (local) {
            youkuPlayerView.playLocalVideo(vid);
        } else {
            if (TextUtils.isEmpty(password)) {
                youkuPlayerView.playYoukuVideo(vid);
            } else {
                youkuPlayerView.playYoukuPrivateVideo(vid, password);
            }
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        // 必须重写的onPause()
        youkuPlayerView.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // 必须重写的onResume()
        youkuPlayerView.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 必须重写的onDestroy()
        youkuPlayerView.onDestroy();
    }

    // 添加播放器的监听器
    private class MyPlayerListener extends PlayerListener {
        @Override
        public void onComplete() {
            // TODO Auto-generated method stub
            super.onComplete();
        }

        @Override
        public void onError(int code, PlayerErrorInfo info) {
            // TODO Auto-generated method stub
            //txt1.setText(info.getDesc());
        }

        @Override
        public void OnCurrentPositionChanged(int msec) {
            // TODO Auto-generated method stub
            super.OnCurrentPositionChanged(msec);
        }

        @Override
        public void onVideoNeedPassword(int code) {
            // TODO Auto-generated method stub
            super.onVideoNeedPassword(code);
        }

        @Override
        public void onVideoSizeChanged(int width, int height) {
            // TODO Auto-generated method stub
            super.onVideoSizeChanged(width, height);
        }
    }

    private void initEvent() {
        // findViewById(R.id.btn0).setOnClickListener(new View.OnClickListener() {
        //     @Override
        //     public void onClick(View view) {
        //         youkuPlayerView.showControllerView();
        //     }
        // });
        // findViewById(R.id.btn1).setOnClickListener(new View.OnClickListener() {
        //     @Override
        //     public void onClick(View view) {
        //         youkuPlayerView.hideControllerView();

        //     }
        // });
    }

}
