package cn.qmpos;

import java.util.Timer;
import java.util.TimerTask;

import android.app.AlertDialog;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.qmpos.R;
import cn.qmpos.fragment.MainT1Fragment;
import cn.qmpos.fragment.MainT2Fragment;
import cn.qmpos.fragment.MainT3Fragment;
import cn.qmpos.fragment.MainT4Fragment;

public class MainActivity extends BaseActivity implements OnClickListener {

	protected static final String APPURL = null;
	private MainT1Fragment mainT1Fragment;
	private MainT2Fragment mainT2Fragment;
	private MainT3Fragment mainT3Fragment;
	private MainT4Fragment mainT4Fragment;

	private View mainT1Layout;
	private View mainT2Layout;
	private View mainT3Layout;
	private View mainT4Layout;

	private ImageView mainT1Image;
	private ImageView mainT2Image;
	private ImageView mainT3Image;
	private ImageView mainT4Image;

	private TextView mainT1Text;
	private TextView mainT2Text;
	private TextView mainT3Text;
	private TextView mainT4Text;
	private Timer timer;
	public static int bottomHeight;
	/**
	 * ���ڶ�Fragment���й���
	 */
	private FragmentManager fragmentManager;

	private MainActivity mainActivity;

	public MainActivity() {
		// TODO Auto-generated constructor stub
	}

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// requestWindowFeature(Window.FEATURE_NO_TITLE);
		allActivity.add(this);
		setContentView(R.layout.activity_main);
		final LinearLayout layout = (LinearLayout) this
				.findViewById(R.id.main_bottom_layout);
		final Handler myHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				if (msg.what == 1) {
					if (layout.getHeight() != 0) {
						bottomHeight = layout.getHeight();
						// ȡ����ʱ��
						timer.cancel();

					}
				}
			}
		};

		timer = new Timer();
		TimerTask task = new TimerTask() {
			public void run() {
				Message message = new Message();
				message.what = 1;
				myHandler.sendMessage(message);
			}
		};
		// �ӳ�ÿ���ӳ�10 ���� ��1��ִ��һ��
		timer.schedule(task, 10, 1000);

		initViews();
		fragmentManager = getFragmentManager();
		mainActivity = this;
		// ��һ������ʱѡ�е�0��tab
		setTabSelection(0);

		// δʵ������
		Intent intent = getIntent();
		String isAuthentication = intent.getStringExtra("isAuthentication");
		if ("A".equals(isAuthentication) || "F".equals(isAuthentication)) {
			AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity);
			builder.setTitle("��ʾ");
			builder.setMessage("��δ���տ����п����Ƿ�����ʵ����");
