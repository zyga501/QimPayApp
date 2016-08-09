package cn.qmpos.fragment;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.LoginActivity;
import cn.qmpos.MerListActivity;
import cn.qmpos.WebViewActivity;
import cn.qmpos.WebViewMoreActivity;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class MainT3Fragment extends Fragment implements OnClickListener,
		PlatformActionListener {

	private TextView textMerNum,tv_fenxiangjilu;
	private View viewShare1, viewShare2, viewShare3, viewShare4;
	protected ProgressDialog progressDialog;
	private Activity mainActivity;
	private SharedPreferences mySharedPreferences;
	private String loginId, merName, shareUrl, merId;
	private View view, share_wechat_layout, share_wxfriend_layout;
	private TextView txt_cancel;
	// private String url = "http://dwz.cn/L8uet";
	private Dialog Wxdialog;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View t2Layout = inflater.inflate(R.layout.main_t3_layout, container,
				false);
		init(t2Layout);
		mainActivity = this.getActivity();
		ShareSDK.initSDK(mainActivity);
		return t2Layout;
	}

	private void init(View t1Layout) {
		textMerNum = (TextView) t1Layout
				.findViewById(R.id.main_t2_myNextMerNum);

		mySharedPreferences = getActivity().getSharedPreferences("qmpos",
				Activity.MODE_PRIVATE);
		String merNum = CommUtil.removeDecimal(mySharedPreferences.getString(
				"MER0_avlBal", "0"));
		String sessionId = mySharedPreferences.getString("sessionId", "");
		merName = mySharedPreferences.getString("merName", "");
		loginId = mySharedPreferences.getString("loginId", "");
		merId = mySharedPreferences.getString("merId", "");

		textMerNum.setText(merNum + "��");

		viewShare1 = (View) t1Layout.findViewById(R.id.main_t2_share_1);
		viewShare2 = (View) t1Layout.findViewById(R.id.main_t2_share_2);
		viewShare3 = (View) t1Layout.findViewById(R.id.main_t2_share_3);
		viewShare4 = (View) t1Layout.findViewById(R.id.main_t2_share_4);
		viewShare1.setOnClickListener(this);
		viewShare2.setOnClickListener(this);
		viewShare3.setOnClickListener(this);
		viewShare4.setOnClickListener(this);
		tv_fenxiangjilu = (TextView) t1Layout
				.findViewById(R.id.tv_fenxiangjilu);
		tv_fenxiangjilu.setOnClickListener(this);
		String regUrl = Constants.server_host + Constants.server_doReg_url
				+ "?agentId=" + Constants.server_agent_id + "&mobile="
				+ loginId;
		InitTask initTask = new InitTask();
		initTask.execute(new String[] { merId, sessionId, regUrl });
	}

	public void onClick(View v) {
		try {
			String appName = this.getString(R.string.app_name);
			String shareStr = "����" + merName + "�ķ��� " + appName + "APP ����ע���ַ"
					+ shareUrl;
			Intent i;
			switch (v.getId()) {
			// �����¼
			case R.id.tv_fenxiangjilu:
				i = new Intent(this.getActivity(), MerListActivity.class);
				this.startActivity(i);
				break;
			// qq����
			case R.id.main_t2_share_4:
				initShareIntent(appName, shareStr);
				break;
			// �����ά��
			case R.id.main_t2_share_3:
				i = new Intent(this.getActivity(), WebViewMoreActivity.class);
				String url = Constants.server_host
						+ Constants.server_createtgqrcode_url + "?agentId="
						+ Constants.server_agent_id + "&merId=" + merId
						+ "&loginId=" + loginId;
				i.putExtra("url", url);
				i.putExtra("title", "ɨ������ά��");
				this.getActivity().startActivity(i);
				break;
			// ���ŷ���
			case R.id.main_t2_share_2:
				sendSms(mainActivity, shareStr);
				break;
			// ΢�ţ�����Ȧ������
			case R.id.main_t2_share_1:
				view = LayoutInflater.from(mainActivity).inflate(
						R.layout.share, null);
				share_wechat_layout = (RelativeLayout) view
						.findViewById(R.id.share_wechat_layout);
				share_wxfriend_layout = (RelativeLayout) view
						.findViewById(R.id.share_wxfriend_layout);
				txt_cancel = (TextView) view.findViewById(R.id.txt_cancel);
				share_wechat_layout.setOnClickListener(this);
				share_wxfriend_layout.setOnClickListener(this);
				txt_cancel.setOnClickListener(this);
				Wxdialog = new Dialog(mainActivity,
						R.style.ActionSheetDialogStyle);
				Wxdialog.setContentView(view);
				Window dialogWindow = Wxdialog.getWindow();
				dialogWindow.setGravity(Gravity.LEFT | Gravity.BOTTOM);
				WindowManager.LayoutParams lp = dialogWindow.getAttributes();
				lp.width = LayoutParams.FILL_PARENT;
				lp.x = 0;
				lp.y = 0;
				dialogWindow.setAttributes(lp);
				Wxdialog.show();
				break;
			// ΢�ŷ���
			case R.id.share_wechat_layout:
				Wxdialog.dismiss();
				ShareParams spWechat = new ShareParams();
				spWechat.setShareType(Platform.SHARE_WEBPAGE);
				spWechat.setTitle(appName);
				spWechat.setText(shareStr);
				spWechat.setUrl(shareUrl);
				spWechat.setImageData(BitmapFactory.decodeResource(
						getResources(), R.drawable.ic_launcher1));
				Platform wechat = ShareSDK.getPlatform(Wechat.NAME);
				wechat.setPlatformActionListener(this);
				// ִ��ͼ�ķ���
				wechat.share(spWechat);
				break;
			// ����Ȧ����
			case R.id.share_wxfriend_layout:
				Wxdialog.dismiss();
				ShareParams spWxfriend = new ShareParams();
				spWxfriend.setShareType(Platform.SHARE_WEBPAGE);
				spWxfriend.setTitle(appName);
				// "���� " + merName + "�ķ��� " + appName+ "APP ����ע���ַ" + shareUrl
				spWxfriend.setText(shareStr);
				spWxfriend.setUrl(shareUrl);
				spWxfriend.setImageData(BitmapFactory.decodeResource(
						getResources(), R.drawable.ic_launcher1));
				Platform wxfriend = ShareSDK.getPlatform(WechatMoments.NAME);
				wxfriend.setPlatformActionListener(this);
				// ִ��ͼ�ķ���
				wxfriend.share(spWxfriend);
				break;
			// ȡ��
			case R.id.txt_cancel:
				Wxdialog.dismiss();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void sendSms(Context context, String smsBody) {
		Intent sendIntent = new Intent(Intent.ACTION_SENDTO);
		sendIntent.setData(Uri.parse("smsto:"));
		sendIntent.putExtra("sms_body", smsBody);
		context.startActivity(sendIntent);

	}

	private void initShareIntent(String appName, String shareStr) {
		Intent intent = new Intent(Intent.ACTION_SEND);
		intent.setType("text/plain");
		intent.putExtra(Intent.EXTRA_SUBJECT, "����");
		intent.putExtra(Intent.EXTRA_TEXT, shareStr);
		startActivity(Intent.createChooser(intent, appName));
	}

	class InitTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();

			try {
				String payUrl = params[2];
				payUrl = HttpRequest.getShortConnection(payUrl);
				returnMap.put("payUrl", payUrl);
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}
			// �ʽ��̻����
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("acctType", "MER0");
				map.put("sessionId", params[1]);

				String requestUrl = Constants.server_host
						+ Constants.server_queryMerBal_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�json
				JSONTokener jsonParser = new JSONTokener(responseStr);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();
				String respCode = jsonObj.getString("respCode");
				String respDesc = jsonObj.getString("respDesc");
				returnMap.put("respCode", respCode);
				returnMap.put("respDesc", respDesc);
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;

				returnMap.put("MER0_acctBal", jsonObj.getString("acctBal"));
				returnMap.put("MER0_frzBal", jsonObj.getString("frzBal"));
				returnMap.put("MER0_avlBal", jsonObj.getString("avlBal"));
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;

			}
			return returnMap;
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (Constants.SERVER_NO_LOGIN.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						mainActivity);
				builder.setTitle("��¼");
				builder.setMessage("��¼ʧЧ�������µ�¼!��");
				builder.setPositiveButton("ȷ��",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface progressDialog,
									int which) {
								Intent i = new Intent(mainActivity,
										LoginActivity.class);
								mainActivity.startActivity(i);
							}
						});
				builder.show();
				return;
			} else if (!Constants.SERVER_SUCC.equals(respCode)) {
				// textAcctBal.setText("����ѯʧ��");
				return;
			}

			// ���뱾�ػ���
			mySharedPreferences = mainActivity.getSharedPreferences("qmpos",
					Activity.MODE_PRIVATE);
			SharedPreferences.Editor editor = mySharedPreferences.edit();
			// ����¼����̻���Ϣ����
			editor.putString("MER0_acctBal", resultMap.get("MER0_acctBal"));
			editor.putString("MER0_frzBal", resultMap.get("MER0_frzBal"));
			editor.putString("MER0_avlBal", resultMap.get("MER0_avlBal"));
			editor.commit();

			String merNum = CommUtil.removeDecimal(resultMap
					.get("MER0_acctBal"));
			textMerNum.setText(merNum + "��");

			// ��ö�����
			shareUrl = resultMap.get("payUrl");
		}
	}

	@Override
	public void onCancel(Platform arg0, int arg1) {
		handler.sendEmptyMessage(0);
	}

	@Override
	public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
		handler.sendEmptyMessage(1);
	}

	@Override
	public void onError(Platform arg0, int arg1, Throwable arg2) {
		handler.sendEmptyMessage(2);
	}

	Handler handler = new Handler() {
		public void handleMessage(Message msg) {
			if (msg.what == 0) {
				Toast.makeText(mainActivity, "ȡ������", 1000).show();
			} else if (msg.what == 1) {
				Toast.makeText(mainActivity, "����ɹ�", 1000).show();
			} else {
				Toast.makeText(mainActivity, "�����ֻ�δ��װ΢�ţ��밲װ����", 1000).show();
			}
		};
	};

}
