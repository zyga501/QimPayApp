package cn.qmpos.fragment;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.NorRecv1Activity;
import cn.qmpos.WebViewActivity;
import cn.qmpos.WebViewMoreActivity;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;

public class MainT2Fragment extends Fragment implements OnClickListener {

	private Activity mainActivity;
	private View t1Layout, single_delete_layout, ok_layout;
	private View one_layout, two_layout, three_layout, four_layout,
			five_layout, six_layout, seven_layout, eight_layout, nine_layout,
			zero_layout, two_zero_layout, point_layout, empty_layout,
			weixinzhifu_layout, zhifubaozhifu_layout;
	private String tempnum = "";
	private EditText tv_price;
	@SuppressWarnings("unused")
	private boolean isOperation = false;
	private double longitude, latitude;
	protected ProgressDialog dialog;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		t1Layout = inflater.inflate(R.layout.main_t2_layout, container, false);
		init(t1Layout);
		dialog = new ProgressDialog(mainActivity);
		dialog.setCanceledOnTouchOutside(false);
		return t1Layout;
	}

	private void setIsOperationTrue() {
		isOperation = true;
	}

	private void setMyShowValue(String str) {
		tv_price.setText(str);
	}

	private void init(View t1Layout) {
		mainActivity = this.getActivity();
		ok_layout = t1Layout.findViewById(R.id.ok_layout);
		single_delete_layout = t1Layout.findViewById(R.id.single_delete_layout);
		one_layout = t1Layout.findViewById(R.id.one_layout);
		two_layout = t1Layout.findViewById(R.id.two_layout);
		three_layout = t1Layout.findViewById(R.id.three_layout);
		four_layout = t1Layout.findViewById(R.id.four_layout);
		five_layout = t1Layout.findViewById(R.id.five_layout);
		six_layout = t1Layout.findViewById(R.id.six_layout);
		seven_layout = t1Layout.findViewById(R.id.seven_layout);
		eight_layout = t1Layout.findViewById(R.id.eight_layout);
		nine_layout = t1Layout.findViewById(R.id.nine_layout);
		zero_layout = t1Layout.findViewById(R.id.zero_layout);
		two_zero_layout = t1Layout.findViewById(R.id.two_zero_layout);
		point_layout = t1Layout.findViewById(R.id.point_layout);
		tv_price = (EditText) t1Layout.findViewById(R.id.tv_price);
		tv_price.addTextChangedListener(mTextWatcher);
		empty_layout = t1Layout.findViewById(R.id.empty_layout);
		weixinzhifu_layout = t1Layout.findViewById(R.id.weixinzhifu_layout);
		zhifubaozhifu_layout = t1Layout.findViewById(R.id.zhifubaozhifu_layout);

		ok_layout.setOnClickListener(this);
		single_delete_layout.setOnClickListener(this);
		one_layout.setOnClickListener(this);
		two_layout.setOnClickListener(this);
		three_layout.setOnClickListener(this);
		four_layout.setOnClickListener(this);
		five_layout.setOnClickListener(this);
		six_layout.setOnClickListener(this);
		seven_layout.setOnClickListener(this);
		eight_layout.setOnClickListener(this);
		nine_layout.setOnClickListener(this);
		zero_layout.setOnClickListener(this);
		two_zero_layout.setOnClickListener(this);
		point_layout.setOnClickListener(this);
		empty_layout.setOnClickListener(this);
		weixinzhifu_layout.setOnClickListener(this);
		zhifubaozhifu_layout.setOnClickListener(this);
	}

	TextWatcher mTextWatcher = new TextWatcher() {
		@Override
		public void onTextChanged(CharSequence s, int start, int before,
				int count) {
			if (s.toString().contains(".")) {
				if (s.length() - 1 - s.toString().indexOf(".") > 2) {
					s = s.toString().subSequence(0,
							s.toString().indexOf(".") + 3);
					tv_price.setText(s);
					tv_price.setSelection(s.length());
					Toast.makeText(mainActivity, "������ļ۸�����λС����",
							Toast.LENGTH_SHORT).show();
				}
			}
			if (s.toString().trim().substring(0).equals(".")) {
				s = "0" + s;
				tv_price.setText(s);
				tv_price.setSelection(2);
			}

			// if (s.toString().startsWith("0")
			// && s.toString().trim().length() > 1) {
			// if (!s.toString().substring(1, 2).equals(".")) {
			// tv_price.setText(s.subSequence(0, 1));
			// tv_price.setSelection(1);
			// return;
			// }
			// }
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {

		}
	};

	// ���һ������
	private void addNum(String str) {
		if (tempnum.length() == 10) {
			Toast.makeText(mainActivity, "���ɴ���10λ��", Toast.LENGTH_SHORT)
					.show();
			return;
		}
		tempnum += str;
		setMyShowValue(tempnum);
	}

	// ȫ�����
	private void clear() {
		tempnum = "";
		setMyShowValue("");
	}

	// д����
	public void setPrice(int flag) {
		String showValue = tv_price.getText().toString();
		if (showValue == null || "".equals(showValue)) {
			Toast.makeText(mainActivity, "�������տ��", Toast.LENGTH_SHORT).show();
			tv_price.setFocusable(true);
			return;
		}
		if (!CommUtil.isNumberCanWithDot(showValue)) {
			Toast.makeText(mainActivity, "�տ���Ǳ�׼�Ľ���ʽ��", Toast.LENGTH_SHORT)
					.show();
			tv_price.setFocusable(true);
			return;
		}
		float showValues = Float.parseFloat(showValue);
		if (showValues < Constants.DEFAULT_DOUBLE_ERROR) {
			Toast.makeText(mainActivity, "����С��0��", Toast.LENGTH_SHORT).show();
			return;
		}
		showValue = CommUtil.getCurrencyFormt(showValue);

		// ����ֵ�ÿ� ��ʱע�ͣ���Ҫ��ʱ��⿪
		// tempnum = "";
		// setMyShowValue(tempnum);

		// // Intent���ݲ���
		// Intent intent = new Intent(mainActivity, NorRecv1Activity.class);
		// intent.putExtra("showValue", showValue);
		// startActivity(intent);

		if (flag == 1) {
			// ����֤���� ��˵����T1�����ÿ������ȣ�γ��
			WeChatCreatepayTask weChatCreatepayTask = new WeChatCreatepayTask();
			weChatCreatepayTask.execute(new String[] { showValue, "΢��֧��", "T1",
					"X", longitude + "", latitude + "", "weixin" });
		} else if (flag == 2) {
			// ����֤���� ��˵����T1�����ÿ������ȣ�γ��
			WeChatCreatepayTask weChatCreatepayTask = new WeChatCreatepayTask();
			weChatCreatepayTask.execute(new String[] { showValue, "֧����֧��",
					"T1", "X", longitude + "", latitude + "", "alipay" });
		} else {
			// Intent���ݲ���
			Intent intent = new Intent(mainActivity, NorRecv1Activity.class);
			intent.putExtra("showValue", showValue);
			startActivity(intent);
		}
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.weixinzhifu_layout:
				setPrice(1);
				break;
			case R.id.zhifubaozhifu_layout:
				setPrice(2);
				break;
			case R.id.ok_layout:
				setPrice(3);
				break;
			case R.id.single_delete_layout:
				singleDelete();
				break;
			case R.id.empty_layout:
				clear();
				break;
			case R.id.one_layout:
				addNum("1");
				setIsOperationTrue();
				break;
			case R.id.two_layout:
				addNum("2");
				setIsOperationTrue();
				break;
			case R.id.three_layout:
				addNum("3");
				setIsOperationTrue();
				break;
			case R.id.four_layout:
				addNum("4");
				setIsOperationTrue();
				break;
			case R.id.five_layout:
				addNum("5");
				setIsOperationTrue();
				break;
			case R.id.six_layout:
				addNum("6");
				setIsOperationTrue();
				break;
			case R.id.seven_layout:
				addNum("7");
				setIsOperationTrue();
				break;
			case R.id.eight_layout:
				addNum("8");
				setIsOperationTrue();
				break;
			case R.id.nine_layout:
				addNum("9");
				setIsOperationTrue();
				break;
			case R.id.zero_layout:
				addNum("0");
				break;
			case R.id.two_zero_layout:
				addNum("00");
				setIsOperationTrue();
				break;
			case R.id.point_layout:
				addNum(".");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ����ɾ��
	private void singleDelete() {
		try {
			tempnum = tempnum.substring(0, (tempnum.length() - 1));
			setMyShowValue(tempnum);
		} catch (Exception e) {
			e.printStackTrace();
			Log.e("dddd", e.getMessage());
		}
	}

	// ΢��֧��
	class WeChatCreatepayTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("֧���У����Ժ�...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();
			SharedPreferences mySharedPreferences = mainActivity
					.getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
			String merId = mySharedPreferences.getString("merId", "");
			String loginId = mySharedPreferences.getString("loginId", "");
			String sessionId = mySharedPreferences.getString("sessionId", "");
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
				map.put("longitude", params[4]);
				map.put("latitude", params[5]);
				map.put("gateId", params[6]);
				map.put("clientModel", Build.MODEL);

				String requestUrl = Constants.server_host
						+ Constants.server_createpay_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
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
				returnMap.put("transSeqId", jsonObj.getString("transSeqId"));
				returnMap.put("credNo", jsonObj.getString("credNo"));
				returnMap.put("transAmt", jsonObj.getString("transAmt"));
				returnMap.put("transFee", jsonObj.getString("transFee"));

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
				String responseStr = HttpRequest.getResponse(requestUrl, map);
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
				Toast.makeText(mainActivity, respDesc, Toast.LENGTH_LONG)
						.show();
				return;
			}
			dialog.hide();
			try {
				String qrCodeUrl = resultMap.get("qrCodeUrl");
				Intent i = new Intent(mainActivity, WebViewMoreActivity.class);
				i.putExtra("url", qrCodeUrl);
				startActivity(i);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		/**
		 * ��ȡ��γ������
		 */
		void getGPS() {
			LocationManager locationManager = (LocationManager) mainActivity
					.getSystemService(Context.LOCATION_SERVICE);
			if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
				Location location = locationManager
						.getLastKnownLocation(LocationManager.GPS_PROVIDER);
				if (location != null) {
					latitude = location.getLatitude();
					longitude = location.getLongitude();
				}
			} else {
				LocationListener locationListener = new LocationListener() {

					// Provider��״̬�ڿ��á���ʱ�����ú��޷�������״ֱ̬���л�ʱ�����˺���
					@Override
					public void onStatusChanged(String provider, int status,
							Bundle extras) {

					}

					// Provider��enableʱ�����˺���������GPS����
					@Override
					public void onProviderEnabled(String provider) {

					}

					// Provider��disableʱ�����˺���������GPS���ر�
					@Override
					public void onProviderDisabled(String provider) {

					}

					// ������ı�ʱ�����˺��������Provider������ͬ�����꣬���Ͳ��ᱻ����
					@Override
					public void onLocationChanged(Location location) {
						if (location != null) {
							Log.e("Map",
									"Location changed : Lat: "
											+ location.getLatitude() + " Lng: "
											+ location.getLongitude());
						}
					}
				};
				locationManager.requestLocationUpdates(
						LocationManager.NETWORK_PROVIDER, 1000, 0,
						locationListener);
				Location location = locationManager
						.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
				if (location != null) {
					latitude = location.getLatitude(); // ����
					longitude = location.getLongitude(); // γ��
				}
			}
		}
	}
}
