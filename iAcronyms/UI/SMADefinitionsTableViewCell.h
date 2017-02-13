//
//  SMADefinitionsTableViewCell.h
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/12/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMADefinitionsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *longFormLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedSince;
@property (weak, nonatomic) IBOutlet UILabel *frequency;

+ (UINib *)nib;

@end
