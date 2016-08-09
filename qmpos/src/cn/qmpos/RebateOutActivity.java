package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class RebateOutActivity extends BaseActivity implements OnClickListener {

	private EditText editRebateAmt;
	private EditText editTransPwd;
	private TextView textAmtInfo;

	private Button btnBack;
	private Button btnSubmit;

	private RebateOutActivity rebateOutActivity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_rebate_out);
		init();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.rebate_out_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.rebate_out_btn_submit);
		textAmtInfo = (TextView) this.findViewById(R.id.rebate_out_amt_info);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);

		editRebateAmt = (EditText) this
				.findViewById(R.id.rebate_out_rebate_amt);
		editTransPwd = (EditText) this.findViewById(R.id.rebate_out_trans_pwd);

		rebateOutActivity = this;

		// 查询结算商户信息
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String merId = mySharedPreferences.getString("merId", "");
		String loginId = mySharedPreferences.getString("loginId", "");
		String sessionId = mySharedPreferences.getString("sessionId", "");
		InitTask initTask = new InitTask();
		initTask.execute(new String[] { merId, loginId, sessionId });

	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.rebate_out_btn_back:
				finish();
				break;
			case R.id.rebate_out_btn_submit:
				submitRebateOut();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void submitRebateOut() {
		String rebateAmt = editRebateAmt.getText().toString().trim();
		String transPwd = editTransPwd.getText().toString().trim();

		if (rebateAmt == null || "".equals(rebateAmt)) {
			Toast.makeText(this, "请输入转出金额！", Toast.LENGTH_SHORT).show();
			editRebateAmt.setFocusable(true);
			return;
		}

		if (!CommUtil.isNumberCanWithDot(rebateAmt)) {
			Toast.makeText(this, "金额不是标准的金额格式！", Toast.LENGTH_SHORT).show();
			editRebateAmt.setFocusable(true);
			return;
		}
		rebateAmt = CommUtil.getCurrencyFormt(rebateAmt);

		float tempAmt = Float.parseFloat(rebateAmt);
		if (tempAmt < Constants.DEFAULT_DOUBLE_ERROR) {
			Toast.makeText(this, "转出金额必须大于0！", Toast.LENGTH_SHORT).show();
			editRebateAmt.setFocusable(true);
			return;
		}

		if (transPwd == null || "".equals(transPwd)) {
			Toast.makeText(this, "请输入交易密码！", Toast.LENGTH_SHORT).show();
			editTransPwd.setFocusable(true);
			return;
		}

		// 查询结算商户信息
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String merId = mySharedPreferences.getString("merId", "");
		String loginId = mySharedPreferences.getString("loginId", "");
		String sessionId = mySharedPreferences.getString("sessionId", "");

		// 发起收款
		MD5Hash m = new MD5Hash();
		RebateOutTask rebateOutTask = new RebateOutTask();
		rebateOutTask.execute(new String[] { merId, loginId, rebateAmt,
				m.getMD5ofStr(transPwd), sessionId });

	}

	class RebateOutTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("系统处理中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("transAmt", params[2]);
				map.put("transPwd", params[3]);
				map.put("sessionId", params[4]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host
						+ Constants.server_rebateRollOut_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(
						requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", responseStr);
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
				returnMap.put("respDesc", e.getMessage());
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				Toast.makeText(rebateOutActivity, respDesc, Toast.LENGTH_SHORT)
						.show();
				return;
			}

			AlertDialog.Builder builder = new AlertDialog.Builder(
					rebateOutActivity);
			builder.setTitle("成功");
			builder.setMessage("返佣资金已转入到你的现金账户。");
			builder.setPositiveButton("确认",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(rebateOutActivity,
									MainActivity.class);
							rebateOutActivity.startActivity(i);
						}
					});
			builder.show();
			return;
		}
	}

	class InitTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("数据加载中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();

			// 资金商户余额
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("acctType", "RATE");
				map.put("sessionId", params[1]);

				String requestUrl = Constants.server_host
						+ Constants.server_queryMerBal_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(
						requestUrl, map);
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
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("RATE_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("RATE_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("RATE_avlBal", jsonObj.getString("avlBal"));
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();

			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						rebateOutActivity);
				builder.setTitle("系统异常");
				builder.setMessage(respDesc);
				builder.setPositiveButton("确认",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								Intent i = new Intent(rebateOutActivity,
										LoginActivity.class);
								rebateOutActivity.startActivity(i);
							}
						});
				builder.show();
				return;
			}

			try {
				String acctBal = resultMap.get("RATE_acctBal");
				String avlBal = resultMap.get("RATE_avlBal");
				textAmtInfo.setText(Html.fromHtml("返佣账户余额<font color=#78b2ed>"
						+ CommUtil.getCurrencyFormt(acctBal)
						+ "</font> 元可转出余额<font color=#78b2ed>"
						+ CommUtil.getCurrencyFormt(avlBal) + "</font>元"));

				btnSubmit.setEnabled(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
