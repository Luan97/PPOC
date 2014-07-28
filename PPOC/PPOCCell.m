//
//  PPOCCell.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCCell.h"
#import "AbstractTextView.h"

@implementation PPOCCell
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize imageUrl=_imageUrl;
@synthesize image = _image;
@synthesize colorBlock = _colorBlock;
@synthesize backgroundBlock = _backgroundBlock;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(highlighted){
        [UIView animateWithDuration:0.15 animations:^{
            _titleLabel.textColor = [UIColor colorWithRed:(0/255.f) green:(120/255.f) blue:(174/255.f) alpha:1];
            _dateLabel.textColor = [UIColor colorWithRed:(92/255.f) green:(120/255.f) blue:(133/255.f) alpha:1];
            _backgroundBlock.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _colorBlock.alpha=0.6;
            [_colorBlock setFrame:CGRectMake(0, 0, 10, self.frame.size.height-1)];
        }];
        
    }else{
        [UIView animateWithDuration:0.15	 animations:^{
            _titleLabel.textColor = [UIColor blackColor];
            _dateLabel.textColor = [UIColor grayColor];
            _backgroundBlock.frame = CGRectMake(0, 0, 0, self.frame.size.height);
            _colorBlock.alpha=0.4;
            [_colorBlock setFrame:CGRectMake(0, 0, 4, self.frame.size.height-1)];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)loadThumb
{
    NSURL* imgUrl = [NSURL URLWithString:[_imageUrl objectForKey:@"square"]];
    _image.crossfadeDuration = 0;
	
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_image];
    
    //load the image
    _image.imageURL = imgUrl;
    
    //[_image setBackgroundColor:[UIColor blackColor]];
}


@end
