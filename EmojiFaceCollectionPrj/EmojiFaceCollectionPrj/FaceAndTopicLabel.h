//
//  FaceAndTopicLabel.h
//  EmojiFaceCollectionPrj
//
//  Created by zhangchaoqun on 14-8-29.
//  Copyright (c) 2014年 zhangchaoqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceAndTopicLabel : UILabel
@property (nonatomic,copy) NSArray * topicArr;
@property (nonatomic,copy) void(^tapedOnTopicBlcok)(id data);
@property (nonatomic,copy) UIImage * (^faceImageForFaceNameBlock)(NSString *name);






@end
