package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.telephony.SmsMessage;
import android.text.TextUtils;
import android.text.format.Time;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import cn.qmpos.R;
import cn.qmpos.async.SmsTask;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class FindLoginPwd1Activity extends BaseActivity implements
		OnClickListener {

	private TimeCount time;
	private Button btnGetSmsCode, btnBack, btnNext;
	private EditText editMobile, editSmsCode;
	private FindLoginPwd1Activity findLoginPwd1Activity;
	private String mobileNo, smsCode;

	private BroadcastReceiver smsReceiver;
	private IntentFilter filter;
	private Handler handler;
	private String strContent, verificationCode;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_find_login_pwd1);
		init();
		SmsContent();
	}

	// ����У��
	private void SmsContent() {
		handler = new Handler() {
			public void handleMessage(Message msg) {
				editSmsCode.setText(verificationCode);
			};
		};
		filter = new IntentFilter();
		filter.addAction(Constants.SSMS_ACTION);
		filter.setPriority(Integer.MAX_VALUE);
		smsReceiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				Object[] objs = (Object[]) intent.getExtras().get("pdus");
				for (Object obj : objs) {
					byte[] pdu = (byte[]) obj;
					SmsMessage sms = SmsMessage.createFromPdu(pdu);
					// ���ŵ�����
					String message = sms.getMessageBody();
					Log.d("logo", "message     " + message);
					// ��Ϣ���ֻ��š���+86��ͷ��
					String from = sms.getOriginatingAddress();
					Log.d("logo", "from     " + from);
					Time time = new Time();
					time.set(sms.getTimestampMillis());
					String time2 = time.format3339(true);
					Log.d("logo", from + "   " + message + "  " + time2);
					strContent = from + "   " + message;
					handler.sendEmptyMessage(1);
					if (!TextUtils.isEmpty(from)) {

						int p = message.indexOf("��֤��");
						if (p != -1) {
							verificationCode = message.substring(p + 4, p + 8);
							// editSmsCode.setText(verificationCode);
						}
						String code = CommUtil.patternCode(message);
						if (!TextUtils.isEmpty(code)) {
							strContent = code;
							handler.sendEmptyMessage(1);
						}
					}
				}
			}
		};
		registerReceiver(smsReceiver, filter);
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.find_login_pwd1_btn_back);
		btnNext = (Button) this.findViewById(R.id.find_login_pwd1_btn_next);
		btnGetSmsCode = (Button) this
				.findViewById(R.id.find_login_pwd1_btn_getSmsCode);
		btnBack.setOnClickListener(this);
		btnNext.setOnClickListener(this);
		btnGetSmsCode.setOnClickListener(this);
		editMobile = (EditText) this
				.findViewById(R.id.find_login_pwd1_edit_mobile);

		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String loginId = mySharedPreferences.getString("loginId", "");
		editMobile.setText(loginId);
		editSmsCode = (EditText) this
				.findViewById(R.id.find_login_pwd1_edit_smsCode);
		time = new TimeCount(60000, 1000);// ����CountDownTimer����
		findLoginPwd1Activity = this;

	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.find_login_pwd1_btn_back:
				finish();
				break;
			case R.id.find_login_pwd1_btn_next:
				next();
				break;
			case R.id.find_login_pwd1_btn_getSmsCode:
				getSmsCode();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void next() {
		// �ж��ֻ��Ÿ�ʽ
		mobileNo = editMobile.getText().toString().trim();
		smsCode = editSmsCode.getText().toString().trim();

		if ("".equals(mobileNo) || mobileNo.length() != 11
				|| !CommUtil.isMp(mobileNo)) {
			showToast("�ֻ��Ŵ���");
			return;
		}
		if (smsCode.length() != 4) {
			showToast("��������λ��Ч��֤��");
			return;
		}
		if ("".equals(smsCode) || smsCode.length() < 4) {
			showToast("��������ȷ����֤�룡");
			return;
		}

		FindLoginPwd1Task findLoginPwd1Task = new FindLoginPwd1Task();
		findLoginPwd1Task.execute(new String[] { mobileNo, smsCode });
	}

	private void getSmsCode() {
		String mobileNo = editMobile.getText().toString().trim();

		if ("".equals(mobileNo) || mobileNo.length() != 11
				|| !CommUtil.isMp(mobileNo)) {
			showToast("�ֻ��Ŵ���");
			return;
		}

		time.start();// ��ʼ��ʱ

		SmsTask smsTask = new SmsTask(mobileNo);
		smsTask.execute();
	}

	class FindLoginPwd1Task extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ϵͳ������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();

			// �ж��ֻ����Ƿ����
			try {
				MD5Hash m = new MD5Hash();
				String signMsg = Constants.server_agent_id + params[0]
						+ Constants.server_md5key;
				String chkValue = m.getMD5ofStr(signMsg);

				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("loginId", params[0]);
				map.put("chkValue", chkValue);
				String requestUrl = Constants.server_host
						+ Constants.server_mobileexistverify_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�json
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				String isExist = jsonObj.getString("isExist");
				if (!Constants.PUBLIC_Y.equals(isExist)) {
					returnMap.put("respCode", Constants.SERVER_SYSERR);
					returnMap.put("respDesc", "���ֻ���δע��!");
				} else {
					returnMap.put("respCode", respCode);
					returnMap.put("respDesc", respDesc);
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
				showToast(respDesc);
				return;
			}

			try {
				dialog.hide();
				Intent i = new Intent(findLoginPwd1Activity,
						FindLoginPwd2Activity.class);
				i.putExtra("mobile", editMobile.getText().toString().trim());
				i.putExtra("smsCode", editSmsCode.getText().toString().trim());

				findLoginPwd1Activity.startActivity(i);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	class TimeCount extends CountDownTimer {
		public TimeCount(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);// ��������Ϊ��ʱ��,�ͼ�ʱ��ʱ����
		}

		@Override
		public void onFinish() {// ��ʱ���ʱ����
			btnGetSmsCode.setText("��ȡ��֤��");
			btnGetSmsCode.setClickable(true);
		}

		@Override
		public void onTick(long millisUntilFinished) {// ��ʱ������ʾ
			btnGetSmsCode.setClickable(false);
			btnGetSmsCode.setText(millisUntilFinished / 1000 + "��");
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(smsReceiver);
	}
}
