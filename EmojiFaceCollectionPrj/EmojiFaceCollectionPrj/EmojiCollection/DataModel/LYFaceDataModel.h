//
//  LYFaceModel.h
//  ShaiHuo
//
//  Created by 李言 on 14-8-13.
//  Copyright (c) 2014年 CBSi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum  {

    face_AppleType = 0

}LYFaceType;
@interface LYFaceDataModel : NSObject

@property (nonatomic,assign) int faceID; //表情id

@property (nonatomic,copy) NSString *faceName; //表情名称

@property (nonatomic,copy) NSString *faceFileName; //表情的文件名

@property (nonatomic,copy) NSString *faceURL;  //表情的链接

@property (nonatomic,copy) NSString *faceCode; //表情的编码

@property (nonatomic,assign) int facegroupid; //分组id

@property (nonatomic,assign) LYFaceType faceType; // 表情的类型

/**
 *	@brief	请求表情
 */
+(void)FaceListModelRequstWithControllerBlock:(void (^)(NSArray *dataArr, NSError *error))block
;
@end
