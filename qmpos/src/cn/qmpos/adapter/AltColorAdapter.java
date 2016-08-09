package cn.qmpos.adapter;

import java.util.List;
import java.util.Map;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleAdapter;
import cn.qmpos.R;


/**
 * ListView¸ôÐÐ±äÉ«
 * 
 * @author Administrator
 * 
 */
public class AltColorAdapter extends SimpleAdapter {

	private static int[] mColors = { R.color.text_gray, R.color.whilte };

	public AltColorAdapter(Context context,
			List<? extends Map<String, ?>> data, int resource, String[] from,
			int[] to) {
		super(context, data, resource, from, to);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		int[] arrayOfInt = mColors;
		int colorLength = mColors.length;
		int selected = arrayOfInt[position % colorLength];
		View localView = super.getView(position, convertView, parent);
		localView.setBackgroundResource(selected);
		return localView;
	}
}
