//
//  SMALongForm.h
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/11/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMALongForm : NSObject

@property (nonatomic, strong) NSString *longForm;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) NSString *since;
@property (nonatomic, strong) NSArray *variations;

@end
