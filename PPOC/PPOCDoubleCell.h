//
//  PPOCDoubleCell.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/29/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PPOCDoubleCell : UITableViewCell

@property (weak, nonatomic) NSDictionary* imageUrl;

@property (weak, nonatomic) NSDictionary* imageTwoUrl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet AsyncImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;

@property (weak, nonatomic) IBOutlet UILabel *titleLabelTwo;

@property (weak, nonatomic) IBOutlet AsyncImageView *imageTwo;

@property (weak, nonatomic) IBOutlet UILabel *dateLabelTwo;

@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;

@property (retain, nonatomic) UIView *colorBlock;
@property (retain, nonatomic) UIView *backgroundBlock;

@property (retain, nonatomic) UIView *colorBlockTwo;
@property (retain, nonatomic) UIView *backgroundBlockTwo;

- (IBAction)onButtonDown:(UIButton*)sender;

- (IBAction)onButtonUp:(UIButton*)sender;


-(void)loadThumb;


@end
