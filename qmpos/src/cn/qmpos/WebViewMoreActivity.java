package cn.qmpos;

import java.util.HashMap;
import java.util.List;

import org.apache.http.cookie.Cookie;

import android.content.Intent;
import android.graphics.BitmapFactory;
import android.net.http.SslError;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.SslErrorHandler;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.R;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.wechat.friends.Wechat;

public class WebViewMoreActivity extends BaseActivity implements OnClickListener, PlatformActionListener {

	private Button btnBack;
	private WebView webView;
	private TextView webTitle;
	private String url, title, back;
	private ImageView img_fenxiang;
	private WebViewMoreActivity webViewActivity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_web);
		init();
		initCookie(url);
		webViewActivity = this;
		ShareSDK.initSDK(webViewActivity);
		// getWindow().requestFeature(Window.FEATURE_PROGRESS);
		webView.setWebViewClient(new WebViewClient() {
			public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
				// handler.cancel(); // AndroidĬ�ϵĴ���ʽ
				handler.proceed(); // ����������վ��֤��
				// handleMessage(Message msg); // ������������
			}
		});
		webView.getSettings().setJavaScriptEnabled(true);
		webView.getSettings().setDefaultTextEncodingName("gb2312");
		webView.getSettings().setSaveFormData(true);
		webView.getSettings().setDomStorageEnabled(true);
		webView.loadUrl(url);

	}

	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK) && webView.canGoBack()) {
			webView.goBack(); // goBack()��ʾ����WebView����һҳ��
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	private void initCookie(String url) {
		List<Cookie> cookies = HttpRequest.httpClient.getCookieStore().getCookies();
		Cookie cookie = null;
		if (!cookies.isEmpty()) {
			for (int i = cookies.size(); i > 0; i--) {
				Cookie sessionCookie = (Cookie) cookies.get(i - 1);
				System.out.print(sessionCookie.getName() + ":" + sessionCookie.getValue());
				if ("JSESSIONID".equals(sessionCookie.getName())) {
					cookie = sessionCookie;
				}
			}
		}
		CookieSyncManager.createInstance(this);
		CookieManager cookieManager = CookieManager.getInstance();
		if (cookie != null) {
			String cookieString = cookie.getName() + "=" + cookie.getValue() + "; domain=" + cookie.getDomain();
			cookieManager.setCookie(Constants.server_host, cookieString);
			CookieSyncManager.getInstance().sync();
		}
	}

	private void init() {
		btnBack = (Button) this.findViewById(R.id.btn_back);
		btnBack.setOnClickListener(this);
		img_fenxiang = (ImageView) this.findViewById(R.id.img_fenxiang);
		img_fenxiang.setOnClickListener(this);
		webTitle = (TextView) this.findViewById(R.id.web_title);
		webView = (WebView) this.findViewById(R.id.web_view);

		Intent intent = getIntent();
		url = intent.getStringExtra("url");
		title = intent.getStringExtra("title");
		if (title == null || "".equals(title))
			title = "�տ�";

		webTitle.setText(title);
		loadView(url);

		Intent intents = getIntent();
		title = intents.getStringExtra("title");
		back = intents.getStringExtra("back");

		// title = intent.getStringExtra("web_title");
		// if (title.equals(webTitle)) {
		// img_fenxiang.setVisibility(View.GONE);
		// }
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.img_fenxiang:
				showToast("΢�Ż�����...");
				ShareParams spWechat = new ShareParams();
				spWechat.setShareType(Platform.SHARE_WEBPAGE);
				spWechat.setTitle(this.getString(R.string.app_name));
				spWechat.setText(url);
				spWechat.setUrl(url);
				spWechat.setImageData(BitmapFactory.decodeResource(getResources(), R.drawable.ic_launcher1));
				Platform wechat = ShareSDK.getPlatform(Wechat.NAME);
				wechat.setPlatformActionListener(this);
				// ִ��ͼ�ķ���
				wechat.share(spWechat);
				break;
			case R.id.btn_back:
				finish();
				if (!back.equals(title)) {
					Intent i = new Intent(this, MainActivity.class);
					startActivity(i);
				}
				break;

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void loadView(String urlStr) {

		WebSettings settings = webView.getSettings();

		settings.setSupportZoom(true);
		// ֧������

		settings.setBuiltInZoomControls(true);
		// ������������װ��

		settings.setJavaScriptEnabled(true);
		// ����JS�ű�

		// webView.setWebViewClient(new WebViewClient() {
		// // ���������ʱ,ϣ�����Ƕ����Ǵ��´���@Override
		// public boolean shouldOverrideUrlLoading(WebView view, String url) {
		// view.loadUrl(url);
		// // �����µ�url
		// return true;
		// // ����true,�����¼��Ѵ���,�¼���������ֹ
		// }
		// });

		webView.loadUrl(urlStr);
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
				Toast.makeText(webViewActivity, "ȡ������", 1000).show();
			} else if (msg.what == 1) {
				Toast.makeText(webViewActivity, "����ɹ�", 1000).show();
			} else {
				Toast.makeText(webViewActivity, "�����ֻ�δ��װ΢�ţ��밲װ����", 1000).show();
			}
		};
	};
}
