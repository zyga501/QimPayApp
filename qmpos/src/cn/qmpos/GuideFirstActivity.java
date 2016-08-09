package cn.qmpos;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import cn.qmpos.R;
import cn.qmpos.adapter.ViewPagerAdapter;

public class GuideFirstActivity extends Activity implements OnClickListener,
		OnPageChangeListener, OnTouchListener {

	private ViewPager viewPager;

	private ViewPagerAdapter viewPagerAdapter;

	private List<View> views;

	private ImageView[] dots;

	private int currentIndex;

	private int lastX = 0;

	// private static final int[] pics = {R.drawable.g2, R.drawable.g3,
	// R.drawable.g4 };

	private static final int[] pics = { R.layout.guide_first_lay1,
			R.layout.guide_first_lay2, R.layout.guide_first_lay3,
			R.layout.guide_first_lay4 };

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_guide_first);
		views = new ArrayList<View>();

		// LinearLayout.LayoutParams mParams = new LinearLayout.LayoutParams(
		// LinearLayout.LayoutParams.WRAP_CONTENT,
		// LinearLayout.LayoutParams.FILL_PARENT);

		LayoutInflater mInflater = getLayoutInflater();

		for (int i = 0; i < pics.length; i++) {
			// ImageView iv = new ImageView(this);
			// iv.setLayoutParams(mParams);
			// iv.setImageResource(pics[i]);
			// views.add(iv);
			views.add(mInflater.inflate(pics[i], null));
		}
		viewPager = (ViewPager) findViewById(R.id.viewpager);
		viewPagerAdapter = new ViewPagerAdapter(views);
		viewPager.setOnTouchListener(this);
		viewPager.setAdapter(viewPagerAdapter);
		viewPager.setOnPageChangeListener(this);

		initBottomDots();

	}

	private void initBottomDots() {
		LinearLayout ll = (LinearLayout) findViewById(R.id.ll);
		dots = new ImageView[pics.length];
		for (int i = 0; i < pics.length; i++) {
			dots[i] = (ImageView) ll.getChildAt(i);
			dots[i].setEnabled(true);
			dots[i].setOnClickListener(this);
			dots[i].setTag(i);
		}
		currentIndex = 0;
		dots[currentIndex].setEnabled(false);
	}

	@Override
	public void onClick(View v) {
		int position = (Integer) v.getTag();
		setCurView(position);
		setCurDot(position);
	}

	@Override
	public void onPageScrollStateChanged(int state) {
	}

	@Override
	public void onPageScrolled(int index, float arg1, int dis) {
	}

	@Override
	public void onPageSelected(int index) {
		setCurDot(index);
	}

	private void setCurDot(int positon) {
		if (positon < 0 || positon > pics.length - 1 || currentIndex == positon) {
			return;
		}
		dots[positon].setEnabled(false);
		dots[currentIndex].setEnabled(true);
		currentIndex = positon;
	}

	private void setCurView(int position) {
		if (position < 0 || position >= pics.length) {
			return;
		}
		viewPager.setCurrentItem(position);
	}

	@Override
	public boolean onTouch(View v, MotionEvent event) {
		switch (event.getAction()) {
		case MotionEvent.ACTION_DOWN:
			lastX = (int) event.getX();
			break;
		case MotionEvent.ACTION_MOVE:
			if ((lastX - event.getX()) > 100
					&& (currentIndex == views.size() - 1)) {
				Intent i = new Intent(this, LoginActivity.class);
				this.startActivity(i);
				finish();
			}
			break;
		default:
			break;
		}
		return false;
	}

}
