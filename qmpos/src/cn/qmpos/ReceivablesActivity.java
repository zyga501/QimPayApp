package cn.qmpos;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;

/**
 * 转账
 * 
 * @author 徐丽红
 * 
 */
public class ReceivablesActivity extends BaseActivity implements
		OnClickListener {

	private EditText edit_receivables_money, edit_receivables_remark;
	private Button btnBack, btnSubmit;
	private SharedPreferences sp;
	private String merId, loginId, receivables_money, receivables_remark;
	private ReceivablesActivity receivablesActivity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_receivables);
		init();
	}

	private void init() {
		receivablesActivity = this;
		sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		merId = sp.getString("merId", "");
		loginId = sp.getString("loginId", "");
		edit_receivables_money = (EditText) findViewById(R.id.edit_receivables_money);
		edit_receivables_remark = (EditText) findViewById(R.id.edit_receivables_remark);
		edit_receivables_remark.setText("货款");
		btnBack = (Button) findViewById(R.id.btn_back);
		btnSubmit = (Button) findViewById(R.id.btn_receivables_money_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_receivables_money_submit:
				initView();
				break;
			case R.id.btn_back:
				finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void initView() throws UnsupportedEncodingException {
		// 判断金额，收款说明，交易密码是否输入
		receivables_money = edit_receivables_money.getText().toString().trim();
		receivables_money = CommUtil.getCurrencyFormt(receivables_money);
		receivables_remark = edit_receivables_remark.getText().toString()
				.trim();
		if (receivables_money == null || "".equals(receivables_money)) {
			showToast("请输入收款金额！");
			return;
		}
		if (!CommUtil.isNumberCanWithDot(receivables_money)) {
			showToast("收款金额不是标准的金额格式！");
			return;
		}
		if (receivables_remark == null || "".equals(receivables_remark)) {
			showToast("请输入收款说明！");
			return;
		}

		Intent intent = new Intent(receivablesActivity, WebViewActivity.class);
		String url;
		url = Constants.server_host + Constants.server_createTrfQrCode_url
				+ "?agentId=" + Constants.server_agent_id + "&merId=" + merId
				+ "&loginId=" + loginId + "&transAmt=" + receivables_money
				+ "&trfTitle=" + URLEncoder.encode(receivables_remark, "GBK");
		intent.putExtra("url", url);
		startActivity(intent);

	}
}
