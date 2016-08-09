//
//  addCardTableViewCell.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/14.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "addCardTableViewCell.h"
#import "Header.h"
@implementation addCardTableViewCell

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
    
    
    self.cardImage=[[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 10*screenWidth/320.0, 300*screenWidth/320.0, 80*screenWidth/320.0)];
    self.cardImage.image=[UIImage imageNamed:@""];
    [self.contentView addSubview:self.cardImage];
    
    
    self. openAcctId=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 50*screenWidth/320, 200*screenWidth/320, 30*screenWidth/320)];
    self.openAcctId.textColor=[UIColor whiteColor];
    //self.openAcctId.backgroundColor=[UIColor yellowColor];
    self.openAcctId.font=[UIFont boldSystemFontOfSize:15];
    [self.cardImage addSubview:self.openAcctId];
    
    
    
    self.openAcctName=[[UILabel alloc] initWithFrame:CGRectMake(160*screenWidth/320, 50*screenWidth/320, 80*screenWidth/320, 30*screenWidth/320)];
    self.openAcctName.textColor=[UIColor whiteColor];
   
    self.openAcctName.font=[UIFont boldSystemFontOfSize:15];
    [self.cardImage addSubview:self.openAcctName];
    
        self.isDefault=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 50*screenWidth/320, 70*screenWidth/320, 30*screenWidth/320)];
    self.isDefault.textColor=[UIColor whiteColor];
  self.isDefault.textAlignment=NSTextAlignmentRight;
    self.isDefault.font=[UIFont boldSystemFontOfSize:15];
    [self.cardImage addSubview:self.isDefault];
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
