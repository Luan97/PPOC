//
//  PPOCDetailViewController.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/24/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Results.h"
#import "AsyncImageView.h"
#import "AbstractTextView.h"

@interface PPOCDetailViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) Results* result;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet AsyncImageView *heroImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (retain, nonatomic) AbstractTextView * titleLabel;
@property (retain, nonatomic) AbstractTextView * createdLabel;
@property (retain, nonatomic) AbstractTextView * modifiedLabel;
@property (retain, nonatomic) AbstractTextView * creatorLabel;
@property (retain, nonatomic) AbstractTextView * mediumLabel;
@property (retain, nonatomic) AbstractTextView * pkLabel;

@end
