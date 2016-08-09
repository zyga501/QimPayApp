package cn.qmpos.view;

import java.io.File;

import android.content.Context;

public abstract class AbstractFileCache {

	private String dirString;

	public AbstractFileCache(Context context) {

		dirString = getCacheDir();
		boolean ret = FileHelper.createDirectory(dirString);
	}

	public File getFile(String url) {
		File f = new File(getSavePath(url));
		return f;
	}

	public abstract String getSavePath(String url);

	public abstract String getCacheDir();

	public void clear() {
		FileHelper.deleteDirectory(dirString);
		FileHelper.createDirectory(dirString);
	}

}
