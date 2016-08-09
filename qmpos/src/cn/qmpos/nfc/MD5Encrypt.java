package cn.qmpos.nfc;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Title: MD5�����㷨
 *
 */
public class MD5Encrypt {

	/** ���� */
	private static String ENCODE = "UTF-8";
	
	/**
	 * MD5ǩ��
	 * @param signSrc �������ǩ��������
	 * @param md5Key ǩ����key
	 * @return MD5ǩ������
	 * @throws NoSuchAlgorithmException
	 * @throws UnsupportedEncodingException
	 */
	public static String sign(String signSrc, String md5Key) throws NoSuchAlgorithmException, UnsupportedEncodingException{
		/********MD5ǩ��*********/
		String signmd5Src = signSrc + "&KEY="+md5Key;
		String signmd5 = MD5Encrypt.getMessageDigest(signmd5Src);
		return signmd5;
	}
	
	
	/**
	 * ���ܣ�MD5����
	 * @param strSrc ���ܵ�Դ�ַ���
	 * @return ���ܴ� ����32λ(hex��)
	 * @throws NoSuchAlgorithmException 
	 * @throws UnsupportedEncodingException 
	 */
	public static String getMessageDigest(String strSrc) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		MessageDigest md = null;
		String strDes = "";
		final String ALGO_MD5 = "MD5";

		byte[] bt = strSrc.getBytes(ENCODE);
		md = MessageDigest.getInstance(ALGO_MD5);
		md.update(bt);
		strDes = byte2hex(md.digest());
		return strDes;
	}
	
	/**
	 * ���ֽ�����תΪHEX�ַ���(16���ƴ�)
	 * 
	 * @param b Ҫת�����ֽ�����
	 * @return ת�����HEX��
	 */
	public static String byte2hex(byte[] b) {
		char[] digit = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
		char[] out = new char[b.length * 2];
		for (int i = 0; i < b.length; i++) {
			byte c = b[i];
			out[i * 2] = digit[(c >>> 4) & 0X0F];
			out[i * 2 + 1] = digit[c & 0X0F];
		}

		return new String(out);
	}

	
	// ����ǩ��������(��һ����
	/**
	 * 
	 * @param str
	 *            ��Ҫ���������
	 * @return
	 */
	public static String signJsonStringSort(String str) {
		JSONArray ja = null;
		String endString = "";
		ArrayList<String> array = new ArrayList<String>();
		try {

			JSONObject newJo = new JSONObject(str);
			ja = newJo.names();

			for (int i = 0; i < ja.length(); i++) {
				array.add(ja.getString(i));
			}
			Collections.sort(array, new Comparator<String>() {
				@Override
				public int compare(String o1, String o2) {
					return o1.compareToIgnoreCase(o2);
				}
			});

			for (int j = 0; j < array.size(); j++) {
				endString += array.get(j) + "=" + newJo.getString(array.get(j))
						+ "&";
				if (j == array.size() - 1) {
					endString = endString.substring(0,
							endString.lastIndexOf("&"));
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return endString;

	}
	
}
