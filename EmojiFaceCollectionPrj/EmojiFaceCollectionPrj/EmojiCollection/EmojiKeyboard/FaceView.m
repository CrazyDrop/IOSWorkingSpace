//
//  FaceView.m
//  ViewControllerTest
//
//  Created by 李言 on 14-8-11.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "FaceView.h"
#import "FaceDetailView.h"
#import "FaceDataManager.h"
#import "MQHCONST.h"
#import "LYFaceDataModel.h"
#import "SHDataStorage.h"
@interface FaceView()
{
    int totalPage;
    UIScrollView * scroll;
    NSMutableArray *firstArray ;
    NSMutableArray *secondArray ;
    
    UIButton *lastBtn;
}
-(void)reloadFaceView;
@property (nonatomic,strong) NSArray * viewArr;
@end
@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showFaceModelArr =[[NSArray alloc] init];
       self.frame = CGRectMake(0, 0, 320, FaceKeyBoardHeight);
        if ([[FaceDataManager shareFaceDataManager].faceModelArray count]==0||[[FaceDataManager shareFaceDataManager].faceNameArray count ]==0) {
            [[FaceDataManager shareFaceDataManager].faceNameArray removeAllObjects];
            [[FaceDataManager shareFaceDataManager].faceModelArray removeAllObjects];
            NSArray * array = [[SHDataStorage shareInstance] getFaceDataModelArray];
            for (LYFaceDataModel *model in array) {
                [ [FaceDataManager shareFaceDataManager].faceNameArray  addObject:model.faceName];
                [[FaceDataManager shareFaceDataManager].faceModelArray  addObject:model];
            }
        }
        
        
   
        [self initBottomFaceView];
        
    }
    return self;
}

-(void)initfaceView:(NSArray *)faceArray{
    if ([faceArray count]%17 == 0) {
         totalPage = (int) ([faceArray count]/17 );
    }else{
         totalPage = (int) ([faceArray count]/17 +1);
    }
   

    grayPageControl.numberOfPages = totalPage;
     _showFaceModelArr = faceArray;
    [self reloadFaceView];
    
    [self prepareForPage:0];
    
    scroll.contentSize = CGSizeMake(scroll.bounds.size.width*totalPage, scroll.bounds.size.height);
   

}
-(void)faceTabClick:(UIButton *)sender{
    lastBtn.selected =NO;
    sender.selected = YES;
    lastBtn = sender;
    
    
    if (sender.tag == 1) {
        [self initfaceView:firstArray];
    }
    if (sender.tag == 2) {
        [self initfaceView:secondArray];
    }
  
  


}

-(void)initBottomFaceView{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lineView.backgroundColor = [YRTools colorWithHexColorString:@"bfbfbf"];
    self.backgroundColor = [YRTools colorWithHexColorString:@"f8f8f8"];
    
    [self addSubview:lineView];
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 180)];
    [self addSubview:scroll];
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0;i<3 ;i++ )
    {
        CGRect eveRect = CGRectMake(0+i*scroll.bounds.size.width, 0, scroll.bounds.size.width, scroll.bounds.size.height);
        FaceDetailView * aView = [[FaceDetailView alloc] initWithFrame:eveRect];
        [scroll addSubview:aView];
        [array addObject:aView];
        
        aView.ClickFaceButton  =^(NSString * facename){
            
            [self.delegate ClickFaceName:facename];
        };
        
        aView.BackFace = ^{
            [self.delegate backFace];
            
        };
    }
    self.viewArr = array;
    
    
    //添加PageControl
    grayPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, self.bounds.size.height-20 -40, 100, 20)];
    
    [grayPageControl addTarget:self
                        action:@selector(pageChange:)
              forControlEvents:UIControlEventValueChanged];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lineView2.backgroundColor = [YRTools colorWithHexColorString:@"bfbfbf"];
    self.backgroundColor = [YRTools colorWithHexColorString:@"f8f8f8"];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-40, 320, 40)];
    firstArray =[[NSMutableArray alloc] init];
    secondArray = [[NSMutableArray alloc] init];
    
    NSArray * arr  = [FaceDataManager shareFaceDataManager].faceModelArray;
    
    for (LYFaceDataModel *model in arr) {
        
        if (model.facegroupid == 1) {
            [firstArray addObject:model];
        }
        if (model.facegroupid == 2) {
            [secondArray addObject:model];
        }
    }
    
    grayPageControl.currentPage = 0;
    grayPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    grayPageControl.currentPageIndicatorTintColor = KColor_ButiBlue;
    [self addSubview:grayPageControl];
    
    UIButton *firstbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstbutton.frame =CGRectMake(0, 0, 80, 40);
    [firstbutton setBackgroundImage:[UIImage imageNamed:@"表情TOOLBAR_1"] forState:UIControlStateNormal];
    [firstbutton setBackgroundImage:[UIImage imageNamed:@"表情TOOLBAR_1——当前选中"] forState:UIControlStateSelected];
    firstbutton.tag  = 1;
    [firstbutton addTarget:self action:@selector(faceTabClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:firstbutton];
    
    UIButton *secondbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondbutton.frame =CGRectMake(80, 0, 80, 40);
    secondbutton.tag = 2;
    [secondbutton setBackgroundImage:[UIImage imageNamed:@"表情TOOLBAR_2"] forState:UIControlStateNormal];
    [secondbutton setBackgroundImage:[UIImage imageNamed:@"表情TOOLBAR_2——当前选中"] forState:UIControlStateSelected];
    [secondbutton addTarget:self action:@selector(faceTabClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:secondbutton];
    
    [bottomView addSubview:lineView2];
    [self addSubview:bottomView];
    [self faceTabClick:firstbutton];
    
    

}
-(void)reloadFaceView
{
    for (UIView * eveView in self.viewArr)
    {
        eveView.tag = 0;
    }
}
+ (FaceView *)shareInstance{
    static FaceView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];

    });
    return _instance;

}

-(void)pageChange:(id)sender{
    

    [scroll  setContentOffset:CGPointMake( grayPageControl.currentPage * scroll.bounds.size.width,0) animated:YES];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    grayPageControl.currentPage= page;
    
    [self prepareForPage:page];
    [self prepareForPage:page-1];
    [self prepareForPage:page+1];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    int page = scrollView.contentOffset.x/scrollView.bounds.size.width;

    

}
-(void)prepareForPage:(int)page
{
    if (page<0)
    {
        return;
    }
    if (page>totalPage-1)
    {
        return;
    }
    
    int viewNum = page%3;
    //去处相应的view
    
    
    FaceDetailView * detail = [self.viewArr objectAtIndex:viewNum];
    if (detail.tag==page+300)
    {
        return;
    }
    detail.tag = page+300;
    
    detail.faceArr = _showFaceModelArr;
    [detail layOutFaceView:page];
    
    detail.frame  = CGRectMake(self.bounds.size.width*page, 0, self.bounds.size.width, self.bounds.size.height);
    
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
