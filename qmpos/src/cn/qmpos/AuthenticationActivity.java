package cn.qmpos;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import cn.qmpos.R;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;

/**
 * ���տ����п�
 * 
 * @author Administrator
 * 
 */
public class AuthenticationActivity extends BaseActivity implements OnClickListener {

	private Button btnBack;
	private Button btnNext;

	private TextView textBankName, photo_template;
	private EditText textCardName;
	private EditText editCardNo;

	// ���֤����
	private View cardPositive;
	private File cardPositiveFile;
	private TextView cardPositiveView;
	private ImageView cardPositiveImage;

	// ���֤����
	private View cardReverse;
	private File cardReverseFile;
	private TextView cardReverseView;
	private ImageView cardReverseImage;

	// ���˳ֿ�
	private View manCard;
	private File manCardFile;
	private TextView manCardView;
	private ImageView manCardImage;
	private Bitmap miniBitmap = null;
	// // ���п�����
	// private View bankPositive;
	// private File bankPositiveFile;
	// private TextView bankPositiveView;
	// private ImageView bankPositiveImage;
	//
	// // ���п�����
	// private View bankReverse;
	// private File bankReverseFile;
	// private TextView bankReverseView;
	// private ImageView bankReverseImage;
	//
	// // ���˳ֿ�
	// private View manBank;
	// private File manBankFile;
	// private TextView manBankView;
	// private ImageView manBankImage;

	private EditText editCertNo;
	private AuthenticationActivity authenticationActivity;

