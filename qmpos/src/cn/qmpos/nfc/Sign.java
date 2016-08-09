package cn.qmpos.nfc;
import java.security.KeyFactory;
import java.security.Signature;
import java.security.interfaces.RSAPrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;



public class Sign {

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

	// ��˽Կ�Ա������ַ�������RSAǩ�� (�ڶ���)
	/**
	 * 
	 * @param signKey  ˽Կ
	 * @param src  �����ܵ�����
	 * @return  ���ܹ��������
	 * @throws Exception
	 */
	public static String sign(String src, String signKey)
			throws Exception {
		// ����������תΪbyte����
		byte[] data = src.getBytes("UTF-8");
		RSAPrivateKey priKey = createRSAPrivateKey(signKey);
		// ʵ����Signature
		Signature signature = Signature.getInstance("MD5withRSA");
		// ��ʼ��Signature
		signature.initSign(priKey);
		// ����
		signature.update(data);
		byte[] signB = signature.sign();
		return byte2hex(signB);
	}
	public static RSAPrivateKey createRSAPrivateKey(String priKey) throws Exception {
		byte[] keyBytes = Base64.decode(priKey, Base64.DEFAULT);
		PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(keyBytes);
		KeyFactory keyFactory = KeyFactory.getInstance("RSA");
		return (RSAPrivateKey) keyFactory.generatePrivate(keySpec);
	}
	public static String byte2hex(byte[] b) {
		char[] Digit = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A',
				'B', 'C', 'D', 'E', 'F' };
		char[] out = new char[b.length * 2];
		for (int i = 0; i < b.length; i++) {
			byte c = b[i];
			out[i * 2] = Digit[(c >>> 4) & 0X0F];
			out[i * 2 + 1] = Digit[c & 0X0F];
		}

		return new String(out);
	}
}
