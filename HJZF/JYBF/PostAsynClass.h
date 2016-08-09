//
//  PostAsynClass.h
//  PostAsyn
//
//  Created by llz on 14-9-27.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostAsynClass : NSObject
+(NSMutableURLRequest*)postAsynWithURL:(NSString*)url andInterface:(NSString*)newInterface andKeyArr:(NSArray*)newKeyArr andValueArr:(NSArray*)newValueArr;
@end
