package cn.qmpos.util;

/**
 * 公共类
 * 
 * @author rui.cheng
 * @create time: 2015-02-14
 */
public class Constants {
	public static String cookie = "";
	/**
	 * 公共的"是"和"否"
	 */
	public static final String PUBLIC_Y = "Y";
	public static final String PUBLIC_N = "N";

	/** 操作成功 */
	public static final String OK = "000000";

	/** 操作失败 */
	public static final String ERROR = "999999";

	/** 操作成功 */
	public static final String SERVER_SUCC = "000";

	/** 未登录 */
	public static final String SERVER_NO_LOGIN = "008";

	/** 系统异常 */
	public static final String SERVER_SYSERR = "998";

	/** 网络异常 */
	public static final String SERVER_NETERR = "999";

	/**
	 * 默认的误差：用于浮点运算
	 */
	public static double DEFAULT_DOUBLE_ERROR = 0.000001;

	/**
	 * 默认的误差：用于浮点运算
	 */
	public static double DEFAULT_DOUBLE_ERROR_SUB = -0.000001;

	// 广播过滤
	public static final String SSMS_ACTION = "android.provider.Telephony.SMS_RECEIVED";

	// 检验验证码正则
	public static final String PATTERNCODER = "(?<!\\d)\\d{4}(?!\\d)";

	// 企盟支付域名线上qimeng.pospt.cn
	public static String server_host = "http://qimeng.pospt.cn/mobile/ss/";
	public static String server_agent_id = "2000000063";

	// 企盟支付线上的
	// public static String server_host = "http://121.41.118.80/mobile/ss/";
	// public static String server_agent_id = "2000000063";

	// 企盟支付线下测试
	// public static String server_host = "http://192.168.2.155/mobile/ss/";
	// public static String server_agent_id = "1234567890";

	public static String server_version_url = "appVersion.do";
	public static String server_login_url = "login.do";
	public static String server_register_url = "register.do";
	public static String server_sendsms_url = "sendSms.do";
	public static String server_mobileexistverify_url = "mobileExistVerify.do";
	public static String server_createpay_url = "createPay.do";
	public static String server_createtgqrcode_url = "createTgQrCode.do";
	public static String server_doQrCode_url = "doQrCode.do";
	public static String server_dopay_url = "doPay.do";
	public static String server_doscore_url = "doScore.do";
	public static String server_queryscoreInList_url = "queryScoreInList.do";
	public static String server_smscodeverify_url = "smsCodeVerify.do";
	public static String server_updateLoginPwd_url = "updateLoginPwd.do";
	public static String server_updateTransPwd_url = "updateTransPwd.do";
	public static String server_queryMerInfo_url = "queryMerInfo.do";
	public static String server_queryLiqCard_url = "queryMerLiqCard.do";
	public static String server_doLiq_url = "doLiq.do";
	public static String server_rebateRollOut_url = "rebateRollOut.do";
	public static String server_queryMerBal_url = "queryMerBal.do";
	public static String server_bankCardBind_url = "bankCardBind.do";
	public static String server_applyAuthentication_url = "applyAuthentication.do";
	public static String server_uploadAttach_url = "uploadAttach.do";
	public static String server_queryPayList_url = "queryPayList.do";
	public static String server_queryLiqList_url = "queryCashList.do";
	public static String server_queryRebateInList_url = "queryRebateInList.do";
	public static String server_queryMerRegSubList_url = "queryMerRegSubList.do";
	public static String server_queryScoreBusList_url = "queryScoreBusList.do";

	public static String server_doGuide_url = "doGuide.do";
	public static String server_md5key = "1234567890";
	public static String server_doReg_url = "doReg.do";
	public static String server_bankCardDel_url = "bankCardDel.do";
	public static String server_bankCardDefault_url = "bankCardDefault.do";
	// 修改手机号
	public static String server_mobileModify_url = "mobileModify.do";
	// 上传头像
	public static String server_uploadFaceImg_url = "uploadFaceImg.do";
	// 根据手机号查询商户名称
	public static String server_queryMerNameByMobile_url = "queryMerNameByMobile.do";
	// 转账
	public static String server_doTrfToMer_url = "doTrfToMer.do";
	// 收款
	public static String server_createTrfQrCode_url = "createTrfQrCode.do";
	// 转账记录
	public static String server_queryTrfToMerList_url = "queryTrfToMerList.do";
	// 登录合作的H5网站，例如理财，基金等
	public static String server_extSysLogin_url = "extSysLogin.do";
	// 费率信息
	public static String server_queryMerFeeInfo_url = "queryMerFeeInfo.do";
	// 商户积分排行榜查询接口
	public static String server_queryScoreTotList_url = "queryScoreTotList.do";
	// 收款二维码
	public static String server_doRecvQrCode_url = "doRecvQrCode.do";
	// NFC卡号
	public static String server_queryMerTransCard_url = "queryMerTransCard.do";

}
