//
//  PPOCCell.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PPOCCell : UITableViewCell

@property (weak, nonatomic) NSDictionary* imageUrl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet AsyncImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (retain, nonatomic) UIView *colorBlock;
@property (retain, nonatomic) UIView *backgroundBlock;

-(void)loadThumb;

@end
