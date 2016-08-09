package cn.qmpos.view;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.widget.ArrayAdapter;
import cn.qmpos.R;

import cn.qmpos.util.Constants;
import cn.qmpos.view.XListView.IXListViewListener;

public class XListViewActivity extends Activity implements IXListViewListener {
	private XListView mListView;
	private ArrayAdapter<String> mAdapter;
	private ArrayList<String> items = new ArrayList<String>();
	private Handler mHandler;
	private int start = 0;
	private static int refreshCnt = 0;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		geneItems();
		mListView = (XListView) findViewById(R.id.xListView);
		mListView.setPullLoadEnable(true);
		mAdapter = new ArrayAdapter<String>(this, R.layout.list_item, items);
		mListView.setAdapter(mAdapter);
		// mListView.setPullLoadEnable(false);
		// mListView.setPullRefreshEnable(false);
		mListView.setXListViewListener(this);

		LoadTask load = new LoadTask();
		load.execute(new String[] { "", "" });
		mHandler = new Handler();
	}

	private void geneItems() {
		if (1 == 1)
			return;
		for (int i = 0; i != 20; ++i) {
			items.add("refresh cnt " + (++start));
		}
	}

	private void onLoad() {
		mListView.stopRefresh();
		mListView.stopLoadMore();
		mListView.setRefreshTime("12:11:23");
	}

	@Override
	public void onRefresh() {
		mHandler.postDelayed(new Runnable() {
			@Override
			public void run() {
				start = ++refreshCnt;
				items.clear();
				geneItems();
				// mAdapter.notifyDataSetChanged();
				LoadTask load = new LoadTask();
				load.execute(new String[] { "", "" });
				// mAdapter = new ArrayAdapter<String>(XListViewActivity.this,
				// R.layout.list_item, items);
				// mListView.setAdapter(mAdapter);
				onLoad();
			}
		}, 2000);
	}

	@Override
	public void onLoadMore() {
		mHandler.postDelayed(new Runnable() {
			@Override
			public void run() {
				geneItems();
				LoadTask load = new LoadTask();
				load.execute(new String[] { "", "" });
				// mAdapter.notifyDataSetChanged();
				onLoad();
			}
		}, 2000);
	}

	class LoadTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
		}

		protected HashMap<String, String> doInBackground(String... params) {

			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				SharedPreferences mySharedPreferences = getSharedPreferences(
						"qmpos", Activity.MODE_PRIVATE);
				String merId = mySharedPreferences.getString("merId", "");
				String sessionId = mySharedPreferences.getString("sessionId",
						"");

				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", merId);
				map.put("sessionId", sessionId);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host
						+ Constants.server_queryLiqCard_url;
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
				if (respCode.equals(Constants.SERVER_SUCC)) {
					int totalNum = Integer.parseInt(jsonObj
							.getString("totalNum"));
					if (totalNum > 0) {
						JSONArray tempArray = jsonObj
								.getJSONArray("ordersInfo");
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							items.add(tempObj.getString("openBankId") + " - "
									+ tempObj.getString("openAcctId"));
						}
					}
				}
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
			mAdapter.notifyDataSetChanged();
			return;
		}
	}

}