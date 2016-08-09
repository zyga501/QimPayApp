package cn.qmpos;

import cn.qmpos.R;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class LiqDescActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;

	private TextView text1;
	private TextView text2;
	private TextView text3;
	private TextView text4;
	private TextView text5;
	private TextView text6;
	private TextView text7;
	private TextView text8;

	private View view8;

	public LiqDescActivity() {
		// TODO Auto-generated constructor stub
	}

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_liq_desc);
		init();
	}

	private void init() {

		btnBack = (Button) this.findViewById(R.id.liq_desc_btn_back);
		text1 = (TextView) this.findViewById(R.id.liq_desc_text1);
		text2 = (TextView) this.findViewById(R.id.liq_desc_text2);
		text3 = (TextView) this.findViewById(R.id.liq_desc_text3);
		text4 = (TextView) this.findViewById(R.id.liq_desc_text4);
		text5 = (TextView) this.findViewById(R.id.liq_desc_text5);
		text6 = (TextView) this.findViewById(R.id.liq_desc_text6);
		text7 = (TextView) this.findViewById(R.id.liq_desc_text7);
		text8 = (TextView) this.findViewById(R.id.liq_desc_text8);

		view8 = (View) this.findViewById(R.id.liq_desc_rel8);

		btnBack.setOnClickListener(this);

		Intent intent = getIntent();

		// ����ʱ��
		text1.setText(intent.getStringExtra("createDate"));
		// ���ֵ���
		text2.setText(intent.getStringExtra("transSeqId"));
		// ���׽��
		text3.setText(intent.getStringExtra("transAmt"));
		// ������
		text4.setText(intent.getStringExtra("transFee"));
		// ����״̬
		text5.setText(intent.getStringExtra("transStat"));
		// �����˻�
		text6.setText(intent.getStringExtra("openAcctName"));
		// �����˺�
		text7.setText(intent.getStringExtra("openAcctId"));
		// ʧ��ԭ��
		text8.setText(intent.getStringExtra("failRemark"));

		if (!"ʧ��".equals(text5.getText())) {
			view8.setVisibility(View.GONE);
		}

	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.liq_desc_btn_back:
				this.finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
