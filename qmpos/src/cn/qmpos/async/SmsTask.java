package cn.qmpos.async;

import java.util.HashMap;

import android.os.AsyncTask;
import cn.qmpos.util.Constants;
import cn.qmpos.util.MD5Hash;

public class SmsTask extends AsyncTask<String, Integer, String> {
	
	private String mobile;
	
	public SmsTask(String mobile){
		this.mobile = mobile;
	}
	
	protected void onPreExecute() {  
	}  

	
	protected String doInBackground(String... params) {
		try{
			MD5Hash m = new MD5Hash();
			String signMsg= Constants.server_agent_id + mobile + "00" + "" + Constants.server_md5key;
			String chkValue = m.getMD5ofStr(signMsg);
			
			HashMap<String, String> map = new HashMap<String, String>();
	        map.put("agentId", Constants.server_agent_id);
	        map.put("loginId", mobile);
	        map.put("smsType", "00");
	        map.put("smsCon", "");
	        map.put("chkValue", chkValue);
	        String requestUrl = Constants.server_host + Constants.server_sendsms_url;
	        String responseStr = cn.qmpos.http.HttpRequest.getResponse(requestUrl, map);
	        System.out.println("http:" + responseStr);
    		return responseStr;
		}catch(Exception e){
			e.printStackTrace();
			return Constants.ERROR;
		}
	}
	
	protected void onPostExecute(String result) {
		
	}
}
