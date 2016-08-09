package cn.qmpos;

import cn.qmpos.R;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ShareQrCodeActivity extends BaseActivity implements
		OnClickListener {

	private Button btnBack;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_share_qr_code);
		init();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.share_qr_code_btn_back);
		btnBack.setOnClickListener(this);
	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.share_qr_code_btn_back:
				this.finish();
				break;
			case R.id.liq1_btn_submit:

				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
