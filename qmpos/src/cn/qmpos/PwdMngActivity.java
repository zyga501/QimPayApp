package cn.qmpos;

import cn.qmpos.R;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class PwdMngActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;
	private TextView textLoginPwdModify;
	private TextView textTransPwdModify;
	private TextView textTransPwdFind;

	public PwdMngActivity() {
		// TODO Auto-generated constructor stub
	}

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_pwd_mng);

		btnBack = (Button) findViewById(R.id.pwd_mng_btn_back);
		textLoginPwdModify = (TextView) findViewById(R.id.pwd_mng_login_pwd_modify);
		textTransPwdModify = (TextView) findViewById(R.id.pwd_mng_trans_pwd_modify);
		textTransPwdFind = (TextView) findViewById(R.id.pwd_mng_trans_pwd_find);

		btnBack.setOnClickListener(this);
		textLoginPwdModify.setOnClickListener(this);
		textTransPwdModify.setOnClickListener(this);
		textTransPwdFind.setOnClickListener(this);
	}

	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			case R.id.pwd_mng_btn_back:
				finish();
				break;
			case R.id.pwd_mng_login_pwd_modify:
				i = new Intent(this, ModifyLoginPwdActivity.class);
				this.startActivity(i);
				break;
			case R.id.pwd_mng_trans_pwd_modify:
				i = new Intent(this, ModifyTransPwdActivity.class);
				this.startActivity(i);
				break;
			case R.id.pwd_mng_trans_pwd_find:
				i = new Intent(this, FindTransPwd1Activity.class);
				this.startActivity(i);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
