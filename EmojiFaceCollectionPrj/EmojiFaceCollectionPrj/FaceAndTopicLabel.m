//
//  FaceAndTopicLabel.m
//  EmojiFaceCollectionPrj
//
//  Created by zhangchaoqun on 14-8-29.
//  Copyright (c) 2014年 zhangchaoqun. All rights reserved.
//

#import "FaceAndTopicLabel.h"
#import <CoreText/CoreText.h>
@interface FaceAndTopicLabel()
@property (nonatomic,strong) NSString * normalStr;
@property (nonatomic,strong) NSAttributedString * currentAttStr;


@end


@implementation FaceAndTopicLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTapHandel];
    }
    return self;
}
-(void)addTapHandel
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedOnLabelGesture:)];
    [self addGestureRecognizer:tap];
    
}
-(void)tapedOnLabelGesture:(UITapGestureRecognizer * )tap
{
    CGPoint location = [tap locationInView:self];
    NSLog(@"NSStringFromCGPoint %@",NSStringFromCGPoint(location));
    
    
    
    
    
    
}

-(NSAttributedString *)currentAttStr
{
    if (_currentAttStr) {
        [self createAttributedStr];
    }
    return _currentAttStr;
}

-(void)setText:(NSString *)text
{
    self.currentAttStr = nil;
    self.normalStr = text;

    
}


-(void)createAttributedStr
{
    NSString * text = self.normalStr;
//    if (text||[text length]==0)
//    {
//        return;
//    }
    
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSInteger totalLength = [text length];
    //处理topicArr
    for (NSString * topicStr in self.topicArr)
    {
        NSRange range = [text rangeOfString:topicStr];
        while (range.length>0)
        {
            //处理话题字符串
            [att addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor redColor] range:range];
            [att addAttribute:@"topicAtt" value:topicStr range:range];

            
            NSInteger startIndex = range.location+range.length;
            range = [text rangeOfString:topicStr options:NSCaseInsensitiveSearch range:NSMakeRange(startIndex, totalLength-startIndex)];
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
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
