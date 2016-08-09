//
//  User.m
//  SquadronLeader
//
//  Created by 6217 on 15/1/22.
//  Copyright (c) 2015年 6217. All rights reserved.
//

#import "User.h"

@implementation User

+ (id)currentUser
{
    static User * user = nil;
    if (user == nil) {
        user = [[User alloc]init];
    }
    return user;
}


//归档时调用该方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
//反归档时调用该方法
- (id)initWithCoder:(NSCoder *)aDecoder
{
    User * user = [[User alloc] init];
    
    return user;
}


@end
