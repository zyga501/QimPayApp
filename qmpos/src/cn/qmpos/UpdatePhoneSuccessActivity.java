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

import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;

/**
 * 更换手机号
 * 
 * @author Administrator
 * 
 */
public class UpdatePhoneSuccessActivity extends BaseActivity implements
		OnClickListener {

	private EditText ed_original_phone, ed_new_phone;
	private Button btnBack, btnUpdatePhoneSubmit;
	private UpdatePhoneSuccessActivity UpdatePhoneSuccessActivity;
	private String merId;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.update_phone_success);
		allActivity.add(this);
		init();

	}

	private void init() {
		UpdatePhoneSuccessActivity = this;
		btnBack = (Button) findViewById(R.id.btn_back);
		btnUpdatePhoneSubmit = (Button) findViewById(R.id.btn_update_phone_submit);
		ed_original_phone = (EditText) this
				.findViewById(R.id.ed_original_phone);
		ed_new_phone = (EditText) this.findViewById(R.id.ed_new_phone);
		btnBack.setOnClickListener(this);
		btnUpdatePhoneSubmit.setOnClickListener(this);

		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String loginId = mySharedPreferences.getString("loginId", "");
		merId = mySharedPreferences.getString("merId", "");
		ed_original_phone.setText(loginId);
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			case R.id.btn_update_phone_submit:
				updatePhone();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void updatePhone() {
		String newPhone = ed_new_phone.getText().toString().trim();
		if ((newPhone == null) || (newPhone.equals(""))) {
			showToast("请输入您要更换的手机号码");
			return;
		}

		Intent intent = getIntent();
		String smscode = intent.getStringExtra("smsCode");

		MobileModifyTask mobileModifyTask = new MobileModifyTask();
		mobileModifyTask.execute(new String[] { merId, newPhone, smscode });

	}

	class MobileModifyTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("正在更改，请稍候...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("merId", params[0]);
				map.put("loginId", params[1]);
				map.put("smsCode", params[2]);

				String requestUrl = Constants.server_host
						+ Constants.server_mobileModify_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
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
				Toast.makeText(UpdatePhoneSuccessActivity, respDesc,
						Toast.LENGTH_SHORT).show();
				return;
			}

			try {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						UpdatePhoneSuccessActivity);
				builder.setTitle("成功");
				builder.setMessage("手机号码更改成功,请重新登录！");
				builder.setPositiveButton("确认",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								Intent i = new Intent(
										UpdatePhoneSuccessActivity,
										LoginActivity.class);
								UpdatePhoneSuccessActivity.startActivity(i);
							}
						});
				builder.show();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
