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
import android.widget.TextView;
import cn.qmpos.R;

import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class ScanAfterPaymentActivity extends BaseActivity implements
		OnClickListener {

	private TextView shoukuan_name, shoukuan_mobile, fukuan_money, fukuan_note,
			zhuagnhu_yue_money, keyong_yue_money;
	private EditText edit_trading_pwd;
	private Button btn_back, btn_after_money_submit;
	private SharedPreferences sp;
	private String merId, loginId, sessionId, userMerId;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_scan_after_payment);
		initView();
		valuesUrl();
	}

	private void valuesUrl() {
		String values = getIntent().getStringExtra("Values");
		// "2000000055^M1509080079759^������^18611710508^10000.00^����"
		try {
			String[] vs = values.split("\\^");
			System.out.println("Values=" + values);
			userMerId = vs[1];
			shoukuan_name.setText(vs[2]);
			shoukuan_mobile.setText(vs[3]);
			fukuan_money.setText(vs[4]);
			fukuan_note.setText(vs[5]);
		} catch (Exception e) {
			if (values.indexOf("http") != -1) {
				Intent intent = new Intent(this, WebViewActivity.class);
				intent.putExtra("url", values);
				intent.putExtra("title", " ");
				startActivity(intent);
				finish();
			} else {
				e.printStackTrace();
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setTitle("��ʾ");
				builder.setMessage("�˶�ά�����");
				builder.setPositiveButton("ȷ��",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								finish();
							}
						});
				builder.show();
			}
		}
	}

	private void initView() {
		shoukuan_name = (TextView) findViewById(R.id.shoukuan_name);
		shoukuan_mobile = (TextView) findViewById(R.id.shoukuan_mobile);
		fukuan_money = (TextView) findViewById(R.id.fukuan_money);
		fukuan_note = (TextView) findViewById(R.id.fukuan_note);
		zhuagnhu_yue_money = (TextView) findViewById(R.id.zhuagnhu_yue_money);
		keyong_yue_money = (TextView) findViewById(R.id.keyong_yue_money);
		edit_trading_pwd = (EditText) findViewById(R.id.edit_trading_pwd);
		btn_back = (Button) findViewById(R.id.btn_back);
		btn_back.setOnClickListener(this);
		btn_after_money_submit = (Button) findViewById(R.id.btn_after_money_submit);
		btn_after_money_submit.setOnClickListener(this);

		sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		merId = sp.getString("merId", "");
		loginId = sp.getString("loginId", "");
		sessionId = sp.getString("sessionId", "");
		String acctBal = sp.getString("PAY0_acctBal", "0.00");
		String avlBal = sp.getString("PAY0_avlBal", "0.00");
		zhuagnhu_yue_money.setText(acctBal + "Ԫ");
		keyong_yue_money.setText(avlBal + "Ԫ");

		InitTask initTask = new InitTask();
		initTask.execute(new String[] { merId, loginId, sessionId });
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			case R.id.btn_after_money_submit:
				init();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void init() {
		String shoukuanMobile = shoukuan_mobile.getText().toString().trim();
		String fukuanMoney = fukuan_money.getText().toString().trim();
		String fukuanNote = fukuan_note.getText().toString().trim();

		String trading_pwd = edit_trading_pwd.getText().toString().trim();
		if (trading_pwd == null || "".equals(trading_pwd)) {
			showToast("�����뽻�����룡");
			return;
		}

		MD5Hash m = new MD5Hash();
		ScanAfterPaymentTask scanAfterPaymentTask = new ScanAfterPaymentTask();
		scanAfterPaymentTask.execute(new String[] { userMerId, shoukuanMobile,
				fukuanMoney, fukuanNote, m.getMD5ofStr(trading_pwd) });

	}

	// ��ѯ�ʽ��̻����
	class InitTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("���ݼ�����...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();

			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("acctType", "PAY0");
				map.put("sessionId", params[2]);

				String requestUrl = Constants.server_host
						+ Constants.server_queryMerBal_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(
						requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("PAY0_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("PAY0_avlBal", jsonObj.getString("avlBal"));
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();

			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast(respDesc);
			}

			try {
				SharedPreferences sp = getSharedPreferences("qmpos",
						Activity.MODE_PRIVATE);
				SharedPreferences.Editor editor = sp.edit();
				// ����¼����̻���Ϣ����
				editor.putString("totAmtT1", resultMap.get("totAmtT1"));
				editor.putString("PAY0_acctBal", resultMap.get("PAY0_acctBal"));
				editor.putString("PAY0_avlBal", resultMap.get("PAY0_avlBal"));
				editor.commit();

				float totAmtT1 = Float
						.parseFloat(resultMap.get("PAY0_acctBal"));
				float avlBal = Float.parseFloat(resultMap.get("PAY0_avlBal"));
				float liqAmt = avlBal - totAmtT1;
				// ������Ϊ����״̬����Χ0Ԫ
				if (liqAmt < 0) {
					liqAmt = 0;
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	// ɨ�踶��
	class ScanAfterPaymentTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ϵͳ������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
				map.put("agentId", Constants.server_agent_id);
				System.out.println(params[0] + "----------");
				map.put("merId", params[0]);
				map.put("mobile", params[1]);
				map.put("transAmt", params[2]);
				map.put("trfTitle", params[3]);
				map.put("transPwd", params[4]);
				map.put("clientModel", android.os.Build.MODEL);
				String requestUrl = Constants.server_host
						+ Constants.server_doTrfToMer_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
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
				showToast(respDesc);
				return;
			} else {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						ScanAfterPaymentActivity.this);
				builder.setTitle("��ʾ");
				builder.setMessage("����ɹ�");
				builder.setPositiveButton("ȷ��",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								Intent intent = new Intent(
										ScanAfterPaymentActivity.this,
										MainActivity.class);
								startActivity(intent);
							}
						});
				builder.show();
			}
		}
	}
}
