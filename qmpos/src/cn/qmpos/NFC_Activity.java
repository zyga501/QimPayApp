package cn.qmpos;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.wepayplugin.nfcstd.WepayPlugin;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.nfc.NfcManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.nfc.MD5Encrypt;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.R;

@SuppressLint({ "SimpleDateFormat", "InflateParams", "InlinedApi" })
public class NFC_Activity extends BaseActivity implements OnClickListener {
	private EditText tv_price;
	private Button back;
	private TextView bankname, accpname, bankcardId, ratet1, ratet0;
	private String tempnum = "", showValue, liqType, merId, cardId;
	private double longitude, latitude;
	private ProgressDialog progressDialog;
	private int totalNum;
	private View one, two, three, four, five, six, seven, eight, nine, zero, dian, delect, t1, d0, ok, choose;
	private ArrayList<HashMap<String, String>> itemArr = new ArrayList<HashMap<String, String>>();
	private ArrayList<HashMap<String, String>> itemArrs = new ArrayList<HashMap<String, String>>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_nfc_layout);

		progressDialog = new ProgressDialog(NFC_Activity.this, R.style.Dialog);
		init();
	}

	private void init() {
		liqType = "T0";
		merId = sp.getString("merId", "");
		tv_price = (EditText) findViewById(R.id.tv_price);
		one = findViewById(R.id.button1);
		two = findViewById(R.id.button5);
		three = findViewById(R.id.button9);
		four = findViewById(R.id.button2);
		five = findViewById(R.id.button6);
		six = findViewById(R.id.button10);
		seven = findViewById(R.id.button3);
		eight = findViewById(R.id.button7);
		nine = findViewById(R.id.button11);
		dian = findViewById(R.id.button4);
		zero = findViewById(R.id.button8);
		delect = findViewById(R.id.imageButton1);
		d0 = findViewById(R.id.button12);
		t1 = findViewById(R.id.button13);
		ok = findViewById(R.id.button14);
		bankname = (TextView) findViewById(R.id.text_bankname);
		accpname = (TextView) findViewById(R.id.text_accpname);
		bankcardId = (TextView) findViewById(R.id.text_bankId);
		choose = findViewById(R.id.choose_bank);
		ratet1 = (TextView) findViewById(R.id.text_t1);
		ratet0 = (TextView) findViewById(R.id.text_t0);
		back = (Button) findViewById(R.id.btn_back);
		back.setOnClickListener(this);
		choose.setOnClickListener(this);
		one.setOnClickListener(this);
		two.setOnClickListener(this);
		three.setOnClickListener(this);
		four.setOnClickListener(this);
		five.setOnClickListener(this);
		six.setOnClickListener(this);
		seven.setOnClickListener(this);
		eight.setOnClickListener(this);
		nine.setOnClickListener(this);
		dian.setOnClickListener(this);
		zero.setOnClickListener(this);
		delect.setOnClickListener(this);
		d0.setOnClickListener(this);
		t1.setOnClickListener(this);
		ok.setOnClickListener(this);
		NfcTask nfcTask = new NfcTask();
		nfcTask.execute(new String[] { merId, "Y" });

	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.btn_back:
			finish();
			break;
		case R.id.button1:
			addNum("1");
			break;
		case R.id.button5:
			addNum("2");
			break;
		case R.id.button9:
			addNum("3");
			break;
		case R.id.button2:
			addNum("4");
			break;
		case R.id.button6:
			addNum("5");
			break;
		case R.id.button10:
			addNum("6");
			break;
		case R.id.button3:
			addNum("7");
			break;
		case R.id.button7:
			addNum("8");
			break;
		case R.id.button11:
			addNum("9");
			break;
		case R.id.button4:
			addNum(".");
			break;
		case R.id.button8:
			addNum("0");
			break;
		case R.id.imageButton1:
			singleDelete();
			break;
		case R.id.button12:
			liqType = "T0";
			d0.setBackgroundResource(R.drawable.rate_border);
			t1.setBackgroundResource(R.drawable.main_border2);
			break;
		case R.id.button13:
			liqType = "T1";
			t1.setBackgroundResource(R.drawable.rate_border);
			d0.setBackgroundResource(R.drawable.main_border2);
			break;
		case R.id.button14:
			setprice();
			break;
		case R.id.choose_bank:
			chooseDialog();
			break;
		default:
			break;
		}

	}

	private void chooseDialog() {
		LayoutInflater inflater = LayoutInflater.from(this);
		View view = inflater.inflate(R.layout.activity_dialog, null);
		ListView listView = (ListView) view.findViewById(R.id.listView1);
		final Dialog dialog = new Dialog(NFC_Activity.this, R.style.Dialog);
		dialog.setContentView(view);
		dialog.show();
		SimpleAdapter simpleAdapter = new SimpleAdapter(this, itemArr, R.layout.list_item_rate,
				new String[] { "openBankName", "openAcctName", "cardId" },
				new int[] { R.id.tv_pay_type, R.id.tv_t0_t1, R.id.tv_rate });
		listView.setAdapter(simpleAdapter);
		listView.setItemsCanFocus(false);
		listView.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View views, int position, long id) {

				ListView lv = (ListView) parent;
				@SuppressWarnings("unchecked")
				HashMap<String, Object> person = (HashMap<String, Object>) lv.getItemAtPosition(position);
				cardId = person.get("openAcctId").toString();
				bankname.setText(person.get("openBankName").toString());
				accpname.setText(person.get("openAcctName").toString());
				bankcardId.setText(CommUtil.addBarToBankCard(person.get("openAcctId").toString()));
				dialog.dismiss();

			}
		});
	}

	private void setMyShowValue(String str) {
		tv_price.setText(str);
	}

	TextWatcher mTextWatcher = new TextWatcher() {
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			if (s.toString().contains(".")) {
				if (s.length() - 1 - s.toString().indexOf(".") > 2) {
					s = s.toString().subSequence(0, s.toString().indexOf(".") + 3);
					tv_price.setText(s);
					tv_price.setSelection(s.length());
					Toast.makeText(NFC_Activity.this, "您输入的价格保留两位小数！", Toast.LENGTH_SHORT).show();
				}
			}
			if (s.toString().trim().substring(0).equals(".")) {
				s = "0" + s;
				tv_price.setText(s);
				tv_price.setSelection(2);
			}
		}

		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		public void afterTextChanged(Editable s) {

		}
	};

	// 添加一个数字
	private void addNum(String str) {
		if (tempnum.length() == 10) {
			Toast.makeText(NFC_Activity.this, "金额不可大于10位！", Toast.LENGTH_SHORT).show();
			return;
		}
		tempnum += str;
		setMyShowValue(tempnum);
	}

	// 全部清空
	// private void clear() {
	// tempnum = "";
	// setMyShowValue("");
	// }
	// 单个删除
	private void singleDelete() {
		try {
			tempnum = tempnum.substring(0, (tempnum.length() - 1));
			setMyShowValue(tempnum);
		} catch (Exception e) {
			e.printStackTrace();
			Log.e("dddd", e.getMessage());
		}
	}

	private void setprice() {
		showValue = tv_price.getText().toString().trim();
		if (showValue == null || "".equals(showValue)) {
			Toast.makeText(NFC_Activity.this, "请输入付款金额！", Toast.LENGTH_SHORT).show();
			tv_price.setFocusable(true);
			return;
		}
		if (!CommUtil.isNumberCanWithDot(showValue)) {
			Toast.makeText(NFC_Activity.this, "付款金额不是标准的金额格式！", Toast.LENGTH_SHORT).show();
			tv_price.setFocusable(true);
			return;
		}
		float showValues = Float.parseFloat(showValue);
		if (showValues < Constants.DEFAULT_DOUBLE_ERROR) {
			Toast.makeText(this, "金额不能小于0！", Toast.LENGTH_SHORT).show();
			return;
		}
		showValue = CommUtil.getCurrencyFormt(showValue);
		NfcManager manager = (NfcManager) getSystemService(Context.NFC_SERVICE);
		if (manager.getDefaultAdapter().isEnabled() == false) {
			AlertDialog.Builder dialog = new AlertDialog.Builder(this);
			dialog.setTitle("NFC未打开");
			dialog.setMessage("请先在设置中打开NFC方可进行下一步操作");
			dialog.setPositiveButton("确定", new android.content.DialogInterface.OnClickListener() {

				@Override
				public void onClick(DialogInterface arg0, int arg1) {

					// 转到手机设置界面，用户设置NFC
					Intent intent = new Intent(Settings.ACTION_NFC_SETTINGS);
					startActivityForResult(intent, 0); // 设置完成后返回到原来的界面
					arg0.dismiss();

				}
			});
			dialog.setNegativeButton("取消", new DialogInterface.OnClickListener() {

				@Override
				public void onClick(DialogInterface arg0, int arg1) {
					// TODO Auto-generated method stub
					arg0.dismiss();
				}
			});
			dialog.create().show();
		} else {
			NorRecvTask norRecvTask = new NorRecvTask();
			norRecvTask
					.execute(new String[] { showValue, "nfc收款", liqType, "X", longitude + "", latitude + "", "zlnfc" });
		}

	}

	public static String getRandomNum(int len) {
		String[] arr = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };
		String s = "";
		if (len <= 0) {
			return s;
		}
		Random ra = new Random();
		int arrLen = arr.length;
		for (int i = 0; i < len; i++) {
			s += arr[ra.nextInt(arrLen)];
		}
		return s;
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == WepayPlugin.reqCod) {
			if (data != null) {
				Bundle mbundle = data.getExtras();
				String parames = mbundle.getString("result");
				if (parames.equals("success")) {
					Toast.makeText(this, "支付成功", Toast.LENGTH_SHORT).show();
				} else if (parames.equals("cancel")) {
					Toast.makeText(this, "支付取消", Toast.LENGTH_SHORT).show();
				} else if (parames.equals("fail")) {
					Toast.makeText(this, "支付失败", Toast.LENGTH_SHORT).show();
				} else if (parames.equals("error")) {
					Toast.makeText(this, "数据异常", Toast.LENGTH_SHORT).show();
				}
			} else {
				Toast.makeText(this, "出错啦", Toast.LENGTH_SHORT).show();
			}
		}
	}

	// 查询卡信息
	class NfcTask extends AsyncTask<String, Integer, HashMap<String, String>> {
		@Override
		protected void onPreExecute() {
			dialog.setMessage("加载中,请稍候...");
			dialog.show();
		}

		@Override
		protected HashMap<String, String> doInBackground(String... params) {
			// TODO Auto-generated method stub
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("isMyself", params[1]);
				String requestUrl = Constants.server_host + Constants.server_queryMerTransCard_url;
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

				if (respCode.equals(Constants.SERVER_SUCC)) {
					totalNum = Integer.parseInt(jsonObj.getString("totalNum"));
					if (totalNum > 0) {
						JSONArray tempArray = jsonObj.getJSONArray("ordersInfo");
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							HashMap<String, String> dataMap = new HashMap<String, String>();
							dataMap.put("openAcctName", tempObj.getString("openAcctName"));
							dataMap.put("openBankName", tempObj.getString("openBankName"));
							dataMap.put("openAcctId", tempObj.getString("openAcctId"));
							dataMap.put("cardId", "尾号：" + CommUtil.addBarToBankCardWH(tempObj.getString("openAcctId")));
							itemArr.add(dataMap);
						}
					}

				}
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
			}
			// 查询费率信息
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				String requestUrl = Constants.server_host + Constants.server_queryMerFeeInfo_url;
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

				int recordSum = 0;
				if (respCode.equals(Constants.SERVER_SUCC)) {
					int totalNum = Integer.parseInt(jsonObj.getString("totalNum"));
					if (totalNum > 0) {
						JSONArray tempArray = jsonObj.getJSONArray("merFeeInfo");
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							recordSum = tempArray.length();
							HashMap<String, String> dataMap1 = new HashMap<String, String>();
							dataMap1.put("gateId", tempObj.getString("gateId"));

							dataMap1.put("feeRateT0", tempObj.getString("feeRateT0") + "%");
							if (tempObj.getString("gateId").equals("zlnfc")) {
								itemArrs.add(dataMap1);
							}

							HashMap<String, String> dataMap2 = new HashMap<String, String>();
							dataMap2.put("gateId", tempObj.getString("gateId"));

							dataMap2.put("feeRateT0", tempObj.getString("feeRateT1") + "%");
							if (tempObj.getString("gateId").equals("zlnfc")) {
								itemArrs.add(dataMap2);
							}

						}

					}
				}

				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				returnMap.put("recordSum", String.valueOf(recordSum));
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");

			}
			return returnMap;
		}

		@Override
		protected void onPostExecute(HashMap<String, String> resultMap) {
			// TODO Auto-generated method stub
			super.onPostExecute(resultMap);
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			dialog.hide();
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				Toast.makeText(NFC_Activity.this, respDesc, Toast.LENGTH_LONG).show();
			}
			try {
				if (totalNum == 0) {
					AlertDialog.Builder builder = new AlertDialog.Builder(NFC_Activity.this);
					builder.setCancelable(false);
					builder.setTitle("提示");
					builder.setMessage("您未绑定交易卡，需在收款页进行交易，方可使用NFC");
					builder.setNegativeButton("回首页", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {

							Intent i = new Intent(NFC_Activity.this, MainActivity.class);
							startActivity(i);
						}
					});
					builder.create().show();
				}
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			try {
				HashMap<String, String> str = itemArr.get(0);
				cardId = str.get("openAcctId");
				bankname.setText(str.get("openBankName").toString());
				accpname.setText(str.get("openAcctName").toString());
				bankcardId.setText(CommUtil.addBarToBankCard(str.get("openAcctId").toString()));
				HashMap<String, String> strd = itemArrs.get(0);
				ratet0.setText("D0手续费" + strd.get("feeRateT0").toString());
				HashMap<String, String> strt = itemArrs.get(1);
				ratet1.setText("T1手续费" + strt.get("feeRateT0").toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

	}

	class NorRecvTask extends AsyncTask<String, Integer, HashMap<String, String>> {
		@Override
		protected void onPreExecute() {
			// TODO Auto-generated method stub
			progressDialog.setMessage("正在加载...");
			progressDialog.show();
		}

		@Override
		protected HashMap<String, String> doInBackground(String... params) {
			// TODO Auto-generated method stub
			HashMap<String, String> returnMap = new HashMap<String, String>();

			String merId = sp.getString("merId", "");
			String loginId = sp.getString("loginId", "");
			String sessionId = sp.getString("sessionId", "");
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
				map.put("longitude", params[4]);
				map.put("latitude", params[5]);
				map.put("gateId", params[6]);
				map.put("clientModel", Build.MODEL);

				String requestUrl = Constants.server_host + Constants.server_createpay_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC)) {
					return returnMap;
				}

				returnMap.put("transSeqId", jsonObj.getString("transSeqId"));
				returnMap.put("credNo", jsonObj.getString("credNo"));
				returnMap.put("transAmt", jsonObj.getString("transAmt"));
				returnMap.put("transFee", jsonObj.getString("transFee"));
				returnMap.put("sysSeqId", jsonObj.getString("sysSeqId"));
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
			return returnMap;

		}

		@Override
		protected void onPostExecute(HashMap<String, String> resultMap) {
			// TODO Auto-generated method stub
			super.onPostExecute(resultMap);
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				progressDialog.hide();

				Toast.makeText(NFC_Activity.this, respDesc, Toast.LENGTH_SHORT).show();
				return;
			}
			progressDialog.hide();
			String mAmount = resultMap.get("transAmt");
			float cmount = Float.parseFloat(mAmount) * 100;
			String sAmount = CommUtil.removeDecimal(CommUtil.getCurrencyFormt(String.valueOf(cmount)));
			String sysSeqId = resultMap.get("sysSeqId");
			JSONObject jsonm = new JSONObject();
			String merId = sp.getString("merId", "");
			try {
				jsonm.put(WepayPlugin.merchantCode, "1000003026");
				jsonm.put(WepayPlugin.outUserId, merId);
				jsonm.put(WepayPlugin.nonceStr, getRandomNum(32));
				jsonm.put(WepayPlugin.outOrderId, sysSeqId);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
				jsonm.put(WepayPlugin.orderCreateTime, sdf.format(new Date()));
				jsonm.put(WepayPlugin.totalAmount, sAmount);
				jsonm.put(WepayPlugin.lastPayTime, "");
				String signmd5Src = MD5Encrypt.signJsonStringSort(jsonm.toString());
				String signmd5 = MD5Encrypt.sign(signmd5Src, "5bba400e-657a-473b-bbcd-76eecd37a2c3");
				jsonm.put(WepayPlugin.sign, signmd5);
				jsonm.put(WepayPlugin.payNotifyUrl, "http://115.29.194.93/par/zlnfcBgServlet.do");
				jsonm.put(WepayPlugin.goodsName, "NFC支付");
				jsonm.put(WepayPlugin.goodsExplain, "快捷  安全  便利   的手机支付");

			} catch (Exception e) {
				e.printStackTrace();
			}
			WepayPlugin.getInstance().genWepayPayRequestJar(NFC_Activity.this, jsonm.toString(), cardId, true);

		}
	}

}
