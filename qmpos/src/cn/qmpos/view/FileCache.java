package cn.qmpos.view;

import android.content.Context;
import cn.qmpos.util.CommUtil;

public class FileCache extends AbstractFileCache {

	public FileCache(Context context) {
		super(context);

	}

	@Override
	public String getSavePath(String url) {
		String filename = String.valueOf(url.hashCode());
		return getCacheDir() + filename;
	}

	@Override
	public String getCacheDir() {
		if (CommUtil.hasSDCard()) {
			return CommUtil.getRootFilePath() + "cn.baijia/files/";
		} else {
			return CommUtil.getRootFilePath() + "cn.baijia/files";
		}
	}

}
