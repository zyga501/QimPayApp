package cn.qmpos.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Date;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import cn.qmpos.util.CommUtil;

public class FileUtil {

	public static void writeFile(OutputStream fos, InputStream is) {
		if (null == fos || is == null) {
			return;
		}
		byte[] buff = new byte[1024];
		int hasread = 0;
		// ��URL��Դ���ص�����
		try {
			while ((hasread = is.read(buff)) > 0) {
				fos.write(buff, 0, hasread);
				fos.flush();
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
				fos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static String readFile(FileInputStream fis) {
		if (null == fis) {
			return null;
		}
		byte[] bytes = new byte[1024];
		StringBuffer rtn = new StringBuffer();
		try {
			while (fis.read(bytes) != -1) {
				rtn.append(bytes);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return rtn.toString();
	}

	public String saveBitmap(Bitmap mBitmap) {

		try {
			String sdCardPath = "";
			if (CommUtil.hasSDCard()) {
				sdCardPath = Environment.getExternalStorageDirectory()
						.getPath();
			} else {

			}

			String filePath = sdCardPath + "/" + "myImg/";

			Date date = new Date(System.currentTimeMillis());

			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

			String imgPath = filePath + sdf.format(date) + ".png";

			File file = new File(filePath);

			if (!file.exists()) {
				file.mkdirs();
			}
			File imgFile = new File(imgPath);

			if (!imgFile.exists()) {
				imgFile.createNewFile();
			}

			FileOutputStream fOut = new FileOutputStream(imgFile);

			mBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);

			fOut.flush();

			if (fOut != null) {

				fOut.close();
			}
			return imgPath;

		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * ѹ��ͼƬ
	 */
	public static Bitmap getBitmapByBytes(InputStream is, InputStream is2) {
		Bitmap bmp;
		// ����ͼƬ�Ķ��β���,��Ҫ�õ�ͼƬ�Ŀ����
		int width = 0;
		int height = 0;
		int sampleSize = 1; // Ĭ������Ϊ1
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true; // ���������Ե����
		// ���ָ����inJustDecodeBounds��decodeByteArray������Ϊ��
		bmp = BitmapFactory.decodeStream(is, null, options);
		// �õ������
		height = options.outHeight;
		width = options.outWidth;

		// ͼƬʵ�ʵĿ���ߣ�����Ĭ������Сֵ���õ�ͼƬʵ�ʵ����ű���
		while ((height / sampleSize > 150) || (width / sampleSize > 150)) {
			sampleSize *= 2;
		}

		BitmapFactory.Options o2 = new BitmapFactory.Options();
		o2.inSampleSize = sampleSize;
		bmp = BitmapFactory.decodeStream(is2, null, o2);
		return bmp;
	}

	/**
	 * ��ȡָ���ļ���С
	 * 
	 * @param f
	 * @return
	 * @throws Exception
	 */
	public static long getFileSize(File file) throws Exception {
		long size = 0;
		if (file.exists()) {
			FileInputStream fis = null;
			fis = new FileInputStream(file);
			size = fis.available();
		} else {
			file.createNewFile();
		}
		return size;
	}

	/**
	 * ��ȡָ���ļ���
	 * 
	 * @param f
	 * @return
	 * @throws Exception
	 */
	public static long getFileSizes(File f) throws Exception {
		long size = 0;
		File flist[] = f.listFiles();
		for (int i = 0; i < flist.length; i++) {
			if (flist[i].isDirectory()) {
				size = size + getFileSizes(flist[i]);
			} else {
				size = size + getFileSize(flist[i]);
			}
		}
		return size;
	}

	/**
	 * ת���ļ���С
	 * 
	 * @param fileS
	 * @return
	 */
	public static String FormetFileSize(long fileS) {
		DecimalFormat df = new DecimalFormat("#.00");
		String fileSizeString = "";
		String wrongSize = "0B";
		if (fileS == 0) {
			return wrongSize;
		}
		if (fileS < 1024) {
			fileSizeString = df.format((double) fileS) + "B";
		} else if (fileS < 1048576) {
			fileSizeString = df.format((double) fileS / 1024) + "KB";
		} else if (fileS < 1073741824) {
			fileSizeString = df.format((double) fileS / 1048576) + "MB";
		} else {
			fileSizeString = df.format((double) fileS / 1073741824) + "GB";
		}
		return fileSizeString;
	}
}
