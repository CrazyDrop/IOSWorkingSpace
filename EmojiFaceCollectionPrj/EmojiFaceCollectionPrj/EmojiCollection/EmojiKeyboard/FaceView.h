//
//  FaceView.h
//  ViewControllerTest
//
//  Created by 李言 on 14-8-11.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FaceKeyBoardHeight  220

@protocol getFaceDelegete <NSObject>
@required
/**
 *	@brief	点击表情的回调
 *
 *	@param 	faceName 	表情字符串
 */
-(void)ClickFaceName:(NSString *)faceName;
/**
 *	@brief	表情键盘的删除
 */
-(void)backFace;
@end

@interface FaceView : UIView<UIScrollViewDelegate>
{
    NSArray *color;
//    NSDictionary *_faceMap;
    UIPageControl *grayPageControl;
    
}

@property (nonatomic, weak)id<getFaceDelegete>delegate;
@property (nonatomic, strong)NSArray *showFaceModelArr;


+ (FaceView *)shareInstance;


@end
