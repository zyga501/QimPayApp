package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import cn.qmpos.R;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class ModifyLoginPwdActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;
	private Button btnSubmit;

	private EditText editNowPwd;
	private EditText editNewPwd;
	private EditText editAgainPwd;

	private ModifyLoginPwdActivity modifyLoginPwdActivity;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_modify_login_pwd);

		init();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.modify_login_pwd_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.modify_login_pwd_btn_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);

		editNowPwd = (EditText) this.findViewById(R.id.modify_login_pwd_now_pwd);
		editNewPwd = (EditText) this.findViewById(R.id.modify_login_pwd_new_pwd);
		editAgainPwd = (EditText) this.findViewById(R.id.modify_login_pwd_again_pwd);

		modifyLoginPwdActivity = this;
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.modify_login_pwd_btn_back:
				finish();
				break;
			case R.id.modify_login_pwd_btn_submit:
				submit();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void submit() {
		String nowPwd = editNowPwd.getText().toString().trim();
		String newPwd = editNewPwd.getText().toString().trim();
		String againPwd = editAgainPwd.getText().toString().trim();

		if ((nowPwd == null) || (nowPwd.equals(""))) {
			Toast.makeText(this, "原密码不能为空", Toast.LENGTH_SHORT).show();
			return;
		}

		if ((newPwd == null) || (newPwd.equals(""))) {
			Toast.makeText(this, "新密码不能为空", Toast.LENGTH_SHORT).show();
			return;
		}

		// if (!newPwd.matches("^(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9]{6,}$"))
		// {
		// Toast.makeText(this, "密码必须包含数字和字母且长度最少6位", Toast.LENGTH_SHORT)
		// .show();
		// return;
		// }

		if (newPwd.length() != 6) {
			Toast.makeText(this, "登录密码长度为6位", Toast.LENGTH_SHORT).show();
			return;
		}

		if (!newPwd.equals(againPwd)) {
			Toast.makeText(this, "密码二次输入不一致", Toast.LENGTH_SHORT).show();
			return;
		}

		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String mobile = mySharedPreferences.getString("loginId", "");
		String sessionId = mySharedPreferences.getString("sessionId", "");

		MD5Hash m = new MD5Hash();

		ModifyLoginPwdTask modifyLoginPwdTask = new ModifyLoginPwdTask();
		modifyLoginPwdTask.execute(new String[] { sessionId, mobile, m.getMD5ofStr(nowPwd), m.getMD5ofStr(newPwd) });
	}

	class ModifyLoginPwdTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("系统处理中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("loginId", params[1]);
				map.put("oldPwd", params[2]);
				map.put("newPwd", params[3]);

				String requestUrl = Constants.server_host + Constants.server_updateLoginPwd_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", responseStr);
					return returnMap;
				}

				// 解释返回的JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
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
				Toast.makeText(modifyLoginPwdActivity, respDesc, Toast.LENGTH_SHORT).show();
				return;
			}

			try {
				AlertDialog.Builder builder = new AlertDialog.Builder(modifyLoginPwdActivity);
				builder.setTitle("成功");
				builder.setMessage("登录密码更改成功！");
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent i = new Intent(modifyLoginPwdActivity, MainActivity.class);
						modifyLoginPwdActivity.startActivity(i);
					}
				});
				builder.show();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
}
