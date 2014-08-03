//
//  PPOCDoubleCell.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/29/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCDoubleCell.h"

@implementation PPOCDoubleCell

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize imageUrl=_imageUrl;
@synthesize image = _image;
@synthesize colorBlock = _colorBlock;
@synthesize backgroundBlock = _backgroundBlock;

@synthesize titleLabelTwo = _titleLabelTwo;
@synthesize dateLabelTwo = _dateLabelTwo;
@synthesize imageTwoUrl=_imageTwoUrl;
@synthesize imageTwo = _imageTwo;
@synthesize colorBlockTwo = _colorBlockTwo;
@synthesize backgroundBlockTwo = _backgroundBlockTwo;


- (IBAction)onButtonDown:(UIButton*)sender {
    UILabel *title;
    UILabel *date;
    UIView *colorB;
    UIView *bgB;
    
    if(sender.tag%2==0){
        title = _titleLabel;
        date = _dateLabel;
        colorB = _colorBlock;
        bgB = _backgroundBlock;
    }else{
        title = _titleLabelTwo;
        date = _dateLabelTwo;
        colorB = _colorBlockTwo;
        bgB = _backgroundBlockTwo;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        title.textColor = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1];
        date.textColor = [UIColor colorWithRed:(92/255.f) green:(120/255.f) blue:(133/255.f) alpha:1];
        bgB.frame = CGRectMake(bgB.frame.origin.x, 0, self.frame.size.width/2, self.frame.size.height);
        colorB.alpha=0.7;
        [colorB setFrame:CGRectMake(colorB.frame.origin.x, 0, 10, self.frame.size.height-1)];
    }];

}

- (IBAction)onButtonUp:(UIButton*)sender {
    UILabel *title;
    UILabel *date;
    UIView *colorB;
    UIView *bgB;
     
    if(sender.tag%2==0){
        title = _titleLabel;
        date = _dateLabel;
        colorB = _colorBlock;
        bgB = _backgroundBlock;
    }else{
        title = _titleLabelTwo;
        date = _dateLabelTwo;
        colorB = _colorBlockTwo;
        bgB = _backgroundBlockTwo;
    }
    
    [UIView animateWithDuration:0.15 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        title.textColor = [UIColor blackColor];
        date.textColor = [UIColor grayColor];
        bgB.frame = CGRectMake(bgB.frame.origin.x, 0, 0, self.frame.size.height);
        colorB.alpha=0.4;
        [colorB setFrame:CGRectMake(colorB.frame.origin.x, 0, ((sender.tag%2)==0)?5:3, self.frame.size.height-1)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)loadThumb
{
    NSURL* imgUrl = [NSURL URLWithString:[_imageUrl objectForKey:@"square"]];
    _image.crossfadeDuration = 0;
    
    NSURL* imgTwoUrl = [NSURL URLWithString:[_imageTwoUrl objectForKey:@"square"]];
    _imageTwo.crossfadeDuration = 0;
	
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_image];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_imageTwo];
    
    //load the image
    _image.imageURL = imgUrl;
    _imageTwo.imageURL = imgTwoUrl;
    
    //[_image setBackgroundColor:[UIColor blackColor]];
}


@end
