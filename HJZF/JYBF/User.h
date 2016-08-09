//
//  User.h
//  SquadronLeader
//
//  Created by 6217 on 15/1/22.
//  Copyright (c) 2015年 6217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>


@property (nonatomic,retain)NSString * phoneText;
//登录密码
@property (nonatomic,retain)NSString * yuanText;
//交易密码
@property (nonatomic,retain)NSString * yanText;

@property (nonatomic,retain)NSString * date;


@property (nonatomic,retain)NSString * shouxu;
@property (nonatomic,retain)NSString * dingDan;
@property (nonatomic,retain)NSString * pingZheng;


@property (nonatomic,retain)NSString * ming;

@property (nonatomic,retain)NSString * name;

@property (nonatomic,retain)NSString * headImage;
@property (nonatomic,retain)NSString * str;

@property (nonatomic,retain)NSString * merid;



@property (nonatomic,retain)NSString * xia;

@property (nonatomic,retain)NSString * url;

@property (nonatomic,retain)NSString * one;
@property (nonatomic,retain)NSString * two;
@property (nonatomic,retain)NSString * three;
@property (nonatomic,retain)NSString * four;

@property (nonatomic,retain)NSString * six;
@property (nonatomic,retain)NSString * seven;
@property (nonatomic,retain)NSString * eight;
@property (nonatomic,retain)NSString * nine;
@property (nonatomic,retain)NSString * ten;
@property (nonatomic,retain)NSString * eleven;


@property (nonatomic,retain)NSString * yu;
@property (nonatomic,retain)NSString * KYyue;
@property (nonatomic,retain)NSString * KTyue;
@property(nonatomic ,retain)NSString *totAmtT1;
@property (nonatomic,retain)NSString * fanYong;
@property (nonatomic,retain)NSString * jiFen;
@property (nonatomic,retain)NSString * Yue;


@property (nonatomic,retain)NSString * jiekahao;
@property (nonatomic,retain)NSString * kaname;
@property (nonatomic,retain)NSString * kaBian;
@property (nonatomic,retain)NSString *  text;


//T0是否开通
@property (nonatomic,retain)NSString * tZero;


@property (nonatomic,retain)NSString * sm;
@property (nonatomic,retain)NSString * sm1;
@property (nonatomic,retain)NSString * bian;

@property (nonatomic,retain)NSString * sx;

@property (nonatomic,retain)NSString * uid;

//交易状态
@property (nonatomic,retain)NSString * stat;


@property (nonatomic,retain)NSString * yanoK;

@property (nonatomic,retain)NSString * i;
//判断t0是否开通
@property (nonatomic,retain)NSString * xuant;
//通讯录手机号码传值
@property (nonatomic,retain)NSString * tongxun;

//借记卡T1
@property (nonatomic,retain)NSString * jieji1;

//借记卡T2
@property (nonatomic,retain)NSString * jieji2;

//贷记卡
@property (nonatomic,retain)NSString * daiji;

//版本号
@property (nonatomic,retain)NSString * banBen;

//收款金额
@property (nonatomic,retain)NSString * numJin;


//银行卡是否默认
@property(nonatomic,retain)NSString *moren;
//结算卡编号
@property(nonatomic,retain)NSString *moRenNun;

//地理位置
@property(nonatomic,retain)NSString *jing;
@property(nonatomic,retain)NSString *wei;

//版本
@property(nonatomic,retain)NSString *URL;
@property(nonatomic,retain)NSString *BenDiBanBen;
+ (id)currentUser;
@end
