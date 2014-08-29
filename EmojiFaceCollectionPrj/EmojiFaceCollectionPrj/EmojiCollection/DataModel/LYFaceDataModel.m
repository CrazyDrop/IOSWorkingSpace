//
//  LYFaceModel.m
//  ShaiHuo
//
//  Created by 李言 on 14-8-13.
//  Copyright (c) 2014年 CBSi. All rights reserved.
//

#import "LYFaceDataModel.h"
#import "AFAPPHTTPClient.h"
#import "JSONKit.h"
#import "RequestDefine.h"
#import "Constant.h"
@implementation LYFaceDataModel
-(id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
  
    if([attributes isKindOfClass:[NSDictionary class]]){
        
        
        self.faceID = [[attributes objectForKey:@"smiid"]  intValue];
        self.faceName = [attributes objectForKey:@"code"];
        self.faceType = [[attributes objectForKey:@"type"] intValue];
        self.faceURL = [attributes objectForKey:@"img"];
        self.facegroupid = [[attributes objectForKey:@"groupid"]  intValue];
        self.faceCode = @"";
    
    }
//    self.faceID =
//    self.faceURL=
//    self.faceCode=
//    self.faceType=
    
    
    return self;
}



+(void)FaceListModelRequstWithControllerBlock:(void (^)(NSArray *dataArr, NSError *error))block{

    NSString * path = [NSString stringWithFormat:@"%@&%@=%d&etype=1",DEFAULT_HTTP_SERVER_PATH,URLREQUEST_ARGV_REQUEST_ID,URLREQUEST_ID_FACE];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:@"1" forKey:@"etype"];
//    [dic setValue:[NSString stringWithFormat:@"%d",URLREQUEST_ID_FACE] forKey:URLREQUEST_ARGV_REQUEST_ID];
    
    AFAPPHTTPClient * client = [AFAPPHTTPClient sharedClient];
    [client getPath:path
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, NSData * responseObject){
                id object = [responseObject objectFromJSONData];
                if ([object isKindOfClass:[NSDictionary class]]){
                    NSDictionary *modeldic =[object objectForKey:@"de"];
                    NSArray *modelarray = [modeldic objectForKey:@"smi"];
                    if (modelarray && [modelarray isKindOfClass:[NSArray class]]){
                    
                     NSMutableArray * modelArr = [NSMutableArray array];
                        for (NSDictionary * dic in modelarray)
                        {
                            LYFaceDataModel * model = [[LYFaceDataModel alloc] initWithAttributes:dic];
                            [modelArr addObject:model];
                        }
                        if (block)
                        {
                            block(modelArr,nil);
                        }

                    
                    }
                
                }
               
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (block)
                {
                    block(nil,error);
                }
            }];




}
@end
