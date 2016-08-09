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
 * 绑定收款银行卡
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

	// 身份证正面
	private View cardPositive;
	private File cardPositiveFile;
	private TextView cardPositiveView;
	private ImageView cardPositiveImage;

	// 身份证反面
	private View cardReverse;
	private File cardReverseFile;
	private TextView cardReverseView;
	private ImageView cardReverseImage;

	// 体人持卡
	private View manCard;
	private File manCardFile;
	private TextView manCardView;
	private ImageView manCardImage;
	private Bitmap miniBitmap = null;
	// // 银行卡正面
	// private View bankPositive;
	// private File bankPositiveFile;
	// private TextView bankPositiveView;
	// private ImageView bankPositiveImage;
	//
	// // 银行卡反面
	// private View bankReverse;
	// private File bankReverseFile;
	// private TextView bankReverseView;
	// private ImageView bankReverseImage;
	//
	// // 本人持卡
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
		// 证件路径
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

		// 初始化，判断当前状态
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
				i.putExtra("title", "认证示例");
				startActivity(i);
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void showBankDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("请选择银行");
		builder.setItems(R.array.bank_name, new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				String bankName = authenticationActivity.getResources().getStringArray(R.array.bank_name)[which];
				bankCode = authenticationActivity.getResources().getStringArray(R.array.bank_code)[which];
				textBankName.setText(bankName);
			}
		});
		builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {

			}
		});
		builder.show();
	}

	private void toAuth() {

		System.out.println("hellllllllllllllllll");
		// 验证输入参数
		String cardName = textCardName.getText().toString();
		String cardNo = editCardNo.getText().toString();
		String certNo = editCertNo.getText().toString();

		if (cardNo == null || "".equals(cardNo)) {
			Toast.makeText(this, "请填写结算卡号！", Toast.LENGTH_SHORT).show();
			return;
		}

		if ((certNo == null) || "".equals(certNo)) {
			Toast.makeText(this, "请输入身份证号！", Toast.LENGTH_SHORT).show();
			return;
		}

		if (!CommUtil.isNumber(cardNo)) {
			Toast.makeText(this, "结算卡号格式不正确！", Toast.LENGTH_SHORT).show();
			return;
		}

		if (bankCode == null || "".equals(bankCode)) {
			Toast.makeText(this, "请选择结算银行！", Toast.LENGTH_SHORT).show();
			return;
		}

		if (cardPositiveFile == null || !cardPositiveFile.exists()) {
			Toast.makeText(this, "请拍摄身份证和银行卡正面！", Toast.LENGTH_SHORT).show();
			return;
		}

		if (cardReverseFile == null || !cardReverseFile.exists()) {
			Toast.makeText(this, "请拍摄身份证和银行卡反面！", Toast.LENGTH_SHORT).show();
			return;
		}

		// if (manCardFile == null || !manCardFile.exists()) {
		// Toast.makeText(this, "请拍摄手持身份证和银行卡正面！", Toast.LENGTH_SHORT).show();
		// return;
		// }
		//
		// if (bankPositiveFile == null || !bankPositiveFile.exists()) {
		// Toast.makeText(this, "请拍摄银行卡正面照！", Toast.LENGTH_SHORT).show();
		// return;
		// }
		//
		// if (bankReverseFile == null || !bankReverseFile.exists()) {
		// Toast.makeText(this, "请拍摄银行卡反面照！", Toast.LENGTH_SHORT).show();
		// return;
		// }
		//
		// if (manBankFile == null || !manBankFile.exists()) {
		// Toast.makeText(this, "请拍摄本人持卡照！", Toast.LENGTH_SHORT).show();
		// return;
		// }
		if (certNo.length() != 18 && certNo.length() != 15) {
			Toast.makeText(this, "请输入18位或15位正确的身份证号", Toast.LENGTH_SHORT).show();
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

		// 拍照后先修改再显示此图片
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
		// 第一次解析将inJustDecodeBounds设置为true，来获取图片大小
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(pathName, options);
		// 调用上面定义的方法计算inSampleSize值
		options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
		// 使用获取到的inSampleSize值再次解析图片
		options.inJustDecodeBounds = false;
		return BitmapFactory.decodeFile(pathName, options);
	}

	public static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
		// 源图片的高度和宽度
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;
		if (height > reqHeight || width > reqWidth) {
			// 计算出实际宽高和目标宽高的比率
			final int heightRatio = Math.round((float) height / (float) reqHeight);
			final int widthRatio = Math.round((float) width / (float) reqWidth);

			// 选择宽和高中最小的比率作为inSampleSize的值，这样可以保证最终图片的宽和高
			// 一定都会大于等于目标的宽和高。
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

	/**
	 * 
	 * 图片压缩方法二
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
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();

				// 商户基本信息查询
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
					returnMap.put("isAuthentication", jsonObj.getString("isAuthentication"));
				}
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				AlertDialog.Builder builder = new AlertDialog.Builder(authenticationActivity);
				builder.setTitle("系统异常");
				builder.setMessage(respDesc);
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
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
					builder.setTitle("提示");
					builder.setMessage("您已经为实名状态！");
					builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							finish();
						}
					});
					builder.show();
					return;
				}

				if ("IT".indexOf(isAuthentication) != -1) {
					AlertDialog.Builder builder = new AlertDialog.Builder(authenticationActivity);
					builder.setTitle("提示");
					builder.setMessage("您的实名审核正在审核中！");
					builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
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
			dialog.setMessage("图片上传需花费几分钟时间，请稍后...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();

			// 上传照片
			for (int i = 0; i < 3; i++) {
				try {
					HashMap<String, String> stringMap = new HashMap<String, String>();
					HashMap<String, File> fileMap = new HashMap<String, File>();
					stringMap.put("merId", params[0]);

					if (i == 0) {
						stringMap.put("attachName", "身份证+银行卡（正面）.jpg");
						fileMap.put("attachPath", cardPositiveFile);
					} else if (i == 1) {
						stringMap.put("attachName", "身份证+银行卡（反面）.jpg");
						fileMap.put("attachPath", cardReverseFile);
					} else if (i == 2) {
						stringMap.put("attachName", "手持身份证+银行卡（正面）.jpg");
						fileMap.put("attachPath", manCardFile);
					}
					// else if (i == 3) {
					// stringMap.put("attachName", "银行卡正面.jpg");
					// fileMap.put("attachPath", bankPositiveFile);
					// } else if (i == 4) {
					// stringMap.put("attachName", "银行卡反面.jpg");
					// fileMap.put("attachPath", bankReverseFile);
					// } else if (i == 5) {
					// stringMap.put("attachName", "本人持卡.jpg");
					// fileMap.put("attachPath", manBankFile);
					// }
					String requestUrl = Constants.server_host + Constants.server_uploadAttach_url;
					String responseStr = HttpRequest.getResponse(requestUrl, stringMap, fileMap);
					if (Constants.ERROR.equals(responseStr)) {
						returnMap.put("respCode", Constants.SERVER_NETERR);
						returnMap.put("respDesc", "网络异常");
						return returnMap;
					}

					// 解释返回的json
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
					returnMap.put("respDesc", "系统异常");
					return returnMap;
				}
			}

			// 绑定结算卡
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
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
				return returnMap;
			}

			// 绑定收款银行卡
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("merName", params[3]);
				map.put("certId", params[4]);

				String requestUrl = Constants.server_host + Constants.server_applyAuthentication_url;
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
				return returnMap;
			} catch (Exception e) {
				e.printStackTrace();
				returnMap.put("respCode", Constants.SERVER_SYSERR);
				returnMap.put("respDesc", "系统异常");
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
			builder.setTitle("提示");
			builder.setMessage("已提交绑定收款银行卡！");
			builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					finish();
				}
			});
			builder.show();
			return;
		}
	}

}
