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
 * Óà¶î
 * 
 * Grave
 * 
 */
public class RebateActivity extends BaseActivity implements OnClickListener {

	private Button mBack, bt_rebate_record, bt_rebate;
	private TextView textRateAmt;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_rebate);
		init();
	}

	private void init() {
		mBack = (Button) findViewById(R.id.btn_back);
		mBack.setOnClickListener(this);
		bt_rebate_record = (Button) findViewById(R.id.bt_rebate_record);
		bt_rebate_record.setOnClickListener(this);
		bt_rebate = (Button) findViewById(R.id.bt_rebate);
		bt_rebate.setOnClickListener(this);
		textRateAmt = (TextView) findViewById(R.id.textRateAmt);

		SharedPreferences sp = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String rateAmt = sp.getString("RATE_avlBal", "0.00");
		textRateAmt.setText(rateAmt + "Ôª");
	}

	public void onClick(View v) {
		try {
			Intent intent;
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			// ·µÓ¶¼ÇÂ¼
			case R.id.bt_rebate_record:
				intent = new Intent(this, RebateListActivity.class);
				startActivity(intent);
				break;
			// ·µÓ¶×ª³ö
			case R.id.bt_rebate:
				intent = new Intent(this, RebateOutActivity.class);
				startActivity(intent);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
