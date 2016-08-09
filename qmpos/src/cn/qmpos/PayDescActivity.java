package cn.qmpos;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;

public class PayDescActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;

	private TextView text1;
	private TextView text2;
	private TextView text3;
	private TextView text4;
	private TextView text5;
	private TextView text6;
	private TextView text7;
	private TextView text8;
	private TextView text9;
	private TextView show_liqType;

	private View view7;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_pay_desc);

		init();
	}

	private void init() {

		btnBack = (Button) this.findViewById(R.id.pay_desc_btn_back);
		text1 = (TextView) this.findViewById(R.id.pay_desc_text1);
		text2 = (TextView) this.findViewById(R.id.pay_desc_text2);
		text3 = (TextView) this.findViewById(R.id.pay_desc_text3);
		text4 = (TextView) this.findViewById(R.id.pay_desc_text4);
		text5 = (TextView) this.findViewById(R.id.pay_desc_text5);
		text6 = (TextView) this.findViewById(R.id.pay_desc_text6);
		text7 = (TextView) this.findViewById(R.id.pay_desc_text7);
		text8 = (TextView) this.findViewById(R.id.pay_desc_text8);
		text9 = (TextView) this.findViewById(R.id.pay_desc_text9);
		show_liqType=(TextView) this.findViewById(R.id.show_liqType);
		
		view7 = (View) this.findViewById(R.id.pay_desc_rel7);

		btnBack.setOnClickListener(this);

		Intent intent = getIntent();

		// 交易时间
		text1.setText(intent.getStringExtra("createDate"));
		// 交易单号
		text2.setText(intent.getStringExtra("transSeqId"));
		// 交易金额
		text3.setText(intent.getStringExtra("transAmt"));
		// 手续费
		text4.setText(intent.getStringExtra("transFee"));
		// 交易状态
		text5.setText(intent.getStringExtra("transStat"));
		// 订单说明
		text6.setText(intent.getStringExtra("ordRemark"));
		// 订单说明
		text7.setText(intent.getStringExtra("failRemark"));
		// 持卡人
		text8.setText(intent.getStringExtra("acctName"));
		// 支付卡号
		text9.setText(CommUtil.addBarToBankCardNo(intent
				.getStringExtra("acctId")));

		show_liqType.setText(intent.getStringExtra("liqType"));
		
		if (!"交易失败".equals(text5.getText())) {
			view7.setVisibility(View.GONE);
		}
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.pay_desc_btn_back:
				finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
