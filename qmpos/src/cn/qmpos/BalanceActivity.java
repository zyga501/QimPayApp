package cn.qmpos;

import cn.qmpos.R;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

/**
 * 余额
 * 
 * Grave
 * 
 */
public class BalanceActivity extends BaseActivity implements OnClickListener {

	private Button mBack, bt_collection_record, bt_recharge, bt_withdrawals;
	private TextView textPay0Amt;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_balance);
		init();
	}

	private void init() {
		mBack = (Button) findViewById(R.id.btn_back);
		mBack.setOnClickListener(this);
		bt_collection_record = (Button) findViewById(R.id.bt_collection_record);
		bt_collection_record.setOnClickListener(this);
		bt_recharge = (Button) findViewById(R.id.bt_recharge);
		bt_recharge.setOnClickListener(this);
		bt_withdrawals = (Button) findViewById(R.id.bt_withdrawals);
		bt_withdrawals.setOnClickListener(this);
		textPay0Amt = (TextView) findViewById(R.id.textPay0Amt);
		SharedPreferences sp = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String pay0Amt = sp.getString("PAY0_acctBal", "0.00");
		textPay0Amt.setText(pay0Amt + "元");
	}

	public void onClick(View v) {
		try {
			Intent intent;
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			// 收款
			case R.id.bt_collection_record:
				intent = new Intent(this, PayListActivity.class);
				startActivity(intent);
				break;
			// 充值
			case R.id.bt_recharge:
				intent = new Intent(this, NorRecv1Activity.class);
				startActivity(intent);
				break;
			// 提现
			case R.id.bt_withdrawals:
				intent = new Intent(this, Liq1Activity.class);
				startActivity(intent);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
