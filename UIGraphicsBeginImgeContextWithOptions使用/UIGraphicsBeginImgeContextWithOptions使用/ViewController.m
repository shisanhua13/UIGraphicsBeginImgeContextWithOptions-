//
//  ViewController.m
//  UIGraphicsBeginImgeContextWithOptions使用
//
//  Created by ZILIANG HA on 2018/12/13.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "ViewController.h"
#import "GetContextImage.h"
#import "CutAreaView.h"
@interface ViewController ()
@property (nonatomic, strong) UIImageView *oneImageV;
@property (nonatomic, strong) UIImageView *twoImageV;
@property (nonatomic, strong) UIImageView *threeImageV;
@property (nonatomic, strong) UIImageView *fourImageV;
@property (nonatomic, strong) UIImageView *fiveImageV;

@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) CutAreaView *cutAreaView;
@property (nonatomic, strong) UIButton *cutBtn;
@property (nonatomic, strong) UIImageView *cutImageV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _oneImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 100, 100)];
    [self.view addSubview:_oneImageV];
    _oneImageV.image = [GetContextImage drawImageWithImageNamed:@"miao"];
    
    
    NSString *text = @"添加水印";
    CGPoint point = CGPointMake(20, 20);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5;//模糊度
    shadow.shadowColor = [UIColor blueColor];
    shadow.shadowOffset = CGSizeMake(10, 3);
    NSDictionary *attibute = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20.f], NSBackgroundColorAttributeName: [UIColor redColor], NSForegroundColorAttributeName:[UIColor greenColor],NSStrokeColorAttributeName:[UIColor yellowColor],NSStrokeWidthAttributeName:@3, NSKernAttributeName:[NSNumber numberWithFloat:3.5f],NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:1], NSStrikethroughColorAttributeName:[UIColor orangeColor],NSShadowAttributeName: shadow, NSVerticalGlyphFormAttributeName:@0,};
    _twoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 150, 150)];
    [self.view addSubview:_twoImageV];
    _twoImageV.image = [GetContextImage drawWaterImageWithImageNamed:@"miao" text:text textPoint:point attributeString:attibute];
    
    
    _threeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_twoImageV.frame) + 10, 150, 150)];
    [self.view addSubview:_threeImageV];
    _threeImageV.image = [GetContextImage drawWaterImageWithImageNamed:@"miao" waterImageName:@"logo" waterImageRect:CGRectMake(10, 10, 40, 20)];
    
    _fourImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_threeImageV.frame) + 10, 150, 150)];
    [self.view addSubview:_fourImageV];
    _fourImageV.image = [GetContextImage clipCircleImageWithImageNamed:@"miao"];
    
    _fiveImageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_fourImageV.frame) + 10, CGRectGetMinY(_fourImageV.frame), 150, 150)];
    [self.view addSubview:_fiveImageV];
    _fiveImageV.image = [GetContextImage clipCircleImageWithImageNamed:@"miao" borderWidth:5 borderColor:[UIColor redColor]];
    
    
    _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 40 - 150)];
    _backImageV.image = [UIImage imageNamed:@"back"];
    _backImageV.userInteractionEnabled = YES;
    [self.view addSubview:_backImageV];
    _cutAreaView = [[CutAreaView alloc] initWithFrame:CGRectMake(10, 40, 100, 100)];
    [_backImageV addSubview:_cutAreaView];
    _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cutBtn.frame = CGRectMake(10, CGRectGetMaxY(_backImageV.frame) + 10, 100, 60);
    [_cutBtn setTitle:@"确定裁剪" forState:UIControlStateNormal];
    [_cutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cutBtn.backgroundColor = [UIColor yellowColor];
    [_cutBtn addTarget:self action:@selector(cutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cutBtn];
    _cutImageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cutBtn.frame) + 50, CGRectGetMinY(_cutBtn.frame), 100, 100)];
    _cutImageV.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_cutImageV];
}
-(void)cutAction
{
    [GetContextImage cutScreenWithView:_backImageV cutFrame:_cutAreaView.frame successBlock:^(UIImage *image, NSData *imagedata) {
        if (image) {
            NSLog(@"截取成功");
            NSString * path = [NSString stringWithFormat:@"%@/Documents/cutSome.jpg",NSHomeDirectory()];
            if( [imagedata writeToFile:path atomically:YES]){
                NSLog(@"保存成功%@",path);
            }
            
            _cutImageV.image = image;
        }
    }];
}

@end
