package cn.qmpos;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.qmpos.entity.Cardinfos;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.R;

/**
 * 结算卡号管理
 * 
 * @author Administrator
 * 
 */
public class CardManagerActivity extends BaseActivity implements OnClickListener {

	private Button mBack;
	private ImageView mImgAddCad;
	private CardManagerActivity cardManagerActivity;
	private String[] liqCardIdArr = null;
	private String[] openBankNameArr = null;
	private String[] openAcctIdArr = null;
	private String[] openAcctNameArr = null;
	private String[] openBankIdArr = null;
	private String[] isDefaultArr = null;
	private LinearLayout card_items_layout;
	private String merId;
	private List<Cardinfos> listInfos;
	private View deleteView;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_card_manager);
		allActivity.add(this);
		init();
	}

	private void init() {
		cardManagerActivity = this;
		mBack = (Button) findViewById(R.id.back);
		card_items_layout = (LinearLayout) this.findViewById(R.id.card_items_layout);
		mImgAddCad = (ImageView) findViewById(R.id.img_add_card);
		mBack.setOnClickListener(this);
		mImgAddCad.setOnClickListener(this);
		// 查询结算卡
		merId = sp.getString("merId", "");
		QueryMerInfoTask queryMerInfoTask = new QueryMerInfoTask();
		queryMerInfoTask.execute(new String[] { merId, "J" });
	}

	public void onClick(View v) {
		try {
			Intent intent;
			switch (v.getId()) {
			case R.id.back:
				finish();
				break;
			case R.id.img_add_card:
				intent = new Intent(cardManagerActivity, AddCardActivity.class);
				startActivityForResult(intent, 1000);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == 1000 && resultCode == RESULT_OK) {
			QueryMerInfoTask queryMerInfoTask = new QueryMerInfoTask();
			queryMerInfoTask.execute(new String[] { merId, "J" });
		}
	}

	// 查询结算卡
	class QueryMerInfoTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("数据加载中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			// 查询商户结算账号信息
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("cardType", params[1]);
				String requestUrl = Constants.server_host + Constants.server_queryLiqCard_url;
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
				if (respCode.equals(Constants.SERVER_SUCC)) {
					int totalNum = Integer.parseInt(jsonObj.getString("totalNum"));
					returnMap.put("totalNum", jsonObj.getString("totalNum"));
					if (totalNum > 0) {
						liqCardIdArr = new String[totalNum];
						openAcctNameArr = new String[totalNum];
						openAcctIdArr = new String[totalNum];
						openBankNameArr = new String[totalNum];
						openBankIdArr = new String[totalNum];
						isDefaultArr = new String[totalNum];

						JSONArray tempArray = jsonObj.getJSONArray("ordersInfo");
						listInfos = new ArrayList<Cardinfos>();
						System.out.println(listInfos.size());
						for (int i = 0; i < tempArray.length(); i++) {
							JSONObject tempObj = tempArray.getJSONObject(i);
							Cardinfos infos = new Cardinfos(tempObj.getString("openAcctId"),
									tempObj.getString("openAcctName"), tempObj.getString("isDefault"),
									tempObj.getString("liqCardId"), tempObj.getString("openBankName"));
							listInfos.add(infos);
							liqCardIdArr[i] = tempObj.getString("liqCardId");// 结算卡编号
							openAcctNameArr[i] = tempObj.getString("openAcctName");// 户主
							openAcctIdArr[i] = tempObj.getString("openAcctId");// 卡号
							openBankNameArr[i] = tempObj.getString("openBankName");// 银行的名称
							openBankIdArr[i] = tempObj.getString("openBankId");// 结算银行代码
							isDefaultArr[i] = tempObj.getString("isDefault");// 是否默认
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
			return returnMap;

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(cardManagerActivity);
				builder.setTitle("提示");
				builder.setMessage(respDesc);
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						finish();
					}
				});
				builder.show();
				return;
			} else {
				try {
					if (openAcctNameArr.length > 0) {
						addCard();
					}
					SharedPreferences.Editor editor = sp.edit();
					editor.putString("totalNum", resultMap.get("totalNum"));
					editor.commit();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

	}

	// 显示银行卡处理
	private void addCard() {
		card_items_layout.removeAllViews();
		for (int i = 0; i < listInfos.size(); i++) {
			final View view = View.inflate(CardManagerActivity.this, R.layout.layout_addcard_item, null);
			final Cardinfos infos = listInfos.get(i);
			ImageView tv_card_delete = (ImageView) view.findViewById(R.id.tv_card_delete);
			TextView tv_cardNo = (TextView) view.findViewById(R.id.tv_cardNo);
			TextView tv_card_name = (TextView) view.findViewById(R.id.tv_card_name);
			TextView tv_card_default = (TextView) view.findViewById(R.id.tv_card_default);
			RelativeLayout card_name_layout = (RelativeLayout) view.findViewById(R.id.card_name_layout);
			tv_card_name.setText(infos.getOpenAcctName());
			tv_cardNo.setText(CommUtil.addBarToBankCardNo(infos.getOpenAcctId()));
			tv_card_default.setText(CommUtil.f_default(infos.getIsDefault()));
			if (infos.getOpenBankName().equals("北京银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_beijing);
			} else if (infos.getOpenBankName().equals("招商银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_zhaoshang);
			} else if (infos.getOpenBankName().equals("工商银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_gongshang);
			} else if (infos.getOpenBankName().equals("建设银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_jianshe);
			} else if (infos.getOpenBankName().equals("交通银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_jiaotong);
			} else if (infos.getOpenBankName().equals("中信银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_zhongxing);
			} else if (infos.getOpenBankName().equals("农业银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_nongye);
			} else if (infos.getOpenBankName().equals("光大银行")) {
				card_name_layout.setBackgroundResource(R.drawable.bg_guangda);
			}
			if ("Y".equals(infos.getIsDefault())) {
				tv_card_delete.setVisibility(View.GONE);
			}
			final String liqCardId = infos.getLiqCardId();
			tv_card_delete.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View arg0) {
					AlertDialog.Builder builder = new AlertDialog.Builder(cardManagerActivity);
					builder.setTitle("提示");
					builder.setMessage("您确定删除该银行卡吗？");
					if (!"Y".equals(infos.getIsDefault())) {
						builder.setPositiveButton("否", new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int which) {
								dialog.dismiss();
							}
						});
						builder.setNegativeButton("是", new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int which) {
								// 删除卡号
								deleteView = view;
								DeleteMerInfoTask deleteMerInfoTask = new DeleteMerInfoTask();
								deleteMerInfoTask.execute(new String[] { merId, liqCardId });
							}
						});
					}
					builder.show();
				}
			});

			// 设置为默认卡号
			if (!"Y".equals(infos.getIsDefault())) {

				tv_card_default.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View arg0) {
						SetCardDefaultTask setCardDefaultTask = new SetCardDefaultTask();
						setCardDefaultTask.execute(new String[] { merId, liqCardId });
					}
				});
			}
			card_items_layout.addView(view);
		}
	}

	// 删除结算卡
	class DeleteMerInfoTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("正在删除此卡...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("liqCardId", params[1]);
				String requestUrl = Constants.server_host + Constants.server_bankCardDel_url;
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
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
			return returnMap;
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(cardManagerActivity);
				builder.setTitle("系统异常！");
				builder.setMessage(respDesc);
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					}
				});
				builder.show();
				return;
			} else {
				card_items_layout.removeView(deleteView);
			}
		}
	}

	// 设置默认卡
	class SetCardDefaultTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("设置中...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("liqCardId", params[1]);
				String requestUrl = Constants.server_host + Constants.server_bankCardDefault_url;
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
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}
			return returnMap;
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			dialog.hide();
			String respCode = resultMap.get("respCode");
			if (Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(cardManagerActivity);
				builder.setTitle("提示");
				builder.setMessage("您确定将该卡设为默认吗？");
				builder.setPositiveButton("否", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					}
				});
				builder.setNegativeButton("是", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						QueryMerInfoTask queryMerInfoTask = new QueryMerInfoTask();
						queryMerInfoTask.execute(new String[] { merId, "J" });
					}
				});
				builder.show();
			}
		}
	}
}
