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
		// 仅针对WEB登录
		if (url.indexOf("extSysLogin") != -1) {
			initCookie(url);
		}
		webView.setWebViewClient(new WebViewClient() {
			public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
				// handler.cancel(); // Android默认的处理方式
				handler.proceed(); // 接受所有网站的证书
				// handleMessage(Message msg); // 进行其他处理
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
			webView.goBack(); // goBack()表示返回WebView的上一页面
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
			title = "收款";

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
		// 支持缩放

		settings.setBuiltInZoomControls(true);
		// 启用内置缩放装置

		settings.setJavaScriptEnabled(true);
		// 启用JS脚本

		// webView.setWebViewClient(new WebViewClient() {
		// // 当点击链接时,希望覆盖而不是打开新窗口@Override
		// public boolean shouldOverrideUrlLoading(WebView view, String url) {
		// view.loadUrl(url);
		// // 加载新的url
		// return true;
		// // 返回true,代表事件已处理,事件流到此终止
		// }
		// });

		webView.loadUrl(urlStr);
	}

}
