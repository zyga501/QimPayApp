package cn.qmpos;

import cn.qmpos.R;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class EventDetailsActivity extends BaseActivity implements
		OnClickListener {

	private Button btn_back;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.event_details);
		initView();
	}

	private void initView() {
		btn_back = (Button) this.findViewById(R.id.btn_back);
		btn_back.setOnClickListener(this);
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
