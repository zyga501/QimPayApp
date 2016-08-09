package cn.qmpos.fragment;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.BalanceActivity;
import cn.qmpos.LoginActivity;
import cn.qmpos.MainActivity;
import cn.qmpos.NFC_Activity;
import cn.qmpos.RebateActivity;
import cn.qmpos.ScoreDetailsAcitivty;
import cn.qmpos.TurnOutMoney1Activity;
import cn.qmpos.WebViewActivity;
import cn.qmpos.WebViewMoreActivity;
import cn.qmpos.ZanShanFuActivity;
import cn.qmpos.R;

import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.view.ImageCycleView;
import cn.qmpos.view.ImageCycleView.ImageCycleViewListener;

@SuppressLint("HandlerLeak")
public class MainT1Fragment extends Fragment implements OnClickListener {

	private MainActivity mainActivity;
	private TextView textPay0Amt, textRateAmt, textJfAmt;
	private View weixint1_layout, weixint0_layout, jifen_layout, zhuanzhang_layout, yiyuanxy_layout, xykhaikuan_layout,
			liuliang_layout, jrchaoshi_layout, shangcheng_layout, nfcsk_layout, zanshangfu_layout, kawugl_layout,
			wsxiaodai_layout, xyktie_layout, xyksq_layout, fenrundk_layout, quanlw_layout;
	private View t1Layout, balance_layout, rebate_layout;
	private SharedPreferences sp;
	protected ProgressDialog dialog;
	File picFile;
	private ImageCycleView mAdView;
	private ArrayList<Integer> mImageUrl = null;
	private ArrayList<String> mImageTitle = null;
	public int stype = 1;
	private String url, merId;
	SharedPreferences mySharedPreferences = null;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		t1Layout = inflater.inflate(R.layout.main_t1_layout, container, false);
		init(t1Layout);
		return t1Layout;
	}

	private void init(View t1Layout) {
		mainActivity = (MainActivity) this.getActivity();
		sp = getActivity().getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String loginId = sp.getString("loginId", "");
		merId = sp.getString("merId", "");
		
		String sessionId = sp.getString("sessionId", "");
		String rateAmt = sp.getString("RATE_avlBal", "0.00");
		String acctBal = sp.getString("PAY0_acctBal", "0.00");

		String jfAmt = CommUtil.removeDecimal(sp.getString("JF00_avlBal", "0.00"));
		textPay0Amt = (TextView) t1Layout.findViewById(R.id.main_t1_pay0_amt);
		textRateAmt = (TextView) t1Layout.findViewById(R.id.main_t1_rate_amt);
		textJfAmt = (TextView) t1Layout.findViewById(R.id.main_t1_jf_amt);
		textPay0Amt.setText(acctBal + "元");
		textRateAmt.setText(rateAmt + "元");
		textJfAmt.setText(jfAmt + "分");
		rebate_layout = t1Layout.findViewById(R.id.rebate_layout);
		rebate_layout.setOnClickListener(this);
		balance_layout = t1Layout.findViewById(R.id.balance_layout);
		balance_layout.setOnClickListener(this);

		weixint1_layout = t1Layout.findViewById(R.id.weixint1_layout);
		weixint0_layout = t1Layout.findViewById(R.id.weixint0_layout);
		jifen_layout = t1Layout.findViewById(R.id.jifen_layout);
		zhuanzhang_layout = t1Layout.findViewById(R.id.zhuanzhang_layout);
		yiyuanxy_layout = t1Layout.findViewById(R.id.yiyuanxy_layout);
		xykhaikuan_layout = t1Layout.findViewById(R.id.xykhaikuan_layout);
		liuliang_layout = t1Layout.findViewById(R.id.liuliang_layout);
		jrchaoshi_layout = t1Layout.findViewById(R.id.jrchaoshi_layout);
		shangcheng_layout = t1Layout.findViewById(R.id.shangcheng_layout);
		nfcsk_layout = t1Layout.findViewById(R.id.nfcsk_layout);
		zanshangfu_layout = t1Layout.findViewById(R.id.zanshangfu_layout);
		kawugl_layout = t1Layout.findViewById(R.id.kawugl_layout);
		wsxiaodai_layout = t1Layout.findViewById(R.id.wsxiaodai_layout);
		xyktie_layout = t1Layout.findViewById(R.id.xyktie_layout);
		xyksq_layout = t1Layout.findViewById(R.id.xyksq_layout);
		fenrundk_layout = t1Layout.findViewById(R.id.fenrundk_layout);
		quanlw_layout = t1Layout.findViewById(R.id.quanlw_layout);

		weixint1_layout.setOnClickListener(this);
		weixint0_layout.setOnClickListener(this);
		jifen_layout.setOnClickListener(this);
		zhuanzhang_layout.setOnClickListener(this);
		yiyuanxy_layout.setOnClickListener(this);
		xykhaikuan_layout.setOnClickListener(this);
		liuliang_layout.setOnClickListener(this);
		jrchaoshi_layout.setOnClickListener(this);
		shangcheng_layout.setOnClickListener(this);
		nfcsk_layout.setOnClickListener(this);
		zanshangfu_layout.setOnClickListener(this);
		kawugl_layout.setOnClickListener(this);
		wsxiaodai_layout.setOnClickListener(this);
		xyktie_layout.setOnClickListener(this);
		xyksq_layout.setOnClickListener(this);
		fenrundk_layout.setOnClickListener(this);
		quanlw_layout.setOnClickListener(this);

		InitTask initTask = new InitTask();
		initTask.execute(new String[] { loginId, merId, sessionId });

		mImageUrl = new ArrayList<Integer>();
		mImageUrl.add(R.drawable.banner1);
		mImageUrl.add(R.drawable.banner2);
		mImageUrl.add(R.drawable.banner3);

		mImageTitle = new ArrayList<String>();
		mImageTitle.add("广州");
		mImageTitle.add("北京");
		mImageTitle.add("深圳");
		mAdView = (ImageCycleView) t1Layout.findViewById(R.id.ad_view);
		mAdView.setImageResources(mImageUrl, mImageTitle, mAdCycleViewListener, stype);
	}

	private ImageCycleViewListener mAdCycleViewListener = new ImageCycleViewListener() {
		@Override
		public void onImageClick(int position, View imageView) {

		}
	};

	public void onClick(View v) {
		try {
			Intent intent;
			switch (v.getId()) {
			// 提现
			case R.id.balance_layout:
				intent = new Intent(mainActivity, BalanceActivity.class);
				startActivity(intent);
				break;
			// 返佣
			case R.id.rebate_layout:
				intent = new Intent(mainActivity, RebateActivity.class);
				startActivity(intent);
				break;
			// 微信T1
			case R.id.weixint1_layout:
			
				intent = new Intent(mainActivity, WebViewMoreActivity.class);
				url = Constants.server_host + Constants.server_doRecvQrCode_url + "?merId=" + merId + "&liqType=T1";
				intent.putExtra("url", url);
				intent.putExtra("title", "微信T1");
				startActivity(intent);
				break;
			// 微信T0
			case R.id.weixint0_layout:
				intent = new Intent(mainActivity, WebViewMoreActivity.class);
				url = Constants.server_host + Constants.server_doRecvQrCode_url + "?merId=" + merId + "&liqType=T0";
				intent.putExtra("url", url);
				intent.putExtra("title", "微信T0");
				startActivity(intent);
				break;
			// 积分
			case R.id.jifen_layout:
				intent = new Intent(mainActivity, ScoreDetailsAcitivty.class);
				startActivity(intent);
				break;
			// 转账
			case R.id.zhuanzhang_layout:
				intent = new Intent(mainActivity, TurnOutMoney1Activity.class);
				startActivity(intent);
				break;
			// 信用卡还款
			case R.id.xykhaikuan_layout:
				intent = new Intent(mainActivity, WebViewActivity.class);
				url = Constants.server_host + Constants.server_extSysLogin_url + "?agentId=" + Constants.server_agent_id
						+ "&merId=" + merId + "&extSysId=" + "0012";
				intent.putExtra("url", url);
				intent.putExtra("title", "信用卡还款");
				startActivity(intent);
				break;
			// 4G流量卡
			case R.id.liuliang_layout:
				intent = new Intent(mainActivity, WebViewActivity.class);
				url = Constants.server_host + Constants.server_extSysLogin_url + "?agentId=" + Constants.server_agent_id
						+ "&merId=" + merId + "&extSysId=" + "0001";
				intent.putExtra("url", url);
				intent.putExtra("title", "4G流量卡");
				startActivity(intent);
				break;
			// 金融超市
			case R.id.jrchaoshi_layout:
				intent = new Intent(mainActivity, WebViewActivity.class);
				url = Constants.server_host + Constants.server_extSysLogin_url + "?agentId=" + Constants.server_agent_id
						+ "&merId=" + merId + "&extSysId=" + "0000";
				intent.putExtra("url", url);
				intent.putExtra("title", "金融超市");
				startActivity(intent);
				break;
			// NFC收款
			case R.id.nfcsk_layout:
				if (mainActivity.getPackageManager().hasSystemFeature(PackageManager.FEATURE_NFC) == false) {
					Toast.makeText(mainActivity, "手机不支持NFC", Toast.LENGTH_SHORT).show();
				} else {
					intent = new Intent(mainActivity, NFC_Activity.class);
					startActivity(intent);
				}
				break;
			// 攒善付收款
			case R.id.zanshangfu_layout:
				intent = new Intent(mainActivity, ZanShanFuActivity.class);
				startActivity(intent);
				break;
			// 圈里圈外
			case R.id.quanlw_layout:
				intent = new Intent(mainActivity, WebViewActivity.class);
				intent.putExtra("url",
						"http://www.qmtpay.net/qlqw/shop/share/index.ajax?memberId=37deae57db3542d4838e85e50722dd08&from=singlemessage&isappinstalled=1");
				intent.putExtra("title", "圈里圈外");
				startActivity(intent);
				break;
			// 网上小贷
			case R.id.wsxiaodai_layout:
				intent = new Intent(mainActivity, WebViewActivity.class);
				url = Constants.server_host + Constants.server_extSysLogin_url + "?agentId=" + Constants.server_agent_id
						+ "&merId=" + merId + "&extSysId=" + "0007";
				intent.putExtra("url", url);
				intent.putExtra("title", "网上小贷");
				startActivity(intent);
				break;
			// 信用卡申请
			case R.id.xyksq_layout:
				intent = new Intent(mainActivity, WebViewMoreActivity.class);
				intent.putExtra("url", "http://m.51credit.com/mp/cc.html");
				intent.putExtra("title", "信用卡申请");
				startActivity(intent);
				break;
			// 一元许愿
			case R.id.yiyuanxy_layout:
				Toast.makeText(mainActivity, "暂未开通", Toast.LENGTH_SHORT).show();
				break;
			// 分润贷款
			case R.id.fenrundk_layout:
				Toast.makeText(mainActivity, "暂未开通", Toast.LENGTH_SHORT).show();
				break;
			// 卡务管理
			case R.id.kawugl_layout:
				Toast.makeText(mainActivity, "暂未开通", Toast.LENGTH_SHORT).show();
				break;
			// 信用卡提额
			case R.id.xyktie_layout:
				Toast.makeText(mainActivity, "暂未开通", Toast.LENGTH_SHORT).show();
				break;
			// 商城
			case R.id.shangcheng_layout:
				Toast.makeText(mainActivity, "暂未开通", Toast.LENGTH_SHORT).show();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 调用商户基本信息查询
	class InitTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
		}

		protected HashMap<String, String> doInBackground(String... params) {

			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("loginId", params[0]);
				map.put("merId", params[1]);
				map.put("sessionId", params[2]);

				String requestUrl = Constants.server_host + Constants.server_queryMerInfo_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("certId", jsonObj.getString("certId"));
				returnMap.put("chnlId", jsonObj.getString("chnlId"));
				returnMap.put("chnlName", jsonObj.getString("chnlName"));
				returnMap.put("feeRateT0", jsonObj.getString("feeRateT0"));
				returnMap.put("feeRateT1", jsonObj.getString("feeRateT1"));

				returnMap.put("debitFeeRateT0", jsonObj.getString("debitFeeRateT0"));
				returnMap.put("debitFeeRateT1", jsonObj.getString("debitFeeRateT1"));
				returnMap.put("feeRateLiq1", jsonObj.getString("feeRateLiq1"));
				returnMap.put("feeRateLiq2", jsonObj.getString("feeRateLiq2"));
				returnMap.put("feeRateLiq3", jsonObj.getString("feeRateLiq3"));
				returnMap.put("totAmtT1", jsonObj.getString("totAmtT1"));
				returnMap.put("openDate", jsonObj.getString("openDate"));
				returnMap.put("isAuthentication", jsonObj.getString("isAuthentication"));
				returnMap.put("t0Stat", jsonObj.getString("t0Stat"));
				returnMap.put("t1Stat", jsonObj.getString("t1Stat"));
				returnMap.put("liqStat", jsonObj.getString("liqStat"));
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 资金商户余额
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[1]);
				map.put("acctType", "PAY0");
				map.put("sessionId", params[2]);

				String requestUrl = Constants.server_host + Constants.server_queryMerBal_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("PAY0_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("PAY0_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("PAY0_avlBal", jsonObj.getString("avlBal"));

			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 返佣商户余额
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[1]);
				map.put("acctType", "RATE");
				map.put("sessionId", params[2]);

				String requestUrl = Constants.server_host + Constants.server_queryMerBal_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("RATE_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("RATE_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("RATE_avlBal", jsonObj.getString("avlBal"));

			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 积分商户余额
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[1]);
				map.put("acctType", "JF00");
				map.put("sessionId", params[2]);

				String requestUrl = Constants.server_host + Constants.server_queryMerBal_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("JF00_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("JF00_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("JF00_avlBal", jsonObj.getString("avlBal"));

			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			return returnMap;

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			if (Constants.SERVER_NO_LOGIN.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity);
				builder.setTitle("登录");
				builder.setMessage("登录失效，请重新登录!！");
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(mainActivity, LoginActivity.class);
						mainActivity.startActivity(intent);
					}
				});
				builder.show();
				return;
			} else if (!Constants.SERVER_SUCC.equals(respCode)) {
				return;
			}

			// 放入本地缓存
			SharedPreferences mySharedPreferences = mainActivity.getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
			SharedPreferences.Editor editor = mySharedPreferences.edit();
			// 将登录后的商户信息保存
			editor.putString("certId", resultMap.get("certId"));
			editor.putString("chnlId", resultMap.get("chnlId"));
			editor.putString("chnlName", resultMap.get("chnlName"));
			editor.putString("feeRateT0", resultMap.get("feeRateT0"));
			editor.putString("feeRateT1", resultMap.get("feeRateT1"));

			editor.putString("debitFeeRateT0", resultMap.get("debitFeeRateT0"));
			editor.putString("debitFeeRateT1", resultMap.get("debitFeeRateT1"));
			editor.putString("feeRateLiq1", resultMap.get("feeRateLiq1"));
			editor.putString("feeRateLiq2", resultMap.get("feeRateLiq2"));
			editor.putString("feeRateLiq3", resultMap.get("feeRateLiq3"));
			editor.putString("totAmtT1", resultMap.get("totAmtT1"));
			editor.putString("openDate", resultMap.get("openDate"));
			editor.putString("isAuthentication", resultMap.get("isAuthentication"));
			editor.putString("t0Stat", resultMap.get("t0Stat"));
			editor.putString("t1Stat", resultMap.get("t1Stat"));
			editor.putString("liqStat", resultMap.get("liqStat"));
			editor.putString("PAY0_acctBal", resultMap.get("PAY0_acctBal"));
			editor.putString("PAY0_frzBal", resultMap.get("PAY0_frzBal"));
			editor.putString("PAY0_avlBal", resultMap.get("PAY0_avlBal"));
			editor.putString("RATE_acctBal", resultMap.get("RATE_acctBal"));
			editor.putString("RATE_frzBal", resultMap.get("RATE_frzBal"));
			editor.putString("RATE_avlBal", resultMap.get("RATE_avlBal"));
			editor.putString("JF00_acctBal", resultMap.get("JF00_acctBal"));
			editor.putString("JF00_frzBal", resultMap.get("JF00_frzBal"));
			editor.putString("JF00_avlBal", resultMap.get("JF00_avlBal"));
			editor.commit();

			String pay0Amt = resultMap.get("PAY0_acctBal");
			String rateAmt = resultMap.get("RATE_acctBal");
			// String jfAmt = CommUtil
			// .removeDecimal(resultMap.get("JF00_acctBal"));
			textPay0Amt.setText(pay0Amt + "元");
			textRateAmt.setText(rateAmt + "元");
			// textJfAmt.setText(jfAmt + "分");
		}
	}
}