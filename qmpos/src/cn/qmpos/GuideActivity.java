package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.ImageView;
import cn.jpush.android.api.JPushInterface;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.R;

public class GuideActivity extends BaseActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_guide);
		// 初始化
		init();
	}

	private void init() {
		// 判断，如果是更新版本后第一次登录，则跳到
		try {
			PackageInfo pkg = this.getPackageManager().getPackageInfo(
					this.getApplication().getPackageName(), 0);
			String nowVersionId = pkg.versionName;

			String key = nowVersionId + "_first";
			SharedPreferences mySharedPreferences = getSharedPreferences(
					"qmpos", Activity.MODE_PRIVATE);
			SharedPreferences.Editor editor = mySharedPreferences.edit();
			String value = mySharedPreferences.getString(key, "");
			Log.i("eee", value);
			if (!"N".equals(value)) {
				// 更改为N
				editor.putString(key, "N");
				editor.commit();

				Intent i = new Intent(this, cn.qmpos.GuideFirstActivity.class);
				this.startActivity(i);
				finish();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		AlphaAnimation alphaAnimation = new AlphaAnimation(0.3f, 1f);
		alphaAnimation.setDuration(2000);
		alphaAnimation.setAnimationListener(new AnimationListener() {
			@Override
			public void onAnimationEnd(Animation arg0) {
				redirectTo();
			}

			@Override
			public void onAnimationRepeat(Animation animation) {
			}

			@Override
			public void onAnimationStart(Animation animation) {
			}
		});

		ImageView guideImage = (ImageView) this.findViewById(R.id.guide_image);
		guideImage.startAnimation(alphaAnimation);
	}

	private void redirectTo() {
		// 判断是否记住手机号
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String loginId = mySharedPreferences.getString("loginId", "");
		String login_pwd = mySharedPreferences.getString("login_pwd", "");
		if (!loginId.equals("") && !login_pwd.equals("")) {
			LoginTask loginTask = new LoginTask();
			loginTask.execute(new String[] { loginId, login_pwd });
			// Intent intent = new Intent(GuideActivity.this,
			// MainActivity.class);
			// GuideActivity.this.startActivity(intent);
		} else {
			Intent i = new Intent(this, LoginActivity.class);
			this.startActivity(i);
			finish();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.guide, menu);
		return true;
	}

	@Override
	protected void onResume() {
		super.onResume();
		JPushInterface.onResume(this);

	}

	@Override
	protected void onPause() {
		super.onPause();
		JPushInterface.onPause(this);
	}

	// 登录操作类
	class LoginTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("loginId", params[0]);
				map.put("loginPwd", params[1]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host
						+ Constants.server_login_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "请网络是否正常");
					return returnMap;
				}

				// 解释返回的JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (Constants.SERVER_SUCC.equals(respCode)) {
					returnMap.put("merId", jsonObj.getString("merId"));
					returnMap.put("merName", jsonObj.getString("merName"));
					returnMap.put("lastLoginDate",
							jsonObj.getString("lastLoginDate"));
					returnMap.put("isAuthentication",
							jsonObj.getString("isAuthentication"));
					returnMap.put("sessionId", jsonObj.getString("sessionId"));
				}
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			Intent intent = new Intent(GuideActivity.this, MainActivity.class);
			if (Constants.SERVER_SUCC.equals(respCode)) {
				// 判断是否记住用户名
				try {
					String merId = resultMap.get("merId");
					String merName = resultMap.get("merName");
					String lastLoginDate = resultMap.get("lastLoginDate")
							.trim();
					String isAuthentication = resultMap.get("isAuthentication");
					String sessionId = resultMap.get("sessionId");

					SharedPreferences mySharedPreferences = getSharedPreferences(
							"qmpos", Activity.MODE_PRIVATE);
					SharedPreferences.Editor editor = mySharedPreferences
							.edit();

					editor.putString("merId", merId);
					editor.putString("merName", merName);
					editor.putString("lastLoginDate", lastLoginDate);
					editor.putString("isAuthentication", isAuthentication);
					editor.putString("sessionId", sessionId);
					editor.putString("sessionId", sessionId);

					editor.putString("login_isRememberUserName",
							Constants.PUBLIC_Y);
					editor.commit();
					intent.putExtra("isAuthentication", isAuthentication);
				} catch (Exception e) {
				}
			}
			GuideActivity.this.startActivity(intent);

		}
	}

}
