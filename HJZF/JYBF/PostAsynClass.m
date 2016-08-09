//
//  PostAsynClass.m
//  PostAsyn
//
//  Created by llz on 14-9-27.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import "PostAsynClass.h"

@implementation PostAsynClass
+(NSMutableURLRequest*)postAsynWithURL:(NSString *)url andInterface:(NSString *)newInterface andKeyArr:(NSArray *)newKeyArr andValueArr:(NSArray *)newValueArr
{
    //1、准备url
    NSString *urlStr = url;
    
    //2、准备接口
    NSString *interface = newInterface;
    
    //3、准备key、value数组
    NSArray *keyArr = newKeyArr;
    NSArray *valueArr = newValueArr;
    
    //4、准备两个可变字符串，一个存url+interface，一个存key、value
    NSMutableString *reqStr = [NSMutableString stringWithCapacity:0];
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    
    //5、拼url+interface
    [reqStr appendString:urlStr];
    [reqStr appendString:interface];
    NSLog(@"%@",urlStr);
    NSLog(@"%@",interface);
    //6、拼key+value
    for(int i = 0;i<keyArr.count;i++)
    {
        [paStr appendFormat:@"%@=%@",keyArr[i],valueArr[i]];
        if(i<keyArr.count-1)
        {
            [paStr appendString:@"&"];
        }
    }
    NSLog(@"%@",paStr);
  
//    //7、把paStr变成data
//    NSData *paData = [paStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //8、准备请求体
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    //7、把paStr变成data
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    NSData *paData = [paStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:enc];
    
    
    //8、准备请求体
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqStr] cachePolicy:nil timeoutInterval:30];
    

    //9、设置请求体
    [req setHTTPBody:paData];
    [req setHTTPMethod:@"POST"];
    
    return req;
}
@end
