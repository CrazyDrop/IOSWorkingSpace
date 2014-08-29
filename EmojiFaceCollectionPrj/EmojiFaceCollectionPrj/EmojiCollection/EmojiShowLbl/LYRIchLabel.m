//
//  LYLabel.m
//  ViewControllerTest
//
//  Created by 李言 on 14-8-8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "LYRichLabel.h"
#import <CoreText/CoreText.h>
#import "FaceDataManager.h"
#import "Constant.h"
#import "YRTools.h"
@implementation LYRichLabel

static CGFloat faceWidth=18;
static CGFloat faceHeight=18;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // rangeArr = [[NSMutableArray alloc] init];
      //  Emoji=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"]];
        rangeArray = [[NSMutableArray alloc] init];
        imageTextArray =[[NSMutableArray alloc] init];

    }
    return self;
}
void LYRunDelegateDeallocCallback( void* refCon ){
}
/**
 *	@brief	上升 回调
 *
 *	@param 	refCon
 *
 *	@return	高度
 */
CGFloat LYRunDelegateGetAscentCallback( void *refCon )
{
    NSString *imageName = (__bridge NSString *)refCon;
    if ([UIImage imageWithContentsOfFile:imageName]) {
        return faceHeight;
    }
    return 0;
}
/**
 *	@brief	下降回调
 *
 *	@param 	refCon
 *
 *	@return 高度
 */
CGFloat LYRunDelegateGetDescentCallback(void *refCon)
{
     NSString *imageName = (__bridge NSString *)refCon;
    if ([UIImage imageWithContentsOfFile:imageName]) {
        return 0;
    }
    return 0;
}


/**
 *	@brief	宽度回调
 *
 *	@param 	refCon
 *
 *	@return	宽度
 */
CGFloat LYRunDelegateGetWidthCallback(void *refCon)
{
    NSString *imageName = (__bridge NSString *)refCon;
    if ([UIImage imageWithContentsOfFile:imageName]) {
        return faceWidth+1;
    }
    return 0;
}

/**
 *	@brief	构建NSMutableAttributedString
 *
 *	@param 	string 	字符串
 *	@param 	array 	数组
 *
 *	@return	NSMutableAttributedString
 */
-(NSMutableAttributedString *)bulidAttributeString:(NSString * )string
{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string] ;
    UIFont *font = self.font;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0, [attributedString length])];
    
    // [self  getImageRange:string andArray:array];
    NSArray *array = [self transformString:string];
       NSInteger charIndex = 0;
    for ( int   i  =  0; i<[array count]; i++) {
        NSString *ImageName = [FaceImageDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png" ,[[array objectAtIndex:i] md5HexDigest]]];
        
        UIImage *img = [UIImage imageWithContentsOfFile:ImageName];
        CTRunDelegateCallbacks imageCallbacks;
        imageCallbacks.version = kCTRunDelegateVersion1; //必须指定，否则不会生效，没有回调产生。
        imageCallbacks.dealloc = LYRunDelegateDeallocCallback;
        imageCallbacks.getAscent = LYRunDelegateGetAscentCallback;
        imageCallbacks.getDescent = LYRunDelegateGetDescentCallback;
        imageCallbacks.getWidth = LYRunDelegateGetWidthCallback;
        
        NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
        [imageAttributedString addAttribute:@"imageName" value:ImageName range:NSMakeRange(0, 1)];
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)(ImageName));
        [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
        CFRelease(runDelegate);
        
        NSString *string = [array objectAtIndex:i];
        NSRange  range ;
        
        if ([string hasPrefix:@"["] &&[string hasSuffix:@"]"] && img) {
            range = NSMakeRange(charIndex,string.length);
            charIndex ++;
            [attributedString deleteCharactersInRange:range];
        }else{
            range = NSMakeRange(charIndex,string.length);
            charIndex = charIndex + string.length+1;
        }
        [attributedString insertAttributedString:imageAttributedString atIndex:range.location];
        
    }
    //  换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    
    // 构建属性
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    // 将属性添加到  attributedstring
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    if (!self.text) {
        return;
    }
   // NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableAttributedString *attributedString = [self bulidAttributeString:self.text];
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageWithContentsOfFile:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(faceWidth, faceHeight);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y-4;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
            
        }
        
    }
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
 
    
}

/**
 *	@brief	获取字符串高度
 *
 *	@param 	string 	字符串
 *	@param 	width 	宽度
 *	@param 	doneBlock 	完成的回调
 */
- (CGFloat)lblSizeEndChangedWithNewString:(NSString *)string  WidthValue:(float) width ;

{
    
    NSMutableAttributedString *attributedTextString = [self bulidAttributeString:string ];
    
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedTextString);
    CGSize suggestFrameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(self.frame.size.width, CGFLOAT_MAX), NULL);
    
    CFRelease(framesetter);
    return suggestFrameSize.height+2;

}



-(void)setText:(NSString *)text{

    [super setText:text];


}

/**
 *	@brief  递归筛选字符串
 *
 *	@param 	message 	要筛选的字符串   
 *  @param  array       传入的数组
 */
