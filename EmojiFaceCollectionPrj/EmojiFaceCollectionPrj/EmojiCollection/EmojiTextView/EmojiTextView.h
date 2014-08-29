//
//  EmojiTextView.h
//  emoji
//
//  Created by Apple on 14-8-11.
//
//

#import <UIKit/UIKit.h>
/**
 *	@brief	完成删除时，自动判定表情字符串功能，实现表情整体删除
 */
@interface EmojiTextView : UITextView
{
}

@property (nonatomic,strong) NSArray * emojiNameArray;

//提供删除方法
-(void)removePartTextStringWithStartRangeLocation:(NSInteger)location;

-(void)addFaceViewImageWithImageName:(NSString * )ImageName andImage:(UIImage *)img;

-(NSString *)currentPostString;




@end
