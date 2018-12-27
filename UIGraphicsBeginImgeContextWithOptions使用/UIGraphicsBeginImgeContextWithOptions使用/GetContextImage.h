//
//  GetContextImage.h
//  UIGraphicsBeginImgeContextWithOptions使用
//
//  Created by ZILIANG HA on 2018/12/13.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GetContextImage : NSObject

/*
 * 根据图片名称，获取绘制的图片
 *
 */
+(UIImage *)drawImageWithImageNamed:(NSString *)name;
/*
 * 根据图片名称，获取绘制的图片，并给图片添加文字水印
 *
 */
+(UIImage *)drawWaterImageWithImageNamed:(NSString *)name text:(NSString *)text textPoint:(CGPoint)point attributeString:(NSDictionary *)attributed;
/*
 * 根据图片名称，获取绘制的图片，并给图片添加图片水印
 *
 */
+(UIImage *)drawWaterImageWithImageNamed:(NSString *)name waterImageName:(NSString *)waterImageName waterImageRect:(CGRect)rect;
/*
 * 裁剪圆形区域图片
 *
 */
+(UIImage *)clipCircleImageWithImageNamed:(NSString *)name;
/*
 * 裁剪带边框圆形区域图片
 *
 */
+(UIImage *)clipCircleImageWithImageNamed:(NSString *)name borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor;
/*
 * 截屏
 */
+(void)cutScreenWithView:(UIView *)view successBlock:(nullable void(^)(UIImage * _Nullable image,NSData * _Nullable imagedata))block;
/*
 * 对view的某一部分进行裁剪
 */
+(void)cutScreenWithView:(UIView *)view
                cutFrame:(CGRect)frame
            successBlock:(void(^)(UIImage *image, NSData *imagedata))block;
@end