	private String bankCode;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_authentication);
		allActivity.add(this);
		init();
	}

	private void init() {
		authenticationActivity = this;
		btnBack = (Button) this.findViewById(R.id.auth_btn_back);
		btnNext = (Button) this.findViewById(R.id.auth_btn_next);
		btnBack.setOnClickListener(this);
		btnNext.setOnClickListener(this);
		photo_template = (TextView) this.findViewById(R.id.photo_template);
		photo_template.setOnClickListener(this);
		cardPositive = (View) this.findViewById(R.id.auth_cardPositive);
		cardReverse = (View) this.findViewById(R.id.auth_cardReverse);
		manCard = (View) this.findViewById(R.id.auth_manCard);
		// bankPositive = (View) this.findViewById(R.id.auth_bankPositive);
		// bankReverse = (View) this.findViewById(R.id.auth_bankReverse);
		// manBank = (View) this.findViewById(R.id.auth_manBank);
		cardPositive.setOnClickListener(this);
		cardReverse.setOnClickListener(this);
		manCard.setOnClickListener(this);
		// bankPositive.setOnClickListener(this);
		// bankReverse.setOnClickListener(this);
		// manBank.setOnClickListener(this);
		editCertNo = (EditText) this.findViewById(R.id.reg2_edit_cert_no);
		textBankName = (TextView) this.findViewById(R.id.auth_text_bank_name);
		textBankName.setOnClickListener(this);

		textCardName = (EditText) this.findViewById(R.id.auth_text_card_name);
		textCardName.setOnClickListener(this);
		editCardNo = (EditText) this.findViewById(R.id.auth_edit_card_no);

		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String merId = mySharedPreferences.getString("merId", "");
		String merName = mySharedPreferences.getString("merName", "");
		String certId = mySharedPreferences.getString("certId", "");
		String loginId = mySharedPreferences.getString("loginId", "");
		String sessionId = mySharedPreferences.getString("sessionId", "");
		textCardName.setText(merName);
		editCertNo.setText(certId);
		// ֤��·��
		String photoPath = Environment.getExternalStorageDirectory().getAbsolutePath() + "/DCIM/Camera/";
		String photoName = CommUtil.getDate() + CommUtil.getTime();
		File tempFile = new File(photoPath);
		if (!tempFile.exists())
			tempFile.mkdirs();

		cardPositiveFile = new File(photoPath + photoName + "_cardPositive.jpg");
		cardPositiveView = (TextView) this.findViewById(R.id.auth_cardPositiveView);
		cardPositiveImage = (ImageView) this.findViewById(R.id.auth_cardPositiveImage);

		cardReverseFile = new File(photoPath + photoName + "_cardReverse.jpg");
		cardReverseView = (TextView) this.findViewById(R.id.auth_cardReverseView);
		cardReverseImage = (ImageView) this.findViewById(R.id.auth_cardReverseImage);

		manCardFile = new File(photoPath + photoName + "_manCard.jpg");
		manCardView = (TextView) this.findViewById(R.id.auth_manCardView);
		manCardImage = (ImageView) this.findViewById(R.id.auth_manCardImage);

		// manCardFile = new File(photoPath + photoName + "_manCard.jpg");
		// manCardView = (TextView) this.findViewById(R.id.auth_manCardView);
		// manCardImage = (ImageView) this.findViewById(R.id.auth_manCardImage);
		// bankPositiveFile = new File(photoPath + photoName +
		// "_bankPositive.jpg");
		// bankPositiveView = (TextView) this
		// .findViewById(R.id.auth_bankPositiveView);
		// bankPositiveImage = (ImageView) this
		// .findViewById(R.id.auth_bankPositiveImage);
		//
		// bankReverseFile = new File(photoPath + photoName +
		// "_bankReverse.jpg");
		// bankReverseView = (TextView) this
		// .findViewById(R.id.auth_bankReverseView);
		// bankReverseImage = (ImageView) this
		// .findViewById(R.id.auth_bankReverseImage);
		//
		// manBankFile = new File(photoPath + photoName + "_manBank.jpg");
		// manBankView = (TextView) this.findViewById(R.id.auth_manBankView);
		// manBankImage = (ImageView) this.findViewById(R.id.auth_manBankImage);

		// ��ʼ�����жϵ�ǰ״̬
		InitTask initTask = new InitTask();
		initTask.execute(new String[] { merId, merName, certId, loginId, sessionId });
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.auth_btn_back:
				finish();
				break;
			case R.id.auth_btn_next:
				toAuth();
				break;
			case R.id.auth_cardPositive:
				camera(v.getId());
				break;
			case R.id.auth_cardReverse:
				camera(v.getId());
				break;
			case R.id.auth_manCard:
				camera(v.getId());
				break;
			case R.id.auth_bankPositive:
				camera(v.getId());
				break;
			case R.id.auth_bankReverse:
				camera(v.getId());
				break;
			case R.id.auth_manBank:
				camera(v.getId());
				break;
			case R.id.auth_text_bank_name:
				showBankDialog();
				break;
			case R.id.photo_template:
				Intent i = new Intent(this, WebViewActivity.class);
				i.putExtra("url", "file:///android_asset/phototemplate" + Constants.server_agent_id + ".html");
				i.putExtra("title", "��֤ʾ��");
				startActivity(i);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void showBankDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("��ѡ������");
		builder.setItems(R.array.bank_name, new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				String bankName = authenticationActivity.getResources().getStringArray(R.array.bank_name)[which];
				bankCode = authenticationActivity.getResources().getStringArray(R.array.bank_code)[which];
				textBankName.setText(bankName);
			}
		});
		builder.setNegativeButton("ȡ��", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {

			}
		});
		builder.show();
	}

	private void toAuth() {

		System.out.println("hellllllllllllllllll");
		// ��֤�������
		String cardName = textCardName.getText().toString();
		String cardNo = editCardNo.getText().toString();
		String certNo = editCertNo.getText().toString();

		if (cardNo == null || "".equals(cardNo)) {
			Toast.makeText(this, "����д���㿨�ţ�", Toast.LENGTH_SHORT).show();
			return;
		}

		if ((certNo == null) || "".equals(certNo)) {
			Toast.makeText(this, "���������֤�ţ�", Toast.LENGTH_SHORT).show();
			return;
		}

		if (!CommUtil.isNumber(cardNo)) {
			Toast.makeText(this, "���㿨�Ÿ�ʽ����ȷ��", Toast.LENGTH_SHORT).show();
			return;
		}

		if (bankCode == null || "".equals(bankCode)) {
			Toast.makeText(this, "��ѡ��������У�", Toast.LENGTH_SHORT).show();
			return;
		}

		if (cardPositiveFile == null || !cardPositiveFile.exists()) {
			Toast.makeText(this, "���������֤�����п����棡", Toast.LENGTH_SHORT).show();
			return;
		}

		if (cardReverseFile == null || !cardReverseFile.exists()) {
			Toast.makeText(this, "���������֤�����п����棡", Toast.LENGTH_SHORT).show();
			return;
		}

		// if (manCardFile == null || !manCardFile.exists()) {
		// Toast.makeText(this, "�������ֳ����֤�����п����棡", Toast.LENGTH_SHORT).show();
		// return;
		// }
		//
		// if (bankPositiveFile == null || !bankPositiveFile.exists()) {
		// Toast.makeText(this, "���������п������գ�", Toast.LENGTH_SHORT).show();
		// return;
		// }
		//
		// if (bankReverseFile == null || !bankReverseFile.exists()) {
		// Toast.makeText(this, "���������п������գ�", Toast.LENGTH_SHORT).show();
		// return;
		// }
		//
		// if (manBankFile == null || !manBankFile.exists()) {
		// Toast.makeText(this, "�����㱾�˳ֿ��գ�", Toast.LENGTH_SHORT).show();
		// return;
		// }
		if (certNo.length() != 18 && certNo.length() != 15) {
			Toast.makeText(this, "������18λ��15λ��ȷ�����֤��", Toast.LENGTH_SHORT).show();
			return;
		}

		SharedPreferences mySharedPreferences = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
		String merId = mySharedPreferences.getString("merId", "");
		AuthTask authTask = new AuthTask();
		authTask.execute(new String[] { merId, bankCode, cardNo, cardName, certNo, "J" });

	}

	private void camera(int id) throws IOException {

		Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
		Uri mPhotoOnSDCardUri = null;
		if (id == R.id.auth_cardPositive) {
			mPhotoOnSDCardUri = Uri.fromFile(cardPositiveFile);
		} else if (id == R.id.auth_cardReverse) {
			mPhotoOnSDCardUri = Uri.fromFile(cardReverseFile);
		} else if (id == R.id.auth_manCard) {
			mPhotoOnSDCardUri = Uri.fromFile(manCardFile);
		}
		// else if (id == R.id.auth_bankPositive) {
		// mPhotoOnSDCardUri = Uri.fromFile(bankPositiveFile);
		// } else if (id == R.id.auth_bankReverse) {
		// mPhotoOnSDCardUri = Uri.fromFile(bankReverseFile);
		// } else if (id == R.id.auth_manBank) {
		// mPhotoOnSDCardUri = Uri.fromFile(manBankFile);
		// }
		intent.putExtra(MediaStore.EXTRA_OUTPUT, mPhotoOnSDCardUri);

		// ���պ����޸�����ʾ��ͼƬ
		startActivityForResult(intent, id);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == R.id.auth_cardPositive) {
			// cardPositiveImage.setImageURI(Uri.fromFile(cardPositiveFile));
			save(cardPositiveFile.getAbsolutePath(), cardPositiveFile);
			System.out.println(cardPositiveFile.getAbsolutePath() + "---------------------");
			cardPositiveImage
					.setImageBitmap(decodeSampledBitmapFromResource(cardPositiveFile.getAbsolutePath(), 180, 180));
			cardPositiveImage.setVisibility(View.VISIBLE);
			cardPositiveView.setVisibility(View.GONE);
		} else if (requestCode == R.id.auth_cardReverse) {
			save(cardReverseFile.getAbsolutePath(), cardReverseFile);
			System.out.println(cardReverseFile.getAbsolutePath() + "---------------------");
			// cardReverseImage.setImageURI(Uri.fromFile(cardReverseFile));
			cardReverseImage
					.setImageBitmap(decodeSampledBitmapFromResource(cardReverseFile.getAbsolutePath(), 180, 180));
			cardReverseImage.setVisibility(View.VISIBLE);
			cardReverseView.setVisibility(View.GONE);
		} else if (requestCode == R.id.auth_manCard) {
			// manCardImage.setImageURI(Uri.fromFile(manCardFile));
			save(manCardFile.getAbsolutePath(), manCardFile);
			System.out.println(manCardFile.getAbsolutePath() + "---------------------");
			manCardImage.setImageBitmap(decodeSampledBitmapFromResource(manCardFile.getAbsolutePath(), 180, 180));
			manCardImage.setVisibility(View.VISIBLE);
			manCardView.setVisibility(View.GONE);
		}
		// else if (requestCode == R.id.auth_bankPositive) {
		// // bankPositiveImage.setImageURI(Uri.fromFile(bankPositiveFile));
		// bankPositiveImage.setImageBitmap(decodeSampledBitmapFromResource(
		// bankPositiveFile.getAbsolutePath(), 180, 180));
		// bankPositiveImage.setVisibility(View.VISIBLE);
		// bankPositiveView.setVisibility(View.GONE);
		// } else if (requestCode == R.id.auth_bankReverse) {
		// // bankReverseImage.setImageURI(Uri.fromFile(bankReverseFile));
		// bankReverseImage.setImageBitmap(decodeSampledBitmapFromResource(
		// bankReverseFile.getAbsolutePath(), 180, 180));
		// bankReverseImage.setVisibility(View.VISIBLE);
		// bankReverseView.setVisibility(View.GONE);
		// } else if (requestCode == R.id.auth_manBank) {
		// // manBankImage.setImageURI(Uri.fromFile(manBankFile));
		// manBankImage.setImageBitmap(decodeSampledBitmapFromResource(
		// manBankFile.getAbsolutePath(), 180, 180));
		// manBankImage.setVisibility(View.VISIBLE);
		// manBankView.setVisibility(View.GONE);
		// }
	}

	public static Bitmap decodeSampledBitmapFromResource(String pathName, int reqWidth, int reqHeight) {
		// ��һ�ν�����inJustDecodeBounds����Ϊtrue������ȡͼƬ��С
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(pathName, options);
		// �������涨��ķ�������inSampleSizeֵ
		options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
		// ʹ�û�ȡ����inSampleSizeֵ�ٴν���ͼƬ
		options.inJustDecodeBounds = false;
		return BitmapFactory.decodeFile(pathName, options);
	}

	public static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
		// ԴͼƬ�ĸ߶ȺͿ��
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;
		if (height > reqHeight || width > reqWidth) {
			// �����ʵ�ʿ�ߺ�Ŀ���ߵı���
			final int heightRatio = Math.round((float) height / (float) reqHeight);
			final int widthRatio = Math.round((float) width / (float) reqWidth);

			// ѡ���͸�����С�ı�����ΪinSampleSize��ֵ���������Ա�֤����ͼƬ�Ŀ�͸�
			// һ��������ڵ���Ŀ��Ŀ�͸ߡ�
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

	/**
	 * 
	 * ͼƬѹ��������
	 * 
	 * @param mCurrentPhotoPath
	 */
	private void save(String mCurrentPhotoPath, File minFile) {
		if (mCurrentPhotoPath != null) {
			try {
				miniBitmap = getSmallBitmap(mCurrentPhotoPath);
				FileOutputStream fos = new FileOutputStream(minFile);
				miniBitmap.compress(Bitmap.CompressFormat.JPEG, 95, fos);

			} catch (Exception e) {
			}

		} else {
		}
	}

	class InitTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();

				// �̻�������Ϣ��ѯ
				map.put("merId", params[0]);
				map.put("merName", params[1]);
				map.put("certId", params[2]);
				map.put("loginId", params[3]);
				map.put("sessionId", params[4]);
				map.put("clientModel", android.os.Build.MODEL);

				String requestUrl = Constants.server_host + Constants.server_queryMerInfo_url;
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
				if (respCode.equals(Constants.SERVER_SUCC)) {
					returnMap.put("isAuthentication", jsonObj.getString("isAuthentication"));
				}
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(authenticationActivity);
				builder.setTitle("ϵͳ�쳣");
				builder.setMessage(respDesc);
				builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent i = new Intent(authenticationActivity, LoginActivity.class);
						authenticationActivity.startActivity(i);
					}
				});
				builder.show();
				return;
			}

			try {
				String isAuthentication = resultMap.get("isAuthentication");

				if ("S".equals(isAuthentication)) {
					AlertDialog.Builder builder = new AlertDialog.Builder(authenticationActivity);
					builder.setTitle("��ʾ");
					builder.setMessage("���Ѿ�Ϊʵ��״̬��");
					builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							finish();
						}
					});
					builder.show();
					return;
				}

				if ("IT".indexOf(isAuthentication) != -1) {
					AlertDialog.Builder builder = new AlertDialog.Builder(authenticationActivity);
					builder.setTitle("��ʾ");
					builder.setMessage("����ʵ�������������У�");
					builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							finish();
						}
					});
					builder.show();
					return;
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	class AuthTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ͼƬ�ϴ��軨�Ѽ�����ʱ�䣬���Ժ�...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();

			// �ϴ���Ƭ
			for (int i = 0; i < 3; i++) {
				try {
					HashMap<String, String> stringMap = new HashMap<String, String>();
					HashMap<String, File> fileMap = new HashMap<String, File>();
					stringMap.put("merId", params[0]);

					if (i == 0) {
						stringMap.put("attachName", "���֤+���п������棩.jpg");
						fileMap.put("attachPath", cardPositiveFile);
					} else if (i == 1) {
						stringMap.put("attachName", "���֤+���п������棩.jpg");
						fileMap.put("attachPath", cardReverseFile);
					} else if (i == 2) {
						stringMap.put("attachName", "�ֳ����֤+���п������棩.jpg");
						fileMap.put("attachPath", manCardFile);
					}
					// else if (i == 3) {
					// stringMap.put("attachName", "���п�����.jpg");
					// fileMap.put("attachPath", bankPositiveFile);
					// } else if (i == 4) {
					// stringMap.put("attachName", "���п�����.jpg");
					// fileMap.put("attachPath", bankReverseFile);
					// } else if (i == 5) {
					// stringMap.put("attachName", "���˳ֿ�.jpg");
					// fileMap.put("attachPath", manBankFile);
					// }
					String requestUrl = Constants.server_host + Constants.server_uploadAttach_url;
					String responseStr = HttpRequest.getResponse(requestUrl, stringMap, fileMap);
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
				} catch (Exception e) {
					e.printStackTrace();
					returnMap.put("respCode", Constants.SERVER_SYSERR);
					returnMap.put("respDesc", "ϵͳ�쳣");
					return returnMap;
				}
			}

			// �󶨽��㿨
			try {

				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("openBankId", params[1]);
				map.put("openAcctId", params[2]);
				map.put("openAcctName", params[3]);
				map.put("cardType", params[5]);
				String requestUrl = Constants.server_host + Constants.server_bankCardBind_url;
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
				if (!respCode.equals(Constants.SERVER_SUCC))
					return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}

			// ���տ����п�
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("merName", params[3]);
				map.put("certId", params[4]);

				String requestUrl = Constants.server_host + Constants.server_applyAuthentication_url;
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
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "ϵͳ�쳣");
				return returnMap;
			}
		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				dialog.hide();
				Toast.makeText(authenticationActivity, respDesc, Toast.LENGTH_SHORT).show();
				return;
			}

			AlertDialog.Builder builder = new AlertDialog.Builder(authenticationActivity);
			builder.setTitle("��ʾ");
			builder.setMessage("���ύ���տ����п���");
			builder.setPositiveButton("ȷ��", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					finish();
				}
			});
			builder.show();
			return;
		}
	}

}
