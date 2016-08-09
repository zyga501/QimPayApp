package cn.qmpos;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.SimpleAdapter;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.view.XListView;
import cn.qmpos.view.XListView.IXListViewListener;

/**
 * 收款记录
 * 
 * @author Administrator
 * 
 */
public class PayListActivity extends BaseActivity implements OnClickListener,
		IXListViewListener, OnItemClickListener {
	LoadTask load;
	private Button btnBack;
	public Button mAllTradingButton, mSuccessfulTradingButton;
	public View mAllTradingUnderline, mSuccessfulTradingUnderline;
	private XListView dataListView;
	private SimpleAdapter simpleAdapter;
	private ArrayList<HashMap<String, String>> itemArr = new ArrayList<HashMap<String, String>>();

	// 商户号
	private String merId;
	// 手机号
	private String loginId;
	// sessionID
	private String sessionId;
	// 交易开始日期
	private String beginDate;
	// 交易截止日期
	private String endDate;
	// 交易状态
	private String transStat = "";
	// 当前页数
	private int pageNum = 1;
	// 每页显示数目
	private String pageSize = "10";

	private PayListActivity payListActivity;

	public PayListActivity() {
		// TODO Auto-generated constructor stub
	}

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_pay_list);

		payListActivity = this;

		btnBack = (Button) this.findViewById(R.id.pay_list_btn_back);
		btnBack.setOnClickListener(this);

		mAllTradingButton = (Button) findViewById(R.id.all_trading_button);
		mSuccessfulTradingButton = (Button) findViewById(R.id.successful_trading_button);
		mAllTradingUnderline = findViewById(R.id.all_trading_underline);
		mSuccessfulTradingUnderline = findViewById(R.id.successful_trading_underline);
		mAllTradingButton.setOnClickListener(this);
		mSuccessfulTradingButton.setOnClickListener(this);

		dataListView = (XListView) findViewById(R.id.pay_list_data_list);
		dataListView.setPullLoadEnable(true); // 设置加载更多
		dataListView.setPullRefreshEnable(true); // 设置可刷新
		dataListView.setXListViewListener(this);
		dataListView.setOnItemClickListener(this);

		simpleAdapter = new SimpleAdapter(this, itemArr,
				R.layout.list_item_pay, new String[] { "transSeqId",
						"transAmt", "createDate", "transStat" }, new int[] {
						R.id.list_item2_trans_seq_id,
						R.id.list_item2_trans_amt,
						R.id.list_item2_trans_create_date,
						R.id.list_item2_trans_stat });
		dataListView.setAdapter(simpleAdapter);

		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		merId = mySharedPreferences.getString("merId", "");
		loginId = mySharedPreferences.getString("loginId", "");
		sessionId = mySharedPreferences.getString("sessionId", "");
		endDate = CommUtil.getDate();
		beginDate = CommUtil.getNextDate(endDate, -60);
		load = new LoadTask();
		load.execute(new String[] { sessionId, merId, loginId, beginDate,
				endDate, transStat, String.valueOf(pageNum), pageSize });
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.pay_list_btn_back:
				finish();
				break;
			case R.id.all_trading_button:
				transStat = "";
				pageNum = 1;
				itemArr.clear();
				mAllTradingButton.setTextColor(Color.RED);
				mSuccessfulTradingButton.setTextColor(Color.BLACK);
				mAllTradingUnderline.setBackgroundResource(R.color.red);
				mSuccessfulTradingUnderline
						.setBackgroundResource(R.color.under_line);
				load = new LoadTask();
				load.execute(new String[] { sessionId, merId, loginId,
						beginDate, endDate, transStat, String.valueOf(pageNum),
						pageSize });
				onLoad();
				break;
			case R.id.successful_trading_button:
				transStat = "S";
				pageNum = 1;
				itemArr.clear();
				mAllTradingButton.setTextColor(Color.BLACK);
				mSuccessfulTradingButton.setTextColor(Color.RED);
				mAllTradingUnderline.setBackgroundResource(R.color.under_line);
				mSuccessfulTradingUnderline.setBackgroundResource(R.color.red);
				load = new LoadTask();
				load.execute(new String[] { sessionId, merId, loginId,
						beginDate, endDate, transStat, String.valueOf(pageNum),
						pageSize });
				onLoad();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onRefresh() {
		// TODO Auto-generated method stub
		pageNum = 1;
		itemArr.clear();
		Log.i("e", "刷新....");
		LoadTask load = new LoadTask();
		load.execute(new String[] { sessionId, merId, loginId, beginDate,
				endDate, transStat, String.valueOf(pageNum), pageSize });
		onLoad();
	}

	@Override
	public void onLoadMore() {
		// TODO Auto-generated method stub
		pageNum++;
		Log.i("e", "更多....");
		LoadTask load = new LoadTask();
		load.execute(new String[] { sessionId, merId, loginId, beginDate,
				endDate, transStat, String.valueOf(pageNum), pageSize });
		onLoad();
	}

	private void onLoad() {
		dataListView.stopRefresh();
		dataListView.stopLoadMore();
		dataListView.setRefreshTime(CommUtil.addChineseToTimeString(CommUtil
				.getTime()));
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		// TODO Auto-generated method stub
		// 取出所有值跳到下一页
		HashMap<String, String> map = (HashMap<String, String>) payListActivity.simpleAdapter
				.getItem(arg2 - 1);

		Intent i = new Intent(payListActivity, PayDescActivity.class);
		i.putExtra("createDate", map.get("createDate"));
		i.putExtra("transAmt", map.get("transAmt"));
		i.putExtra("transFee", map.get("transFee"));
		i.putExtra("transSeqId", map.get("transSeqId"));
		i.putExtra("transType", map.get("transType"));
		i.putExtra("transStat", map.get("transStat"));
		i.putExtra("liqType", map.get("liqType"));
		i.putExtra("ordRemark", map.get("ordRemark"));
		i.putExtra("failRemark", map.get("failRemark"));
		i.putExtra("acctId", map.get("acctId"));
		i.putExtra("acctName", map.get("acctName"));
		payListActivity.startActivity(i);
		return;
	}

	class LoadTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {

		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				// load.execute(new String[]
				// {sessionId,merId,loginId,beginDate,endDate,transStat,pageNum,pageSize});
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("sessionId", params[0]);
				map.put("merId", params[1]);
				map.put("beginDate", params[3]);
				map.put("endDate", params[4]);
				map.put("transStat", params[5]);
				map.put("pageNum", params[6]);
				map.put("pageSize", params[7]);
				map.put("clientModel", android.os.Build.MODEL);
				returnMap.put("pageNum", params[6]);
				String requestUrl = Constants.server_host
						+ Constants.server_queryPayList_url;
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
				int recordSum = 0;
				if (respCode.equals(Constants.SERVER_SUCC)) {
					int totalNum = Integer.parseInt(jsonObj
							.getString("totalNum"));
					if (totalNum > 0) {
						JSONArray tempArray = jsonObj
								.getJSONArray("ordersInfo");
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							recordSum = tempArray.length();

							HashMap<String, String> dataMap = new HashMap<String, String>();
							dataMap.put(
									"createDate",
									CommUtil.addBarToDateString(tempObj
											.getString("createDate"))
											+ " "
											+ CommUtil
													.addColonToTimeString(tempObj
															.getString("createTime")));
							dataMap.put("transAmt",
									tempObj.getString("transAmt"));
							dataMap.put("transFee",
									tempObj.getString("transFee"));
							dataMap.put("transSeqId",
									tempObj.getString("transSeqId"));
							dataMap.put("transType",
									tempObj.getString("transType"));
							dataMap.put("transStat",
									tempObj.getString("transStat"));
							dataMap.put("liqType", tempObj.getString("liqType"));
							dataMap.put("ordRemark",
									tempObj.getString("ordRemark"));
							dataMap.put("failRemark",
									tempObj.getString("failRemark"));
							dataMap.put("acctId", tempObj.getString("acctId"));
							dataMap.put("acctName",
									tempObj.getString("acctName"));
							itemArr.add(dataMap);
						}
					}
				}
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				returnMap.put("recordSum", String.valueOf(recordSum));
				return returnMap;
			} catch (Exception e) {

				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_NETERR);
				returnMap.put("respDesc", "");
				return returnMap;
			}
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			super.onPostExecute(resultMap);
			simpleAdapter.notifyDataSetChanged();

			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			String recordSum = resultMap.get("recordSum");
			String pageNum = resultMap.get("pageNum");

			if (!Constants.SERVER_SUCC.equals(respCode)) {
				Toast.makeText(payListActivity, respDesc, Toast.LENGTH_SHORT)
						.show();
				return;
			}
			boolean isFirstPage = true;
			if (!pageNum.equals("1")) {
				isFirstPage = false;
			}

			if (isFirstPage) {
				if ("0".equals(recordSum)) {
					showToast("近期内你还没有收款记录");
				}

			} else {
				if ("0".equals(recordSum)) {
					showToast("已无更多记录!");
				}

			}
			return;
		}
	}

}
