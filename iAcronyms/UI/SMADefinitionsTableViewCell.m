//
//  SMADefinitionsTableViewCell.m
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/12/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import "SMADefinitionsTableViewCell.h"

@implementation SMADefinitionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"SMADefinitionsTableViewCell" bundle:[NSBundle mainBundle]];
}

- (void)prepareForReuse {
    self.longFormLabel.text = @"";
    self.usedSince.text = @"";
    self.frequency.text = @"";
}

@end
