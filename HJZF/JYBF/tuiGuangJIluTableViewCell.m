//
//  tuiGuangJIluTableViewCell.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/24.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "tuiGuangJIluTableViewCell.h"
#import "User.h"
#import "Header.h"
@implementation tuiGuangJIluTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.transDate=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 5*screenWidth/320, 170*screenWidth/320, 20*screenWidth/320)];
    self.transDate.textColor=[UIColor grayColor];
    self.transDate.textAlignment=NSTextAlignmentLeft;
    self.transDate.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.transDate];
    
    self.transTime=[[UILabel alloc] initWithFrame:CGRectMake(90*screenWidth/320, 5*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    self.transTime.textColor=[UIColor grayColor];
    self.transTime.font=[UIFont systemFontOfSize:14];
    //[self.contentView addSubview:self.transTime];
    
    
    
    self.regMerName=[[UILabel alloc] initWithFrame:CGRectMake(165*screenWidth/320, 5*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    self.regMerName.textColor=[UIColor grayColor];
   
    [self.regMerName setTextAlignment:NSTextAlignmentRight];
    self.regMerName.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.regMerName];
    
    
    
    self.regMobile=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 5*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
    self.regMobile.textColor=[UIColor grayColor];
    self.regMobile.font=[UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:self.regMobile];
  
 //   User *user=[User currentUser];
    self.isFirstTrans=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 28*screenWidth/320, 100*screenWidth/320, 15*screenWidth/320)];
    self.isFirstTrans.textColor=[UIColor lightGrayColor];
    self.isFirstTrans.textAlignment=NSTextAlignmentLeft;
    self.isFirstTrans.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.isFirstTrans];

    
    
    self.isAuthentication=[[UILabel alloc] initWithFrame:CGRectMake(250*screenWidth/320, 28*screenWidth/320, 50*screenWidth/320, 15*screenWidth/320)];
    self.isAuthentication.textColor=[UIColor redColor];
    self.isAuthentication.textAlignment=NSTextAlignmentRight;
    self.isAuthentication.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.isAuthentication];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
