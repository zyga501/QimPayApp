//
//  paihangTableViewCell.m
//  Theterritoryofpayment
//
//  Created by 铂金数据 on 15/11/10.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "paihangTableViewCell.h"
#import "Header.h"

@implementation paihangTableViewCell

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
    
    //排行榜
    
    self.rankNo=[[UILabel alloc] initWithFrame:CGRectMake(15*screenWidth/320, 8*screenWidth/320, 20*screenWidth/320, 20*screenWidth/320)];
    self.rankNo.textColor=[UIColor blackColor];
    self.rankNo.font=[UIFont systemFontOfSize:14*screenWidth/320];
    self.rankNo.textAlignment = NSTextAlignmentCenter;
//    self.rankNo.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.rankNo];
    
    
    self.merMp=[[UILabel alloc] initWithFrame:CGRectMake(130*screenWidth/320, 8*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
    self.merMp.textColor=[UIColor blackColor];
    self.merMp.font=[UIFont systemFontOfSize:12*screenWidth/320];
//    self.merMp.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.merMp];
    
//    
    self.merName=[[UILabel alloc] initWithFrame:CGRectMake(105*screenWidth/320, 8*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    self.merName.textColor=[UIColor blackColor];
    self.merName.font=[UIFont systemFontOfSize:12*screenWidth/320];
    [self.contentView addSubview:self.merName];
    
    
    
    self.transAmt=[[UILabel alloc] initWithFrame:CGRectMake(250*screenWidth/320, 8*screenWidth/320, 60*screenWidth/320, 20*screenWidth/320)];
    self.transAmt.textColor=[UIColor blackColor];
    self.transAmt.textAlignment=NSTextAlignmentRight;
//    self.transAmt.backgroundColor = [UIColor yellowColor];
    self.transAmt.font=[UIFont systemFontOfSize:14*screenWidth/320];
    [self.contentView addSubview:self.transAmt];
    
    
    //积分
    
    
    self.scoreOrdId=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 5*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    self.scoreOrdId.textColor=[UIColor blackColor];
    self.scoreOrdId.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.scoreOrdId];
    
    
    
    self.transDate=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 25*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    self.transDate.textColor=[UIColor grayColor];
    self.transDate.textAlignment=NSTextAlignmentLeft;
    self.transDate.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.transDate];
    
    self.transTime=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 25*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    self.transTime.textColor=[UIColor grayColor];
    self.transTime.font=[UIFont systemFontOfSize:14];
    //[self.contentView addSubview:self.transTime];
    
    
    
    self.scoreSrc=[[UILabel alloc] initWithFrame:CGRectMake(190*screenWidth/320, 25*screenWidth/320, 120*screenWidth/320, 20*screenWidth/320)];
    self.scoreSrc.textColor=[UIColor redColor];
//        self.scoreSrc.backgroundColor = [UIColor yellowColor];
    self.scoreSrc.textAlignment = NSTextAlignmentRight;
    
    self.scoreSrc.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.scoreSrc];
    
    
    
    self.transAmt1=[[UILabel alloc] initWithFrame:CGRectMake(170*screenWidth/320, 5*screenWidth/320, 130*screenWidth/320, 20*screenWidth/320)];
    self.transAmt1.textColor=[UIColor grayColor];
    self.transAmt1.textAlignment=NSTextAlignmentRight;
    self.transAmt1.font=[UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:self.transAmt1];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