-(void)getImageRange:(NSString*)message andArray: (NSMutableArray*)array
 {
    NSRange range=[message rangeOfString:@"["];
    NSRange range1=[message rangeOfString:@"]"];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0 ) {
        
        if (range1.location<range.location) {
            [array addObject:[message substringToIndex:range1.location+1]];
            NSString *str = [message substringFromIndex:range1.location+1];
            [self getImageRange:str andArray:array];
        
            return;
        }
        if (range.location > 0) {
            NSString *string = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            if ([[FaceDataManager shareFaceDataManager].faceNameArray containsObject:string ]) {//如果是表情 存入
                  [array addObject:[message substringToIndex:range.location ]];//存入@"["之前的
                 [array addObject:string];//存入表情
                NSString *str=[message substringFromIndex:range1.location+1];//截取
                [self getImageRange:str andArray:array];
                return;
            }else{
                [array addObject:[message substringToIndex:range.location +1]];//不是表情 存入 包括 @"[" 及之前的
                NSString *str = [message substringFromIndex:range.location+1];
                [self getImageRange:str andArray:array];
                return;
            }
           
       
           
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            
            //排除文字是“”的
            if (![nextstr isEqualToString:@""] ) {
                
                if ([Emoji objectForKey:nextstr]) {
                    
                    [array addObject:nextstr];
                    
                    NSString *str=[message substringFromIndex:range1.location+1];
                    [self getImageRange:str andArray:array];
                    
                    return;
                }else{
                    [array addObject:[message substringToIndex:range.location+1]];
                    
                    NSString *str=[message substringFromIndex:range.location+1];
                    [self getImageRange:str andArray:array];
                    
                    return;
                }
                
                
                
                return;
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
       
    }
}


/**
 *	@brief	转换字符串为数组
 *
 *	@param 	originalStr 	字符串
 *
 *	@return	数组
 */
- (NSArray *)transformString:(NSString *)originalStr

{
    //匹配表情，
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    [imageTextArray removeAllObjects] ;
    [ rangeArray removeAllObjects];
    NSMutableArray *newstr = [[NSMutableArray alloc] init];
    
    NSInteger startIndex = 0;
    if ([array_emoji count]) {
        for (int i  = 0  ;i <[array_emoji count] ; i++) {
            NSString *str= [array_emoji objectAtIndex:i];
            
            NSRange range = [text rangeOfString:str options:NSLiteralSearch range:NSMakeRange(startIndex, [text length]-startIndex)];
            if ([[FaceDataManager shareFaceDataManager].faceNameArray containsObject:str])
            {
                NSString *a = [text substringWithRange:NSMakeRange(startIndex, range.location-startIndex)];
                if(![a isEqualToString:@""]){
                    [newstr addObject:a];
                }
                [newstr addObject:str];
                [imageTextArray  addObject:str];
                [rangeArray addObject:NSStringFromRange(range)];
                startIndex =([str length]+range.location);
                
                
            }
            
            if([array_emoji count] -1== i ){
                if(![[text substringFromIndex:startIndex] isEqualToString:@""])
                    [newstr addObject:[text substringFromIndex:startIndex] ];
                
            }
        }
    }
    
    return newstr;
}



+(NSString *)valueStringWithPartString:(NSString *)part andAppendBooNumber:(NSNumber **)number
{
    
    
    NSMutableString * partValueStr = [NSMutableString string];
    NSString * endStr = @"]";
    NSString * sepTagString = @"|";
    
    NSArray * eveArr = [part componentsSeparatedByString:endStr];
    
    NSString * containStr = nil;
    if ([eveArr count]==1)
    {
        return part;
    }else
    {
        containStr = [eveArr objectAtIndex:0];
        NSArray * sepArr  =[containStr componentsSeparatedByString:sepTagString];
        if ([sepArr count]==1)
        {
            //此处eroor的有无，需要再分析
            [partValueStr appendString:containStr];
            [partValueStr appendString:endStr];
            *number = [NSNumber numberWithBool:YES];
            
        }else
        {
            NSString * tagStr = [sepArr objectAtIndex:0];
            NSString * valueStr = [sepArr objectAtIndex:1];
            if ([tagStr isEqualToString:@"0"])
            {
                *number = [NSNumber numberWithBool:YES];
                [partValueStr appendString:valueStr];
                [partValueStr appendString:endStr];
                
            }else
            {
                [partValueStr appendString:valueStr];
            }
            
            for (int i=2;i<[sepArr count] ;i++ )
            {
                NSString * obj = [sepArr objectAtIndex:i];
                [partValueStr appendString:obj];
            }
        }
        
        for (int i = 1;i<[eveArr count];i++ )
        {
            NSString * obj = [eveArr objectAtIndex:i];
            [partValueStr appendString:obj];
        }
        return partValueStr;
    }
    
    
    
}


+(NSString *)checkString :(NSString *)string{
    
    NSString * startStr = @"[";
    //    NSString * endStr = @"]";
    //    NSString * sepTagString = @"|";
    
    NSMutableString * totalStr = [NSMutableString string];
    NSArray * dataArr = [string componentsSeparatedByString:startStr];
    
    for (NSString * str in dataArr)
    {
        
        NSNumber * number = nil;
        NSString *  partStr =[LYRichLabel valueStringWithPartString:str andAppendBooNumber:&number];
        
        //如果有error，则添加分隔号,有error，标识自定义的表情
        if ([number boolValue])
        {
            [totalStr appendString:startStr];
        }
        
        [totalStr appendString:partStr];
        
    }
    return totalStr;
    
    
}




@end
