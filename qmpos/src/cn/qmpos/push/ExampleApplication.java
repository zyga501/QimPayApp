package cn.qmpos.push;

import android.app.Application;

/**
 * For developer startup JPush SDK
 * 
 * һ�㽨�����Զ��� Application �����ʼ����Ҳ�������� Activity �
 */
public class ExampleApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();

		// JPushInterface.setDebugMode(true); // ���ÿ�����־,����ʱ��ر���־
		// JPushInterface.init(this); // ��ʼ�� JPush
	}
}
