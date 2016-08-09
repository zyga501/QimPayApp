package cn.qmpos;

import java.util.HashMap;

import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.http.HttpRequest;
import cn.qmpos.util.CommUtil;
import cn.qmpos.util.Constants;

/**
 * ת��
 * 
 * @author Administrator
 * 
 */
public class TurnOutMoney1Activity extends BaseActivity implements
		OnClickListener {

	private TurnOutMoney1Activity turnOutMoney1Activity;
	private EditText editOthersMobile;
	private Button btnBack, btnNext, get_phone, btn_transfer_record;
	private String usernumber;
	private SharedPreferences sp;
	private String othersMobile;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_turn_out_money1);
		allActivity.add(this);
		init();
	}

	private void init() {
		turnOutMoney1Activity = this;
		btnBack = (Button) this.findViewById(R.id.btn_back);
		btnNext = (Button) this
				.findViewById(R.id.btn_next_turn_out_money_mobile);
		btn_transfer_record = (Button) findViewById(R.id.btn_transfer_record);
		btn_transfer_record.setOnClickListener(this);
		btnBack.setOnClickListener(this);
		btnNext.setOnClickListener(this);
		get_phone = (Button) findViewById(R.id.get_mail_list);
		get_phone.setOnClickListener(this);
		editOthersMobile = (EditText) findViewById(R.id.edit_turnout_money_mobile);
		sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);

	}

	// ��ȡϵͳ�Դ���ͨѶ¼
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == 0) {
			if (resultCode == Activity.RESULT_OK) {
				ContentResolver reContentResolverol = getContentResolver();
				Uri contactData = data.getData();
				Cursor cursor = reContentResolverol.query(contactData, null,
						null, null, null);
				if (!cursor.isAfterLast()) {
					while (cursor.moveToNext()) {
						usernumber = cursor
								.getString(cursor
										.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
						String contactId = cursor.getString(cursor
								.getColumnIndex(ContactsContract.Contacts._ID));
						Cursor phone = reContentResolverol
								.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
										null,
										ContactsContract.CommonDataKinds.Phone.CONTACT_ID
												+ " = " + contactId, null, null);

						while (phone.moveToNext()) {
							usernumber = phone
									.getString(phone
											.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
							usernumber = CommUtil.removeAllSpace(usernumber);
							editOthersMobile.setText(usernumber);
						}
						phone.close();
					}
				} else {
					showToast("����ͨѶ¼�ѱ����ã����ֶ������ֻ�����");
				}
				cursor.close();

			}
		}

	}

	public void onClick(View v) {
		try {
			switch (v.getId()) {
			// ת�˼�¼
			case R.id.btn_transfer_record:
				Intent intent = new Intent(this, TransferRecordAcitivty.class);
				startActivity(intent);
				break;
			case R.id.get_mail_list:
				startActivityForResult(new Intent(Intent.ACTION_PICK,
						ContactsContract.Contacts.CONTENT_URI), 0);
				break;
			case R.id.btn_back:
				finish();
				break;
			case R.id.btn_next_turn_out_money_mobile:
				initView();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void initView() {
		// �жϽ����տ�˵���Ƿ�����
		othersMobile = editOthersMobile.getText().toString().trim();

		if ("".equals(othersMobile)) {
			Toast.makeText(this, "������Է��ֻ���", Toast.LENGTH_SHORT).show();
			return;
		}
		if (othersMobile.length() != 11 || !CommUtil.isMp(othersMobile)) {
			Toast.makeText(this, "�ֻ��Ŵ���", Toast.LENGTH_SHORT).show();
			return;
		}
		// �����տ�
		TurnOutMoney1Task turnOutMoney1Task = new TurnOutMoney1Task();
		turnOutMoney1Task.execute(new String[] { othersMobile });

	}

	class TurnOutMoney1Task extends
			AsyncTask<String, Integer, HashMap<String, String>> {

		protected void onPreExecute() {
			dialog.setMessage("ϵͳ������...");
			dialog.show();
		}

		protected HashMap<String, String> doInBackground(String... params) {
			// ��װ��������ע��ӿ�
			HashMap<String, String> returnMap = new HashMap<String, String>();
			try {
				HashMap<String, String> map = new HashMap<String, String>();

				sp = getSharedPreferences("qmpos", Activity.MODE_PRIVATE);
				map.put("agentId", Constants.server_agent_id);
				map.put("mobile", params[0]);

				String requestUrl = Constants.server_host
						+ Constants.server_queryMerNameByMobile_url;
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
					returnMap.put("merId", jsonObj.getString("merId"));
					returnMap.put("merName", jsonObj.getString("merName"));
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
				dialog.hide();
				showToast(respDesc);
				return;
			}
			try {
				dialog.hide();
				Intent intent = new Intent(turnOutMoney1Activity,
						TurnOutMoney2Activity.class);
				intent.putExtra("merId", resultMap.get("merId"));
				intent.putExtra("merName", resultMap.get("merName"));
				intent.putExtra("othersMobile", othersMobile);
				startActivity(intent);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
