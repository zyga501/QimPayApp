package cn.qmpos;

import java.util.ArrayList;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;

public class SmsRecv2Activity extends BaseActivity implements OnClickListener {

	private TextView editRecvMobile, textSmsText, editTransAmt, editOrdRemark;
	private Button btnBack, btnSubmit;
	private SmsRecv2Activity smsRecv2Activity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_sms_recv2);
		allActivity.add(this);
		init();
	}

	private void init() {
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String merId = mySharedPreferences.getString("merId", "");
		String merName = mySharedPreferences.getString("merName", "");
		String transSeqId = mySharedPreferences.getString(
				"sms_recv_transSeqId", "");
		String credNo = mySharedPreferences.getString("sms_recv_credNo", "");
		String transAmt = CommUtil.getCurrencyFormt(mySharedPreferences
				.getString("sms_recv_transAmt", ""));
		String recvMobile = mySharedPreferences.getString(
				"sms_recv_recvMobile", "");
		String ordRemark = mySharedPreferences.getString("sms_recv_ordRemark",
				"");

		Intent intent = getIntent();
		recvMobile = intent.getStringExtra("recvMobile");
		transAmt = intent.getStringExtra("showValue");
		ordRemark = intent.getStringExtra("ordRemark");

		btnBack = (Button) this.findViewById(R.id.sms_recv2_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.sms_recv2_btn_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);

		editRecvMobile = (TextView) this
				.findViewById(R.id.sms_recv2_recv_mobile);
		editTransAmt = (TextView) this.findViewById(R.id.sms_recv2_trans_amt);
		editOrdRemark = (TextView) this.findViewById(R.id.sms_recv2_ord_remark);
		textSmsText = (TextView) this.findViewById(R.id.sms_recv2_smsText);
		editRecvMobile.setText(recvMobile);
		editTransAmt.setText(transAmt);
		editOrdRemark.setText(ordRemark);

		String payUrl = Constants.server_host + Constants.server_dopay_url
				+ "?merId=" + merId + "&transSeqId=" + transSeqId + "&credNo="
				+ credNo + "&paySrc=sms";
		String tempStr = "你好！" + merName + "正在向你收款，金额为：" + transAmt + "元，付款请点击"
				+ payUrl;
		textSmsText.setText(tempStr);
		// InitContent initContent = new InitContent();
		// initContent.execute(new String[] { payUrl });
		smsRecv2Activity = this;
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.sms_recv2_btn_submit:
				sendSms();
				break;
			case R.id.sms_recv2_btn_back:
				finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void sendSms() {
		String mobileStr = (String) editRecvMobile.getText();
		String smsTextStr = textSmsText.getText().toString();
		System.out.println(mobileStr + ":" + smsTextStr);
		try {
			SmsManager smsManager = SmsManager.getDefault();
			if (smsTextStr.length() > 70) {
				ArrayList<String> contents = smsManager
						.divideMessage(smsTextStr);
				smsManager.sendMultipartTextMessage(mobileStr, null, contents,
						null, null);
			} else {
				smsManager.sendTextMessage(mobileStr, null, smsTextStr, null,
						null);
			}

			AlertDialog.Builder builder = new AlertDialog.Builder(
					smsRecv2Activity);
			builder.setTitle("提示");
			builder.setMessage("短信发送成功，此交易涉及资金安全，请联系收件人！");
			builder.setPositiveButton("确认",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(smsRecv2Activity,
									MainActivity.class);
							smsRecv2Activity.startActivity(i);
						}
					});
			builder.show();

		} catch (Exception e) {
		}
	}

	// // 端连接请求
	// class InitContent extends
	// AsyncTask<String, Integer, HashMap<String, String>> {
	//
	// protected void onPreExecute() {
	// dialog.setMessage("数据加载中...");
	// dialog.show();
	// }
	//
	// protected HashMap<String, String> doInBackground(String... params) {
	// // 组装能数，调注册接口
	// HashMap<String, String> returnMap = new HashMap<String, String>();
	// // 查询商户基本信息
	// try {
	// String payUrl = params[0];
	// payUrl = HttpRequest.getShortConnection(payUrl);
	// returnMap.put("payUrl", payUrl);
	// } catch (Exception e) {
	// e.printStackTrace();
	// returnMap.put("respCode", Constants.SERVER_SYSERR);
	// returnMap.put("respDesc", "系统异常");
	// return returnMap;
	// }
	// return returnMap;
	// }
	//
	// protected void onPostExecute(HashMap<String, String> resultMap) {
	// dialog.hide();
	// SharedPreferences mySharedPreferences = getSharedPreferences(
	// "qmpos", Activity.MODE_PRIVATE);
	// String merName = mySharedPreferences.getString("merName", "");
	// String transAmt = CommUtil.getCurrencyFormt(mySharedPreferences
	// .getString("sms_recv_transAmt", ""));
	// String tempStr = "你好！" + merName + "正在向你收款，金额为：" + transAmt
	// + "元，付款请点击" + resultMap.get("payUrl");
	// textSmsText.setText(tempStr);
	// }
	// }
}
