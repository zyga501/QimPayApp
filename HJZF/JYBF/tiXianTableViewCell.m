//
//  tiXianTableViewCell.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/28.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "tiXianTableViewCell.h"
#import "User.h"
#import "Header.h"

@implementation tiXianTableViewCell

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
    
    self.openAcctId=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 3*screenWidth/320, 170*screenWidth/320, 20*screenWidth/320)];
    self.openAcctId.textColor=[UIColor blackColor];
    self.openAcctId.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.openAcctId];
    
    
    self.createDate=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 17*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    self.createDate.textColor=[UIColor lightGrayColor];
    self.createDate.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.createDate];
    
    
    
    self.createTime=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320, 17*screenWidth/320, 70*screenWidth/320, 20*screenWidth/320)];
    self.createTime.textColor=[UIColor lightGrayColor];
    self.createTime.font=[UIFont systemFontOfSize:12];
    //[self.contentView addSubview:self.createTime];
    
    
    self.transAmt=[[UILabel alloc] initWithFrame:CGRectMake(250*screenWidth/320, 3*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    self.transAmt.textColor=[UIColor blackColor];
    self.transAmt.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.transAmt];
    
    
    
    self.transStat=[[UILabel alloc] initWithFrame:CGRectMake(270*screenWidth/320, 17*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    self.transStat.textColor=[UIColor redColor];
    self.transStat.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.transStat];

    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
