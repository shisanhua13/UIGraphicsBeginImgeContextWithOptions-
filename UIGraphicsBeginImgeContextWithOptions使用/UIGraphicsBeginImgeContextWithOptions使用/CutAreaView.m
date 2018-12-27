//
//  CutAreaView.m
//  UIGraphicsBeginImgeContextWithOptions使用
//
//  Created by ZILIANG HA on 2018/12/24.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "CutAreaView.h"
#import "UIView+pgqViewExtension.h"

@interface CutAreaView ()
/* 裁剪框上的拖动按钮，用来改变裁剪框的大小*/
@property (nonatomic, strong) UIButton *sizeBtn;
/* 记录 裁剪区域的初始位置*/
@property (nonatomic, assign) CGPoint startP;
/* 记录 改变裁剪框大小时的开始点*/
@property (nonatomic, assign) CGPoint sizeStartP;
/* 记录 裁剪框的上一次大小*/
@property (nonatomic, assign) CGSize oldSize;
@end
@implementation CutAreaView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.3;
        [self addSubViews];
    }
    return self;
}
-(void)addSubViews
{
    _sizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sizeBtn.x = self.width - 28;
    _sizeBtn.y = self.height - 28;
    _sizeBtn.size = CGSizeMake(28, 28);
    [self addSubview:_sizeBtn];
    [_sizeBtn setBackgroundImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    // 添加平移拖动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sizePan:)];
    [_sizeBtn addGestureRecognizer:panRecognizer];
}
#pragma mark - 通过拖动按钮，来改变裁剪区域的大小
// 拖动手势事件
-(void)sizePan:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        // 手势开始
        case UIGestureRecognizerStateBegan:
        {
            //locationInView:获取到的是手指点击屏幕实时的坐标点
            //- (CGPoint)locationInView:(UIView *)view：函数返回一个CGPoint类型的值，表示触摸在view这个视图上的位置，这里返回的位置是针对view的坐标系的。调用时传入的view参数为空的话，返回的时触摸点在整个窗口的位置
            // 1.改变裁剪框大小时的开始点
            _sizeStartP = [sender locationInView:self];
            // 2.记录下 此时裁剪区域的大小
            _oldSize = self.size;
        }
            break;
        // 手势进行中
        case UIGestureRecognizerStateChanged:
        {
            // 1.获取拖动过程中拖动的点，来计算要改变的宽和高
            CGPoint curP = [sender locationInView:self];
            // 2.计算要改变的宽和高
            CGFloat w = curP.x  - _sizeStartP.x;
            CGFloat h = curP.y  - _sizeStartP.y;
            // 3.改变self的宽和高
            self.width = _oldSize.width + w;
            self.height = _oldSize.height + h;
            //保证按钮的位置不变
            _sizeBtn.x = self.width - 28;
            _sizeBtn.y = self.height - 28;
            // 4.保证裁剪区域永远在屏幕中显示
            [self ifOut];
        }
            break;
        default:
            break;
    }
}
-(void)ifOut
{
    
    //如果 裁剪区域出了屏幕，就自动移动裁剪区域的位置，使裁剪区域完全显示在屏幕上
    if (self.y + self.height >= [UIScreen mainScreen].bounds.size.height-64) {
        self.y =  [UIScreen mainScreen].bounds.size.height - self.height - 64;
    }
    if (self.x + self.width >= [UIScreen mainScreen].bounds.size.width) {
        self.x =  [UIScreen mainScreen].bounds.size.width - self.width;
    }
}
#pragma mark - 通过拖动self，来改变裁剪区域的位置
//开始点击
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取一个触摸对象
    UITouch *touch = [touches anyObject];
    //- (CGPoint)locationInView:(UIView *)view：函数返回一个CGPoint类型的值，表示触摸在view这个视图上的位置，这里返回的位置是针对view的坐标系的。调用时传入的view参数为空的话，返回的时触摸点在整个窗口的位置
    //记录裁剪区域的初始位置
    _startP = [touch locationInView:self];
}
//移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取一个触摸对象
    UITouch * touch = [touches anyObject];
    //记录移动的点
    CGPoint curP = [touch locationInView:self];
    //计算偏移量
    CGFloat x = curP.x - _startP.x;
    CGFloat y = curP.y - _startP.y;
    //限制范围 不允许超出屏幕
    self.x += x;
    if (self.x <=0) {
        self.x = 0;
    }
    self.y += y;
    if (self.y <= 0) {
        self.y = 0;
    }
    //范围判断
    [self ifOut];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


@end
