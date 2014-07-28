//
//  PPOCAppDelegate.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPOCAppModel.h"

@interface PPOCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) PPOCAppModel* model;

@end
