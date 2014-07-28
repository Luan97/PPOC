//
//  PPOCAppModel.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPOCAppModel : NSObject

@property (nonatomic, assign) int hitCount;

+ (id)sharedInstance;
- (void)parseData:(NSDictionary*) data;
- (void)fetchData;

@end


