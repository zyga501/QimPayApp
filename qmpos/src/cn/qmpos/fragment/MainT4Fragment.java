package cn.qmpos.fragment;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.AcctInfoActivity;
import cn.qmpos.AuthenticationActivity;
import cn.qmpos.BaseActivity;
import cn.qmpos.CardManagerActivity;
import cn.qmpos.MainActivity;
import cn.qmpos.MerListActivity;
import cn.qmpos.PwdMngActivity;
import cn.qmpos.R;

import cn.qmpos.RateInformationActivity;
import cn.qmpos.UpdatePhoneActivity;
import cn.qmpos.WebViewActivity;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.view.ImageLoader;

public class MainT4Fragment extends Fragment implements View.OnClickListener {

	private MainActivity mainActivity;
	private View acctInfo, pwdMng, main_zhanghu15_list, authentication, exit,
			main_tuiguangjili, main_update_phone, mTransationLayout, popView,
			feilv_layout;
	private static String APPURL;
	private TextView textMerName, textLoginId;
	private ImageView mUserImg;
	private Button mUserIconPhoteGraph, mUserIconPhote, mUserIconExit;
	private SharedPreferences sp;
	private Bitmap miniBitmap = null;
	private PopupWindow popWindow;
	private Uri photoUri;
	protected ProgressDialog dialog;
	private final int PIC_FROM_CAMERA = 1;
	private final int PIC_FROM＿LOCALPHOTO = 0;
	File picFile;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View t4Layout = inflater.inflate(R.layout.main_t4_layout, container,
				false);
		init(t4Layout);
		initPw();
		sp = getActivity().getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String login_phone = sp.getString("loginId", "");
		String merId = sp.getString("merId", "");
		InitMerInfoTask initMerInfoTask = new InitMerInfoTask();
		initMerInfoTask.execute(new String[] { login_phone, merId });
		return t4Layout;
	}

	private void init(View t4Layout) {
		mainActivity = (MainActivity) this.getActivity();
		View textAbout = t4Layout.findViewById(R.id.main_t4_about);
		View textVersion = t4Layout.findViewById(R.id.main_t4_version);
		View textUseManual = t4Layout.findViewById(R.id.main_t4_use_manual);
		View textAgreement = t4Layout.findViewById(R.id.main_t4_agreement);
		textAbout.setOnClickListener(this);
		textVersion.setOnClickListener(this);
		textUseManual.setOnClickListener(this);
		textAgreement.setOnClickListener(this);

		try {
			PackageInfo pkg = mainActivity.getPackageManager().getPackageInfo(
					mainActivity.getApplication().getPackageName(), 0);
			String nowVersionId = pkg.versionName;
			TextView editVersionId = (TextView) t4Layout
					.findViewById(R.id.main_t4_version_id);
			editVersionId.setText("v" + nowVersionId);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mainActivity = (MainActivity) this.getActivity();
		acctInfo = t4Layout.findViewById(R.id.main_t3_acct_info);
		pwdMng = t4Layout.findViewById(R.id.main_t3_pwd_mng);
		main_zhanghu15_list = t4Layout.findViewById(R.id.main_zhanghu15_list);
		authentication = t4Layout.findViewById(R.id.main_t3_authentication);
		exit = t4Layout.findViewById(R.id.main_t3_exit);

		main_tuiguangjili = t4Layout.findViewById(R.id.main_tuiguangjili);
		main_tuiguangjili.setOnClickListener(this);
		main_update_phone = t4Layout.findViewById(R.id.main_update_phone);
		main_update_phone.setOnClickListener(this);
		acctInfo.setOnClickListener(this);
		pwdMng.setOnClickListener(this);
		main_zhanghu15_list.setOnClickListener(this);
		authentication.setOnClickListener(this);
		exit.setOnClickListener(this);
		feilv_layout = t4Layout.findViewById(R.id.feilv_layout);
		feilv_layout.setOnClickListener(this);
		sp = getActivity().getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String authStat = sp.getString("isAuthentication", "");
		String loginId = sp.getString("loginId", "");
		String merName = sp.getString("merName", "");
		textMerName = (TextView) t4Layout.findViewById(R.id.main_t3_mer_name);
		textLoginId = (TextView) t4Layout.findViewById(R.id.main_t3_login_id);
		textMerName.setText(merName);
		textLoginId.setText(loginId);
		if ("S".equals(authStat)) {
			authentication.setVisibility(View.GONE);
		}
		if (!"S".equals(authStat)) {
			main_zhanghu15_list.setVisibility(View.GONE);
		}

		mUserImg = (ImageView) t4Layout.findViewById(R.id.user_head);
		mUserImg.setOnClickListener(this);
		mTransationLayout = t4Layout.findViewById(R.id.transtantbg_layout);
		mTransationLayout.setOnClickListener(this);
		String merId = sp.getString("merId", "");
		// 保存裁剪后的图片文件
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
		photoUri = Uri.fromFile(picFile);
		File file = new File(Environment.getExternalStorageDirectory(),
				"/uploadTemp/" + merId + ".jpg");
		if (!file.exists()) {
			mUserImg.setImageResource(R.drawable.touxiang);
		} else {
			mUserImg.setImageURI(Uri.fromFile(file));
		}
	}

	@SuppressWarnings("deprecation")
	private void initPw() {
		popView = mainActivity.getLayoutInflater().inflate(
				R.layout.upload_usericon_dialog, null);
		mUserIconPhoteGraph = (Button) popView
				.findViewById(R.id.usericon_pw_photograph);
		mUserIconPhoteGraph.setOnClickListener(this);
		mUserIconPhote = (Button) popView.findViewById(R.id.usericon_pw_photo);
		mUserIconPhote.setOnClickListener(this);
		mUserIconExit = (Button) popView.findViewById(R.id.usericon_pw_exit);
		mUserIconExit.setOnClickListener(this);
		popWindow = new PopupWindow(popView, LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT, false);
		popWindow.setAnimationStyle(R.style.usericonPopupAnimation);

	}

	@SuppressWarnings("static-access")
	public void onClick(View v) {
		try {
			Intent i;
			switch (v.getId()) {
			// 头像
			case R.id.user_head:
				mTransationLayout.setVisibility(View.VISIBLE);
				popWindow.showAtLocation(mTransationLayout, Gravity.BOTTOM, 0,
						0);
				break;
			// 照相机获取
			case R.id.usericon_pw_photograph:
				mUserIconPhoteGraph.setEnabled(false);
				doHandlerPhoto(PIC_FROM_CAMERA);
				break;
			// 从相册中去获取
			case R.id.usericon_pw_photo:
				mUserIconPhote.setEnabled(false);
				doHandlerPhoto(PIC_FROM＿LOCALPHOTO);
				break;
			// 取消
			case R.id.usericon_pw_exit:
				mTransationLayout.setVisibility(View.GONE);
				popWindow.dismiss();
				break;
			case R.id.transtantbg_layout:
				mTransationLayout.setVisibility(View.GONE);
				popWindow.dismiss();
				break;
			// 联系我们
			case R.id.main_t4_about:
				i = new Intent(mainActivity, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/contact"
						+ Constants.server_agent_id + ".html");
				i.putExtra("title", "联系我们");
				mainActivity.startActivity(i);
				break;
			// 推广记录
			case R.id.main_tuiguangjili:
				i = new Intent(this.getActivity(), MerListActivity.class);
				this.startActivity(i);
				break;
			case R.id.main_t4_version:
				VersionTask versionTask = new VersionTask();
				versionTask.execute();
				break;
			case R.id.main_t4_use_manual:
				i = new Intent(mainActivity, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/manual"
						+ Constants.server_agent_id + ".html");
				i.putExtra("title", "操作手册");
				mainActivity.startActivity(i);
				break;
			case R.id.main_t4_agreement:
				i = new Intent(mainActivity, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/agree"
						+ Constants.server_agent_id + ".html");
				i.putExtra("title", "用户协议");
				mainActivity.startActivity(i);
				break;
			// 账户详情
			case R.id.main_t3_acct_info:
				i = new Intent(mainActivity, AcctInfoActivity.class);
				mainActivity.startActivity(i);
				break;
			// 费率信息
			case R.id.feilv_layout:
				i = new Intent(mainActivity, RateInformationActivity.class);
				mainActivity.startActivity(i);
				break;
			// 密码管理
			case R.id.main_t3_pwd_mng:
				i = new Intent(mainActivity, PwdMngActivity.class);
				mainActivity.startActivity(i);
				break;
			// 更改手机号
			case R.id.main_update_phone:
				i = new Intent(mainActivity, UpdatePhoneActivity.class);
				mainActivity.startActivity(i);
				break;
			// 结算卡管理
			case R.id.main_zhanghu15_list:
				i = new Intent(mainActivity, CardManagerActivity.class);
				mainActivity.startActivity(i);
				break;
			// 绑定收款银行卡
			case R.id.main_t3_authentication:
				i = new Intent(mainActivity, AuthenticationActivity.class);
				mainActivity.startActivity(i);
				break;
			// 退出
			case R.id.main_t3_exit:
				BaseActivity baseActivity = new BaseActivity();
				baseActivity.propmptExit(mainActivity);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 版本检查类
	class VersionTask extends AsyncTask<String, Integer, String> {

		protected void onPreExecute() {
		}

		protected String doInBackground(String... params) {
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("agentId", Constants.server_agent_id);
				map.put("appType", "android");
				String requestUrl = Constants.server_host
						+ Constants.server_version_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				System.out.println("http:" + responseStr);
				return responseStr;
			} catch (Exception e) {
				e.printStackTrace();
				return Constants.ERROR;
			}
		}

		protected void onPostExecute(String result) {
			try {
				if (Constants.ERROR.equals(result)) {
					return;
				}
				// 解释返回的JSON
				JSONTokener jsonParser = new JSONTokener(result);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();

				String respCode = jsonObj.getString("respCode");
				String versionId = jsonObj.getString("versionId");
				String appUrl = jsonObj.getString("appUrl");

				// 判断返回状态
				if (Constants.SERVER_SUCC.equals(respCode)) {
					// 判断当前的版本与服务器上的最瓣版本是否一致
					PackageInfo pkg = mainActivity.getPackageManager()
							.getPackageInfo(
									mainActivity.getApplication()
											.getPackageName(), 0);
					String appName = pkg.applicationInfo.loadLabel(
							mainActivity.getPackageManager()).toString();
					String nowVersionId = pkg.versionName;
					System.out.println("appName:" + appName);
					System.out.println("versionName:" + nowVersionId);
					if (nowVersionId.equals(versionId)) {
						Toast.makeText(mainActivity, "您已经是最新版本了！",
								Toast.LENGTH_LONG).show();
						return;
					}

					// 弹框提示,是否强制更新
					APPURL = appUrl;
					AlertDialog.Builder builder = new AlertDialog.Builder(
							mainActivity);
					builder.setTitle("版本更新");
					builder.setMessage("存在最新的版本程序，确认是否更新！");
					builder.setPositiveButton("更新",
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int which) {
									Intent intent = new Intent(
											Intent.ACTION_VIEW, Uri
													.parse(APPURL));
									startActivity(intent);
								}
							});
					builder.setNegativeButton("暂不更新", null);
					builder.show();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 根据不同方式选择图片设置ImageView
	 * 
	 * @param type
	 *            0-本地相册选择，非0为拍照
	 */
	private void doHandlerPhoto(int type) {
		try {
			if (type == PIC_FROM＿LOCALPHOTO) {
				Intent intent = getCropImageIntent();
				startActivityForResult(intent, PIC_FROM＿LOCALPHOTO);
			} else {
				Intent cameraIntent = new Intent(
						MediaStore.ACTION_IMAGE_CAPTURE);
				cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri);
				startActivityForResult(cameraIntent, PIC_FROM_CAMERA);
			}

		} catch (Exception e) {
		}
	}

	/**
	 * 调用图片剪辑程序
	 */
	public Intent getCropImageIntent() {
		Intent intent = new Intent(Intent.ACTION_GET_CONTENT, null);
		intent.setType("image/*");
		setIntentParams(intent);
		return intent;
	}

	/**
	 * 启动裁剪
	 */
	private void cropImageUriByTakePhoto() {
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(photoUri, "image/*");
		setIntentParams(intent);
		startActivityForResult(intent, PIC_FROM＿LOCALPHOTO);
	}

	/**
	 * 设置公用参数
	 */
	private void setIntentParams(Intent intent) {
		intent.putExtra("crop", "true");
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);
		intent.putExtra("outputX", 300);
		intent.putExtra("outputY", 300);
		intent.putExtra("noFaceDetection", true); // no face detection
		intent.putExtra("scale", true);
		intent.putExtra("scaleUpIfNeeded", true);// 去黑边
		intent.putExtra("return-data", false);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri);
		intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
	}

	/**
	 * 
	 * 图片压缩方法二
	 * 
	 * @param mCurrentPhotoPath
	 */
	private void CompressionPhoto(String mCurrentPhotoPath) {
		if (mCurrentPhotoPath != null) {
			try {
				miniBitmap = getSmallBitmap(mCurrentPhotoPath);
				String merId = sp.getString("merId", "");
				FileOutputStream fos = new FileOutputStream(new File(
						Environment.getExternalStorageDirectory(), "/upload/"
								+ merId + ".jpg"));
				miniBitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);

			} catch (Exception e) {
			}

		} else {
		}
	}

	/**
	 * 计算图片的缩放值
	 * 
	 * @param options
	 * @param reqWidth
	 * @param reqHeight
	 * @return
	 */
	public static int calculateInSampleSize(BitmapFactory.Options options,
			int reqWidth, int reqHeight) {
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;
		if (height > reqHeight || width > reqWidth) {
			final int heightRatio = Math.round((float) height
					/ (float) reqHeight);
			final int widthRatio = Math.round((float) width / (float) reqWidth);
			inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
		}
		return inSampleSize;
	}

	/**
	 * 根据路径获得突破并压缩返回bitmap用于显示
	 * 
	 * @param imagesrc
	 * @return
	 */
	public static Bitmap getSmallBitmap(String filePath) {
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(filePath, options);
		options.inSampleSize = calculateInSampleSize(options, 480, 800);
		options.inJustDecodeBounds = false;

		return BitmapFactory.decodeFile(filePath, options);
	}

	private void decodeUriAsBitmap(Uri uri) {
		FileOutputStream fos = null;
		try {
			if (CommUtil.checkNetState(mainActivity)) {
				String merId = sp.getString("merId", "");
				CompressionPhoto(Environment.getExternalStorageDirectory()
						+ "/upload/" + merId + ".jpg");
				uploadIcon();
			} else {
				Toast.makeText(mainActivity, "网络异常", Toast.LENGTH_LONG).show();

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (fos != null) {
					fos.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		switch (requestCode) {
		case PIC_FROM_CAMERA: // 拍照
			try {
				mUserIconPhoteGraph.setEnabled(true);
				if (resultCode == Activity.RESULT_OK) {
					cropImageUriByTakePhoto();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case PIC_FROM＿LOCALPHOTO:
			try {
				mUserIconPhote.setEnabled(true);
				if (photoUri != null && data != null) {
					mTransationLayout.setVisibility(View.GONE);
					popWindow.dismiss();
					decodeUriAsBitmap(photoUri);
				} else {
					Toast.makeText(mainActivity, "取消设置", Toast.LENGTH_LONG)
							.show();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		}
	}

	private void uploadIcon() {
		sp = getActivity().getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String merId = sp.getString("merId", "");
		UploadFaceImgTask uploadFaceImgTask = new UploadFaceImgTask();
		uploadFaceImgTask.execute(new String[] { merId });
	}

	// 上传头像
	class UploadFaceImgTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {
		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			// 上传头像
			try {
				HashMap<String, String> stringMap = new HashMap<String, String>();
				stringMap.put("merId", params[0]);
				HashMap<String, File> picMap = new HashMap<String, File>();
				picMap.put("attachPath", picFile);

				String requestUrl = Constants.server_host
						+ Constants.server_uploadFaceImg_url;
				String responseStr = HttpRequest.getResponse(requestUrl,
						stringMap, picMap);
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
				if (!respCode.equals(Constants.SERVER_SUCC)) {
					return returnMap;
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
			String respCode = resultMap.get("respCode");
			if (Constants.SERVER_SUCC.equals(respCode)) {
				if (miniBitmap != null) {
					saveMyBitmap(miniBitmap);
					mUserImg.setImageBitmap(miniBitmap);
				}
				ImageLoader.getInstence(mainActivity).clearCache();
				Toast.makeText(mainActivity, "上传头像成功", Toast.LENGTH_SHORT)
						.show();
			} else {
				Toast.makeText(mainActivity, "上传头像失败", Toast.LENGTH_SHORT)
						.show();
			}
		}

	}

	class InitMerInfoTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
		}

		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			// 调用商户基本信息查询
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("loginId", params[0]);
				map.put("merId", params[1]);

				String requestUrl = Constants.server_host
						+ Constants.server_queryMerInfo_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC)) {
					return returnMap;

				}
				miniBitmap = loadImageFromUrl(jsonObj.getString("faceImgUrl"));
				saveMyBitmap(miniBitmap);
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
			if (Constants.SERVER_SUCC.equals(respCode)) {
				try {
					String merId = sp.getString("merId", "");
					File file = new File(
							Environment.getExternalStorageDirectory(),
							"/uploadTemp/" + merId + ".jpg");
					if (!file.exists()) {
						mUserImg.setImageResource(R.drawable.touxiang);
					} else {
						mUserImg.setImageURI(Uri.fromFile(file));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * 获取头像
	 * 
	 * @param url
	 * @return Bitmap
	 * @throws Exception
	 */
	public Bitmap loadImageFromUrl(String url) throws Exception {
		final DefaultHttpClient client = new DefaultHttpClient();
		final HttpGet getRequest = new HttpGet(url);

		HttpResponse response = client.execute(getRequest);
		int statusCode = response.getStatusLine().getStatusCode();
		if (statusCode != HttpStatus.SC_OK) {
			Log.e("PicShow", "Request URL failed, error code =" + statusCode);
		}
		HttpEntity entity = response.getEntity();
		if (entity == null) {
			Log.e("PicShow", "HttpEntity is null");
		}
		InputStream is = null;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			is = entity.getContent();
			byte[] buf = new byte[1024];
			int readBytes = -1;
			while ((readBytes = is.read(buf)) != -1) {
				baos.write(buf, 0, readBytes);
			}
		} finally {
			if (baos != null) {
				baos.close();
			}
			if (is != null) {
				is.close();
			}
		}
		byte[] imageArray = baos.toByteArray();
		return BitmapFactory.decodeByteArray(imageArray, 0, imageArray.length);
	}

	/**
	 * 把Bitmap保存到SD卡中
	 * 
	 * @param mBitmap
	 */
	public void saveMyBitmap(Bitmap mBitmap) {
		String merId = sp.getString("merId", "");
		File pictureFileDir = new File(
				Environment.getExternalStorageDirectory(), "/uploadTemp");
		if (!pictureFileDir.exists()) {
			pictureFileDir.mkdirs();
		}
		File file = new File(pictureFileDir, merId + ".jpg");
		try {
			file.createNewFile();
		} catch (IOException e) {
			System.out.println("在保存图片时出错：" + e.toString());
		}
		FileOutputStream fOut = null;
		try {
			fOut = new FileOutputStream(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		mBitmap.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
		try {
			fOut.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
		try {
			fOut.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
