//
//  FaceDetailView.m
//  ViewControllerTest
//
//  Created by 李言 on 14-8-11.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "FaceDetailView.h"
#import "YRTools.h"
#import "LYFaceDataModel.h"
#define NumPerLine 6
#define Lines    3
#define FaceSize  36
/*
 ** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 20
#import "FaceView.h"
#import "FaceDataManager.h"
#import "Constant.h"
#import "FaceView.h"
@interface FaceDetailView()
@property (nonatomic,strong) NSArray * buttonArray;
@end

@implementation FaceDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        faceMap = [NSDictionary dictionaryWithContentsOfFile:
//                   [[NSBundle mainBundle] pathForResource:@"Emoji"
//                                                   ofType:@"plist"]];
        
        
        [self initSelfSubViews];
    }
    return self;
}

-(void)initSelfSubViews
{
    // 水平间隔
    CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSize -2*EdgeDistance)/(NumPerLine-1);
    // 上下垂直间隔
    CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSize)/(Lines-1);
 
    
    
    NSMutableArray * dataArray = [NSMutableArray array];
    for (int i = 0; i<Lines; i++)
    {
        for (int x = 0;x<NumPerLine;x++)
        {
//            if ([faceMap count] > index*(NumPerLine*Lines-1)+i*NumPerLine+x+1)
            {
                
                
                UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:expressionButton];
                
             
                [expressionButton setFrame:CGRectMake(x*FaceSize+EdgeDistance+x*horizontalInterval,
                                                      i*FaceSize +i*verticalInterval+EdgeInterVal,
                                                      FaceSize,
                                                      FaceSize)];
                   expressionButton.imageEdgeInsets = UIEdgeInsetsMake(6,6,6,6);
                [dataArray addObject:expressionButton];
                
            }
        }
    }
    
    self.buttonArray = dataArray;

}


-(void)layOutFaceView:(NSInteger)index
{
    
    
    for (int i=0 ;i< [self.buttonArray count];i++ )
    {
        UIButton * expressionButton = [self.buttonArray objectAtIndex:i];
        
        if (i == NumPerLine*Lines-1) {
            [expressionButton setImage:[UIImage imageNamed:@"表情delete"]
                                        forState:UIControlStateNormal];
          //  expressionButton.tag = 0;
            [expressionButton addTarget:self
                                 action:@selector(backClick:)
                       forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
            expressionButton.hidden = NO;
            NSInteger indexNum = index*(NumPerLine*Lines-1)+i;
            NSArray * dataArr = self.faceArr;
            if ([dataArr count]>indexNum)
            {
                LYFaceDataModel *model = [dataArr objectAtIndex:indexNum];
                NSString *imageStr = [model.faceName md5HexDigest];
//                NSLog(@"%@"  ,[FaceImageDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageStr]]);
                [expressionButton setImage:[UIImage imageWithContentsOfFile:[FaceImageDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageStr]]]
                                            forState:UIControlStateNormal];
                
                expressionButton.tag = (NumPerLine*Lines-1)*index+i;
                [expressionButton addTarget:self
                                     action:@selector(faceClick:)
                           forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                expressionButton.hidden = YES;
            }
            

        }
  
    }
    
    
    
    
}

-(void)backClick:(id)sender{
    if ( self.BackFace) {
         self.BackFace();
    }
 

}

- (void)faceClick:(id)sender {
    
    long i = ((UIButton*)sender).tag;

    
    if (self.ClickFaceButton) {
         LYFaceDataModel *model = [self.faceArr objectAtIndex:i];
        self.ClickFaceButton(model.faceName);
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
