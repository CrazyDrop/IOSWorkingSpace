//
//  FaceDetailView.h
//  ViewControllerTest
//
//  Created by 李言 on 14-8-11.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceDetailView : UIView

{
//    NSDictionary *faceMap;// 表情字典
    
}


@property (nonatomic,strong)NSArray *faceArr;
/**
 *	@brief	刷新View
 *
 *	@param 	index 	当前view 的index
 */
-(void)layOutFaceView:(NSInteger)index;

/**
 *	@brief	点击表情的block
 */
@property (nonatomic, strong)void (^ClickFaceButton) (NSString * facename);

/**
 *	@brief	点击删除的block
 */
@property (nonatomic, strong)void (^BackFace)();


@end
