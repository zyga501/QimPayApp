package cn.qmpos.view;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import cn.qmpos.R;


/**
 * 
 * @ClassName: CustomLoadingDialog
 * @Description: TODO(自定义loading对话框)
 * 
 */
public class CustomLoadingDialog extends AlertDialog {
	private Activity context;
	private View mView;

	public CustomLoadingDialog(Activity context) {
		super(context, R.style.loading_dialog_style);
		this.context = context;
		mView = LayoutInflater.from(context).inflate(
				R.layout.view_custom_loading_dialog, null);
	}

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Window w = context.getWindow();
		if (w == null)
			return;

		WindowManager.LayoutParams lp = w.getAttributes();
		if (lp == null)
			return;

		lp.dimAmount = 0f;
		w.setAttributes(lp);

		setCancelable(true);
		// 设置view样式
		this.setContentView(mView);
	}

	@Override
	public void dismiss() {
		super.dismiss();
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			return super.onKeyDown(keyCode, event);
		}

		return super.onKeyDown(keyCode, event);

	}

}
