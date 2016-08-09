package cn.qmpos;

import cn.qmpos.R;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

public class LiqInfoActivity extends BaseActivity implements OnClickListener {

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_liq_info);
		init();
	}

	private void init() {

	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.liq1_btn_back:
				i = new Intent(this, cn.qmpos.MainActivity.class);
				this.startActivity(i);
				break;
			case R.id.liq1_btn_submit:

				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