//			builder.setPositiveButton("�ݲ�ʵ��",
//					new DialogInterface.OnClickListener() {
//						public void onClick(DialogInterface dialog, int which) {
//
//						}
//					});
			builder.setNegativeButton("��Ҫʵ��",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							Intent i = new Intent(mainActivity,
									AuthenticationActivity.class);
							mainActivity.startActivity(i);
						}
					});
			builder.show();
		}

	}

	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			propmptExit(mainActivity);
		}
		return false;
	}

	/**
	 * �������ȡ��ÿ����Ҫ�õ��Ŀؼ���ʵ���������������úñ�Ҫ�ĵ���¼���
	 */
	private void initViews() {
		mainT1Layout = findViewById(R.id.main_t1_layout);
		mainT2Layout = findViewById(R.id.main_t2_layout);
		mainT3Layout = findViewById(R.id.main_t3_layout);
		mainT4Layout = findViewById(R.id.main_t4_layout);

		mainT1Image = (ImageView) findViewById(R.id.main_t1_image);
		mainT2Image = (ImageView) findViewById(R.id.main_t2_image);
		mainT3Image = (ImageView) findViewById(R.id.main_t3_image);
		mainT4Image = (ImageView) findViewById(R.id.main_t4_image);

		mainT1Text = (TextView) findViewById(R.id.main_t1_text);
		mainT2Text = (TextView) findViewById(R.id.main_t2_text);
		mainT3Text = (TextView) findViewById(R.id.main_t3_text);
		mainT4Text = (TextView) findViewById(R.id.main_t4_text);

		mainT1Layout.setOnClickListener(this);
		mainT2Layout.setOnClickListener(this);
		mainT3Layout.setOnClickListener(this);
		mainT4Layout.setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.main_t1_layout:
			// ���������Ϣtabʱ��ѡ�е�1��tab
			setTabSelection(0);
			break;
		case R.id.main_t2_layout:
			// ���������ϵ��tabʱ��ѡ�е�2��tab
			setTabSelection(1);
			break;
		case R.id.main_t3_layout:
			// ������˶�̬tabʱ��ѡ�е�3��tab
			setTabSelection(2);
			break;
		case R.id.main_t4_layout:
			// �����������tabʱ��ѡ�е�4��tab
			setTabSelection(3);
			break;
		}
	}

	/**
	 * ���ݴ����index����������ѡ�е�tabҳ��
	 * 
	 * @param index
	 *            ÿ��tabҳ��Ӧ���±ꡣ0��ʾ��Ϣ��1��ʾ��ϵ�ˣ�2��ʾ��̬��3��ʾ���á�
	 */
	private void setTabSelection(int index) {
		// ÿ��ѡ��֮ǰ��������ϴε�ѡ��״̬
		clearSelection();
		// ����һ��Fragment����
		FragmentTransaction transaction = fragmentManager.beginTransaction();
		// �����ص����е�Fragment���Է�ֹ�ж��Fragment��ʾ�ڽ����ϵ����
		hideFragments(transaction);
		switch (index) {
		case 0:
			mainT1Image.setImageResource(R.drawable.caifu2);
			mainT1Text.setTextColor(0xff649fd7);
			mainT1Fragment = new MainT1Fragment();
			transaction.replace(R.id.main_viewArea, mainT1Fragment);
			break;
		case 1:
			mainT2Image.setImageResource(R.drawable.shoukuan2);
			mainT2Text.setTextColor(0xff649fd7);
			mainT2Fragment = new MainT2Fragment();
			transaction.replace(R.id.main_viewArea, mainT2Fragment);
			break;
		case 2:
			mainT3Image.setImageResource(R.drawable.tuiguang2);
			mainT3Text.setTextColor(0xff649fd7);
			mainT3Fragment = new MainT3Fragment();
			transaction.replace(R.id.main_viewArea, mainT3Fragment);
			break;
		case 3:
			mainT4Image.setImageResource(R.drawable.wode2);
			mainT4Text.setTextColor(0xff649fd7);
			mainT4Fragment = new MainT4Fragment();
			transaction.replace(R.id.main_viewArea, mainT4Fragment);
			break;
		}
		transaction.commit();
	}

	/**
	 * ��������е�ѡ��״̬��
	 */
	private void clearSelection() {
		mainT1Image.setImageResource(R.drawable.caifu);
		mainT1Text.setTextColor(Color.parseColor("#82858b"));
		mainT2Image.setImageResource(R.drawable.shoukuan);
		mainT2Text.setTextColor(Color.parseColor("#82858b"));
		mainT3Image.setImageResource(R.drawable.tuiguang);
		mainT3Text.setTextColor(Color.parseColor("#82858b"));
		mainT4Image.setImageResource(R.drawable.wode);
		mainT4Text.setTextColor(Color.parseColor("#82858b"));
	}

	/**
	 * �����е�Fragment����Ϊ����״̬��
	 * 
	 * @param transaction
	 *            ���ڶ�Fragmentִ�в���������
	 */
	private void hideFragments(FragmentTransaction transaction) {
		if (mainT1Fragment != null) {
			transaction.hide(mainT1Fragment);
		}
		if (mainT2Fragment != null) {
			transaction.hide(mainT2Fragment);
		}
		if (mainT3Fragment != null) {
			transaction.hide(mainT3Fragment);
		}
		if (mainT4Fragment != null) {
			transaction.hide(mainT4Fragment);
		}
	}

}
