package cn.qmpos;

import java.util.HashMap;
import java.util.Set;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;
import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;
import cn.qmpos.R;

@SuppressLint({ "HandlerLeak", "ShowToast" })
public class LoginActivity extends BaseActivity implements OnClickListener {

	private LoginActivity loginActivity;
	private EditText editUserName, editUserPwd;
	private CheckBox bntRememberUserName;
	private View setTouchLayout;
	private ImageView mImgErrorNo;
	protected static final String TAG = "cn.qmpos";
	public static String APPURL;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		allActivity.add(this);
		loginActivity = this;

		// 初始化
		init();
		setTouchLayout = this.getLayoutInflater().inflate(
				R.layout.activity_login, null);
		setTouchLayout.setOnTouchListener(new OnTouchListener() {

			public boolean onTouch(View v, MotionEvent event) {
				setTouchLayout.setFocusable(true);
				setTouchLayout.setFocusableInTouchMode(true);
				setTouchLayout.requestFocus();
				return false;
			}
		});
	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.login_btn_reg:
				i = new Intent(this, Reg1Activity.class);
				this.startActivity(i);
				break;
			case R.id.login_btn_login:
				login();
				break;
			case R.id.login_find_pwd:
				i = new Intent(this, FindLoginPwd1Activity.class);
				this.startActivity(i);
				break;
			case R.id.img_errorNo:
				editUserPwd.setText("");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void login() {

		MD5Hash m = new MD5Hash();
		String userName = editUserName.getText().toString().trim();
		String userPwd = editUserPwd.getText().toString().trim();

		if ("".equals(userName) || userName.length() != 11
				|| !CommUtil.isMp(userName)) {
			showToast("手机号错误！");
			return;
		}

		if (userPwd == null || "".equals(userPwd)) {
			showToast("请输入登录密码！");
			return;
		}

		LoginTask loginTask = new LoginTask();
		loginTask.execute(new String[] { userName, m.getMD5ofStr(userPwd) });
	}

