package cn.qmpos;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import cn.qmpos.util.CommUtil;
import cn.qmpos.R;

public class AcctInfoActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;
	private TextView text1;
	private TextView text2;
	private TextView text3;
	private TextView text4;
	private TextView text5;
	private TextView text6;
	private TextView text7;
	private TextView text9;
	private TextView text10;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_acct_info);
		init();
	}

	@Override
	protected void onResume() {
		super.onResume();
		init();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.acct_info_btn_back);
		text1 = (TextView) this.findViewById(R.id.acct_info_text1);
		text2 = (TextView) this.findViewById(R.id.acct_info_text2);
		text3 = (TextView) this.findViewById(R.id.acct_info_text3);
		text4 = (TextView) this.findViewById(R.id.acct_info_text4);
		text5 = (TextView) this.findViewById(R.id.acct_info_text5);
		text6 = (TextView) this.findViewById(R.id.acct_info_text6);
		text7 = (TextView) this.findViewById(R.id.acct_info_text7);
		text10 = (TextView) this.findViewById(R.id.acct_info_text10);
		text9 = (TextView) this.findViewById(R.id.acct_info_text9);
		btnBack.setOnClickListener(this);

		// ����
		text1.setText(sp.getString("merName", ""));
		// �ֻ���
		String loginId = sp.getString("loginId", "");
		text2.setText(loginId);
		// ϵͳ���
		String merId = sp.getString("merId", "");
		text3.setText(merId);
		// ע������
		String openDate = sp.getString("openDate", "").trim();
		if (!"".equals(openDate)) {
			text4.setText(CommUtil.addBarToDateString(openDate));
		}
		// �ϴε�¼ʱ��
		String lastLoginDate = sp.getString("lastLoginDate", "").trim();
		if (!"".equals(lastLoginDate)) {
			text5.setText(CommUtil.addBarAndColonToDateString(lastLoginDate));
		}
		// ���֤��
		String mNumber = sp.getString("certId", "");
		if (!"".equals(mNumber)) {
			String shouNumber = mNumber.substring(0, 6) + "********"
					+ mNumber.substring(14);
			text6.setText(shouNumber);
		}
		// ʵ��״̬
		String authStat = CommUtil.getAuthStatStr(sp.getString(
				"isAuthentication", ""));
		text7.setText(authStat);

		// ����������
		text9.setText(sp.getString("feeRateLiq1", "") + "Ԫ/��");
		text10.setText(sp.getString("feeRateLiq2", "") + "Ԫ/��");
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.acct_info_btn_back:
				finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
