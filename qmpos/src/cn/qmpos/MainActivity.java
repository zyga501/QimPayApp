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
	 * 用于对Fragment进行管理
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
						// 取消定时器
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
		// 延迟每次延迟10 毫秒 隔1秒执行一次
		timer.schedule(task, 10, 1000);

		initViews();
		fragmentManager = getFragmentManager();
		mainActivity = this;
		// 第一次启动时选中第0个tab
		setTabSelection(0);

		// 未实名提醒
		Intent intent = getIntent();
		String isAuthentication = intent.getStringExtra("isAuthentication");
		if ("A".equals(isAuthentication) || "F".equals(isAuthentication)) {
			AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity);
			builder.setTitle("提示");
			builder.setMessage("您未绑定收款银行卡，是否立即实名！");
//			builder.setPositiveButton("暂不实名",
//					new DialogInterface.OnClickListener() {
//						public void onClick(DialogInterface dialog, int which) {
//
//						}
//					});
			builder.setNegativeButton("我要实名",
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
	 * 在这里获取到每个需要用到的控件的实例，并给它们设置好必要的点击事件。
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
			// 当点击了消息tab时，选中第1个tab
			setTabSelection(0);
			break;
		case R.id.main_t2_layout:
			// 当点击了联系人tab时，选中第2个tab
			setTabSelection(1);
			break;
		case R.id.main_t3_layout:
			// 当点击了动态tab时，选中第3个tab
			setTabSelection(2);
			break;
		case R.id.main_t4_layout:
			// 当点击了设置tab时，选中第4个tab
			setTabSelection(3);
			break;
		}
	}

	/**
	 * 根据传入的index参数来设置选中的tab页。
	 * 
	 * @param index
	 *            每个tab页对应的下标。0表示消息，1表示联系人，2表示动态，3表示设置。
	 */
	private void setTabSelection(int index) {
		// 每次选中之前先清楚掉上次的选中状态
		clearSelection();
		// 开启一个Fragment事务
		FragmentTransaction transaction = fragmentManager.beginTransaction();
		// 先隐藏掉所有的Fragment，以防止有多个Fragment显示在界面上的情况
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
	 * 清除掉所有的选中状态。
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
	 * 将所有的Fragment都置为隐藏状态。
	 * 
	 * @param transaction
	 *            用于对Fragment执行操作的事务
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
