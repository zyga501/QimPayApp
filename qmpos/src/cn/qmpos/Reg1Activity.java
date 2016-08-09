package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
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
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.async.SmsTask;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class Reg1Activity extends BaseActivity implements OnClickListener {

	private TimeCount time;
	private Button btnGetSmsCode, btnBack, btnNext;
	private EditText editMobile, editSmsCode;
	private CheckBox checkboxAgree;
	private TextView textAgreement, tv_contact_customer;
	private Reg1Activity reg1Activity;
	private BroadcastReceiver smsReceiver;
	private IntentFilter filter;
	private Handler handler;
	private String strContent, verificationCode;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_reg1);
		init();
		SmsContent();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.reg1_btn_back);
		btnNext = (Button) this.findViewById(R.id.reg1_btn_next);
		btnGetSmsCode = (Button) this.findViewById(R.id.reg1_btn_getSmsCode);
		btnBack.setOnClickListener(this);
		btnNext.setOnClickListener(this);
		btnGetSmsCode.setOnClickListener(this);
		tv_contact_customer = (TextView) this
				.findViewById(R.id.tv_contact_customer);
		tv_contact_customer.setOnClickListener(this);
		editMobile = (EditText) this.findViewById(R.id.reg1_edit_mobile);
		editSmsCode = (EditText) this.findViewById(R.id.reg1_edit_smsCode);
		checkboxAgree = (CheckBox) this.findViewById(R.id.reg1_checkbox_agree);
		textAgreement = (TextView) this.findViewById(R.id.reg1_agreement);
		textAgreement.setOnClickListener(this);

		time = new TimeCount(60000, 1000);// 构造CountDownTimer对象

		dialog = new ProgressDialog(this);
		dialog.setCanceledOnTouchOutside(false);
		reg1Activity = this;
	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.tv_contact_customer:
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage("400-711-5170");
				builder.setNegativeButton("拨号",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								Uri uri = Uri.parse("tel:400-711-5170");
								Intent it = new Intent(Intent.ACTION_DIAL, uri);
								startActivity(it);
							}
						});
				builder.setPositiveButton("取消", null);
				builder.show();
				break;
			case R.id.reg1_btn_back:
				finish();
				break;
			case R.id.reg1_btn_next:
				next();
				break;
			case R.id.reg1_btn_getSmsCode:
				getSmsCode();
				break;
			case R.id.reg1_agreement:
				i = new Intent(this, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/agree"
						+ Constants.server_agent_id + ".html");
				i.putExtra("title", "用户协议");
				this.startActivity(i);
				break;

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
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

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(smsReceiver);
	}

	// 下一步
	private void next() {

		String mobileNo = editMobile.getText().toString().trim();
		String smsCode = editSmsCode.getText().toString().trim();

		if ("".equals(mobileNo) || mobileNo.length() != 11
				|| !CommUtil.isMp(mobileNo)) {
			Toast.makeText(this, "手机号错误！", Toast.LENGTH_SHORT).show();
			return;
		}
		if ("".equals(smsCode) || smsCode.length() != 4) {
			Toast.makeText(this, "请输入正确的验证码！", Toast.LENGTH_SHORT).show();
			return;
		}

		if (!checkboxAgree.isChecked()) {
			Toast.makeText(this, "请同意服务协议！", Toast.LENGTH_SHORT).show();
			return;
		}

		Reg1Task reg1Task = new Reg1Task();
		reg1Task.execute(new String[] { mobileNo, smsCode });
	}

	// 获取验证码
	private void getSmsCode() {
		String mobileNo = editMobile.getText().toString().trim();

		if ("".equals(mobileNo) || mobileNo.length() != 11
				|| !CommUtil.isMp(mobileNo)) {
			Toast.makeText(this, "手机号错误！", Toast.LENGTH_SHORT).show();
			return;
		}

		time.start();// 开始计时
		SmsTask smsTask = new SmsTask(mobileNo);
		smsTask.execute();
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

	class Reg1Task extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("系统处理中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			String mobile = params[0];
			String smsCode = params[1];
			HashMap<String, String> returnMap = new HashMap<String, String>();

			// 判断手机号是否存在
			try {
				MD5Hash m = new MD5Hash();
				String signMsg = Constants.server_agent_id + mobile
						+ Constants.server_md5key;
				String chkValue = m.getMD5ofStr(signMsg);

				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("loginId", mobile);
				map.put("chkValue", chkValue);
				String requestUrl = Constants.server_host
						+ Constants.server_mobileexistverify_url;
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
				String isExist = jsonObj.getString("isExist");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				returnMap.put("isExist", isExist);

				if (Constants.PUBLIC_Y.equals(isExist))
					return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 判断验证码是否正确
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("loginId", mobile);
				map.put("smsCode", smsCode);
				String requestUrl = Constants.server_host
						+ Constants.server_smscodeverify_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "请检查网络是否正常!");
					return returnMap;
				}

				// 解释返回的json
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (!Constants.SERVER_SUCC.equals(respCode))
					return returnMap;
				returnMap.put("isTrue", jsonObj.getString("isTrue"));
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
				Toast.makeText(reg1Activity, respDesc, Toast.LENGTH_SHORT)
						.show();
				return;
			}

			String isTrue = resultMap.get("isTrue");
			String isExist = resultMap.get("isExist");
			if (Constants.PUBLIC_Y.equals(isExist)) {
				dialog.hide();
				showToast("该手机号已注册成功");
				return;
			}

			if (Constants.PUBLIC_N.equals(isTrue)) {
				dialog.hide();
				Toast.makeText(reg1Activity, "验证码输入错误！！", Toast.LENGTH_SHORT)
						.show();
				return;
			}

			Intent i = new Intent(reg1Activity, Reg2Activity.class);
			i.putExtra("mobile", editMobile.getText().toString().trim());
			i.putExtra("smsCode", editSmsCode.getText().toString().trim());
			reg1Activity.startActivity(i);
		}
	}
}
