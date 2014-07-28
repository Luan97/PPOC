//
//  AbstractTextView.h
//  AKQAFacts
//
//  Created by Luan-Ling Chiang on 2/5/14.
//  Copyright (c) 2014 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractTextView : UITextView

-(void)setGlobalStyle;
-(void)setSize:(NSInteger)size;
-(void)setHtmlText:(NSString *)copy;

@end
