package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
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

public class FindLoginPwd2Activity extends BaseActivity implements
		OnClickListener {

	private EditText editNewPwd;
	private EditText editNewPwdAgain;

	private Button btnBack;
	private Button btnSubmit;

	private FindLoginPwd2Activity findLoginPwd2Activity;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_find_login_pwd2);

		init();

	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.find_login_pwd2_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.find_login_pwd2_btn_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);

		editNewPwd = (EditText) this
				.findViewById(R.id.find_login_pwd2_edit_new_pwd);
		editNewPwdAgain = (EditText) this
				.findViewById(R.id.find_login_pwd2_edit_new_pwd_again);

		findLoginPwd2Activity = this;
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.find_login_pwd2_btn_back:
				finish();
				break;
			case R.id.find_login_pwd2_btn_submit:
				findPwd();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void findPwd() {

		String newPwd = editNewPwd.getText().toString().trim();
		if ((newPwd == null) || (newPwd.equals(""))) {
			Toast.makeText(this, "新密码不能为空", Toast.LENGTH_SHORT).show();
			return;
		}

		// if (!newPwd.matches("^(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9]{8,}$"))
		// {
		// Toast.makeText(this, "密码必须包含数字和字母且长度最少8位", Toast.LENGTH_SHORT)
		// .show();
		// return;
		// }

		if (newPwd.length() != 6) {
			Toast.makeText(this, "登录密码长度最少为6位", Toast.LENGTH_SHORT).show();
			return;
		}

		String newPwdAgain = editNewPwdAgain.getText().toString().trim();
		if (!newPwd.equals(newPwdAgain)) {
			Toast.makeText(this, "密码二次输入不一致", Toast.LENGTH_SHORT).show();
			return;
		}

		Intent intent = getIntent();
		String mobile = intent.getStringExtra("mobile");
		String smscode = intent.getStringExtra("smsCode");

		MD5Hash m = new MD5Hash();

		FindLoginPwd2Task findLoginPwd2Task = new FindLoginPwd2Task();
		findLoginPwd2Task.execute(new String[] { mobile, smscode,
				m.getMD5ofStr(newPwd) });

	}

	class FindLoginPwd2Task extends
			AsyncTask<String, Integer, HashMap<String, String>> {

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
				map.put("loginId", params[0]);
				map.put("smsCode", params[1]);
				map.put("newPwd", params[2]);

				String requestUrl = Constants.server_host
						+ Constants.server_updateLoginPwd_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(
						requestUrl, map);
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
				Toast.makeText(findLoginPwd2Activity, respDesc,
						Toast.LENGTH_SHORT).show();
				return;
			}

			try {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						findLoginPwd2Activity);
				builder.setTitle("提示");
				builder.setMessage("密码更新成功，请重新登录！");
				builder.setPositiveButton("确认",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								Intent i = new Intent(findLoginPwd2Activity,
										LoginActivity.class);
								findLoginPwd2Activity.startActivity(i);
							}
						});
				builder.show();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
