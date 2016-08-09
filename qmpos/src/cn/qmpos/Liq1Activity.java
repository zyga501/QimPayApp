package cn.qmpos;

import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

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
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;
import cn.qmpos.R;

public class Liq1Activity extends BaseActivity implements OnClickListener {

	private EditText editLiqAmt;
	private EditText editTransPwd;

	private TextView textCardInfo;
	private TextView textFeeInfo;

	private ImageView imageSelectDown;

	private Button btnBack, btn_tixianjilu;
	private Button btnSubmit;

	private int selLiqCardId = 0;
	private String[] liqCardIdArr = null;
	private String[] liqCardNameArr = null;

	private Liq1Activity liq1Activity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_liq1);
		init();
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.liq1_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.liq1_btn_submit);
		textCardInfo = (TextView) this.findViewById(R.id.liq1_text_card_info);
		imageSelectDown = (ImageView) this.findViewById(R.id.liq1_seleect_down);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);
		textCardInfo.setOnClickListener(this);
		imageSelectDown.setOnClickListener(this);
		btn_tixianjilu = (Button) this.findViewById(R.id.btn_tixianjilu);
		btn_tixianjilu.setOnClickListener(this);
		editLiqAmt = (EditText) this.findViewById(R.id.liq1_edit_liq_amt);
		editTransPwd = (EditText) this.findViewById(R.id.liq1_edit_trans_pwd);

		textFeeInfo = (TextView) this.findViewById(R.id.liq1_text_fee_info);

		liq1Activity = this;

		// ��ѯ�����̻���Ϣ
		String merId = sp.getString("merId", "");
		String loginId = sp.getString("loginId", "");
		String sessionId = sp.getString("sessionId", "");

		InitTask initTask = new InitTask();
		initTask.execute(new String[] { merId, loginId, sessionId, "J" });

	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			// ���ּ�¼
			case R.id.btn_tixianjilu:
				Intent intnet = new Intent(this, LiqListActivity.class);
				this.startActivity(intnet);
				break;
			case R.id.liq1_btn_back:
				this.finish();
				break;
			case R.id.liq1_btn_submit:
				submitLiq();
				break;
			case R.id.liq1_text_card_info:
				showLiqBankDialog();
				break;
			case R.id.liq1_seleect_down:
				showLiqBankDialog();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void showLiqBankDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("��ѡ�����ֿ���");
		builder.setSingleChoiceItems(liqCardNameArr, selLiqCardId, new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				selLiqCardId = which;
				textCardInfo.setText(liqCardNameArr[which]);
				dialog.dismiss();
			}
		});
		builder.setNegativeButton("ȡ��", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {

			}
		});
		builder.show();
	}

	private void submitLiq() {
		// �жϽ����տ�˵���Ƿ�����
		String liqCardId = liqCardIdArr[selLiqCardId];
		String liqAmt = editLiqAmt.getText().toString().trim();
		String transPwd = editTransPwd.getText().toString().trim();

		if (liqAmt == null || "".equals(liqAmt)) {
			Toast.makeText(this, "����������", Toast.LENGTH_SHORT).show();
			editLiqAmt.setFocusable(true);
			return;
		}

		if (!CommUtil.isNumberCanWithDot(liqAmt)) {
			Toast.makeText(this, "������Ǳ�׼�Ľ���ʽ��", Toast.LENGTH_SHORT).show();
			editLiqAmt.setFocusable(true);
			return;
		}
		float showValues = Float.parseFloat(liqAmt);
		if (showValues < Constants.DEFAULT_DOUBLE_ERROR) {
			Toast.makeText(this, "����С��0��", Toast.LENGTH_SHORT).show();
			return;
		}
		liqAmt = CommUtil.getCurrencyFormt(liqAmt);

		if (transPwd == null || "".equals(transPwd)) {
			Toast.makeText(this, "�����뽻�����룡", Toast.LENGTH_SHORT).show();
			editTransPwd.setFocusable(true);
			return;
		}

		// ��ѯ�����̻���Ϣ
		String merId = sp.getString("merId", "");
		String sessionId = sp.getString("sessionId", "");

		// �����տ�
		MD5Hash m = new MD5Hash();
		Liq1Task liq1Task = new Liq1Task();
		liq1Task.execute(new String[] { merId, liqCardId, liqAmt, m.getMD5ofStr(transPwd), sessionId });

	}

	class Liq1Task extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ϵͳ������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("liqCardId", params[1]);
				map.put("liqAmt", params[2]);
				map.put("transPwd", params[3]);
				map.put("sessionId", params[4]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host + Constants.server_doLiq_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", responseStr);
					return returnMap;
				}

				// ���ͷ��ص�JSON
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
				Toast.makeText(liq1Activity, respDesc, Toast.LENGTH_SHORT).show();
				return;
			}

			AlertDialog.Builder builder = new AlertDialog.Builder(liq1Activity);
			builder.setTitle("���ֳɹ�");
			builder.setMessage("������������Ѿ��ɹ�����ע�������ʽ��˻��䶯��");
			builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					Intent i = new Intent(liq1Activity, MainActivity.class);
					liq1Activity.startActivity(i);
				}
			});
			builder.show();
			return;
		}
	}

	class InitTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("���ݼ�����...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();

			// ��ѯ�̻�������Ϣ
			try {
				HashMap<String, String> map = new HashMap<String, String>();

				map.put("merId", params[0]);
				map.put("loginId", params[1]);
				map.put("sessionId", params[2]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host + Constants.server_queryMerInfo_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				String isAuthentication = "";
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (respCode.equals(Constants.SERVER_SUCC)) {
					isAuthentication = jsonObj.getString("isAuthentication");
					returnMap.put("isAuthentication", jsonObj.getString("isAuthentication"));
					returnMap.put("feeRateLiq1", jsonObj.getString("feeRateLiq1"));
					returnMap.put("feeRateLiq2", jsonObj.getString("feeRateLiq2"));
					returnMap.put("totAmtT1", jsonObj.getString("totAmtT1"));
				}
				if (!"S".equals(isAuthentication))
					return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

			// ��ѯ�̻������˺���Ϣ
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("sessionId", params[2]);
				map.put("cardType", params[3]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host + Constants.server_queryLiqCard_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (respCode.equals(Constants.SERVER_SUCC)) {
					int totalNum = Integer.parseInt(jsonObj.getString("totalNum"));
					returnMap.put("totalNum", jsonObj.getString("totalNum"));
					if (totalNum > 0) {
						liqCardIdArr = new String[totalNum];
						liqCardNameArr = new String[totalNum];
						JSONArray tempArray = jsonObj.getJSONArray("ordersInfo");
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							liqCardIdArr[i] = tempObj.getString("liqCardId");
							liqCardNameArr[i] = tempObj.getString("openBankName") + "\n"
									+ CommUtil.addBarToBankCardNo(tempObj.getString("openAcctId"));
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

			// �ʽ��̻����
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("acctType", "PAY0");
				map.put("sessionId", params[2]);

				String requestUrl = Constants.server_host + Constants.server_queryMerBal_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("PAY0_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("PAY0_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("PAY0_avlBal", jsonObj.getString("avlBal"));
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();

			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(liq1Activity);
				builder.setTitle("ϵͳ�쳣");
				builder.setMessage(respDesc);
				builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent i = new Intent(liq1Activity, LoginActivity.class);
						liq1Activity.startActivity(i);
					}
				});
				builder.show();
				return;
			}

			try {
				SharedPreferences.Editor editor = sp.edit();
				// ����¼����̻���Ϣ����
				editor.putString("isAuthentication", resultMap.get("isAuthentication"));
				editor.putString("feeRateLiq1", resultMap.get("feeRateLiq1"));
				editor.putString("feeRateLiq2", resultMap.get("feeRateLiq2"));
				editor.putString("totAmtT1", resultMap.get("totAmtT1"));
				editor.putString("PAY0_acctBal", resultMap.get("PAY0_acctBal"));
				editor.putString("PAY0_frzBal", resultMap.get("PAY0_frzBal"));
				editor.putString("PAY0_avlBal", resultMap.get("PAY0_avlBal"));
				editor.commit();

				String isAuthentication = resultMap.get("isAuthentication");
				if ("I".equals(isAuthentication)) {
					AlertDialog.Builder builder = new AlertDialog.Builder(liq1Activity);
					builder.setTitle("��ʾ");
					builder.setMessage("��δ���տ����п���������У��ݲ��������֣�");
					builder.setPositiveButton("����ҳ", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(liq1Activity, MainActivity.class);
							liq1Activity.startActivity(i);
						}
					});
					builder.show();
					return;
				} else if (!"S".equals(isAuthentication)) {
					AlertDialog.Builder builder = new AlertDialog.Builder(liq1Activity);
					builder.setTitle("��ʾ");
					builder.setMessage("��δ���տ����п����ݲ��������֣�");
					builder.setPositiveButton("����ҳ", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(liq1Activity, MainActivity.class);
							liq1Activity.startActivity(i);
						}
					});
					builder.setNegativeButton("��Ҫʵ��", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(liq1Activity, AuthenticationActivity.class);
							liq1Activity.startActivity(i);
						}
					});
					builder.show();
					return;
				}

				String feeRateLiq1 = resultMap.get("feeRateLiq1");
				String feeRateLiq2 = resultMap.get("feeRateLiq2");
				float totAmtT1 = Float.parseFloat(resultMap.get("totAmtT1"));
				float avlBal = Float.parseFloat(resultMap.get("PAY0_avlBal"));
				float liqAmt = avlBal - totAmtT1;
				// ������Ϊ����״̬����Χ0Ԫ
				if (liqAmt < 0) {
					liqAmt = 0;
				}
				textCardInfo.setText(liqCardNameArr[0]);
				textFeeInfo.setText(Html.fromHtml("��������������<font color=#78b2ed>" + feeRateLiq1
						+ "</font>Ԫ/��,��������<font color=#78b2ed>" + feeRateLiq2 + "</font>Ԫ/��"));
				editLiqAmt.setHint("��ǰ�����ֵĽ��" + CommUtil.getCurrencyFormt(String.valueOf(liqAmt)) + "Ԫ");

				btnSubmit.setEnabled(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
