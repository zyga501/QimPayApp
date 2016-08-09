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
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.view.XListView;
import cn.qmpos.view.XListView.IXListViewListener;
import cn.qmpos.R;


/**
 * 转账记录
 * 
 * @author Administrator
 * 
 */
public class TransferRecordAcitivty extends BaseActivity implements
		OnClickListener, IXListViewListener, OnItemClickListener {

	private TransferRecordAcitivty transferRecordAcitivty;
	private XListView dataListView;
	private SimpleAdapter simpleAdapter;
	private ArrayList<HashMap<String, String>> itemArr = new ArrayList<HashMap<String, String>>();
	// 商户号,交易开始日期,交易截止日期,交易状态,当前页数,每页显示数目,是否实名认证,转账订单号,转账类型
	private String merId, beginDate, endDate, trfOrdId, trfType,
			pageSize = "10";
	private int pageNum = 1;
	LoadTurnOutTask loadTurnOutTask;
	private SharedPreferences sp;
	public Button btnBack, mBtnZhuanRu, mBtnZhuanChu;
	public View mZhuanRuUnderline, mZhuanChuUnderline;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.acitivty_transfer_record);
		initView();
	}

	private void initView() {
		transferRecordAcitivty = this;
		btnBack = (Button) findViewById(R.id.btn_back);
		dataListView = (XListView) findViewById(R.id.turn_Into_out_list);
		mBtnZhuanRu = (Button) findViewById(R.id.btn_zhuanru);
		mBtnZhuanChu = (Button) findViewById(R.id.btn_zhuanchu);
		mZhuanRuUnderline = findViewById(R.id.zhuanru_underline);
		mZhuanChuUnderline = findViewById(R.id.zhuanchu_underline);
		mBtnZhuanRu.setOnClickListener(this);
		mBtnZhuanChu.setOnClickListener(this);

		btnBack.setOnClickListener(this);
		dataListView.setPullLoadEnable(true); // 设置加载更多
		dataListView.setPullRefreshEnable(true); // 设置可刷新
		dataListView.setXListViewListener(this);
		simpleAdapter = new SimpleAdapter(this, itemArr,
				R.layout.list_item_turn_out, new String[] { "createDate",
						"merInfo", "transAmt" },
				new int[] { R.id.list_turn_date, R.id.list_info,
						R.id.list_transamt });
		dataListView.setAdapter(simpleAdapter);
		sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		merId = sp.getString("merId", "");
		endDate = CommUtil.getDate();
		beginDate = CommUtil.getNextDate(endDate, -60);
		trfOrdId = "";
		trfType = "I";

		loadTurnOutTask = new LoadTurnOutTask();
		loadTurnOutTask.execute(new String[] { merId, beginDate, endDate,
				trfOrdId, trfType, String.valueOf(pageNum), pageSize });
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			case R.id.btn_zhuanru:
				trfType = "I";
				pageNum = 1;
				itemArr.clear();
				mBtnZhuanRu.setTextColor(Color.RED);
				mBtnZhuanChu.setTextColor(Color.BLACK);
				mZhuanRuUnderline.setBackgroundResource(R.color.red);
				mZhuanChuUnderline.setBackgroundResource(R.color.under_line);
				loadTurnOutTask = new LoadTurnOutTask();
				loadTurnOutTask.execute(new String[] { merId, beginDate,
						endDate, trfOrdId, trfType, String.valueOf(pageNum),
						pageSize });
				onLoad();
				break;
			case R.id.btn_zhuanchu:
				trfType = "O";
				pageNum = 1;
				itemArr.clear();
				mBtnZhuanRu.setTextColor(Color.BLACK);
				mBtnZhuanChu.setTextColor(Color.RED);
				mZhuanRuUnderline.setBackgroundResource(R.color.under_line);
				mZhuanChuUnderline.setBackgroundResource(R.color.red);
				loadTurnOutTask = new LoadTurnOutTask();
				loadTurnOutTask.execute(new String[] { merId, beginDate,
						endDate, trfOrdId, trfType, String.valueOf(pageNum),
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
		LoadTurnOutTask loadTurnOutTask = new LoadTurnOutTask();
		loadTurnOutTask.execute(new String[] { merId, beginDate, endDate,
				trfOrdId, trfType, String.valueOf(pageNum), pageSize });
		onLoad();
	}

	@Override
	public void onLoadMore() {
		// TODO Auto-generated method stub
		pageNum++;
		Log.i("e", "更多....");
		LoadTurnOutTask loadTurnOutTask = new LoadTurnOutTask();
		loadTurnOutTask.execute(new String[] { merId, beginDate, endDate,
				trfOrdId, trfType, String.valueOf(pageNum), pageSize });
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
		HashMap<String, String> map = (HashMap<String, String>) transferRecordAcitivty.simpleAdapter
				.getItem(arg2 - 1);

		Intent i = new Intent(transferRecordAcitivty, LiqDescActivity.class);
		i.putExtra("createDate", map.get("createDate"));
		i.putExtra("transAmt", map.get("transAmt"));
		i.putExtra("trfTitle", map.get("trfTitle"));
		i.putExtra("merId", map.get("merId"));
		i.putExtra("merMp", map.get("merMp"));
		i.putExtra("MerName", map.get("MerName"));
		transferRecordAcitivty.startActivity(i);
		return;
	}

	class LoadTurnOutTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("正在添加,请稍候...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("beginDate", params[1]);
				map.put("endDate", params[2]);
				map.put("trfOrdId", params[3]);
				map.put("trfType", params[4]);
				map.put("pageNum", params[5]);
				map.put("pageSize", params[6]);
				String requestUrl = Constants.server_host
						+ Constants.server_queryTrfToMerList_url;
				returnMap.put("pageNum", params[5]);
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "获取信息异常!");
					return returnMap;
				}

				// 解释返回的json
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
							dataMap.put("trfTitle",
									tempObj.getString("trfTitle"));
							dataMap.put("merId", tempObj.getString("merId"));
							dataMap.put(
									"merInfo",
									tempObj.getString("MerName")
											+ "("
											+ CommUtil.addBarToMobile(tempObj
													.getString("merMp")) + ")");
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
			String recordSum = resultMap.get("recordSum");
			String pageNum = resultMap.get("pageNum");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast("请求数据错误！");
				return;
			}
			dialog.hide();
			boolean isFirstPage = true;
			if (!pageNum.equals("1")) {
				isFirstPage = false;
			}

			if (isFirstPage) {
				if ("0".equals(recordSum)) {
					showToast("近期内你还没有转账记录");
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
