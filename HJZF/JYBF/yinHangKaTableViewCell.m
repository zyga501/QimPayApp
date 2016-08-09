//
//  yinHangKaTableViewCell.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/28.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "yinHangKaTableViewCell.h"
#import "Header.h"
@implementation yinHangKaTableViewCell

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
    self.openBankName=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 5*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    self.openBankName.textColor=[UIColor grayColor];
    self.openBankName.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.openBankName];
    
    
    
    self.openAcctId=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 30*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    self.openAcctId.textColor=[UIColor grayColor];
//    self.openAcctId.backgroundColor=[UIColor yellowColor];
    self.openAcctId.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.openAcctId];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
