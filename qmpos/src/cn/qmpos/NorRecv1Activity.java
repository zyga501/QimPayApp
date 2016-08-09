package cn.qmpos;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.R;


/**
 * 普通充值
 * 
 * @author Administrator
 */
public class NorRecv1Activity extends BaseActivity implements OnClickListener {

	private ArrayList<HashMap<String, String>> itemArr = new ArrayList<HashMap<String, String>>();
	private EditText editTransAmt, editOrdRemark;
	private TextView textFeeInfo, tv_paychannel, tv_D0_T1;
	private Button btnBack, btnSubmit;
	private String liqType, gateId, receivablesi = "1", transAmt, ordRemark, carNo;
	private View putong_layout, duanxin_layout, erweima_layout, downchoose_layout;
	private ImageView putong_type, duanxin_type, erweima_type, saoma_type;
	private NorRecv1Activity norRecv1Activity;
	private double longitude, latitude;
	final String TAG = getClass().getName();

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_nor_recv1);
		allActivity.add(this);
		init();
	}

	private void init() {
		norRecv1Activity = this;
		btnBack = (Button) this.findViewById(R.id.nor_recv1_btn_back);
		btnSubmit = (Button) this.findViewById(R.id.nor_recv1_btn_submit);
		btnBack.setOnClickListener(this);
		btnSubmit.setOnClickListener(this);
		editTransAmt = (EditText) this.findViewById(R.id.nor_recv1_trans_amt);
		editOrdRemark = (EditText) this.findViewById(R.id.nor_recv1_ord_remark);
		editOrdRemark.setText("货款");
		tv_D0_T1 = (TextView) findViewById(R.id.tv_D0_T1);
		tv_D0_T1.setOnClickListener(this);
		putong_layout = findViewById(R.id.putong_layout);
		duanxin_layout = findViewById(R.id.duanxin_layout);
		erweima_layout = findViewById(R.id.erweima_layout);
		putong_layout.setOnClickListener(this);
		duanxin_layout.setOnClickListener(this);
		erweima_layout.setOnClickListener(this);

		putong_type = (ImageView) findViewById(R.id.putong_type);
		duanxin_type = (ImageView) findViewById(R.id.duanxin_type);
		erweima_type = (ImageView) findViewById(R.id.erweima_type);
		putong_type.setOnClickListener(this);
		duanxin_type.setOnClickListener(this);
		erweima_type.setOnClickListener(this);
		tv_paychannel = (TextView) findViewById(R.id.tv_paychannel);
		tv_paychannel.setOnClickListener(this);
		downchoose_layout = findViewById(R.id.downchoose_layout);
		downchoose_layout.setOnClickListener(this);
		String t0Stat = sp.getString("t0Stat", "");
		String t1Stat = sp.getString("t1Stat", "");
		// D0,t1均关闭
		if ("N".equals(t1Stat) && "N".equals(t0Stat)) {
			Builder builder = new AlertDialog.Builder(norRecv1Activity);
			builder.setTitle("提示");
			builder.setMessage("你的收款功能被关闭");
			builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					finish();
				}
			});
			builder.show();
			return;
		}

		textFeeInfo = (TextView) this.findViewById(R.id.nor_recv1_fee_info);
		String merId = sp.getString("merId", "");
		QueryMerFeeInfoTask queryMerFeeInfoTask = new QueryMerFeeInfoTask();
		queryMerFeeInfoTask.execute(new String[] { merId });

	}

	// 收款项目弹窗 T+1 D+0
	private void DownChoosePayChanneDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		LayoutInflater inflater = LayoutInflater.from(this);
		View view = inflater.inflate(R.layout.activity_rateinformation, null);
		final AlertDialog dialog = builder.setTitle("请选择通道").setView(view)
				.setPositiveButton("关闭", new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface arg0, int arg1) {

					}

				}).show();
		ListView listView = (ListView) view.findViewById(R.id.list_data_rate);
		// 使用费率信息的XML文件，隐藏掉标题
		View top = view.findViewById(R.id.top);
		top.setVisibility(View.GONE);
		SimpleAdapter simpleAdapter = new SimpleAdapter(this, itemArr, R.layout.list_item_rate,
				new String[] { "gateName", "liqType", "feeRateT0" },
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
				gateId = person.get("gateId").toString();
				tv_paychannel.setText(person.get("gateName").toString());
				tv_D0_T1.setText(person.get("liqType").toString());
				textFeeInfo.setText(person.get("feeRateT0").toString());
				// textFeeInfo.setText(Html.fromHtml("<font color=#C57A36>"
				// + person.get("feeRateT0").toString() + "</font>"));
				liqType = person.get("liqTypei").toString();
				dialog.dismiss();

			}
		});
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			// 充值选择
			case R.id.downchoose_layout:
				DownChoosePayChanneDialog();
				break;
			case R.id.tv_paychannel:
				DownChoosePayChanneDialog();
				break;
			case R.id.nor_recv1_btn_back:
				finish();
				break;
			case R.id.nor_recv1_btn_submit:
				norRecv();
				break;
			case R.id.putong_layout:
				receivablesi = "1";
				putong_type.setImageResource(R.drawable.shoukuaner_09);
				duanxin_type.setImageResource(R.drawable.shoukuaner_10);
				erweima_type.setImageResource(R.drawable.shoukuaner_10);
				saoma_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.duanxin_layout:
				receivablesi = "2";

				duanxin_type.setImageResource(R.drawable.shoukuaner_09);
				putong_type.setImageResource(R.drawable.shoukuaner_10);
				erweima_type.setImageResource(R.drawable.shoukuaner_10);
				saoma_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.erweima_layout:
				receivablesi = "3";

				erweima_type.setImageResource(R.drawable.shoukuaner_09);
				duanxin_type.setImageResource(R.drawable.shoukuaner_10);
				putong_type.setImageResource(R.drawable.shoukuaner_10);
				saoma_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.putong_type:
				receivablesi = "1";

				putong_type.setImageResource(R.drawable.shoukuaner_09);
				duanxin_type.setImageResource(R.drawable.shoukuaner_10);
				erweima_type.setImageResource(R.drawable.shoukuaner_10);
				saoma_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.duanxin_type:
				receivablesi = "2";

				duanxin_type.setImageResource(R.drawable.shoukuaner_09);
				putong_type.setImageResource(R.drawable.shoukuaner_10);
				erweima_type.setImageResource(R.drawable.shoukuaner_10);
				saoma_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			case R.id.erweima_type:
				receivablesi = "3";

				erweima_type.setImageResource(R.drawable.shoukuaner_09);
				duanxin_type.setImageResource(R.drawable.shoukuaner_10);
				putong_type.setImageResource(R.drawable.shoukuaner_10);
				saoma_type.setImageResource(R.drawable.shoukuaner_10);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void norRecv() {
		// 判断金额和充值说明是否输入
		transAmt = editTransAmt.getText().toString().trim();
		ordRemark = editOrdRemark.getText().toString().trim();
		// 使用Intent对象得到NorRecv1Activity传递来的参数
		Intent intent = getIntent();
		transAmt = intent.getStringExtra("showValue");

		if (ordRemark == null || "".equals(ordRemark)) {
			Toast.makeText(this, "请输入充值说明！", Toast.LENGTH_SHORT).show();
			editOrdRemark.setFocusable(true);
			return;
		}

		if (ordRemark.length() > 20) {
			Toast.makeText(this, "充值说明不能超过20个字！", Toast.LENGTH_SHORT).show();
			editOrdRemark.setFocusable(true);
			return;
		}

		transAmt = CommUtil.getCurrencyFormt(transAmt);
		// 获取经度、纬度
		getGPS();
		// 发起充值
		NorRecvTask norRecvTask = new NorRecvTask();
		norRecvTask.execute(new String[] { transAmt, ordRemark, liqType, "X", receivablesi, longitude + "",
				latitude + "", gateId });
	}

	// private void feeInfo(int liqTypei) {
	// String pay = tv_paychannel.getText().toString().trim();
	// if (liqTypei == 1) {// t1
	// liqType = "T1";
	// for (int i = 0; i < itemArr.size(); i++) {
	//
	// if (itemArr.get(i).get("gateName").equals(pay)
	// && itemArr.get(i).get("liqType").equals(liqType)) {
	// textFeeInfo.setText(Html
	// .fromHtml("<font color=#78b2ed>"
	// + itemArr.get(i).get("feeRateT0") + "%"
	// + "</font>"));
	// return;
	// }
	// }
	// } else if (liqTypei == 2) {// t2
	// liqType = "T0";
	// for (int i = 0; i < itemArr.size(); i++) {
	// if (itemArr.get(i).get("gateName").equals(pay)
	// && itemArr.get(i).get("liqType").equals(liqType)) {
	// textFeeInfo.setText(Html
	// .fromHtml("<font color=#78b2ed>"
	// + itemArr.get(i).get("feeRateT0") + "%"
	// + "</font>"));
	// return;
	// }
	// }
	// }
	// // 单笔限额5万,单日不限,带银行积分,手续费
	// }

	class NorRecvTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("系统处理中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();
			String merId = sp.getString("merId", "");
			String loginId = sp.getString("loginId", "");
			String sessionId = sp.getString("sessionId", "");

			String transSeqId = "";
			String credNo = "";
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
				map.put("receivablesi", params[4]);
				map.put("longitude", params[5]);
				map.put("latitude", params[6]);
				map.put("gateId", params[7]);
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

				transSeqId = jsonObj.getString("transSeqId");
				credNo = jsonObj.getString("credNo");
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 调用产生二维码
			// if (receivablesi == "3") {
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", merId);
				map.put("transSeqId", transSeqId);
				map.put("credNo", credNo);

				String requestUrl = Constants.server_host + Constants.server_doQrCode_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "请检查网络是否正常");
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

				String qrCodeUrl = jsonObj.getString("qrCodeUrl");
				returnMap.put("qrCodeUrl", qrCodeUrl);
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
			// }
			// return returnMap;
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				showToast(respDesc);
				return;
			}
			try {
				SharedPreferences.Editor editor = sp.edit();
				editor.putString("sms_recv_transSeqId", resultMap.get("transSeqId"));
				editor.putString("sms_recv_credNo", resultMap.get("credNo"));
				editor.putString("sms_recv_transAmt", resultMap.get("transAmt"));
				editor.putString("sms_recv_transFee", resultMap.get("transFee"));
				editor.commit();
			} catch (Exception e) {
				e.printStackTrace();
			}
			String merId = sp.getString("merId", "");
			String transSeqId = resultMap.get("transSeqId");
			String credNo = resultMap.get("credNo");
			dialog.hide();
			if (receivablesi == "1" && "weixin,alipay".indexOf(gateId) < 0) {
				try {
					String url = Constants.server_host + Constants.server_dopay_url + "?merId=" + merId + "&transSeqId="
							+ transSeqId + "&credNo=" + credNo + "&paySrc=nor";

					Intent i = new Intent(norRecv1Activity, WebViewActivity.class);
					i.putExtra("url", url);
					norRecv1Activity.startActivity(i);
				} catch (Exception e) {
					e.printStackTrace();
				}

			} else if ("weixin,alipay".indexOf(gateId) >= 0) {
				String qrCodeUrl = resultMap.get("qrCodeUrl");
				Intent i = new Intent(norRecv1Activity, WebViewMoreActivity.class);
				i.putExtra("url", qrCodeUrl);
				norRecv1Activity.startActivity(i);
			} else if (receivablesi == "2") {
				Intent intent = new Intent(norRecv1Activity, SmsRecv1Activity.class);
				intent.putExtra("showValue", transAmt);
				intent.putExtra("ordRemark", ordRemark);
				startActivity(intent);
			} else if (receivablesi == "3") {
				String qrCodeUrl = resultMap.get("qrCodeUrl");
				Intent i = new Intent(norRecv1Activity, WebViewActivity.class);
				i.putExtra("url", qrCodeUrl);
				norRecv1Activity.startActivity(i);
			} else if (receivablesi == "4") {
				// 如果未扫描银行卡，默认为空，不传null
				if (carNo == null || "null".equals(carNo)) {
					carNo = "";
				}
				String url = Constants.server_host + Constants.server_dopay_url + "?merId=" + merId + "&transSeqId="
						+ transSeqId + "&credNo=" + credNo + "&paySrc=nor" + "&cardNo=" + carNo;

				Intent i = new Intent(norRecv1Activity, WebViewActivity.class);
				i.putExtra("url", url);
				norRecv1Activity.startActivity(i);
			}
		}
	}

	/**
	 * 获取经纬度坐标
	 */
	void getGPS() {
		LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
			Location location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
			if (location != null) {
				latitude = location.getLatitude();
				longitude = location.getLongitude();
			}
		} else {
			LocationListener locationListener = new LocationListener() {

				// Provider的状态在可用、暂时不可用和无服务三个状态直接切换时触发此函数
				@Override
				public void onStatusChanged(String provider, int status, Bundle extras) {

				}

				// Provider被enable时触发此函数，比如GPS被打开
				@Override
				public void onProviderEnabled(String provider) {

				}

				// Provider被disable时触发此函数，比如GPS被关闭
				@Override
				public void onProviderDisabled(String provider) {

				}

				// 当坐标改变时触发此函数，如果Provider传进相同的坐标，它就不会被触发
				@Override
				public void onLocationChanged(Location location) {
					if (location != null) {
						Log.e("Map", "Location changed : Lat: " + location.getLatitude() + " Lng: "
								+ location.getLongitude());
					}
				}
			};
			locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000, 0, locationListener);
			Location location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
			if (location != null) {
				latitude = location.getLatitude(); // 经度
				longitude = location.getLongitude(); // 纬度
			}
		}
	}

	class QueryMerFeeInfoTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
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
							dataMap1.put("liqType", "D+0");
							dataMap1.put("liqTypei", "T0");
							dataMap1.put("t0Stat", tempObj.getString("t0Stat"));
							dataMap1.put("gateName", tempObj.getString("gateName"));
							dataMap1.put("feeRateT0", tempObj.getString("feeRateT0") + "%");

							HashMap<String, String> dataMap2 = new HashMap<String, String>();
							dataMap2.put("gateId", tempObj.getString("gateId"));
							dataMap2.put("liqType", "T+1");
							dataMap2.put("liqTypei", "T1");
							dataMap1.put("t0Stat", tempObj.getString("t1Stat"));
							dataMap2.put("gateName", tempObj.getString("gateName"));
							dataMap2.put("feeRateT0", tempObj.getString("feeRateT1") + "%");

							String t0Stat = tempObj.getString("t0Stat");
							String t1Stat = tempObj.getString("t1Stat");
							if ("Y".equals(t0Stat)) {
								itemArr.add(dataMap1);
							}
							if ("Y".equals(t1Stat)) {
								itemArr.add(dataMap2);
							}
						}
						// NFC隐藏
						for (int i = 0; i < itemArr.size(); i++) {
							HashMap<String, String> dataMap = itemArr.get(i);
							String gateId = dataMap.get("gateId");
							if (gateId != null && (gateId.equals("zlnfc"))) {
								itemArr.remove(i);
								i = -1;
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
				return returnMap;
			}
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			super.onPostExecute(resultMap);
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast(respDesc);
			}
			if (itemArr == null || itemArr.size() == 0) {
				Builder builder = new AlertDialog.Builder(norRecv1Activity);
				builder.setTitle("提示");
				builder.setMessage("你的收款功能被关闭");
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						finish();
					}
				});
				builder.show();
			}
			try {
				SharedPreferences.Editor editor = sp.edit();
				editor.putString("gateId", resultMap.get("gateId"));
				editor.putString("gateName", resultMap.get("gateName"));
				editor.commit();
				HashMap<String, String> str = itemArr.get(0);
				tv_paychannel.setText(str.get("gateName").toString());
				tv_D0_T1.setText(str.get("liqType").toString());
				textFeeInfo.setText(str.get("feeRateT0").toString());
				gateId = str.get("gateId").toString();
				liqType = str.get("liqTypei").toString();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
