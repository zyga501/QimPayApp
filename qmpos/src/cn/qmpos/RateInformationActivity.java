package cn.qmpos;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.R;


/**
 * 费率信息
 * 
 * @author Administrator
 * 
 */
public class RateInformationActivity extends BaseActivity implements
		OnClickListener {

	private Button btnBack;
	private ArrayList<HashMap<String, String>> itemArr = new ArrayList<HashMap<String, String>>();
	private SimpleAdapter simpleAdapter;
	private ListView dataListView;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_rateinformation);
		initView();
	}

	private void initView() {
		btnBack = (Button) this.findViewById(R.id.btn_back);
		btnBack.setOnClickListener(this);
		String merId = sp.getString("merId", "");
		dataListView = (ListView) findViewById(R.id.list_data_rate);
		simpleAdapter = new SimpleAdapter(this, itemArr,
				R.layout.list_item_rate, new String[] { "gateName", "liqType",
						"feeRateT0" }, new int[] { R.id.tv_pay_type,
						R.id.tv_t0_t1, R.id.tv_rate });
		dataListView.setAdapter(simpleAdapter);

		String t0Stat = sp.getString("t0Stat", "");
		String t1Stat = sp.getString("t1Stat", "");
		// D0,t1均关闭
		if ("N".equals(t1Stat) && "N".equals(t0Stat)) {
			Builder builder = new AlertDialog.Builder(this);
			builder.setTitle("提示");
			builder.setMessage("你的收款功能被关闭");
			builder.setPositiveButton("确认",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							finish();
						}
					});
			builder.show();
			return;
		}
		QueryMerFeeInfoTask queryMerFeeInfoTask = new QueryMerFeeInfoTask();
		queryMerFeeInfoTask.execute(new String[] { merId });
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	class QueryMerFeeInfoTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("加载中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				String requestUrl = Constants.server_host
						+ Constants.server_queryMerFeeInfo_url;
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
					int totalNum = Integer.parseInt(jsonObj
							.getString("totalNum"));
					if (totalNum > 0) {
						JSONArray tempArray = jsonObj
								.getJSONArray("merFeeInfo");
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							recordSum = tempArray.length();

							HashMap<String, String> dataMap1 = new HashMap<String, String>();
							dataMap1.put("gateId", tempObj.getString("gateId"));
							dataMap1.put("liqType", "D+0");
							dataMap1.put("t0Stat", tempObj.getString("t0Stat"));
							dataMap1.put("gateName",
									tempObj.getString("gateName"));
							dataMap1.put("feeRateT0",
									tempObj.getString("feeRateT0") + "%");

							HashMap<String, String> dataMap2 = new HashMap<String, String>();
							dataMap2.put("gateId", tempObj.getString("gateId"));
							dataMap2.put("liqType", "T+1");
							dataMap1.put("t0Stat", tempObj.getString("t1Stat"));
							dataMap2.put("gateName",
									tempObj.getString("gateName"));
							dataMap2.put("feeRateT0",
									tempObj.getString("feeRateT1") + "%");

							String t0Stat = tempObj.getString("t0Stat");
							String t1Stat = tempObj.getString("t1Stat");
							if ("Y".equals(t0Stat)) {
								itemArr.add(dataMap1);
							}
							if ("Y".equals(t1Stat)) {
								itemArr.add(dataMap2);
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
			simpleAdapter.notifyDataSetChanged();
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			dialog.hide();
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast(respDesc);
			}
			if (itemArr == null || itemArr.size() == 0) {
				Builder builder = new AlertDialog.Builder(
						RateInformationActivity.this);
				builder.setTitle("提示");
				builder.setMessage("你的收款功能被关闭");
				builder.setPositiveButton("确认",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								finish();
							}
						});
				builder.show();
			}
		}
	}
}
