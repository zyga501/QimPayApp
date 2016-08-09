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
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;

/**
 * ��ά���տ�
 * 
 * @author Administrator
 * 
 */
public class QrRecv1Activity extends BaseActivity implements OnClickListener {

	private EditText editTransAmt, editOrdRemark;
	private TextView textFeeInfo;
	private Button btnBack, btnSubmit;

	private String liqType, cardType;
	private View icon_xuanz, icon_xuanze, yufufei_layout, xinyongka_layout,
			chuxuka_layout;
	private ImageView liqTypeT0, liqTypeT1, credit_type, savings_card_type,
			prepaid_card_charge_type;
	private RadioButton liqTypeTt;
	private int liqTypei = 1;// 1 t1 2 t2
	private int cardTypei = 1;// 1 ���ÿ� 2 ���
	private QrRecv1Activity qrRecv1Activity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_qr_recv1);
		init();
	}

	private void init() {
		qrRecv1Activity = this;
		btnBack = (Button) this.findViewById(R.id.qr_recv1_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.qr_recv1_btn_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);
		editTransAmt = (EditText) this.findViewById(R.id.qr_recv1_trans_amt);
		editOrdRemark = (EditText) this.findViewById(R.id.qr_recv1_ord_remark);

		yufufei_layout = findViewById(R.id.yufufei_layout);
		yufufei_layout.setOnClickListener(this);
		xinyongka_layout = findViewById(R.id.xinyongka_layout);
		chuxuka_layout = findViewById(R.id.chuxuka_layout);
		xinyongka_layout.setOnClickListener(this);
		chuxuka_layout.setOnClickListener(this);
		credit_type = (ImageView) this.findViewById(R.id.credit_type);
		savings_card_type = (ImageView) this
				.findViewById(R.id.savings_card_type);
		prepaid_card_charge_type = (ImageView) findViewById(R.id.prepaid_card_charge_type);
		credit_type.setOnClickListener(this);
		savings_card_type.setOnClickListener(this);
		prepaid_card_charge_type.setOnClickListener(this);

		liqTypeT0 = (ImageView) this.findViewById(R.id.qr_recv1_liq_type_t0);
		liqTypeT1 = (ImageView) this.findViewById(R.id.qr_recv1_liq_type_t1);
		liqTypeTt = (RadioButton) this.findViewById(R.id.qr_recv1_liq_type_tt);
		liqTypeT0.setOnClickListener(this);
		liqTypeT1.setOnClickListener(this);
		liqTypeTt.setOnClickListener(this);
		// �ж��Ƿ�ʵ����δʵ������ʾT0,TT
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String isAuthentication = mySharedPreferences.getString(
				"isAuthentication", "");
		String t0Stat = mySharedPreferences.getString("t0Stat", "");
		String t1Stat = mySharedPreferences.getString("t1Stat", "");

		// editOrdRemark.setText(String.valueOf(View.VISIBLE));
		// δʵ�����ر�T0
		if (!"S".equals(isAuthentication)) {
			icon_xuanz.setVisibility(View.GONE);
		}

		// T0δ��ͨ�ر�
		if ("N".equals(t0Stat)) {
			icon_xuanz.setVisibility(View.GONE);
		}

		// T1δ��ͨ�ر�
		if ("N".equals(t1Stat)) {
			icon_xuanze.setVisibility(View.GONE);
		}

		// ���T1�رգ�T0δ�رգ�Ĭ��T0�ķ���ֵ
		if ("N".equals(t1Stat)) {
			liqTypei = 2;
			liqTypeT0.setImageResource(R.drawable.shoukuaner_09);
		}

		// t0,t1���ر�
		if (icon_xuanz.getVisibility() == View.GONE
				&& icon_xuanze.getVisibility() == View.GONE) {
			AlertDialog.Builder builder = new AlertDialog.Builder(
					qrRecv1Activity);
			builder.setTitle("��ʾ");
			builder.setMessage("����տ�ܱ��ر�");
			builder.setPositiveButton("ȷ��",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							finish();
						}
					});
			builder.show();
			return;
		}

		textFeeInfo = (TextView) this.findViewById(R.id.qr_recv1_fee_info);

		// ��ʼ������
		feeInfo(liqTypei, cardTypei);

		qrRecv1Activity = this;

	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.yufufei_layout:
				showToast("��δ����");
				break;
			// ���ÿ�
			case R.id.xinyongka_layout:
				cardTypei = 1;
				feeInfo(liqTypei, cardTypei);
				credit_type.setImageResource(R.drawable.shoukuaner_09);
				savings_card_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			// ���
			case R.id.chuxuka_layout:
				cardTypei = 2;
				feeInfo(liqTypei, cardTypei);
				credit_type.setImageResource(R.drawable.shoukuaner_10);
				savings_card_type.setImageResource(R.drawable.shoukuaner_09);
				break;
			case R.id.qr_recv1_liq_type_t1:
				liqTypei = 1;
				feeInfo(liqTypei, cardTypei);
				liqTypeT0.setImageResource(R.drawable.shoukuaner_10);
				liqTypeT1.setImageResource(R.drawable.shoukuaner_09);
				break;
			case R.id.qr_recv1_liq_type_t0:
				liqTypei = 2;
				feeInfo(liqTypei, cardTypei);
				liqTypeT0.setImageResource(R.drawable.shoukuaner_09);
				liqTypeT1.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.credit_type:
				cardTypei = 1;
				feeInfo(liqTypei, cardTypei);
				credit_type.setImageResource(R.drawable.shoukuaner_09);
				savings_card_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.savings_card_type:
				cardTypei = 2;
				feeInfo(liqTypei, cardTypei);
				credit_type.setImageResource(R.drawable.shoukuaner_10);
				savings_card_type.setImageResource(R.drawable.shoukuaner_09);
				break;
			case R.id.qr_recv1_btn_back:
				finish();
				break;
			case R.id.qr_recv1_btn_submit:
				norRecv();
				break;
			case R.id.qr_recv1_liq_type_tt:
				feeInfo(v.getId(), v.getId());
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void norRecv() {
		// �жϽ����տ�˵���Ƿ�����
		String transAmt = editTransAmt.getText().toString().trim();
		String ordRemark = editOrdRemark.getText().toString().trim();

		if (transAmt == null || "".equals(transAmt)) {
			Toast.makeText(this, "�������տ��", Toast.LENGTH_SHORT).show();
			editTransAmt.setFocusable(true);
			return;
		}

		if (!CommUtil.isNumberCanWithDot(transAmt)) {
			Toast.makeText(this, "�տ���Ǳ�׼�Ľ���ʽ��", Toast.LENGTH_SHORT).show();
			editTransAmt.setFocusable(true);
			return;
		}

		if (ordRemark == null || "".equals(ordRemark)) {
			Toast.makeText(this, "�������տ�˵����", Toast.LENGTH_SHORT).show();
			editOrdRemark.setFocusable(true);
			return;
		}

		if (ordRemark.length() > 20) {
			Toast.makeText(this, "�տ�˵�����ܳ���20���֣�", Toast.LENGTH_SHORT).show();
			editOrdRemark.setFocusable(true);
			return;
		}

		transAmt = CommUtil.getCurrencyFormt(transAmt);
		// �����տ�
		QrRecvTask qrRecvTask = new QrRecvTask();
		qrRecvTask.execute(new String[] { transAmt, ordRemark, liqType,
				cardType });

	}

	private void feeInfo(int liqTypei, int cardTypei) {
		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String feeRateT0 = mySharedPreferences.getString("feeRateT0", "");
		String feeRateT1 = mySharedPreferences.getString("feeRateT1", "");

		String debitFeeRateT0 = mySharedPreferences.getString("debitFeeRateT0",
				"");
		String debitFeeRateT1 = mySharedPreferences.getString("debitFeeRateT1",
				"");

		if (liqTypei == 1) {// t1
			if (cardTypei == 1) {// ���ÿ�
				textFeeInfo.setText(Html.fromHtml("������<font color=#78b2ed>"
						+ feeRateT1 + "</font>%"));
				liqType = "T1";
				cardType = "X";
			} else if (cardTypei == 2) {// ���
				textFeeInfo.setText(Html.fromHtml("������<font color=#78b2ed>"
						+ debitFeeRateT1 + "</font>%"));
				liqType = "T1";
				cardType = "J";
			}
		} else if (liqTypei == 2) {// t2
			if (cardTypei == 1) {// ���ÿ�
				textFeeInfo.setText(Html.fromHtml("������<font color=#78b2ed>"
						+ feeRateT0 + "</font>%"));
				liqType = "T0";
				cardType = "X";
			} else if (cardTypei == 2) {// ���
				textFeeInfo.setText(Html.fromHtml("������<font color=#78b2ed>"
						+ debitFeeRateT0 + "</font>%"));
				liqType = "T0";
				cardType = "J";
			}
		}
	}

	class QrRecvTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ϵͳ������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();

			SharedPreferences mySharedPreferences = getSharedPreferences(
					"qmpos", Activity.MODE_PRIVATE);
			String merId = mySharedPreferences.getString("merId", "");
			String loginId = mySharedPreferences.getString("loginId", "");
			String sessionId = mySharedPreferences.getString("sessionId", "");
			String transSeqId = "";
			String credNo = "";

			// ��������
			try {
				HashMap<String, String> map = new HashMap<String, String>();

				map.put("merId", merId);
				map.put("loginId", loginId);
				map.put("credNo", CommUtil.getTime());
				map.put("sessionId", sessionId);
				map.put("transAmt", params[0]);
				map.put("ordRemark", params[1]);
				map.put("liqType", params[2]);
				map.put("cardType", params[3]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host
						+ Constants.server_createpay_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(
						requestUrl, map);
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
				if (!respCode.equals(Constants.SERVER_SUCC)) {
					return returnMap;
				}

				transSeqId = jsonObj.getString("transSeqId");
				credNo = jsonObj.getString("credNo");
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

			// ���ò�����ά��
			try {
				HashMap<String, String> map = new HashMap<String, String>();

				map.put("merId", merId);
				map.put("transSeqId", transSeqId);
				map.put("credNo", credNo);

				String requestUrl = Constants.server_host
						+ Constants.server_doQrCode_url;
				String responseStr = cn.qmpos.http.HttpRequest.getResponse(
						requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "���������Ƿ�����");
					return returnMap;
				}

				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (!respCode.equals(Constants.SERVER_SUCC)) {
					return returnMap;
				}

				String qrCodeUrl = jsonObj.getString("qrCodeUrl");
				returnMap.put("qrCodeUrl", qrCodeUrl);
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				Toast.makeText(qrRecv1Activity, respDesc, Toast.LENGTH_SHORT)
						.show();
				return;
			}

			try {
				dialog.hide();

				String qrCodeUrl = resultMap.get("qrCodeUrl");
				Intent i = new Intent(qrRecv1Activity, WebViewActivity.class);
				i.putExtra("url", qrCodeUrl);
				qrRecv1Activity.startActivity(i);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
