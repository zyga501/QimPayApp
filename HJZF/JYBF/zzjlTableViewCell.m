//
//  zzjlTableViewCell.m
//  JYBF
//
//  Created by 王健超 on 15/10/23.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "zzjlTableViewCell.h"
#import "Header.h"
@implementation zzjlTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    self.timeString=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 5*screenWidth/320, 155*screenWidth/320, 20*screenWidth/320)];
    self.timeString.textColor=[UIColor blackColor];
    self.timeString.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.timeString];
    
    self.nameString=[[UILabel alloc] initWithFrame:CGRectMake(175*screenWidth/320, 5*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    self.nameString.textColor=[UIColor grayColor];
    
    [self.nameString setTextAlignment:NSTextAlignmentRight];
    self.nameString.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameString];
    
    
    
    self.telString=[[UILabel alloc] initWithFrame:CGRectMake(225*screenWidth/320, 5*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
    self.telString.textColor=[UIColor grayColor];
    self.telString.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.telString];
    self.telString.textAlignment = NSTextAlignmentLeft;
    
    self.numString=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 30*screenWidth/320, 100*screenWidth/320, 15*screenWidth/320)];
    self.numString.textColor=[UIColor lightGrayColor];
    self.numString.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.numString];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
