package cn.qmpos;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import cn.qmpos.R;

import cn.qmpos.util.CommUtil;

/**
 * �����տ�
 * 
 * @author Administrator
 * 
 */
public class SmsRecv1Activity extends BaseActivity implements OnClickListener {

	private EditText edValidatePhone;
	private Button btnBack, btnNext, get_phone;

	private String usernumber;// , username;
	private SmsRecv1Activity smsRecv1Activity;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_sms_recv1);
		allActivity.add(this);
		init();
	}

	private void init() {
		smsRecv1Activity = this;
		btnBack = (Button) this.findViewById(R.id.sms_recv1_btn_back);
		btnNext = (Button) this.findViewById(R.id.sms_recv1_btn_next);
		btnBack.setOnClickListener(this);
		btnNext.setOnClickListener(this);
		get_phone = (Button) findViewById(R.id.get_mail_list);
		get_phone.setOnClickListener(this);
		edValidatePhone = (EditText) findViewById(R.id.sms_recv1_edit_recv_mobile);
		smsRecv1Activity = this;

	}

	// ��ȡϵͳ�Դ���ͨѶ¼
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		super.onActivityResult(requestCode, resultCode, data);
		// edValidatePhone.setText("");
		if (requestCode == 0) {
			if (resultCode == Activity.RESULT_OK) {
				ContentResolver reContentResolverol = getContentResolver();
				Uri contactData = data.getData();
				// Cursor cursor = managedQuery(contactData, null, null, null,
				// null);
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
							edValidatePhone.setText(usernumber);
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
			case R.id.get_mail_list:
				startActivityForResult(new Intent(Intent.ACTION_PICK,
						ContactsContract.Contacts.CONTENT_URI), 0);
				break;
			case R.id.sms_recv1_btn_back:
				finish();
				break;
			case R.id.sms_recv1_btn_next:
				smsRecv();
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void smsRecv() {
		// �жϽ����տ�˵���Ƿ�����
		String recvMobile = edValidatePhone.getText().toString().trim();
		if ("".equals(recvMobile)) {
			Toast.makeText(this, "������Է��ֻ���", Toast.LENGTH_SHORT).show();
			return;
		}
		if (recvMobile.length() != 11 || !CommUtil.isMp(recvMobile)) {
			Toast.makeText(this, "�ֻ��Ŵ���", Toast.LENGTH_SHORT).show();
			return;
		}
		// ʹ��Intent����õ�SmsRecv1Activity�������Ĳ���
		Intent intents = getIntent();
		String transAmt = intents.getStringExtra("showValue");
		String ordRemark = intents.getStringExtra("ordRemark");
		transAmt = CommUtil.getCurrencyFormt(transAmt);

		Intent intent = new Intent(smsRecv1Activity, SmsRecv2Activity.class);
		intent.putExtra("recvMobile", recvMobile);
		intent.putExtra("showValue", transAmt);
		intent.putExtra("ordRemark", ordRemark);
		startActivity(intent);

	}
}
