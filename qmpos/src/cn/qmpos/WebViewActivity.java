package cn.qmpos;

import java.util.List;

import org.apache.http.cookie.Cookie;

import android.content.Intent;
import android.net.http.SslError;
import android.os.Bundle;
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
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.Constants;
import cn.qmpos.R;


public class WebViewActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;
	private WebView webView;
	private TextView webTitle;
	private String url, title;
	private ImageView img_fenxiang;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		allActivity.add(this);
		setContentView(R.layout.activity_web);
		// getWindow().requestFeature(Window.FEATURE_PROGRESS);
		init();
		// �����WEB��¼
		if (url.indexOf("extSysLogin") != -1) {
			initCookie(url);
		}
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
		img_fenxiang.setVisibility(View.GONE);
		webTitle = (TextView) this.findViewById(R.id.web_title);
		webView = (WebView) this.findViewById(R.id.web_view);

		Intent intent = getIntent();
		url = intent.getStringExtra("url");
		title = intent.getStringExtra("title");
		if (title == null || "".equals(title))
			title = "�տ�";

		webTitle.setText(title);
		loadView(url);
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

}
