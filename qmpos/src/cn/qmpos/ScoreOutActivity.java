package cn.qmpos;

import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

/**
 * 积分兑换
 * 
 * @author lp.cheng
 * 
 */
public class ScoreOutActivity extends BaseActivity implements OnClickListener,
		OnCheckedChangeListener {

	private EditText editBusNum;
	private EditText editTransPwd;

	private TextView textScoreInfo;
	private RadioGroup radioGroup;
	private TextView textBusInfo;

	private Button btnBack;
	private Button btnSubmit;

	private ScoreOutActivity scoreOutActivity;

	private int nowPosite = 0;
	private String[] busIdArr = null;
	private String[] busNameArr = null;
	private String[] busDescArr = null;
	private String[] scoreNumArr = null;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_score_out);
		init();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.score_out_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.score_out_btn_submit);
		textScoreInfo = (TextView) this.findViewById(R.id.score_out_score_info);
		radioGroup = (RadioGroup) this.findViewById(R.id.score_out_rg);
		textBusInfo = (TextView) this.findViewById(R.id.score_out_bus_info);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);
		radioGroup.setOnCheckedChangeListener(this);

		editBusNum = (EditText) this.findViewById(R.id.score_out_bus_num);
		editTransPwd = (EditText) this.findViewById(R.id.score_out_trans_pwd);

		scoreOutActivity = this;

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
			case R.id.score_out_btn_back:
				finish();
				break;
			case R.id.score_out_btn_submit:
				submitScoreOut();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onCheckedChanged(RadioGroup arg0, int arg1) {
		// TODO Auto-generated method stub
		Log.i("eeeee", arg1 + "");
		nowPosite = arg1;
		String busInfo = busDescArr[arg1] + ",需" + scoreNumArr[arg1] + "个积分";
		textBusInfo.setText(busInfo);
	}

	private void submitScoreOut() {
		String busNum = editBusNum.getText().toString().trim();
		String transPwd = editTransPwd.getText().toString().trim();

		if (busNum == null || "".equals(busNum)) {
			Toast.makeText(this, "请输入兑换数量！", Toast.LENGTH_SHORT).show();
			editBusNum.setFocusable(true);
			return;
		}

		if (!CommUtil.isNumber(busNum)) {
			Toast.makeText(this, "兑换数量格式不正确！", Toast.LENGTH_SHORT).show();
			editBusNum.setFocusable(true);
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
		ScoreOutTask scoreOutTask = new ScoreOutTask();
		scoreOutTask
				.execute(new String[] { merId, loginId, busIdArr[nowPosite],
						busNum, m.getMD5ofStr(transPwd), sessionId });

	}

	class ScoreOutTask extends
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
				map.put("busId", params[2]);
				map.put("transNum", params[3]);
				map.put("transPwd", params[4]);
				map.put("sessionId", params[5]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host
						+ Constants.server_doscore_url;
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
				Toast.makeText(scoreOutActivity, respDesc, Toast.LENGTH_SHORT)
						.show();
				return;
			}

			AlertDialog.Builder builder = new AlertDialog.Builder(
					scoreOutActivity);
			builder.setTitle("成功");
			builder.setMessage("积分兑换成功。");
			builder.setPositiveButton("确认",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(scoreOutActivity,
									MainActivity.class);
							scoreOutActivity.startActivity(i);
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

			HashMap<String, String> returnMap = new HashMap<String, String>();

			// 积分余额
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("acctType", "JF00");
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

				returnMap.put("JF00_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("JF00_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("JF00_avlBal", jsonObj.getString("avlBal"));
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 查询积分商品
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("sessionId", params[1]);
				String requestUrl = Constants.server_host
						+ Constants.server_queryScoreBusList_url;
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

				int totalNum = Integer.parseInt(jsonObj.getString("totalNum"));
				returnMap.put("totalNum", jsonObj.getString("totalNum"));
				if (totalNum < 1) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "无可兑换物品！");
				} else {
					busIdArr = new String[totalNum];
					busNameArr = new String[totalNum];
					busDescArr = new String[totalNum];
					scoreNumArr = new String[totalNum];

					JSONArray tempArray = jsonObj.getJSONArray("ordersInfo");
					for (int i = 0; i < tempArray.length(); i++) {
						JSONObject tempObj = tempArray.getJSONObject(i);
						busIdArr[i] = tempObj.getString("busId");
						busNameArr[i] = tempObj.getString("busName");
						busDescArr[i] = tempObj.getString("busDesc");
						scoreNumArr[i] = tempObj.getString("scoreNum");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
			return returnMap;
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();

			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						scoreOutActivity);
				builder.setTitle("提示");
				builder.setMessage(respDesc);
				builder.setPositiveButton("确认",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								finish();
							}
						});
				builder.show();
				return;
			}

			try {
				String acctBal = resultMap.get("JF00_acctBal");
				String avlBal = resultMap.get("JF00_avlBal");
				textScoreInfo.setText(Html
						.fromHtml("积分总额为：<font color=#78b2ed>"
								+ CommUtil.removeDecimal(CommUtil
										.getCurrencyFormt(acctBal))
								+ "</font>分"));

				for (int i = 0; i < busIdArr.length; i++) {
					final RadioButton radioButton = new RadioButton(
							scoreOutActivity);
					radioButton.setText(busNameArr[i]);
					radioButton.setTextColor(Color.BLACK);
					radioButton.setTextSize(14);
					radioButton.setButtonDrawable(R.drawable.radio_box);
					radioButton.setPadding(12, 10, 10, 10);
					// radioButton.setTag(i);
					radioButton.setId(i);
					if (i == 0) {
						radioButton.setChecked(true);
					} else {
						radioButton.setChecked(false);
					}
					radioGroup.addView(radioButton);
				}

				btnSubmit.setEnabled(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

}
