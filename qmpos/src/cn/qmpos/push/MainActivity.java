package cn.qmpos.push;

import android.app.Activity;
import android.os.Bundle;
import cn.qmpos.R;


public class MainActivity extends Activity {

	public static final String KEY_MESSAGE = "message";

	public static final String KEY_EXTRAS = "extras";

	public static boolean isForeground = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
	}
}