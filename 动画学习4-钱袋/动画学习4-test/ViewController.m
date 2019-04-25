//
//  ViewController.m
//  动画学习4-test
//
//  Created by 张崇超 on 2017/7/12.
//  Copyright © 2017年 huayu. All rights reserved.
//

#import "ViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *canImgV;
@property(nonatomic,strong)NSMutableArray *coinsArr;
@property(nonatomic,strong)CAShapeLayer *layer;

@property(nonatomic,assign)NSInteger animCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animCount = 0;
    self.coinsArr = [NSMutableArray new];
    //创建钱币
    CGFloat width = 28;
    UIImage *img = [UIImage imageNamed:@"2.jpg"];
    img = [self getCirleImageWithOrignalImg:img];
    
    for (int i = 0; i < 30; i ++) {
        
        UIImageView *coinImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -80, width, width)];
        coinImgV.image = img;
        
        [self.view addSubview:coinImgV];
        [self.coinsArr addObject:coinImgV];
    }
}

- (IBAction)openAction:(UIButton *)sender {
    
    //添加钱币移动动画
    for (int i = 0; i < self.coinsArr.count ; i ++ ) {
        
        UIImageView *imgV = self.coinsArr[i];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CGFloat startX = -kWidth/2 + arc4random() % 60;
        [path moveToPoint:CGPointMake(startX, kHeight/2)];
        
        CGFloat endX = self.canImgV.center.x- 20 + arc4random() % 40;
        CGFloat controlX = (self.canImgV.center.x +  startX ) / 2;
        CGFloat controlY = -kHeight/2 +20 + arc4random() % 100;
        
        [path addQuadCurveToPoint:CGPointMake(endX, self.canImgV.center.y) controlPoint:CGPointMake(controlX, controlY)];
        
        //移动动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = path.CGPath;
        
        //动画时间
        animation.duration = 3 - i * 0.06;
        
        animation.delegate = self;

        [imgV.layer addAnimation:animation forKey:[NSString stringWithFormat:@"coinsAnimation%d",i]];
    }
}

//钱袋抖动动画
- (void)canMoveAnimation
{
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    //度数转弧度
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];
    
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = 1;
    [self.canImgV.layer addAnimation:keyAnimaion forKey:nil];
}

#pragma mark ----CAAnimationDelegate----

//开始
- (void)animationDidStart:(CAAnimation *)anim
{
}

//结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.animCount ++;
    if (self.animCount == self.coinsArr.count - 1) {
       
        [self canMoveAnimation];
        self.animCount = 0;
    }
}

- (UIImage *)getCirleImageWithOrignalImg:(id )orignalImgObject
{
    UIImage *img;
    if ([orignalImgObject isKindOfClass:[UIImage class]]) {
        
        img = orignalImgObject;
        
    }else if ([orignalImgObject isKindOfClass:[NSString class]]){
        
        img = [UIImage imageNamed:orignalImgObject];
        
    }else if ([orignalImgObject isKindOfClass:[NSNull class]] || [orignalImgObject length] == 0 || !orignalImgObject){
        
        return nil;
    }
    //计算图片宽高
    CGFloat width = img.size.width;
    CGFloat height = img.size.height;
    width > height?(width = height):(width = width);
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    //设置裁剪区域
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)];
    //裁剪为圆形
    [circlePath addClip];
    //绘制图形
    [img drawAtPoint:CGPointMake(0, 0)];
    //获取图片
    UIImage *clipedImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return clipedImage;
}

- (void)drawerLineWithPath:(UIBezierPath *)path
{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    //绘制出路径
    self.layer = [CAShapeLayer layer];
    
    //设置填充方式
    self.layer.fillColor = [UIColor clearColor].CGColor;
    self.layer.lineWidth = 1.0f;
    self.layer.strokeColor = [UIColor redColor].CGColor;
    
    pathAnima.duration = .8;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    
    //保留动画结束的位置
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [self.layer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    
    self.layer.path = path.CGPath;
    [self.view.layer addSublayer:self.layer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
