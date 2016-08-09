package cn.qmpos.view;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.AttributeSet;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.qmpos.R;


import com.loopj.android.image.SmartImageView;

/*
 * 
 */
public class ImageCycleView extends LinearLayout {
	private Context mContext;
	/**
	 * 鍥剧墖杞挱瑙嗗浘
	 */
	private ViewPager mAdvPager = null;
	/**
	 * 婊氬姩鍥剧墖瑙嗗浘閫傞厤
	 */
	private ImageCycleAdapter mAdvAdapter;
	/**
	 * 鍥剧墖杞挱鎸囩ず鍣ㄦ帶锟�
	 */
	private ViewGroup mGroup;

	private TextView viewGroup2;
	/**
	 * 鍥剧墖杞挱鎸囩ず涓浘
	 */
	private ImageView mImageView = null;

	private TextView mTitleView = null;

	/**
	 * 婊氬姩鍥剧墖鎸囩ず瑙嗗浘鍒楄〃
	 */
	private ImageView[] mImageViews = null;

	private TextView[] mTitleViews = null;
	/**
	 * 鍥剧墖婊氬姩褰撳墠鍥剧墖涓嬫爣
	 */

	private boolean isStop;

	/**
	 * 娓告爣鏄渾褰㈣繕鏄暱鏉★紝瑕佹槸璁剧疆锟�0鏄暱鏉★紝瑕佹槸1灏辨槸鍦嗗舰 榛樿鏄渾锟�
	 */
	public int stype = 1;

	/**
	 * @param context
	 */
	public ImageCycleView(Context context) {
		super(context);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	@SuppressLint("Recycle")
	public ImageCycleView(Context context, AttributeSet attrs) {
		super(context, attrs);
		mContext = context;
		LayoutInflater.from(context).inflate(R.layout.ad_cycle_view, this);
		mAdvPager = (ViewPager) findViewById(R.id.adv_pager);
		mAdvPager.setOnPageChangeListener(new GuidePageChangeListener());
		// 婊氬姩鍥剧墖鍙充笅鎸囩ず鍣ㄨ
		mGroup = (ViewGroup) findViewById(R.id.viewGroup);

		viewGroup2 = (TextView) findViewById(R.id.viewGroup2);
	}

	/**
	 * 瑙︽懜鍋滄璁℃椂鍣紝鎶捣鍚姩璁℃椂锟�
	 */
	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {
		if (event.getAction() == MotionEvent.ACTION_UP) {
			// 锟�濮嬪浘鐗囨粴锟�
			startImageTimerTask();
		} else {
			// 鍋滄鍥剧墖婊氬姩
			stopImageTimerTask();
		}
		return super.dispatchTouchEvent(event);
	}

	/**
	 * 瑁呭～鍥剧墖鏁版嵁
	 * 
	 * @param imageUrlList
	 * @param imageCycleViewListener
	 */
	public void setImageResources(ArrayList<Integer> imageUrlList,
			ArrayList<String> imageTitle,
			ImageCycleViewListener imageCycleViewListener, int stype) {
		this.stype = stype;
		// 娓呴櫎
		mGroup.removeAllViews();
		// viewGroup2.removeAllViews();
		// 鍥剧墖骞垮憡鏁伴噺
		final int imageCount = imageUrlList.size();
		mImageViews = new ImageView[imageCount];

		mTitleViews = new TextView[imageCount];
		for (int i = 0; i < imageCount; i++) {
			mImageView = new ImageView(mContext);
			mTitleView = new TextView(mContext);
			LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT,
					LayoutParams.WRAP_CONTENT);
			params.leftMargin = 30;
			mImageView.setScaleType(ScaleType.CENTER_CROP);
			mImageView.setLayoutParams(params);

			mImageViews[i] = mImageView;

			mTitleViews[i] = mTitleView;

			// mTitleViews[i] = mTitleView;
			if (i == 0) {
				if (this.stype == 1)
					mImageViews[i]
							.setBackgroundResource(R.drawable.banner_dian_focus);
				// else
				// mImageViews[i].setBackgroundResource(R.drawable.cicle_banner_dian_focus);
			} else {
				if (this.stype == 1)
					mImageViews[i]
							.setBackgroundResource(R.drawable.banner_dian_blur);
				// else
				// mImageViews[i].setBackgroundResource(R.drawable.cicle_banner_dian_blur);
			}
			mGroup.addView(mImageViews[i]);
			// viewGroup2.addView(mTitleViews[i]);
		}

		mAdvAdapter = new ImageCycleAdapter(mContext, imageUrlList, imageTitle,
				imageCycleViewListener);
		mAdvPager.setAdapter(mAdvAdapter);
		mAdvPager.setCurrentItem(Integer.MAX_VALUE / 2);
		startImageTimerTask();
	}

	/**
	 * 鍥剧墖杞挱(鎵嬪姩鎺у埗鑷姩杞挱涓庡惁锛屼究浜庤祫婧愭帶浠讹級
	 */
	public void startImageCycle() {
		startImageTimerTask();
	}

