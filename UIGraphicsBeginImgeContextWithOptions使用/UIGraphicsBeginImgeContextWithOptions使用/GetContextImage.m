//
//  GetContextImage.m
//  UIGraphicsBeginImgeContextWithOptions使用
//
//  Created by ZILIANG HA on 2018/12/13.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "GetContextImage.h"
#import "CutAreaView.h"
@implementation GetContextImage
/*
 * 根据图片名称，获取绘制的图片
 *
 */
+(UIImage *)drawImageWithImageNamed:(NSString *)name
{
    //获取图片
    UIImage *image = [UIImage imageNamed:name];
    //1、开启图形上下文
    UIGraphicsBeginImageContext(image.size);
    //2、绘制到图形上下文中
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //3、从上下文中获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4、关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}
/*
 * 根据图片名称，获取绘制的图片，并给图片添加文字水印
 *
 */
+(UIImage *)drawWaterImageWithImageNamed:(NSString *)name text:(NSString *)text textPoint:(CGPoint)point attributeString:(NSDictionary *)attributed
{
    //获取图片
    UIImage *image = [UIImage imageNamed:name];
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 3.添加水印
    [text drawAtPoint:point withAttributes:attributed];
    // 4.从上下文中获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.关闭图形上下文
    UIGraphicsEndImageContext();
    // 返回图片
    return newImage;
}
/*
 * 根据图片名称，获取绘制的图片，并给图片添加图片水印
 *
 */
+(UIImage *)drawWaterImageWithImageNamed:(NSString *)name waterImageName:(NSString *)waterImageName waterImageRect:(CGRect)rect
{
    //获取图片
    UIImage *image = [UIImage imageNamed:name];
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //获取水印图片
    UIImage *waterImage = [UIImage imageNamed:waterImageName];
    // 3.绘制图片t水印到当前上下文
    [waterImage drawInRect:rect];
    // 4.从上下文中获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.关闭图形上下文
    UIGraphicsEndImageContext();
    // 返回图片
    return newImage;
}
/*
 * 裁剪圆形区域图片
 *
 */
+(UIImage *)clipCircleImageWithImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    // 1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    // 2.设置裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 设置路径为裁剪区域
    [path addClip];
    // 3.绘制图片
    [image drawAtPoint:CGPointZero];
    // 4.获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    // 返回图片
    return newImage;
}

/*
 * 裁剪带边框圆形区域图片
 *
 */
+(UIImage *)clipCircleImageWithImageNamed:(NSString *)name borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor
{
    UIImage *image = [UIImage imageNamed:name];
    // 1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    // 2.设置边框
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [borderColor setFill];
    [path fill];
    // 3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, rect.size.width - 2*borderW, rect.size.height - 2*borderW)];
    [clipPath addClip];
    //4、绘制图片
    [image drawAtPoint:CGPointZero];
    //5、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //6、关闭上下文
    UIGraphicsEndImageContext();
    //7、返回新图片
    return newImage;
}
/*
 * 截屏
 */
+(void)cutScreenWithView:(UIView *)view successBlock:(nullable void(^)(UIImage * image,NSData * imagedata))block
{
    // 1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1.0);
    //2.获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //3.截屏
    //renderInContext:就是渲染的方式
    [view.layer renderInContext:ctx];
    //4、获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.转化成为Data
    //compressionQuality:表示压缩比 0 - 1的取值范围
    NSData * data = UIImageJPEGRepresentation(newImage, 1);
    //6、关闭上下文
    UIGraphicsEndImageContext();
    //7.回调
    block(newImage,data);
}
/*
 * 对view的某一部分进行裁剪
 */
+(void)cutScreenWithView:(UIView *)view
                cutFrame:(CGRect)frame
            successBlock:(void(^)(UIImage *image, NSData *imagedata))block
{
    // 1.先把裁剪区域上面显示的层 影藏掉
    for (CutAreaView * cutView in view.subviews) {
        [cutView setHidden:YES];
    }
    //-----------进行第一次裁剪------------
    // 2.开启上下文
    UIGraphicsBeginImageContext(view.frame.size);
    // 3.获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 4.添加裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    [path addClip];
    // 5.渲染
    //renderInContext:就是渲染的方式
    [view.layer renderInContext:ctx];
    // 6.从上下文中获取
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 7.关闭上下文
    UIGraphicsEndImageContext();
    
    
    // 8.进行完第一次裁剪之后，我们就已经拿到了没有半透明层的图片，这个时候可以恢复显示
    for (CutAreaView * cutView in view.subviews) {
        [cutView setHidden:NO];
    }
    //-----------进行第二次裁剪------------
    // 9.开启上下文，这个时候的大小就是我们最终要要显示图片的大小
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    // 10.这里把x、y坐标向左、上移动
    [newImage drawAtPoint:CGPointMake(- frame.origin.x, - frame.origin.y)];
    // 11.得到要显示区域的图片
    UIImage *fImage = UIGraphicsGetImageFromCurrentImageContext();
    // 12.得到data类型 便于保存
    NSData *data2 = UIImageJPEGRepresentation(fImage, 1);
    //13、关闭上下文
    UIGraphicsEndImageContext();
    //14、回调
    block(newImage,data2);
    
}














@end
