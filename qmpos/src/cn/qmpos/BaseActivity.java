package cn.qmpos;

import java.util.ArrayList;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.widget.Toast;

public class BaseActivity extends Activity {

	protected ProgressDialog dialog;
	protected static BaseActivity mContext;
	protected SharedPreferences sp;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		dialog = new ProgressDialog(this);
		dialog.setCanceledOnTouchOutside(false);
		allActivity.add(this);
		mContext = this;
		sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
	}

	// 提示
	protected void showToast(String message) {
		Toast.makeText(mContext, message, Toast.LENGTH_SHORT).show();
	}

	public static ArrayList<Activity> allActivity = new ArrayList<Activity>();

	public static final void propmptExit(final Context mContext) {
		AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
		builder.setTitle("确认退出");
		builder.setMessage("确认是否退出系统？");
		builder.setPositiveButton("暂不退出", null);
		builder.setNegativeButton("退出", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				for (Activity ac : allActivity) {
					if (ac != null) {
						SharedPreferences sp = mContext.getSharedPreferences(
								"qmpos", Activity.MODE_PRIVATE);
						Editor editor = sp.edit();
						editor.putString("loginId", "");
						editor.putString("loginPwd", "");
						editor.commit();
						ac.finish();
					}
				}
			}
		});
		builder.show();
	}
}