	/**
	 * 鏆傚仠杞挱鈥旂敤浜庤妭鐪佽祫锟�
	 */
	public void pushImageCycle() {
		stopImageTimerTask();
	}

	/**
	 * 鍥剧墖婊氬姩浠诲姟
	 */
	private void startImageTimerTask() {
		stopImageTimerTask();
		// 鍥剧墖婊氬姩
		mHandler.postDelayed(mImageTimerTask, 3000);
	}

	/**
	 * 鍋滄鍥剧墖婊氬姩浠诲姟
	 */
	private void stopImageTimerTask() {
		isStop = true;
		mHandler.removeCallbacks(mImageTimerTask);
	}

	private Handler mHandler = new Handler();

	/**
	 * 鍥剧墖鑷姩杞挱Task
	 */
	private Runnable mImageTimerTask = new Runnable() {
		@Override
		public void run() {
			if (mImageViews != null) {
				mAdvPager.setCurrentItem(mAdvPager.getCurrentItem() + 1);
				if (!isStop) { // if isStop=true //褰撲綘锟�鍑哄悗 瑕佹妸杩欎釜缁欏仠涓嬫潵 涓嶇劧
								// 杩欎釜锟�鐩村瓨锟�
								// 灏变竴鐩村湪鍚庡彴寰幆
					mHandler.postDelayed(mImageTimerTask, 3000);
				}

			}
		}
	};

	/**
	 * 杞挱鍥剧墖鐩戝惉
	 * 
	 * @author minking
	 */
	private final class GuidePageChangeListener implements OnPageChangeListener {
		@Override
		public void onPageScrollStateChanged(int state) {
			if (state == ViewPager.SCROLL_STATE_IDLE)
				startImageTimerTask();
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}

		@Override
		public void onPageSelected(int index) {
			index = index % mImageViews.length;
			// 璁剧疆褰撳墠鏄剧ず鐨勫浘锟�
			// 璁剧疆鍥剧墖婊氬姩鎸囩ず鍣ㄨ儗
			if (stype == 1)
				mImageViews[index]
						.setBackgroundResource(R.drawable.banner_dian_focus);
			// else
			// mImageViews[index].setBackgroundResource(R.drawable.cicle_banner_dian_focus);
			for (int i = 0; i < mImageViews.length; i++) {
				if (index != i) {
					if (stype == 1)
						mImageViews[i]
								.setBackgroundResource(R.drawable.banner_dian_blur);
					// else
					// mImageViews[i].setBackgroundResource(R.drawable.cicle_banner_dian_blur);
				}

			}
		}
	}

	private class ImageCycleAdapter extends PagerAdapter {

		/**
		 * 鍥剧墖瑙嗗浘缂撳瓨鍒楄〃
		 */
		private ArrayList<SmartImageView> mImageViewCacheList;

		/**
		 * 鍥剧墖璧勬簮鍒楄〃
		 */
		private ArrayList<Integer> mAdList = new ArrayList<Integer>();
		private ArrayList<String> mATitle = new ArrayList<String>();
		/**
		 * 骞垮憡鍥剧墖鐐瑰嚮鐩戝惉
		 */
		private ImageCycleViewListener mImageCycleViewListener;

		private Context mContext;

		public ImageCycleAdapter(Context context, ArrayList<Integer> adList,
				ArrayList<String> title,
				ImageCycleViewListener imageCycleViewListener) {
			this.mContext = context;
			this.mAdList = adList;
			this.mATitle = title;
			mImageCycleViewListener = imageCycleViewListener;
			mImageViewCacheList = new ArrayList<SmartImageView>();
		}

		@Override
		public int getCount() {
			return Integer.MAX_VALUE;
		}

		@Override
		public boolean isViewFromObject(View view, Object obj) {
			return view == obj;
		}

		@Override
		public Object instantiateItem(ViewGroup container, final int position) {
			Integer imageUrl = mAdList.get(position % mAdList.size());
			String title = mATitle.get(position % mATitle.size());
			Log.i("imageUrl", imageUrl + title);

			viewGroup2.setText(title);
			SmartImageView imageView = null;
			if (mImageViewCacheList.isEmpty()) {
				imageView = new SmartImageView(mContext);
				imageView.setLayoutParams(new LayoutParams(
						LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
				imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);

			} else {
				imageView = mImageViewCacheList.remove(0);
			}

			// 璁剧疆鍥剧墖鐐瑰嚮鐩戝惉
			imageView.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					mImageCycleViewListener.onImageClick(
							position % mAdList.size(), v);
				}
			});
			imageView.setTag(imageUrl);
			container.addView(imageView);
			imageView.setImageResource(imageUrl);
			return imageView;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			SmartImageView view = (SmartImageView) object;
			mAdvPager.removeView(view);
			mImageViewCacheList.add(view);

		}

	}

	/**
	 * 杞挱鎺т欢鐨勭洃鍚簨锟�
	 * 
	 * @author minking
	 */
	public static interface ImageCycleViewListener {

		/**
		 * 鍗曞嚮鍥剧墖浜嬩欢
		 * 
		 * @param position
		 * @param imageView
		 */
		public void onImageClick(int position, View imageView);
	}

}
