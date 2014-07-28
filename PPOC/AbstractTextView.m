//
//  AbstractTextView.m
//  AKQAFacts
//
//  Created by Luan-Ling Chiang on 2/5/14.
//  Copyright (c) 2014 AKQA. All rights reserved.
//

#import "AbstractTextView.h"

@interface AbstractTextView(){
    UIFont *font;
    UIColor *bgColor;
    UIColor *labelColor;
    NSInteger fsize;
}
@end

@implementation AbstractTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setGlobalStyle];
        [self setFont:font];
        self.backgroundColor=bgColor;
        self.textColor=labelColor;
        //self.text = @"Title";
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    if([self respondsToSelector:@selector(layoutManager)]){
        [self sizeToFit];
    }else{
        CGRect newFrame = self.frame;
        newFrame.size.height = self.contentSize.height;
        NSLog(@"??? %f", self.contentSize.height);
        self.frame = newFrame;
    }
    
    
    //[self sizeToFit];
    
}

-(void)setSize:(NSInteger)size{
    fsize = size;
    font = [UIFont fontWithName:@"Helvetica" size:fsize];
    [self setFont:font];
}

-(void)setGlobalStyle{
    font = [UIFont fontWithName:@"Helvetica" size:14];
    bgColor=[UIColor clearColor];
    labelColor=[UIColor blackColor];
}

-(void)setHtmlText:(NSString *)copy{
    //NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[copy dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attributedString.length)];
    
    self.attributedText = attributedString;
    
    [self setUserInteractionEnabled:NO];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
