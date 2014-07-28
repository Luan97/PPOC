//
//  PPOCImageModalViewController.h
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/27/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PPOCImageModalViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (retain, nonatomic) UIScrollView *imageZoomScroll;
@property (retain, nonatomic) AsyncImageView *imageZoom;
@property (retain, nonatomic) NSURL *imageUrl;

- (IBAction)unwindToDetailView:(id)sender;

@end
