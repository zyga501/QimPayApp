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
	private final int PIC_FROM��LOCALPHOTO = 0;
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
		// ����ü����ͼƬ�ļ�
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
			// ͷ��
			case R.id.user_head:
				mTransationLayout.setVisibility(View.VISIBLE);
				popWindow.showAtLocation(mTransationLayout, Gravity.BOTTOM, 0,
						0);
				break;
			// �������ȡ
			case R.id.usericon_pw_photograph:
				mUserIconPhoteGraph.setEnabled(false);
				doHandlerPhoto(PIC_FROM_CAMERA);
				break;
			// �������ȥ��ȡ
			case R.id.usericon_pw_photo:
				mUserIconPhote.setEnabled(false);
				doHandlerPhoto(PIC_FROM��LOCALPHOTO);
				break;
			// ȡ��
			case R.id.usericon_pw_exit:
				mTransationLayout.setVisibility(View.GONE);
				popWindow.dismiss();
				break;
			case R.id.transtantbg_layout:
				mTransationLayout.setVisibility(View.GONE);
				popWindow.dismiss();
				break;
			// ��ϵ����
			case R.id.main_t4_about:
				i = new Intent(mainActivity, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/contact"
						+ Constants.server_agent_id + ".html");
				i.putExtra("title", "��ϵ����");
				mainActivity.startActivity(i);
				break;
			// �ƹ��¼
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
				i.putExtra("title", "�����ֲ�");
				mainActivity.startActivity(i);
				break;
			case R.id.main_t4_agreement:
				i = new Intent(mainActivity, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/agree"
						+ Constants.server_agent_id + ".html");
				i.putExtra("title", "�û�Э��");
				mainActivity.startActivity(i);
				break;
			// �˻�����
			case R.id.main_t3_acct_info:
				i = new Intent(mainActivity, AcctInfoActivity.class);
				mainActivity.startActivity(i);
				break;
			// ������Ϣ
			case R.id.feilv_layout:
				i = new Intent(mainActivity, RateInformationActivity.class);
				mainActivity.startActivity(i);
				break;
			// �������
			case R.id.main_t3_pwd_mng:
				i = new Intent(mainActivity, PwdMngActivity.class);
				mainActivity.startActivity(i);
				break;
			// �����ֻ���
			case R.id.main_update_phone:
				i = new Intent(mainActivity, UpdatePhoneActivity.class);
				mainActivity.startActivity(i);
				break;
			// ���㿨����
			case R.id.main_zhanghu15_list:
				i = new Intent(mainActivity, CardManagerActivity.class);
				mainActivity.startActivity(i);
				break;
			// ���տ����п�
			case R.id.main_t3_authentication:
				i = new Intent(mainActivity, AuthenticationActivity.class);
				mainActivity.startActivity(i);
				break;
			// �˳�
			case R.id.main_t3_exit:
				BaseActivity baseActivity = new BaseActivity();
				baseActivity.propmptExit(mainActivity);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// �汾�����
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
				// ���ͷ��ص�JSON
				JSONTokener jsonParser = new JSONTokener(result);
				JSONObject jsonObj = (JSONObject) jsonParser.nextValue();

				String respCode = jsonObj.getString("respCode");
				String versionId = jsonObj.getString("versionId");
				String appUrl = jsonObj.getString("appUrl");

				// �жϷ���״̬
				if (Constants.SERVER_SUCC.equals(respCode)) {
					// �жϵ�ǰ�İ汾��������ϵ����汾�Ƿ�һ��
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
						Toast.makeText(mainActivity, "���Ѿ������°汾�ˣ�",
								Toast.LENGTH_LONG).show();
						return;
					}

					// ������ʾ,�Ƿ�ǿ�Ƹ���
					APPURL = appUrl;
					AlertDialog.Builder builder = new AlertDialog.Builder(
							mainActivity);
					builder.setTitle("�汾����");
					builder.setMessage("�������µİ汾����ȷ���Ƿ���£�");
					builder.setPositiveButton("����",
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int which) {
									Intent intent = new Intent(
											Intent.ACTION_VIEW, Uri
													.parse(APPURL));
									startActivity(intent);
								}
							});
					builder.setNegativeButton("�ݲ�����", null);
					builder.show();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * ���ݲ�ͬ��ʽѡ��ͼƬ����ImageView
	 * 
	 * @param type
	 *            0-�������ѡ�񣬷�0Ϊ����
	 */
	private void doHandlerPhoto(int type) {
		try {
			if (type == PIC_FROM��LOCALPHOTO) {
				Intent intent = getCropImageIntent();
				startActivityForResult(intent, PIC_FROM��LOCALPHOTO);
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
	 * ����ͼƬ��������
	 */
	public Intent getCropImageIntent() {
		Intent intent = new Intent(Intent.ACTION_GET_CONTENT, null);
		intent.setType("image/*");
		setIntentParams(intent);
		return intent;
	}

	/**
	 * �����ü�
	 */
	private void cropImageUriByTakePhoto() {
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(photoUri, "image/*");
		setIntentParams(intent);
		startActivityForResult(intent, PIC_FROM��LOCALPHOTO);
	}

	/**
	 * ���ù��ò���
	 */
	private void setIntentParams(Intent intent) {
		intent.putExtra("crop", "true");
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);
		intent.putExtra("outputX", 300);
		intent.putExtra("outputY", 300);
		intent.putExtra("noFaceDetection", true); // no face detection
		intent.putExtra("scale", true);
		intent.putExtra("scaleUpIfNeeded", true);// ȥ�ڱ�
		intent.putExtra("return-data", false);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri);
		intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
	}

	/**
	 * 
	 * ͼƬѹ��������
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
	 * ����ͼƬ������ֵ
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
	 * ����·�����ͻ�Ʋ�ѹ������bitmap������ʾ
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
				Toast.makeText(mainActivity, "�����쳣", Toast.LENGTH_LONG).show();

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
		case PIC_FROM_CAMERA: // ����
			try {
				mUserIconPhoteGraph.setEnabled(true);
				if (resultCode == Activity.RESULT_OK) {
					cropImageUriByTakePhoto();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case PIC_FROM��LOCALPHOTO:
			try {
				mUserIconPhote.setEnabled(true);
				if (photoUri != null && data != null) {
					mTransationLayout.setVisibility(View.GONE);
					popWindow.dismiss();
					decodeUriAsBitmap(photoUri);
				} else {
					Toast.makeText(mainActivity, "ȡ������", Toast.LENGTH_LONG)
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

	// �ϴ�ͷ��
	class UploadFaceImgTask extends
			AsyncTask<String, Integer, HashMap<String, String>> {
		protected HashMap<String, String> doInBackground(String... params) {
			HashMap<String, String> returnMap = new HashMap<String, String>();
			// �ϴ�ͷ��
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
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�JSON
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
				returnMap.put("respDesc", "ϵͳ�쳣");
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
				Toast.makeText(mainActivity, "�ϴ�ͷ��ɹ�", Toast.LENGTH_SHORT)
						.show();
			} else {
				Toast.makeText(mainActivity, "�ϴ�ͷ��ʧ��", Toast.LENGTH_SHORT)
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
			// �����̻�������Ϣ��ѯ
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("loginId", params[0]);
				map.put("merId", params[1]);

				String requestUrl = Constants.server_host
						+ Constants.server_queryMerInfo_url;
				String responseStr = HttpRequest.getResponse(requestUrl, map);
				if (Constants.ERROR.equals(responseStr)) {
					returnMap.put("respCode", Constants.SERVER_NETERR);
					returnMap.put("respDesc", "�����쳣");
					return returnMap;
				}

				// ���ͷ��ص�JSON
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
				returnMap.put("respDesc", "ϵͳ�쳣");
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
	 * ��ȡͷ��
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
	 * ��Bitmap���浽SD����
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
			System.out.println("�ڱ���ͼƬʱ����" + e.toString());
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
