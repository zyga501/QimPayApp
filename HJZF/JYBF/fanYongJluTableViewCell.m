//
//  fanYongJluTableViewCell.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/28.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "fanYongJluTableViewCell.h"
#import "Header.h"
#import "User.h"

@implementation fanYongJluTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//@property(nonatomic,retain)UILabel *transDate;
//@property(nonatomic,retain)UILabel *transTime;
//@property(nonatomic,retain)UILabel *transMerName;
//@property(nonatomic,retain)UILabel *transMerId;
//@property(nonatomic,retain)UILabel *transAmt;
//@property(nonatomic,retain)UILabel *rebateAmt;
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
    self.transDate=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 5*screenWidth/320, 155*screenWidth/320, 20*screenWidth/320)];
    self.transDate.textColor=[UIColor blackColor];
    self.transDate.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.transDate];

    
    
    
    self.transTime=[[UILabel alloc] initWithFrame:CGRectMake(95*screenWidth/320, 5*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    self.transTime.textColor=[UIColor blackColor];
    self.transTime.font=[UIFont systemFontOfSize:13];
    //[self.contentView addSubview:self.transTime];
    
    
    
    
    self.transMerName=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 28*screenWidth/320, 50*screenWidth/320, 15*screenWidth/320)];
    self.transMerName.textColor=[UIColor grayColor];
    self.transMerName.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.transMerName];
    
    
    self.transPosTermNo=[[UILabel alloc] initWithFrame:CGRectMake(65*screenWidth/320, 28*screenWidth/320, 90*screenWidth/320, 15*screenWidth/320)];
    self.transPosTermNo.textColor=[UIColor grayColor];
    self.transPosTermNo.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.transPosTermNo];
    
    
    
    self.transAmt=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 5*screenWidth/320, 80*screenWidth/320, 15*screenWidth/320)];
    self.transAmt.textColor=[UIColor grayColor];
    self.transAmt.textAlignment=NSTextAlignmentRight;
    self.transAmt.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.transAmt];
    
    
    
    self.rebateAmt=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 25*screenWidth/320, 80*screenWidth/320, 15*screenWidth/320)];
    self.rebateAmt.textColor=[UIColor redColor];
    self.rebateAmt.textAlignment=NSTextAlignmentRight;
    self.rebateAmt.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.rebateAmt];
    
    
//    UILabel *aa=[[UILabel alloc] initWithFrame:CGRectMake(250*screenWidth/320, 22*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
//    aa.text=@"返佣:";
//      aa.font=[UIFont systemFontOfSize:12];
//    aa.textColor=[UIColor redColor];
//    [self.contentView addSubview:aa];

    
//    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(60*screenWidth/320, 21*screenWidth/320, 160*screenWidth/320, 20*screenWidth/320)];
//    la.text=@"(                     )";
//    la.font=[UIFont systemFontOfSize:12];
//    la.textColor=[UIColor lightGrayColor];
//    [self.contentView addSubview:la];
    
    
        
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
