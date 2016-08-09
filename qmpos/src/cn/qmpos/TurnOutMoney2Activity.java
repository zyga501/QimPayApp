package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class TurnOutMoney2Activity extends BaseActivity implements OnClickListener {

	private TextView get_money_name, get_money_mobile;
	private EditText edit_turn_out_money, edit_turn_out_remark, edit_trading_pwd;
	private Button btnBack, btnSubmit;
	@SuppressWarnings("unused")
	private SharedPreferences sp;
	private String merId, othersMobile;
	private TurnOutMoney2Activity turnOutMoney2Activity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_turn_out_money2);
		init();
	}

	private void init() {
		turnOutMoney2Activity = this;
		sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		Intent intent = getIntent();
		merId = intent.getStringExtra("merId");
		String merName = intent.getStringExtra("merName");
		othersMobile = intent.getStringExtra("othersMobile");

		get_money_name = (TextView) findViewById(R.id.get_money_name);
		get_money_mobile = (TextView) findViewById(R.id.get_money_mobile);
		get_money_name.setText(merName);
		get_money_mobile.setText(othersMobile);
		edit_turn_out_money = (EditText) findViewById(R.id.edit_turn_out_money);
		edit_turn_out_remark = (EditText) findViewById(R.id.edit_turn_out_remark);
		edit_turn_out_remark.setText("货款");
		edit_trading_pwd = (EditText) findViewById(R.id.edit_trading_pwd);
		btnBack = (Button) findViewById(R.id.btn_back);
		btnSubmit = (Button) findViewById(R.id.btn_turn_out_money_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_turn_out_money_submit:
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

	private void initView() {
		// 判断金额，收款说明，交易密码是否输入
		String turn_out_money = edit_turn_out_money.getText().toString().trim();
		turn_out_money = CommUtil.getCurrencyFormt(turn_out_money);
		String turn_out_remark = edit_turn_out_remark.getText().toString().trim();
		String trading_pwd = edit_trading_pwd.getText().toString().trim();

		if (turn_out_money == null || "".equals(turn_out_money)) {
			showToast("请输入转账金额！");
			return;
		}
		if (!CommUtil.isNumberCanWithDot(turn_out_money)) {
			showToast("转账金额不是标准的金额格式！");
			return;
		}
		float showValues = Float.parseFloat(turn_out_money);
		if (showValues < Constants.DEFAULT_DOUBLE_ERROR) {
			Toast.makeText(this, "金额不能小于0！", Toast.LENGTH_SHORT).show();
			return;
		}
		if (turn_out_remark == null || "".equals(turn_out_remark)) {
			showToast("请输入转账说明！");
			return;
		}
		if (trading_pwd == null || "".equals(trading_pwd)) {
			showToast("请输入交易密码！");
			return;
		}

		MD5Hash m = new MD5Hash();

		TurnOutMoney2Task turnOutMoney2Task = new TurnOutMoney2Task();
		turnOutMoney2Task.execute(
				new String[] { merId, othersMobile, turn_out_money, turn_out_remark, m.getMD5ofStr(trading_pwd) });

	}

	class TurnOutMoney2Task extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("系统处理中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
				map.put("agentId", Constants.server_agent_id);
				map.put("merId", params[0]);
				map.put("mobile", params[1]);
				map.put("transAmt", params[2]);
				map.put("trfTitle", params[3]);
				map.put("transPwd", params[4]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host + Constants.server_doTrfToMer_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "网络异常");
					return returnMap;
				}

				// 解释返回的JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				showToast(respDesc);
				return;
			} else {
				showToast("您向对方转账成功！");
				Intent intent = new Intent(turnOutMoney2Activity, MainActivity.class);
				startActivity(intent);
			}
		}
	}
}
