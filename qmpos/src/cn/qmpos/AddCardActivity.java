package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;
import cn.qmpos.R;

/**
 * 添加银行卡
 * 
 * @author Administrator
 * 
 */
public class AddCardActivity extends BaseActivity implements OnClickListener {

	private Button mBack, auth_btn_next;
	private TextView textBankName, textCardName;
	private String bankCode;
	private EditText editCardNo;
	private AddCardActivity addCardActivity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_card);
		allActivity.add(this);
		initView();
	}

	private void initView() {
		addCardActivity = this;
		mBack = (Button) findViewById(R.id.back);
		textBankName = (TextView) this.findViewById(R.id.auth_text_bank_name);
		textCardName = (TextView) this.findViewById(R.id.auth_text_card_name);
		editCardNo = (EditText) this.findViewById(R.id.auth_edit_card_no);
		auth_btn_next = (Button) findViewById(R.id.auth_btn_next);
		mBack.setOnClickListener(this);
		textBankName.setOnClickListener(this);
		auth_btn_next.setOnClickListener(this);

		// 账户名称
		textCardName.setText(sp.getString("merName", ""));
	}

	private void setCard() {
		// 验证输入参数
		String cardName = textCardName.getText().toString();
		String cardNo = editCardNo.getText().toString();

		if (cardNo == null || "".equals(cardNo)) {
			showToast("请填写结算卡号！");
			return;
		}

		if (cardNo.length() >= 30) {
			showToast("结算卡号长度大于30位！");
			return;
		}

		if (cardNo.length() <= 12) {
			showToast("结算卡号长度小于12位！");
			return;
		}

		if (!CommUtil.isNumber(cardNo)) {
			showToast("结算卡号格式不正确！");
			return;
		}

		if (bankCode == null || "".equals(bankCode)) {
			showToast("请选择结算银行！");
			return;
		}

		String merId = sp.getString("merId", "");
		BankCardBindTask bankCardBindTask = new BankCardBindTask();
		bankCardBindTask.execute(new String[] { merId, bankCode, cardNo, cardName, "J" });
	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			case R.id.back:
				finish();
				break;
			case R.id.auth_text_bank_name:
				showBankDialog();
				break;
			case R.id.auth_btn_next:
				setCard();
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
				String bankName = getResources().getStringArray(R.array.bank_name)[which];
				bankCode = getResources().getStringArray(R.array.bank_code)[which];
				textBankName.setText(bankName);
			}
		});
		builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {

			}
		});
		builder.show();
	}

	class BankCardBindTask extends AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("正在添加,请稍候...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// 组装能数，调注册接口
			HashMap<String, String> returnMap = new HashMap<String, String>();
			// 绑定结算卡
			try {

				HashMap<String, String> map = new HashMap<String, String>();
				map.put("merId", params[0]);
				map.put("openBankId", params[1]);
				map.put("openAcctId", params[2]);
				map.put("openAcctName", params[3]);
				map.put("cardType", params[4]);

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
			return returnMap;

		}

		protected void onPostExecute(HashMap<String, String> resultMap) {
			String respCode = resultMap.get("respCode");
			String respDesc = resultMap.get("respDesc");
			dialog.hide();
			if (!Constants.SERVER_SUCC.equals(respCode)) {
				showToast(respDesc);
			} else {
				AlertDialog.Builder builder = new AlertDialog.Builder(addCardActivity);
				builder.setTitle("提示");
				builder.setMessage("添加银行卡成功！");
				builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						setResult(RESULT_OK);
						finish();
					}
				});
				builder.show();
				return;
			}
		}
	}
}
