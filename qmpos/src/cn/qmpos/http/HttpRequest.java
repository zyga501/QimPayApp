package cn.qmpos.http;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.params.HttpClientParams;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import cn.qmpos.util.Constants;

public class HttpRequest {

	public static DefaultHttpClient httpClient = null;

	// 普通
	public static String getResponse(String url,
			HashMap<String, String> requestMap) {
		loginModeSet();
		try {
			System.out.println("请求地址:" + url);
			String host = url; //
			HttpPost httpPost = new HttpPost(host);

			List<NameValuePair> formParams = new ArrayList<NameValuePair>();
			for (Map.Entry<String, String> entry : requestMap.entrySet()) {
				System.out.println(entry.getKey() + ":" + entry.getValue());
				formParams.add(new BasicNameValuePair(entry.getKey(),
						URLEncoder.encode(entry.getValue())));
			}
			httpPost.setEntity(new UrlEncodedFormEntity(formParams, HTTP.UTF_8));
			httpPost.addHeader("Cookie", Constants.cookie);
			HttpResponse response = httpClient.execute(httpPost);
			// 如果有sessionId，需将此session带入
			HttpEntity entity = response.getEntity();
			int statusCode = response.getStatusLine().getStatusCode();
			if (statusCode != 200) {
				System.out.println("请求主机错误，返回码:" + statusCode);
				return Constants.ERROR;
			}

			String htmlCon = EntityUtils.toString(entity, "GB2312");
			System.out.println("返回内容1:" + htmlCon);
			return htmlCon;
		} catch (Exception e) {
			e.printStackTrace();
			httpClient = null;
			Log.i("httpReq", Constants.server_host);
			return e.getMessage();

		}
	}

	// 上传图片文件
	public static String getResponse(String url,
			HashMap<String, String> requestMap, HashMap<String, File> attachMap) {

		loginModeSet();

		try {
			System.out.println("请求地址:" + url);
			String host = url; //
			HttpPost httpPost = new HttpPost(host);
			MultipartEntity multEntity = new MultipartEntity(
					HttpMultipartMode.BROWSER_COMPATIBLE, null,
					Charset.forName("UTF-8"));
			for (Map.Entry<String, String> entry : requestMap.entrySet()) {
				System.out.println(entry.getKey() + ":" + entry.getValue());
				multEntity.addPart(entry.getKey(),
						new StringBody(URLEncoder.encode(entry.getValue())));
			}
			for (Map.Entry<String, File> entry : attachMap.entrySet()) {
				multEntity.addPart(entry.getKey(),
						new FileBody(entry.getValue()));
			}
			httpPost.setEntity(multEntity);
			// httpPost.addRequestHeader("Cookie",cookiesStr);
			HttpResponse response = httpClient.execute(httpPost);
			// 如果有sessionId，需将此session带入
			HttpEntity entity = response.getEntity();
			int statusCode = response.getStatusLine().getStatusCode();
			if (statusCode != 200) {
				System.out.println("请求主机错误，返回码:" + statusCode);
				return Constants.ERROR;
			}

			String htmlCon = EntityUtils.toString(entity, "GB2312");
			System.out.println("返回内容2:" + htmlCon);
			return htmlCon;
		} catch (Exception e) {
			e.printStackTrace();
			httpClient = null;
			return e.getMessage();
		}
	}

	private static void loginModeSet() {
		if (httpClient != null) {
			return;
		}
		// 创建 HttpParams 以用来设置 HTTP 参数（这一部分不是必需的）
		HttpParams httpParams = new BasicHttpParams();
		// 设置连接超时和 Socket 超时，以及 Socket 缓存大小
		HttpConnectionParams.setConnectionTimeout(httpParams, 20 * 1000);
		HttpConnectionParams.setSoTimeout(httpParams, 20 * 1000);
		HttpConnectionParams.setSocketBufferSize(httpParams, 8192);
		// 设置重定向，缺省为 true
		HttpClientParams.setRedirecting(httpParams, true);
		// 设置 user agent
		String userAgent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2) Gecko/20100115 Firefox/3.6";
		HttpProtocolParams.setUserAgent(httpParams, userAgent);
		// 创建一个 HttpClient 实例
		// 注意 HttpClient httpClient = new HttpClient(); 是Commons HttpClient
		// 中的用法，在 Android 1.5 中我们需要使用 Apache 的缺省实现 DefaultHttpClient
		httpClient = new DefaultHttpClient(httpParams);

	}

	// 长地址转成短地址
	public static String getShortConnection(String srcUrl) throws JSONException {
		try {
			String url = "http://dwz.cn/create.php";
			HashMap<String, String> requestMap = new HashMap<String, String>();
			requestMap.put("url", srcUrl);
			String resultUrl = getResponseNor(url, requestMap);
			if (resultUrl == Constants.ERROR) {
				return srcUrl;
			} else {
				JSONObject jo = new JSONObject(resultUrl);
				String str = "";
				if (jo.get("tinyurl") != null || "".equals(jo.get("tinyurl"))) {
					str = (String) jo.get("tinyurl");
				} else {
					str = srcUrl;
				}
				return str;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return srcUrl;
	}

	// http异步请求
	public static String getResponseNor(String url,
			HashMap<String, String> requestMap) {
		try {
			HttpClient hc = new DefaultHttpClient();
			Log.e("请求地址:", url);
			String host = url;
			HttpPost httpPost = new HttpPost(host);
			List<NameValuePair> formParams = new ArrayList<NameValuePair>();
			for (Map.Entry<String, String> entry : requestMap.entrySet()) {
				formParams.add(new BasicNameValuePair(entry.getKey(), entry
						.getValue()));
			}
			httpPost.setEntity(new UrlEncodedFormEntity(formParams, HTTP.UTF_8));

			HttpResponse response = hc.execute(httpPost);
			HttpEntity entity = response.getEntity();
			int statusCode = response.getStatusLine().getStatusCode();
			Log.e("请求主机返回码:", statusCode + "");
			if (statusCode != 200) {
				return Constants.ERROR;
			}
			String htmlCon = EntityUtils.toString(entity, HTTP.UTF_8);
			System.out.println("返回内容3:" + htmlCon);
			return htmlCon;
		} catch (Exception e) {
			e.printStackTrace();
			Log.i("httpReq", Constants.server_host);
			return Constants.ERROR;
		}
	}

}
