//
// Header.h
//  The territory of payment
//
//  Created by 铂金数据 on 15/3/24.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#ifndef The_territory_of_payment_Header_h
#define The_territory_of_payment_Header_h

//屏幕适配的宏
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width


//接口
#define url2 @"/login.do"
#define url3 @"/register.do"
#define url4 @"/sendSms.do"
#define url5 @"/smsCodeVerify.do"
#define url6 @"/mobileExistVerify.do"
#define url7 @"/updateLoginPwd.do"
#define url8 @"/updateTransPwd.do"
#define url11 @"/queryMerInfo.do"
#define url12 @"/queryScoreInList.do"   ///积分记录
#define url13 @"/queryMerBal.do"
#define url013 @"/queryMerLiqCard.do"
#define url14 @"/createPay.do"
#define url15 @"/doQrCode.do"
#define url16 @"/doPay.do"
#define url17 @"/doLiq.do"
#define url21 @"/rebateRollOut.do"
#define url27 @"/appVersion.do"
#define url06 @"/bankCardBind.do"
#define url07 @"/uploadAttach.do"
#define url08 @"/applyAuthentication.do"
#define url20 @"/queryCashList.do"
#define url28 @"/queryMerRegSubList.do"
#define url021 @"/queryPayList.do"
#define url24 @"/queryRebateInList.do"
#define url26 @"/bankCardDefault.do"
#define url30 @"/bankCardDel.do"
#define url25 @"/appVersion.do"
#define url31 @"/mobileModify.do"
#define url32 @"/queryMerNameByMobile.do"//根据手机号查询
#define url33 @"/doTrfToMer.do"//转账接口
#define url34 @"/createTrfQrCode.do"//收款二维码产生
#define url35 @"/extSysLogin.do"  //推广二维码产生  第三方链接
#define url36 @"/queryTrfToMerList.do"   //转账列表
#define url37 @"/queryMerFeeInfo.do"  //费率查询
#define url40 @"/doRecvQrCode.do"   //固定二维码
#define url39 @"/queryScoreTotList.do"    //积分排行榜

#define url1 @"http://121.41.118.80/mobile/ss"
#define can @"2000000063"
#endif
