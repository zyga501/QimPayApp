package cn.qmpos;

import java.util.HashMap;
import java.util.regex.Pattern;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.text.Selection;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class Reg2Activity extends BaseActivity implements OnClickListener {

	private EditText editRealName, editTransPwd, editLoginPwd, editChnlId;
	private ImageView login_showpwd, trading_showpwd;
	private Reg2Activity reg2Activity;
	private int count1 = 0, count2 = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_reg2);
		initView();
	}

	private void initView() {
		reg2Activity = this;
		View btnBack = this.findViewById(R.id.reg2_btn_back);
		View btnNext = this.findViewById(R.id.reg2_btn_confirm);
		editRealName = (EditText) this.findViewById(R.id.reg2_edit_real_name);
		editLoginPwd = (EditText) this.findViewById(R.id.reg2_edit_login_pwd);
		editTransPwd = (EditText) this.findViewById(R.id.reg2_edit_trans_pwd);
		editChnlId = (EditText) this.findViewById(R.id.reg2_edit_chnl_id);
		dialog = new ProgressDialog(this);
		dialog.setCanceledOnTouchOutside(false);
		login_showpwd = (ImageView) findViewById(R.id.login_showpwd);
		trading_showpwd = (ImageView) findViewById(R.id.trading_showpwd);
		login_showpwd.setOnClickListener(this);
		trading_showpwd.setOnClickListener(this);
		btnBack.setOnClickListener(this);
		btnNext.setOnClickListener(this);
	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.reg2_btn_back:
				finish();
				break;
			case R.id.reg2_btn_confirm:
				register();
				break;
			case R.id.login_showpwd:
				if (count1 == 0) {
					login_showpwd.setImageResource(R.drawable.xianshi);
					count1 = 1;
					editLoginPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
				} else {
					login_showpwd.setImageResource(R.drawable.yincang);
					count1 = 0;
					editLoginPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
				}
				Editable etable = editLoginPwd.getText();
				Selection.setSelection(etable, etable.length());
				break;
			case R.id.trading_showpwd:
				if (count2 == 0) {
					trading_showpwd.setImageResource(R.drawable.xianshi);
					count2 = 1;
					editTransPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
				} else {
					trading_showpwd.setImageResource(R.drawable.yincang);
					count2 = 0;
					editTransPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
				}
				Editable etable2 = editTransPwd.getText();
				Selection.setSelection(etable2, etable2.length());
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressLint("DefaultLocale")
	private void register() {
		String realName = editRealName.getText().toString().trim();
		if ((realName == null) || realName.equals("")) {
			showToast("��������ʵ����");
			return;
		}
		if (!Pattern.matches("[\\u4e00-\\u9FA5\\uF900-\\uFA2D]+", realName)) {
			showToast("��ʵ��������ȫΪ����");
			return;
		}
		if (realName.length() > 10) {
			showToast("��ʵ�������10λ");
			return;
		}
		String loginPwd = editLoginPwd.getText().toString().trim();
		if ((loginPwd == null) || (loginPwd.equals(""))) {
			showToast("��¼���벻��Ϊ��");
			return;
		}
		if (loginPwd.length() != 6) {
			showToast("��¼���볤�ȱ���Ϊ6λ");
			return;
		}
		String transPwd = editTransPwd.getText().toString().trim();
		if ((transPwd == null) || (loginPwd.equals(""))) {
			showToast("�������벻��Ϊ��");
			return;
		}
		if (transPwd.length() != 6) {
			showToast("��������ĳ��ȱ���Ϊ6λ");
			return;
		}
		if (loginPwd.equals(transPwd)) {
			showToast("��¼����ͽ������벻�����");
			return;
		}

		String chnlId = editChnlId.getText().toString().trim().toUpperCase();
		if ((chnlId == null) || (chnlId.equals(""))) {
			showToast("�������Ƽ��ֻ���");
			return;
		}

		Intent intent = getIntent();
		String mobile = intent.getStringExtra("mobile");
		String smscode = intent.getStringExtra("smsCode");

		MD5Hash m = new MD5Hash();

		Reg2Task reg2Task = new Reg2Task();
		reg2Task.execute(new String[] { realName, "", m.getMD5ofStr(loginPwd), m.getMD5ofStr(transPwd), chnlId, mobile,
				smscode });
	}

	class Reg2Task extends AsyncTask<String, Integer, HashMap<String, String>> {

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
				map.put("merName", params[0]);
				map.put("certId", params[1]);
				map.put("loginPwd", params[2]);
				map.put("transPwd", params[3]);
				map.put("chnlId", params[4]);
				map.put("loginId", params[5]);
				map.put("smsCode", params[6]);

				String requestUrl = Constants.server_host + Constants.server_register_url;
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
				returnMap.put("respDesc", e.getMessage());
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				Toast.makeText(reg2Activity, respDesc, Toast.LENGTH_SHORT).show();
				return;
			}

			try {
				AlertDialog.Builder builder = new AlertDialog.Builder(reg2Activity);
				builder.setTitle("��ʾ");
				builder.setMessage("ע��ɹ�,ϵͳ��ת����¼����!");
				builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent i = new Intent(reg2Activity, LoginActivity.class);
						reg2Activity.startActivity(i);
					}
				});
				builder.show();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
