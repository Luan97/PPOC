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

#pragma mark - Initilisation

- (id)initWithFrame:(CGRect)frame {
    
    
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self setGlobalStyle];
    [self setFont:font];
    self.backgroundColor=bgColor;
    self.textColor=labelColor;
    [self setUserInteractionEnabled:NO];
}


-(void)setText:(NSString *)text
{
    if([self respondsToSelector:@selector(attributedText)]){
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.minimumLineHeight = fsize+10;
        paragraph.maximumLineHeight = fsize+10;
        paragraph.lineHeightMultiple = fsize+10;
        NSMutableDictionary *attrsDictionary = [[NSMutableDictionary alloc] init];
        [attrsDictionary setObject:paragraph forKey:NSParagraphStyleAttributeName];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
        
        self.attributedText = attributedString;
        [self setFont:font];
    }else{
        [super setText:text];
    }
    
    if([self respondsToSelector:@selector(layoutManager)]){
        [self sizeToFit];
    }else{
        CGRect newFrame = self.frame;
        newFrame.size.height = self.contentSize.height;
        self.frame = newFrame;
    }
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
