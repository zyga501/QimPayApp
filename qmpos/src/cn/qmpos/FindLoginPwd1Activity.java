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

	// 短信校验
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
					// 短信的内容
					String message = sms.getMessageBody();
					Log.d("logo", "message     " + message);
					// 短息的手机号。。+86开头？
					String from = sms.getOriginatingAddress();
					Log.d("logo", "from     " + from);
					Time time = new Time();
					time.set(sms.getTimestampMillis());
					String time2 = time.format3339(true);
					Log.d("logo", from + "   " + message + "  " + time2);
					strContent = from + "   " + message;
					handler.sendEmptyMessage(1);
					if (!TextUtils.isEmpty(from)) {

						int p = message.indexOf("验证码");
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
		time = new TimeCount(60000, 1000);// 构造CountDownTimer对象
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
		// 判断手机号格式
		mobileNo = editMobile.getText().toString().trim();
		smsCode = editSmsCode.getText().toString().trim();

		if ("".equals(mobileNo) || mobileNo.length() != 11
				|| !CommUtil.isMp(mobileNo)) {
			showToast("手机号错误！");
			return;
		}
		if (smsCode.length() != 4) {
			showToast("请输入四位有效验证码");
			return;
		}
		if ("".equals(smsCode) || smsCode.length() < 4) {
			showToast("请输入正确的验证码！");
			return;
		}

		FindLoginPwd1Task findLoginPwd1Task = new FindLoginPwd1Task();
		findLoginPwd1Task.execute(new String[] { mobileNo, smsCode });
	}

	private void getSmsCode() {
		String mobileNo = editMobile.getText().toString().trim();

		if ("".equals(mobileNo) || mobileNo.length() != 11
				|| !CommUtil.isMp(mobileNo)) {
			showToast("手机号错误！");
			return;
		}

		time.start();// 开始计时

		SmsTask smsTask = new SmsTask(mobileNo);
		smsTask.execute();
	}

	class FindLoginPwd1Task extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("系统处理中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();

			// 判断手机号是否存在
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
					returnMap.put("respDesc", "网络异常");
					return returnMap;
				}

				// 解释返回的json
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				String isExist = jsonObj.getString("isExist");
				if (!Constants.PUBLIC_Y.equals(isExist)) {
					returnMap.put("respCode", Constants.SERVER_SYSERR);
					returnMap.put("respDesc", "此手机号未注册!");
				} else {
					returnMap.put("respCode", respCode);
					returnMap.put("respDesc", respDesc);
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
			super(millisInFuture, countDownInterval);// 参数依次为总时长,和计时的时间间隔
		}

		@Override
		public void onFinish() {// 计时完毕时触发
			btnGetSmsCode.setText("获取验证码");
			btnGetSmsCode.setClickable(true);
		}

		@Override
		public void onTick(long millisUntilFinished) {// 计时过程显示
			btnGetSmsCode.setClickable(false);
			btnGetSmsCode.setText(millisUntilFinished / 1000 + "秒");
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(smsReceiver);
	}
}
