package cn.qmpos;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.SimpleAdapter;
import android.widget.SimpleAdapter.ViewBinder;
import android.widget.TextView;
import cn.qmpos.adapter.AltColorAdapter;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.view.XListView;
import cn.qmpos.view.XListView.IXListViewListener;
import cn.qmpos.R;


/**
 * 排行榜/积分详情
 * 
 */
public class ScoreDetailsAcitivty extends BaseActivity implements
		OnClickListener, IXListViewListener, OnItemClickListener {

	private Button btnBack, tv_ranking, tv_integral;
	private XListView dataListView;
	private SimpleAdapter simpleAdapter;
	private ArrayList<HashMap<String, String>> itemArr = new ArrayList<HashMap<String, String>>();
	private String merId, beginDate, endDate, pageSize = "10";// 商户号,起始日期,结束日期,每页显示数目
	private int pageNum = 1; // 当前页数
	private View ranking_layout, integral_layout, title_layout,
			list_itme_layout;
	private boolean integralDetails = true;
	private TextView tv_desc, tv_ranking_activity, tv_name_activity,
			tv_phone_activity, tv_integral_value_activity;
	private ImageView mUserImg;
	File picFile;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_score_details);
		initView();
		System.out.println("PID" + Thread.currentThread().getId());
	}

	private void initView() {
		btnBack = (Button) findViewById(R.id.btn_back);
		tv_ranking = (Button) findViewById(R.id.tv_ranking);
		tv_integral = (Button) findViewById(R.id.tv_integral);
		ranking_layout = findViewById(R.id.ranking_layout);
		integral_layout = findViewById(R.id.integral_layout);
		title_layout = findViewById(R.id.title_layout);
		tv_desc = (TextView) findViewById(R.id.tv_desc);
		tv_ranking_activity = (TextView) findViewById(R.id.tv_ranking_activity);
		tv_name_activity = (TextView) findViewById(R.id.tv_name_activity);
		tv_phone_activity = (TextView) findViewById(R.id.tv_phone_activity);
		tv_integral_value_activity = (TextView) findViewById(R.id.tv_integral_value_activity);
		mUserImg = (ImageView) findViewById(R.id.user_head);
		list_itme_layout = findViewById(R.id.list_itme_layout);
		list_itme_layout.setOnClickListener(this);
		tv_ranking_activity.setOnClickListener(this);
		tv_phone_activity.setOnClickListener(this);
		tv_name_activity.setOnClickListener(this);
		tv_integral_value_activity.setOnClickListener(this);
		btnBack.setOnClickListener(this);
		tv_ranking.setOnClickListener(this);
		tv_integral.setOnClickListener(this);
		title_layout.setOnClickListener(this);
		tv_desc.setOnClickListener(this);

		dataListView = (XListView) findViewById(R.id.pay_list_data_list);
		dataListView.setPullLoadEnable(true); // 设置加载更多
		dataListView.setPullRefreshEnable(true); // 设置可刷新
		dataListView.setXListViewListener(this);
		merId = sp.getString("merId", "");
		endDate = CommUtil.getDate();
		beginDate = CommUtil.getNextDate(endDate, -60);

		IntegralDetails();
		QueryScoreTotListTask queryScoreTotListTask = new QueryScoreTotListTask();
		queryScoreTotListTask.execute();
		onLoad();

		// 显示头像
		File pictureFileDir = new File(
				Environment.getExternalStorageDirectory(), "/upload");
		if (!pictureFileDir.exists()) {
			pictureFileDir.mkdirs();
		}
		picFile = new File(pictureFileDir, merId + ".jpg");
		if (!picFile.exists()) {
			try {
				picFile.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		File file = new File(Environment.getExternalStorageDirectory(),
				"/uploadTemp/" + merId + ".jpg");
		if (!file.exists()) {
			mUserImg.setImageResource(R.drawable.touxiang);
		} else {
			mUserImg.setImageURI(Uri.fromFile(file));
		}
	}

	// 排行榜
	private void IntegralDetails() {
		simpleAdapter = new AltColorAdapter(this, itemArr,
				R.layout.list_item_list, new String[] { "rankNo", "merInfo",
						"transAmt", "bookmarkDr" }, new int[] {
						R.id.tv_ranking, R.id.tv_name_phone,
						R.id.tv_integral_value, R.id.img_ranking });
		simpleAdapter.setViewBinder(new ViewBinder() {
			@Override
			public boolean setViewValue(View view, Object data,
					String textRepresentation) {
				if (view instanceof ImageView && data instanceof Drawable) {
					ImageView iv = (ImageView) view;
					iv.setImageDrawable((Drawable) data);
					return true;
				}
				return false;
			}
		});
		dataListView.setAdapter(simpleAdapter);
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.btn_back:
				finish();
				break;
			// 排行榜
			case R.id.tv_ranking:
				pageNum = 1;
				itemArr.clear();
				integralDetails = true;
				IntegralDetails();
				tv_ranking.setTextColor(Color.DKGRAY);
				tv_integral.setTextColor(Color.WHITE);
				ranking_layout.setBackgroundResource(R.color.whilte);
				integral_layout.setBackgroundResource(R.color.deep_bule);
				title_layout.setVisibility(View.VISIBLE);
				tv_desc.setVisibility(View.VISIBLE);
				list_itme_layout.setVisibility(View.VISIBLE);
				QueryScoreTotListTask queryScoreTotListTask = new QueryScoreTotListTask();
				queryScoreTotListTask.execute();
				onLoad();
				break;
			// 积分详情
			case R.id.tv_integral:
				pageNum = 1;
				itemArr.clear();
				integralDetails = false;
				simpleAdapter = new SimpleAdapter(this, itemArr,
						R.layout.list_item_pay, new String[] { "scoreOrdId",
								"transAmt", "transDate", "scoreSrc" },
						new int[] { R.id.list_item2_trans_seq_id,
								R.id.list_item2_trans_amt,
								R.id.list_item2_trans_create_date,
								R.id.list_item2_trans_stat });
				dataListView.setAdapter(simpleAdapter);
				tv_ranking.setTextColor(Color.WHITE);
				tv_integral.setTextColor(Color.DKGRAY);
				ranking_layout.setBackgroundResource(R.color.deep_bule);
				integral_layout.setBackgroundResource(R.color.whilte);
				title_layout.setVisibility(View.GONE);
				tv_desc.setVisibility(View.GONE);
				list_itme_layout.setVisibility(View.GONE);
				QueryscoreInListTask queryscoreInListTask = new QueryscoreInListTask();
				queryscoreInListTask.execute(new String[] { merId, beginDate,
						endDate, String.valueOf(pageNum), pageSize });
				onLoad();
				break;
			case R.id.tv_desc:
				// Intent intent = new Intent(this, EventDetailsActivity.class);
				// startActivity(intent);
				Intent intent = new Intent(this, WebViewActivity.class);
				intent.putExtra("url", "http://121.41.118.80:9999/forward.html");
				intent.putExtra("title", "活动详情");
				startActivity(intent);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onRefresh() {
		pageNum = 1;
		itemArr.clear();
		Log.i("e", "刷新....");
		if (integralDetails == true) {
			QueryScoreTotListTask queryScoreTotListTask = new QueryScoreTotListTask();
			queryScoreTotListTask.execute();
		} else if (integralDetails == false) {
			QueryscoreInListTask queryscoreInListTask = new QueryscoreInListTask();
			queryscoreInListTask.execute(new String[] { merId, beginDate,
					endDate, String.valueOf(pageNum), pageSize });
		}
		onLoad();
	}

	@Override
	public void onLoadMore() {
		pageNum++;
		Log.i("e", "更多....");
		if (integralDetails == true) {
			itemArr.clear();
			QueryScoreTotListTask queryScoreTotListTask = new QueryScoreTotListTask();
			queryScoreTotListTask.execute();
		} else if (integralDetails == false) {
			QueryscoreInListTask queryscoreInListTask = new QueryscoreInListTask();
			queryscoreInListTask.execute(new String[] { merId, beginDate,
					endDate, String.valueOf(pageNum), pageSize });
		}
		onLoad();
	}

	private void onLoad() {
		dataListView.stopRefresh();
		dataListView.stopLoadMore();
		dataListView.setRefreshTime(CommUtil.addChineseToTimeString(CommUtil
				.getTime()));
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View convertView,
			int position, long arg3) {
	}

	// 排行榜
	class QueryScoreTotListTask extends
			AsyncTask<String, Integer, HashMap<String, Object>> {
		protected void onPreExecute() {
			dialog.setMessage("加载中,请稍候...");
			dialog.show();
		}

		@SuppressWarnings({ "unchecked", "rawtypes" })
		protected HashMap<String, Object> doInBackground(String... params) {
			System.out.println("doInBackground PID"
					+ Thread.currentThread().getId());
			HashMap<String, Object> returnMap = new HashMap<String, Object>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				String requestUrl = Constants.server_host
						+ Constants.server_queryScoreTotList_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", responseStr);
					return returnMap;
				}

				// 解释返回的josn
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				if (respCode.equals(Constants.SERVER_SUCC)) {
					int totalNum = Integer.parseInt(jsonObj
							.getString("totalNum"));
					if (totalNum > 0) {
						JSONArray tempArray = jsonObj
								.getJSONArray("ordersInfo");
						ArrayList<HashMap<String, String>> temp = new ArrayList<HashMap<String, String>>();
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							HashMap dataMap = new HashMap();
							dataMap.put("merId", tempObj.getString("merId"));
							dataMap.put(
									"merInfo",
									CommUtil.addUser(tempObj
											.getString("merName"))
											+ "("
											+ CommUtil.addBarToMobile(tempObj
													.getString("merMp")) + ")");
							dataMap.put("transAmt", CommUtil
									.removeDecimal(tempObj
											.getString("transAmt")));
							Drawable bookmarkDr1 = getResources().getDrawable(
									R.drawable.diyi);
							Drawable bookmarkDr2 = getResources().getDrawable(
									R.drawable.dier);
							Drawable bookmarkDr3 = getResources().getDrawable(
									R.drawable.disan);
							if (i == 0) {
								dataMap.put("rankNo", "");
								dataMap.put("bookmarkDr", bookmarkDr1);
							} else if (i == 1) {
								dataMap.put("rankNo", "");
								dataMap.put("bookmarkDr", bookmarkDr2);
							} else if (i == 2) {
								dataMap.put("rankNo", "");
								dataMap.put("bookmarkDr", bookmarkDr3);
							} else {
								dataMap.put("rankNo",
										tempObj.getString("rankNo"));
								dataMap.put("bookmarkDr", null);
							}
							temp.add(dataMap);
							System.out.println("xxxxx1");
						}
						returnMap.put("list", temp);
						JSONObject tempObj = tempArray.getJSONObject(tempArray
								.length() - 1);
						returnMap.put("rankNo", tempObj.getString("rankNo"));
						returnMap.put("merName", tempObj.getString("merName"));
						returnMap.put("merMp", tempObj.getString("merMp"));
						returnMap.put("transAmt", CommUtil
								.removeDecimal(tempObj.getString("transAmt")));

					}
				}
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				System.out.println("xxxxx==========");
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_NETERR);
				returnMap.put("respDesc", "");
				return returnMap;
			}
		}

		@SuppressWarnings("unchecked")
		protected void onPostExecute(HashMap<String, Object> resultMap) {
			super.onPostExecute(resultMap);
			System.out.println("onPostExecute PID"
					+ Thread.currentThread().getId());
			ArrayList<HashMap<String, String>> object = (ArrayList<HashMap<String, String>>) resultMap
					.get("list");
			if (object != null) {
				for (int i = 0; i < object.size() - 1; i++) {
					HashMap<String, String> tempObj = object.get(i);
					itemArr.add(tempObj);
					System.out.println("xxxxx1");
				}
			}

			if (simpleAdapter != null) {
				simpleAdapter.notifyDataSetChanged();
				System.out.println("xxxx2");
			}
			String respCode = (String) resultMap.get("respCode");
			String respDesc = (String) resultMap.get("respDesc");
			dialog.hide();
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast(respDesc);
				return;
			}

			String rankNo = (String) resultMap.get("rankNo");
			String merName = (String) resultMap.get("merName");
			String merMp = (String) resultMap.get("merMp");
			String transAmt = (String) resultMap.get("transAmt");

			tv_ranking_activity.setText(rankNo);
			tv_name_activity.setText(merName);
			tv_phone_activity.setText(merMp);
			tv_integral_value_activity.setText(transAmt);
		}
	}

	// 积分详情
	class QueryscoreInListTask extends
			AsyncTask<String, Integer, HashMap<String, Object>> {
		protected void onPreExecute() {
			dialog.setMessage("加载中,请稍候...");
			dialog.show();
		}

		protected HashMap<String, Object> doInBackground(String... params) {
			System.out.println("doInBackground PID"
					+ Thread.currentThread().getId());
			HashMap<String, Object> returnMap = new HashMap<String, Object>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("beginDate", params[1]);
				map.put("endDate", params[2]);
				map.put("pageNum", params[3]);
				map.put("pageSize", params[4]);
				returnMap.put("pageNum", params[3]);
				String requestUrl = Constants.server_host
						+ Constants.server_queryscoreInList_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", responseStr);
					return returnMap;
				}

				// 解释返回的josn
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
						ArrayList<HashMap<String, String>> temp = new ArrayList<HashMap<String, String>>();
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							recordSum = tempArray.length();

							HashMap<String, String> dataMap = new HashMap<String, String>();
							dataMap.put(
									"transDate",
									CommUtil.addBarToDateString(tempObj
											.getString("transDate"))
											+ " "
											+ CommUtil
													.addColonToTimeString(tempObj
															.getString("transTime")));
							dataMap.put("transAmt", CommUtil
									.removeDecimal(tempObj
											.getString("transAmt")));
							dataMap.put("scoreOrdId",
									tempObj.getString("scoreOrdId"));
							dataMap.put("scoreSrc",
									tempObj.getString("scoreSrc"));

							temp.add(dataMap);
							System.out.println("xxxxx3");
						}
						returnMap.put("list", temp);
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

		@SuppressWarnings("unchecked")
		protected void onPostExecute(HashMap<String, Object> resultMap) {
			super.onPostExecute(resultMap);
			System.out.println("onPostExecute PID"
					+ Thread.currentThread().getId());
			System.out.println("xxx4");
			ArrayList<HashMap<String, String>> object = (ArrayList<HashMap<String, String>>) resultMap
					.get("list");
			if (object != null) {
				for (int i = 0; i < object.size(); i++) {
					HashMap<String, String> hashMap = object.get(i);
					itemArr.add(hashMap);
				}
			}

			simpleAdapter.notifyDataSetChanged();
			String respCode = (String) resultMap.get("respCode");
			String respDesc = (String) resultMap.get("respDesc");
			String recordSum = (String) resultMap.get("recordSum");
			String pageNum = (String) resultMap.get("pageNum");
			dialog.hide();
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast(respDesc);
				return;
			}

			boolean isFirstPage = true;
			if (!pageNum.equals("1")) {
				isFirstPage = false;
			}

			if (isFirstPage) {
				if ("0".equals(recordSum)) {
					showToast("近期内你还没有积分纪录");
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
