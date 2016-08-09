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

		// ��ʼ��
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
			showToast("�ֻ��Ŵ���");
			return;
		}

		if (userPwd == null || "".equals(userPwd)) {
			showToast("�������¼���룡");
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
				// ��������������ʱ�������ť����գ���������
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

		// �ж��Ƿ��ס�ֻ���
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
		// ����Ƿ��а汾����
		VersionTask versionTask = new VersionTask();
		versionTask.execute();
	}

	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			propmptExit(loginActivity);
		}
		return false;
	}

	// ��¼������
	class LoginTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("��¼������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
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
					returnMap.put("respDesc", "�������Ƿ�����");
					return returnMap;
				}

				// ���ͷ��ص�JSON
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
				returnMap.put("respDesc", "ϵͳ�쳣");
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

			// �ж��Ƿ��ס�û���
			try {
				String merId = resultMap.get("merId");
				String merName = resultMap.get("merName");
				String lastLoginDate = resultMap.get("lastLoginDate").trim();
				String isAuthentication = resultMap.get("isAuthentication");
				String sessionId = resultMap.get("sessionId");

				SharedPreferences mySharedPreferences = getSharedPreferences(
						"qmpos", Activity.MODE_PRIVATE);
				SharedPreferences.Editor editor = mySharedPreferences.edit();

				// ����¼����̻���Ϣ����
				editor.putString("loginId", editUserName.getText().toString()
						.trim());
				editor.putString("loginPwd", editUserPwd.getText().toString()
						.trim());
				editor.putString("merId", merId);
				editor.putString("merName", merName);
				editor.putString("lastLoginDate", lastLoginDate);
				editor.putString("isAuthentication", isAuthentication);
				editor.putString("sessionId", sessionId);
				// ��cookie����
				Constants.cookie = sessionId;

				editor.putString("login_isRememberUserName", Constants.PUBLIC_Y);
				editor.putString("login_mobile", editUserName.getText()
						.toString().trim());
				MD5Hash m = new MD5Hash();
				editor.putString("login_pwd",
						m.getMD5ofStr(editUserPwd.getText().toString().trim()));
				editor.commit();
				dialog.hide();

				// ��ʼ�� JPush,�ڵ�¼֮���յ�������Ϣ
				JPushInterface.setDebugMode(true); // ���ÿ�����־,����ʱ��ر���־
				JPushInterface.init(getApplicationContext());
				setAlias(merId);

				Intent i = new Intent(loginActivity, MainActivity.class);
				i.putExtra("isAuthentication", isAuthentication);
				loginActivity.startActivity(i);
			} catch (Exception e) {
			}
		}
	}

	// ===============Jpush���ñ���=====================
	private void setAlias(String alias) {

		if (TextUtils.isEmpty(alias)) {
			showToast("�豸����Ϊ��");
			return;
		}

		// ���� Handler ���첽���ñ���
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
				// ���������� SharePreference ��дһ���ɹ����õ�״̬���ɹ�����һ�κ��Ժ󲻱��ٴ������ˡ�
				break;
			case 6002:
				logs = "Failed to set alias and tags due to timeout. Try again after 60s.";
				Log.i(TAG, logs);
				// �ӳ� 60 �������� Handler ���ñ���
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
				// ���� JPush �ӿ������ñ�����
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

	// �汾�����
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

				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(result);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();

				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				String versionId = jsonObj.getString("versionId");
				String needUpate = jsonObj.getString("needUpate");
				String appUrl = jsonObj.getString("appUrl");

				// �жϷ���״̬
				if (Constants.SERVER_SUCC.equals(respCode)) {
					// �жϵ�ǰ�İ汾��������ϵ����汾�Ƿ�һ��
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

					// �ж��Ƿ�ǿ�Ƹ���

					// ������ʾ
					APPURL = appUrl;
					AlertDialog.Builder builder = new AlertDialog.Builder(
							mContext);
					builder.setTitle("�汾����");
					builder.setMessage("�������µİ汾����ȷ���Ƿ���£�");
					builder.setPositiveButton("����",
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int which) {
									Intent intent = new Intent(
											Intent.ACTION_VIEW,
											Uri.parse(LoginActivity.APPURL));
									mContext.startActivity(intent);
								}
							});
					builder.setNegativeButton("�ݲ�����", null);
					builder.show();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
