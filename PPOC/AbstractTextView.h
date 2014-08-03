//
//  AbstractTextView.h
//  AKQAFacts
//
//  Created by Luan-Ling Chiang on 2/5/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractTextView : UITextView

-(void)setGlobalStyle;
-(void)setText:(NSString *)text;
-(void)setSize:(NSInteger)size;
-(void)setHtmlText:(NSString *)copy;

@end
