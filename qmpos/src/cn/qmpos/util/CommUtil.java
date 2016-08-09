package cn.qmpos.util;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.text.TextUtils;

public class CommUtil {

	public static boolean isMp(String mp) {
		// "^((13[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0-9]))\\d{8}$"
		Pattern p = Pattern.compile("^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0-9]))\\d{8}$");
		Matcher m = p.matcher(mp);
		System.out.println(m.matches() + "---");
		return m.matches();
	}

	public static String leftPad(String str, int len, char ch) {
		StringBuffer nstr = new StringBuffer(len);

		int p = len - str.length();

		for (int i = 0; i < len; i++) {
			if (i < p)
				nstr.append(ch);
			else
				nstr.append(str.charAt(i - p));
		}
		return new String(nstr);
	}

	public static String getDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		java.util.Date dateCurrent = new java.util.Date();

		String strCurrentDate = formatter.format(dateCurrent);

		return strCurrentDate;

	}

	// nfc银行卡号
	public static String addBarToBankCard(String bankAccount) {
		int length = bankAccount.length();
		if (length < 13)
			return bankAccount;
		return bankAccount.substring(0, length - 11) + "******" + bankAccount.substring(length - 4);
	}

	// nfc银行卡号显示后四位
	public static String addBarToBankCardWH(String bankAccount) {
		int length = bankAccount.length();
		if (length < 13)
			return bankAccount;
		return bankAccount.substring(length - 4);

	}

	public static String getTime() {
		SimpleDateFormat formatter = new SimpleDateFormat("HHmmss");
		java.util.Date dateCurrent = new java.util.Date();

		String strCurrentTime = formatter.format(dateCurrent);

		return strCurrentTime;
	}

	public static String addBarAndColonToDateString(String dateStr) {
		String retDateStr = "";

		if (dateStr == null || dateStr.length() != 14) {
			return dateStr;
		}

		retDateStr = dateStr.substring(0, 4) + "-" + dateStr.substring(4, 6) + "-" + dateStr.substring(6, 8) + " "
				+ dateStr.substring(8, 10) + ":" + dateStr.substring(10, 12) + ":" + dateStr.substring(12);

		return retDateStr;

	}

	// 姓名隐藏
	public static String addUser(String user) {
		return user.substring(0, 1) + leftPad("", user.length() - 1, '*');
	}

	/**
	 * 取得oldDate的相隔sizeOfParamValue的日期，可以带符号
	 * 
	 * @param oldDate
	 *            初始日期
	 * @param sizeOfParamValue
	 *            时间间隔（天）
	 * @return String
	 */
	public static String getNextDate(String oldDate, int sizeOfParamValue) {
		try {
			if (oldDate.length() != 8 || !isNumber(oldDate)) {
				System.out.println("oldDate 必须是YYYYMMDD格式");
				return null;
			}
			int year = new Integer(oldDate.substring(0, 4)).intValue();
			int month = new Integer(oldDate.substring(4, 6)).intValue() - 1;
			int date = new Integer(oldDate.substring(6, 8)).intValue();
			// System.out.println("year[" + year + "]month[" + month + "]date["
			// + date + "]ParamValue[" + ParamValue + "]");
			java.util.Calendar calender = java.util.Calendar.getInstance();
			calender.set(year, month, date);
			calender.add(java.util.Calendar.DATE, sizeOfParamValue);
			year = calender.get(java.util.Calendar.YEAR);
			month = calender.get(java.util.Calendar.MONTH) + 1;
			date = calender.get(java.util.Calendar.DATE);
			// System.out.println("year[" + year + "]month[" + month + "]date["
			// + date + "]ParamValue[" + ParamValue + "]");
			String NextDate = leftPad("" + year, 4, '0') + leftPad("" + month, 2, '0') + leftPad("" + date, 2, '0');
			return NextDate;
		} catch (Exception e) {
			System.out.println("Exception in getNextDate[" + e.getMessage() + "]");
			return null;
		}
	}

	/*************************************************************
	 * function: add bar to a date string , such as if the date string is
	 * "20060912" , the return string is "2006-09-12" input : date string as
	 * "20060912" output : date string as "2006-09-12" note : lp.cheng
	 *********************************************************/
	public static String addBarToDateString(String dateStr) {
		String retDateStr = "";

		if (dateStr == null || dateStr.trim().length() != 8) {
			return dateStr;
		}

		retDateStr = dateStr.substring(0, 4) + "-" + dateStr.substring(4, 6) + "-" + dateStr.substring(6);

		return retDateStr;

	}

	/*************************************************************
	 * function: add bar to a date string , such as if the date string is
	 * "090807" , the return string is "09:08:07" input : date string as
	 * "090807" output : date string as "09:08:07" note : lp.cheng
	 *********************************************************/
	public static String addColonToTimeString(String timeStr) {
		String retDateStr = "";

		if (timeStr == null || timeStr.trim().length() != 6) {
			return timeStr;
		}

		retDateStr = timeStr.substring(0, 2) + ":" + timeStr.substring(2, 4) + ":" + timeStr.substring(4);

		return retDateStr;

	}

	/*************************************************************
	 * function: add bar to a date string , such as if the date string is
	 * "090807" , the return string is "09时08分07秒" input : date string as
	 * "090807" output : date string as "09时08分07秒" note : lp.cheng
	 *********************************************************/
	public static String addChineseToTimeString(String timeStr) {
		String retDateStr = "";

		if (timeStr == null || timeStr.length() != 6) {
			return timeStr;
		}

		retDateStr = timeStr.substring(0, 2) + "时" + timeStr.substring(2, 4) + "分" + timeStr.substring(4) + "秒";

		return retDateStr;

	}

	/*************************************************************
	 * function: 将银行卡号中间加星号处理 input : string as "9558801502203097716" output :
	 * string as "955880******097716" note : lp.cheng
	 *********************************************************/
	public static String addBarToBankCardNo(String bankAccount) {
		int length = bankAccount.length();
		if (length < 13)
			return bankAccount;
		return bankAccount.substring(0, length - 11) + "******" + bankAccount.substring(length - 4);
	}

	/*************************************************************
	 * function: 手机号中间四位星号 input : string as "13621717784" output : string as
	 * "136****7784" note : lp.cheng
	 *********************************************************/
	public static String addBarToMobile(String mobile) {
		int length = mobile.length();
		if (length != 11)
			return mobile;
		return mobile.substring(0, 3) + "****" + mobile.substring(length - 4);
	}

	/**
	 * 判断是否标准金额格式####.##字符串
	 * 
	 * @param TransAmt
	 *            金额字符串
	 * @return true 是，false 否
	 */
	public static boolean isAmt(String TransAmt) {
		int ret, len = TransAmt.length();
		if (len < 4)// 小数点后必须有2位数字
			return false;
		char ch;
		for (ret = 0; ret < len; ret++) {
			ch = TransAmt.charAt(ret);

			if (ret == 0) {
				if (ch > '9' || ch < '0')
					return false;
				if (ch == '0' && len != 4)
					return false;
			}

			if (ret == len - 3) {
				if (ch != '.')
					return false;
				else
					continue;
			}

			if (ch > '9' || ch < '0')
				return false;
		}

		return true;
	}

	/**
	 * 判断字符窜是否全是数字（可以带小数点）
	 * 
	 * @return true,是 false,否
	 */
	static public boolean isNumberCanWithDot(String s) {
		StringBuffer sb = new StringBuffer(s);
		int dotCount = 0;
		for (int i = 0; i < s.length(); i++) {
			char c = sb.charAt(i);

			if (c == '.') {
				if (i == 0 || i == s.length()) { // 如果小数点出现在首位或者末位 则判断不符合规范
					return false;
				}
				dotCount++;
				if (dotCount > 1) { // 小数点多于两位 则判断不符合规范
					return false;
				}
				continue;
			}
			if (c < '0' || c > '9')
				return false;
		}
		return true;
	}

	/**
	 * 判断字符窜是否全是数字组合
	 * 
	 * @return true,是 false,否
	 */
	static public boolean isNumber(String s) {
		StringBuffer sb = new StringBuffer(s);
		for (int i = 0; i < s.length(); i++) {
			char c = sb.charAt(i);
			if (c < '0' || c > '9')
				return false;
		}
		return true;
	}

	/**
	 * 
	 * 货币格式，例：1234567.00 转换后为1,234,567.00 如果参数格式不是数字，则原样返回
	 * 
	 * @time 2009-09-04
	 * @param curry
	 * @return
	 */
	public static String getCurrencyFormt(String curry) {

		try {
			if (curry == null || "".equals(curry) || "-".equals(curry)) {
				return curry;
			}
			curry = curry.replaceAll(",", "");
			DecimalFormat dmf = new DecimalFormat("#####0.00");

			return dmf.format(new Double(curry));
		} catch (Exception e) {
			e.printStackTrace();
			return curry;
		}
	}

	/**
	 * 获取实名状态
	 */
	public static String getAuthStatStr(String authStat) {
		if ("S".equals(authStat)) {
			return "已实名";
		} else if ("I".equals(authStat)) {
			return "审核中";
		} else if ("F".equals(authStat)) {
			return "审核失败";
		} else {
			return "未实名";
		}
	}

	/**
	 * 去除小数点及后面的数字
	 * 
	 * @author rui.cheng
	 * @time 2010-09-01
	 * @param curry
	 * @return
	 */
	public static String removeDecimal(String curry) {

		if (curry == null) {
			return "";
		}

		if (curry.indexOf(".") > 0)
			return curry.substring(0, curry.indexOf("."));
		else
			return curry;

	}

	public static void main(String[] args) {
		System.out.println(addBarToBankCardNo("9558801502203097716"));
	}

	// 获取系统自带的通讯录
	/**
	 * 删除String的所有空格(包括全角和半角), 回车符(\r),制表符(\t \x0B),换行符(\n),换页符(\f)
	 * 
	 * @param str
	 * @return String
	 */
	public static String removeAllSpace(String str) {
		if (iStr(str)) {
			// 全角空格的UniCode是12288,要先将所有的全角空格进行转化,然后替换所有空格
			String tempStr = str.replace((char) 12288, ' ');
			Pattern p = Pattern.compile("[　\\s\\p{Space}\\p{Blank}]*");
			Matcher m = p.matcher(tempStr);
			String s = m.replaceAll("");
			tempStr = null;
			return s;
		}
		return null;
	}

	// 获取系统自带的通讯录
	/**
	 * 只判断单个String是否为空(无论有没全角或半角的空格) 若非空则返回true,否则返回false
	 * 
	 * @param str
	 * @return boolean
	 */
	public static boolean iStr(String str) {
		if (!"".equals(str) && null != str)
			return true;
		return false;
	}

	/**
	 * 自动获取短信 匹配短信中间的4个数字（验证码等）
	 * 
	 * @param patternContent
	 * @return
	 */
	public static String patternCode(String patternContent) {
		if (TextUtils.isEmpty(patternContent)) {
			return null;
		}
		// 短信正则匹配验证码
		Pattern p = Pattern.compile(Constants.PATTERNCODER);
		Matcher matcher = p.matcher(patternContent);
		if (matcher.find()) {
			return matcher.group();
		}
		return null;
	}

	// 设置结算卡管理
	public static String f_default(String isDefault) {
		if ("Y".equals(isDefault)) {
			return "默认";
		} else {
			return "设为默认";
		}
	}

	/**
	 * 判断数据是否可显示
	 */
	public static boolean isShow(String values) {
		boolean flag = true;
		if (null == values || "null".equals(values) || isEmpty(values)) {
			flag = false;
		}
		return flag;
	}

	/**
	 * 判断字符串是否为空?
	 * 
	 * @author
	 * @param str
	 *            判断的字符串
	 */
	public static boolean isEmpty(String str) {
		if (str == null || str.equals("")) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 是否安装SD卡
	 */
	public static boolean hasSDCard() {
		String status = Environment.getExternalStorageState();
		if (!status.equals(Environment.MEDIA_MOUNTED)) {
			return false;
		}
		return true;
	}

	/**
	 * 获取根目录
	 */
	public static String getRootFilePath() {
		if (hasSDCard()) {
			return Environment.getExternalStorageDirectory().getAbsolutePath() + "/";// filePath:/sdcard/
		} else {
			return Environment.getDataDirectory().getAbsolutePath() + "/data/"; // filePath:
																				// /data/data/
		}
	}

	/** 是否有网 */
	public static boolean checkNetState(Context context) {
		boolean netstate = false;
		ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (connectivity != null) {
			NetworkInfo[] info = connectivity.getAllNetworkInfo();
			if (info != null) {
				for (int i = 0; i < info.length; i++) {
					if (info[i].getState() == NetworkInfo.State.CONNECTED) {
						netstate = true;
						break;
					}
				}
			}
		}
		return netstate;
	}

	public static Bitmap cutBitmap(Bitmap bitmap) {
		final float roundPx = 12;
		Bitmap outputBitmap = Bitmap.createBitmap(150, 150, Config.ARGB_8888);
		Canvas canvas = new Canvas(outputBitmap);
		final int color = 0xff424242;
		final Paint paint = new Paint();
		final Rect rect = new Rect(0, 0, 150, 150);
		final RectF rectF = new RectF(0, 0, 150, 150);
		paint.setAntiAlias(true);
		canvas.drawARGB(0, 0, 0, 0);
		paint.setDither(true); // 获取跟清晰的图像采样
		paint.setColor(color);
		canvas.drawRoundRect(rectF, roundPx, roundPx, paint);
		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);
		return outputBitmap;
	}
}