	private void init() {
		View logo = this.findViewById(R.id.login_logo);
		logo.setOnClickListener(this);
		View btnReg = this.findViewById(R.id.login_btn_reg);
		View btnLogin = this.findViewById(R.id.login_btn_login);
		View btnFindPwd = this.findViewById(R.id.login_find_pwd);
		btnReg.setOnClickListener(this);
		btnLogin.setOnClickListener(this);
		btnFindPwd.setOnClickListener(this);
		mImgErrorNo = (ImageView) findViewById(R.id.img_errorNo);
		mImgErrorNo.setOnClickListener(this);
		editUserName = (EditText) this.findViewById(R.id.login_edit_user_name);
		editUserPwd = (EditText) this.findViewById(R.id.login_edit_user_pwd);
		editUserPwd.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				// 当输入的密码错误时，点击按钮，清空，重新输入
				if (editUserPwd.getText().toString().trim().equals("")) {
					mImgErrorNo.setVisibility(View.GONE);
				} else {
					mImgErrorNo.setVisibility(View.VISIBLE);
				}
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				// TODO Auto-generated method stub
			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub
			}
		});
		bntRememberUserName = (CheckBox) this
				.findViewById(R.id.login_remember_user_name);
		bntRememberUserName.setChecked(true);
		// bntRememberUserName =
		// (ToggleButton)this.findViewById(R.id.login_remember_user_name);
		// bntRememberUserName.setChecked(true);

		// 判断是否记住手机号
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String isRememberUserName = mySharedPreferences.getString(
				"login_isRememberUserName", "");
		String mobile = mySharedPreferences.getString("login_mobile", "");
		if (Constants.PUBLIC_Y.equals(isRememberUserName)) {
			if (mobile.length() == 11) {
				editUserName.setText(mobile);
			}
		}
		// 检查是否有版本更新
		VersionTask versionTask = new VersionTask();
		versionTask.execute();
	}

	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			propmptExit(loginActivity);
		}
		return false;
	}

	// 登录操作类
	class LoginTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("登录进行中...");
			dialog.show();
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
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				Toast.makeText(loginActivity, respDesc, Toast.LENGTH_SHORT)
						.show();
				return;
			}

			// 判断是否记住用户名
			try {
				String merId = resultMap.get("merId");
				String merName = resultMap.get("merName");
				String lastLoginDate = resultMap.get("lastLoginDate").trim();
				String isAuthentication = resultMap.get("isAuthentication");
				String sessionId = resultMap.get("sessionId");

				SharedPreferences mySharedPreferences = getSharedPreferences(
						"qmpos", Activity.MODE_PRIVATE);
				SharedPreferences.Editor editor = mySharedPreferences.edit();

				// 将登录后的商户信息保存
				editor.putString("loginId", editUserName.getText().toString()
						.trim());
				editor.putString("loginPwd", editUserPwd.getText().toString()
						.trim());
				editor.putString("merId", merId);
				editor.putString("merName", merName);
				editor.putString("lastLoginDate", lastLoginDate);
				editor.putString("isAuthentication", isAuthentication);
				editor.putString("sessionId", sessionId);
				// 将cookie保存
				Constants.cookie = sessionId;

				editor.putString("login_isRememberUserName", Constants.PUBLIC_Y);
				editor.putString("login_mobile", editUserName.getText()
						.toString().trim());
				MD5Hash m = new MD5Hash();
				editor.putString("login_pwd",
						m.getMD5ofStr(editUserPwd.getText().toString().trim()));
				editor.commit();
				dialog.hide();

				// 初始化 JPush,在登录之后收到推送消息
				JPushInterface.setDebugMode(true); // 设置开启日志,发布时请关闭日志
				JPushInterface.init(getApplicationContext());
				setAlias(merId);

				Intent i = new Intent(loginActivity, MainActivity.class);
				i.putExtra("isAuthentication", isAuthentication);
				loginActivity.startActivity(i);
			} catch (Exception e) {
			}
		}
	}

	// ===============Jpush设置别名=====================
	private void setAlias(String alias) {

		if (TextUtils.isEmpty(alias)) {
			showToast("设备别名为空");
			return;
		}

		// 调用 Handler 来异步设置别名
		mHandler.sendMessage(mHandler.obtainMessage(MSG_SET_ALIAS, alias));
	}

	private final TagAliasCallback mAliasCallback = new TagAliasCallback() {
		@Override
		public void gotResult(int code, String alias, Set<String> tags) {
			String logs;
			switch (code) {
			case 0:
				logs = "Set tag and alias success";
				Log.i(TAG, logs);
				// 建议这里往 SharePreference 里写一个成功设置的状态。成功设置一次后，以后不必再次设置了。
				break;
			case 6002:
				logs = "Failed to set alias and tags due to timeout. Try again after 60s.";
				Log.i(TAG, logs);
				// 延迟 60 秒来调用 Handler 设置别名
				mHandler.sendMessageDelayed(
						mHandler.obtainMessage(MSG_SET_ALIAS, alias), 1000 * 60);
				break;
			default:
				logs = "Failed with errorCode = " + code;
				Log.e(TAG, logs);
			}
			Toast.makeText(getApplicationContext(), logs, 3000).show();
		}

	};
	private static final int MSG_SET_ALIAS = 1001;
	@SuppressLint("ShowToast")
	private final Handler mHandler = new Handler() {
		@SuppressLint("HandlerLeak")
		@Override
		public void handleMessage(android.os.Message msg) {
			super.handleMessage(msg);
			switch (msg.what) {
			case MSG_SET_ALIAS:
				Log.d(TAG, "Set alias in handler.");
				// 调用 JPush 接口来设置别名。
				JPushInterface.setAliasAndTags(getApplicationContext(),
						(String) msg.obj, null, mAliasCallback);
				break;
			default:
				Log.i(TAG, "Unhandled msg - " + msg.what);
			}
		}
	};

	public boolean onTouchEvent(MotionEvent event) {
		InputMethodManager imm = (InputMethodManager) this
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(editUserName.getWindowToken(), 0);
		return super.onTouchEvent(event);
	}

	// 版本检查类
	class VersionTask extends AsyncTask<String, Integer, String> {

		protected void onPreExecute() {
		}

		protected String doInBackground(String... params) {
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("appType", "android");
				String requestUrl = Constants.server_host
						+ Constants.server_version_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				System.out.println("http:" + responseStr);
				return responseStr;
			} catch (Exception e) {
				e.printStackTrace();
				return Constants.ERROR;
			}
		}

		protected void onPostExecute(String result) {
			try {
				if (Constants.ERROR.equals(result)) {
					return;
				}

				// 解释返回的JSON
				JSONTokener jsonParser = new JSONTokener(result);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();

				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				String versionId = jsonObj.getString("versionId");
				String needUpate = jsonObj.getString("needUpate");
				String appUrl = jsonObj.getString("appUrl");

				// 判断返回状态
				if (Constants.SERVER_SUCC.equals(respCode)) {
					// 判断当前的版本与服务器上的最瓣版本是否一致
					PackageInfo pkg = getPackageManager().getPackageInfo(
							getApplication().getPackageName(), 0);
					String appName = pkg.applicationInfo.loadLabel(
							getPackageManager()).toString();
					String nowVersionId = pkg.versionName;
					System.out.println("appName:" + appName);
					System.out.println("versionName:" + nowVersionId);
					if (nowVersionId.equals(versionId)) {
						return;
					}

					// 判断是否强制更新

					// 弹框提示
					APPURL = appUrl;
					AlertDialog.Builder builder = new AlertDialog.Builder(
							mContext);
					builder.setTitle("版本更新");
					builder.setMessage("存在最新的版本程序，确认是否更新！");
					builder.setPositiveButton("更新",
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int which) {
									Intent intent = new Intent(
											Intent.ACTION_VIEW,
											Uri.parse(LoginActivity.APPURL));
									mContext.startActivity(intent);
								}
							});
					builder.setNegativeButton("暂不更新", null);
					builder.show();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
