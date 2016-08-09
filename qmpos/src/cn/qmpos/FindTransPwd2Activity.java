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
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;
import cn.qmpos.R;

public class FindTransPwd2Activity extends BaseActivity implements OnClickListener {

	private EditText editNewPwd;
	private EditText editNewPwdAgain;

	private Button btnBack;
	private Button btnSubmit;

	private FindTransPwd2Activity findTransPwd2Activity;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_find_trans_pwd2);
		init();

	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.find_trans_pwd2_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.find_trans_pwd2_btn_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);

		editNewPwd = (EditText) this.findViewById(R.id.find_trans_pwd2_edit_new_pwd);
		editNewPwdAgain = (EditText) this.findViewById(R.id.find_trans_pwd2_edit_new_pwd_again);

		findTransPwd2Activity = this;
	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.find_trans_pwd2_btn_back:
				i = new Intent(this, FindTransPwd1Activity.class);
				this.startActivity(i);
				break;
			case R.id.find_trans_pwd2_btn_submit:
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
			Toast.makeText(this, "�����벻��Ϊ��", Toast.LENGTH_SHORT).show();
			return;
		}
		if (newPwd.length() != 6) {
			Toast.makeText(this, "����ĳ��ȱ�����6λ", Toast.LENGTH_SHORT).show();
			return;
		}

		String newPwdAgain = editNewPwdAgain.getText().toString().trim();
		if (!newPwd.equals(newPwdAgain)) {
			Toast.makeText(this, "����������벻һ��", Toast.LENGTH_SHORT).show();
			return;
		}

		Intent intent = getIntent();
		String mobile = intent.getStringExtra("mobile");
		String smscode = intent.getStringExtra("smsCode");

		MD5Hash m = new MD5Hash();
		FindTransPwd2Task findTransPwd2Task = new FindTransPwd2Task();
		findTransPwd2Task.execute(new String[] { mobile, smscode, m.getMD5ofStr(newPwd) });

	}

	class FindTransPwd2Task extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ϵͳ������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("loginId", params[0]);
				map.put("smsCode", params[1]);
				map.put("newPwd", params[2]);

				String requestUrl = Constants.server_host + Constants.server_updateTransPwd_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", responseStr);
					return returnMap;
				}

				// ���ͷ��ص�JSON
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
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				Toast.makeText(findTransPwd2Activity, respDesc, Toast.LENGTH_SHORT).show();
				return;
			}

			try {
				AlertDialog.Builder builder = new AlertDialog.Builder(findTransPwd2Activity);
				builder.setTitle("�ɹ�");
				builder.setMessage("����������ĳɹ���");
				builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent i = new Intent(findTransPwd2Activity, MainActivity.class);
						findTransPwd2Activity.startActivity(i);
					}
				});
				builder.show();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
