package cn.qmpos.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Collections;
import java.util.Map;
import java.util.WeakHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.ImageView;

public class ImageLoader {
	private static ImageLoader instence = null;
	private MemoryCache memoryCache;
	private AbstractFileCache fileCache;
	private Map<ImageView, String> imageViews = Collections
			.synchronizedMap(new WeakHashMap<ImageView, String>());
	private ExecutorService executorService;

	private ImageLoader(Context context) {
		fileCache = new FileCache(context);
		executorService = Executors.newFixedThreadPool(5);
		memoryCache = MemoryCache.getInstence();
	}

	public static ImageLoader getInstence(Context context) {
		if (instence == null) {
			instence = new ImageLoader(context);
		}
		return instence;
	}

	/**
	 **/
	public void DisplayImage(String url, ImageView imageView,
			boolean isLoadOnlyFromCache) {
		try {
			imageViews.put(imageView, url);
			Bitmap bitmap = memoryCache.get(url);
			if (bitmap == null) {
				queuePhoto(url, imageView);
			} else {
				// bitmap = SystemUtil.cutBitmap(bitmap);
				imageView.setImageBitmap(bitmap);
			}
		} catch (OutOfMemoryError oom) {
		} catch (Exception e) {

		} finally {
			System.gc();
		}
	}

	private void queuePhoto(String url, ImageView imageView) {
		PhotoToLoad p = new PhotoToLoad(url, imageView);
		executorService.submit(new PhotosLoader(p));
	}

	private Bitmap getBitmap(String url) {
		File f = fileCache.getFile(url);

		Bitmap b = null;
		if (f != null && f.exists()) {
			b = decodeFile(f);
		}
		if (b != null) {
			return b;
		}
		try {
			URL imageUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) imageUrl
					.openConnection();
			conn.setConnectTimeout(30000);
			conn.setReadTimeout(30000);
			conn.setInstanceFollowRedirects(true);
			InputStream is = conn.getInputStream();
			OutputStream os = new FileOutputStream(f);
			CopyStream(is, os);
			os.close();
			b = decodeFile(f);
			return b;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	private Bitmap decodeFile(File f) {
		try {
			BitmapFactory.Options o = new BitmapFactory.Options();
			o.inJustDecodeBounds = true;
			BitmapFactory.decodeStream(new FileInputStream(f), null, o);

			int REQUIRED_SIZE = 100;
			int width_tmp = o.outWidth, height_tmp = o.outHeight;
			int scale = 1;
			while (true) {
				if (width_tmp / 2 < REQUIRED_SIZE
						|| height_tmp / 2 < REQUIRED_SIZE)
					break;
				width_tmp /= 2;
				height_tmp /= 2;
				scale *= 2;
			}
			BitmapFactory.Options o2 = new BitmapFactory.Options();
			o2.inSampleSize = scale;
			return BitmapFactory.decodeStream(new FileInputStream(f), null, o2);
		} catch (OutOfMemoryError oom) {
		} catch (Exception e) {

		} finally {
			System.gc();
		}
		return null;
	}

	private class PhotoToLoad {
		public String url;
		public ImageView imageView;

		public PhotoToLoad(String u, ImageView i) {
			url = u;
			imageView = i;
		}
	}

	class PhotosLoader implements Runnable {
		PhotoToLoad photoToLoad;

		PhotosLoader(PhotoToLoad photoToLoad) {
			this.photoToLoad = photoToLoad;
		}

		@Override
		public void run() {
			if (imageViewReused(photoToLoad))
				return;
			Bitmap bmp = getBitmap(photoToLoad.url);
			memoryCache.put(photoToLoad.url, bmp);
			if (imageViewReused(photoToLoad))
				return;
			BitmapDisplayer bd = new BitmapDisplayer(photoToLoad, bmp);
			Activity a = (Activity) photoToLoad.imageView.getContext();
			a.runOnUiThread(bd);
		}
	}

	/**
	 * @param photoToLoad
	 * @return
	 */
	boolean imageViewReused(PhotoToLoad photoToLoad) {
		String tag = imageViews.get(photoToLoad.imageView);
		if (tag == null || !tag.equals(photoToLoad.url))
			return true;
		return false;
	}

	class BitmapDisplayer implements Runnable {
		PhotoToLoad photoToLoad;
		Bitmap bitmap;

		public BitmapDisplayer(PhotoToLoad p, Bitmap bitmap) {
			photoToLoad = p;
			this.bitmap = bitmap;
		}

		public void run() {
			try {
				if (imageViewReused(photoToLoad))
					return;
				if (bitmap != null) {
					// bitmap = SystemUtil.cutBitmap(bitmap);
					photoToLoad.imageView.setImageBitmap(bitmap);
				}
			} catch (OutOfMemoryError oom) {
			} catch (Exception e) {
			} finally {
				System.gc();
			}
		}
	}

	public void clearCache() {
		memoryCache.clear();
		fileCache.clear();
	}

	public static void CopyStream(InputStream is, OutputStream os) {
		final int buffer_size = 1024;
		try {
			byte[] bytes = new byte[buffer_size];
			for (;;) {
				int count = is.read(bytes, 0, buffer_size);
				if (count == -1)
					break;
				os.write(bytes, 0, count);
			}
		} catch (Exception ex) {
		}
	}
}