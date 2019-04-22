//
//  RoundView.m
//  kitest
//
//  Created by Bear on 14/12/12.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "RoundView.h"
#import "KIConfig.h"


#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define ROUND_WIDTH 170*2 //圆直径
#define ROUND_LINE_WIDTH 20 //弧线的宽度

@implementation RoundView


- (id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(-(ROUND_WIDTH/2.0), 185, ROUND_WIDTH, ROUND_WIDTH);
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self initUIOfView];
    }
    return self;
}

-(void)initUIOfView{
    
    
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.frame = self.bounds;
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    UIColor *_strokeColor = [UIColor whiteColor];
    _trackLayer.strokeColor = [_strokeColor CGColor];//指定path的渲染颜色
    _trackLayer.opacity = 0.5; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _trackLayer.lineWidth = ROUND_LINE_WIDTH;//线的宽度
    _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ROUND_WIDTH/2.0, ROUND_WIDTH/2.0)
                                           radius:(ROUND_WIDTH-ROUND_LINE_WIDTH)/2
                                       startAngle:degreesToRadians(60)
                                         endAngle:degreesToRadians(-150)
                                        clockwise:NO];//上面说明过了用来构建圆形
    _trackLayer.path =[_path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    
    [self setGradientColor];
    [self setPercent:100 animated:YES];
}

- (void)setGradientColor{
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor greenColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = ROUND_LINE_WIDTH;
    _progressLayer.path = [_path CGPath];
    _progressLayer.strokeEnd = 0;
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.width/2, self.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"00F7F2"] CGColor],(id)[[UIColor colorWithHex:@"BBF48A"] CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
    gradientLayer2.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"BBF48A"] CGColor],(id)[[UIColor colorWithHex:@"FDF367"] CGColor], nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

-(void)setPercent:(NSInteger)percent animated:(BOOL)animated{
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:2];
    _progressLayer.strokeEnd = percent/100.0;
    [CATransaction commit];
    
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(ROUND_LINE_WIDTH/2.0*3, ROUND_LINE_WIDTH/2.0*3, ROUND_WIDTH - ROUND_LINE_WIDTH*3, ROUND_WIDTH - ROUND_LINE_WIDTH*3)); //椭圆
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor);//填充颜色
    CGContextSetLineWidth(context, 0.0);//线的宽度
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddEllipseInRect(context, CGRectMake(ROUND_LINE_WIDTH/2.0, ROUND_LINE_WIDTH/2.0, ROUND_WIDTH - ROUND_LINE_WIDTH, ROUND_WIDTH - ROUND_LINE_WIDTH)); //椭圆
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
//    /*画圆*/
//    //边框圆
//    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);//画笔线的颜色
//    CGContextSetLineWidth(context, 2.0);//线的宽度
////    void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
////     x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(context, 100, 20, 15, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
//    
//    //填充圆，无边框
//    CGContextAddArc(context, 150, 30, 30, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathFill);//绘制填充
//    
//    //画大圆并填充颜
//    UIColor*aColor = [UIColor colorWithRed:1 green:1.0 blue:1.0 alpha:0.3];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextSetLineWidth(context, 3.0);//线的宽度
//    CGContextAddArc(context, 250, 40, 40, 0, 2*M_PI, 0);
}

//-(void)initUIOfView{
//    
//    UIBezierPath *path=[UIBezierPath bezierPath];
//    CGRect rect=[UIScreen mainScreen].applicationFrame;
//    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
//    
//    CAShapeLayer *arcLayer=[CAShapeLayer layer];
//    arcLayer.path=path.CGPath;//46,169,230
//    arcLayer.fillColor=[UIColor clearColor].CGColor;
//    arcLayer.strokeColor=[UIColor greenColor].CGColor;
//    arcLayer.lineWidth=25;
//    arcLayer.frame=self.bounds;
//    [self.layer addSublayer:arcLayer];
//    //[self drawLineAnimation:arcLayer];
    
    
//    //创建CGContextRef
//    UIGraphicsBeginImageContext(self.bounds.size);
//    CGContextRef gc = UIGraphicsGetCurrentContext();
//    
//    //=== 绘画逻辑 ===
//    //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(50, 50);
//    //创建CGMutablePathRef
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddArc(path, &transform, 50, 50, 50, 0, 1.5 * M_PI, NO);
//    CGPathMoveToPoint(path, &transform, 50, 0);
//    CGPathAddLineToPoint(path, &transform, 50, 50);
//    CGPathAddLineToPoint(path, &transform, 100, 50);
//    
//    //将CGMutablePathRef添加到当前Context内
//    CGContextAddPath(gc, path);
//    [[UIColor grayColor] setFill];
//    [[UIColor blueColor] setStroke];
//    CGContextSetLineWidth(gc, 2);
//    //执行绘画
//    CGContextDrawPath(gc, kCGPathFillStroke);
//    
//    //从Context中获取图像，并显示在界面上
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    [self addSubview:imgView];
//}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}


//- (void)drawRect:(CGRect)rect {
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
////    [[UIColor blueColor]set];
////    UIRectFill([self bounds]);
//    
//    CGFloat strokeWidth = 20;
//    CGFloat fillWidth = 18;
//    CGFloat lineWidth = strokeWidth - fillWidth;
//    
//    //直径
//    CGFloat maxR = rect.size.width>rect.size.height ? rect.size.height : rect.size.width;
//    CGFloat round_R = maxR/2.0f - lineWidth/2.0f;
//    CGFloat round_r = maxR/2.0f - lineWidth/2.0f*3;
//    
//    //圆心
//    CGPoint origin = CGPointMake(rect.size.width/2.0f, rect.size.height/2.0f);
//    
//    
//    int unitStep = 512;
//    if (rect.size.width >= 300) {
//        unitStep = 1024;
//    }else if(rect.size.width >= 500){
//        unitStep = 2048;
//    }
//    
//    float drawStep = M_PI/unitStep;
//    
//    CGContextSaveGState(context);
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
//    CGContextSetLineWidth(context, 1.0);
//    
//    CGFloat sAngle = 0;
//    CGFloat eAngle = 3;
//    for (float dAngle = sAngle; dAngle <= eAngle; dAngle += drawStep) {
//        
//        CGContextMoveToPoint(context
//                             , origin.x-round_r - round_r*cos(dAngle)
//                             , origin.y - round_r*sin(dAngle));
//        CGContextAddLineToPoint(context
//                                , round_R *(1- cos(dAngle))
//                                , origin.y-round_R - round_R*sin(dAngle));
//        CGContextClosePath(context);
//        CGContextStrokePath(context);
//    }
    
    
    
    
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //    [[UIColor blueColor]set];
//    //    UIRectFill([self bounds]);
//    
//    // Draw
//    float R = rect.size.width/2;
//    float r = R-20;
//    CGPoint origin = CGPointMake(rect.origin.x + rect.size.width/2,
//                                 rect.origin.y + 5*rect.size.height/6);
//    
//    // Draw large circle
//    [self drawCircleInContext:context withRadian:R atOrigin:origin];
//    
//    // Draw small circle
//    [self drawCircleInContext:context withRadian:r atOrigin:origin];
//    
//    // Draw portions
//    float startAngle = 0.0;
//    float endAngle = 2.0;
//    // Draw each portion
//    [self drawPortionInContext:context
//                     withColor:[UIColor greenColor]
//                        origin:origin R:R r:r
//                    startAngle:startAngle endAngle:endAngle];
//}

- (void)drawCircleInContext:(CGContextRef)context withRadian:(float)r atOrigin:(CGPoint)origin {
    CGContextSaveGState(context);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 10.0);
    CGContextAddArc(context, origin.x, origin.y, r, 0, M_PI, YES);
    //CGContextClosePath(context);
    

    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawPortionInContext:(CGContextRef)context withColor:(UIColor*) color
                      origin:(CGPoint)origin R:(float)R r:(float)r
                  startAngle:(float)startAngle endAngle:(float)endAngle
{
    
    CGRect rect = CGContextGetClipBoundingBox(context);
    int unitStep = 512;
    if (rect.size.width >= 300) {
        unitStep = 1024;
    }else if(rect.size.width >= 500){
        unitStep = 2048;
    }
    
    float drawStep = M_PI/unitStep;
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, 1.0);
    
    for (float drawingAngle = startAngle; drawingAngle <= endAngle; drawingAngle += drawStep) {
        
        CGContextMoveToPoint(context,
                             origin.x - r*cos(drawingAngle),
                             origin.y - r*sin(drawingAngle));
        CGContextAddLineToPoint(context,
                                R *(1- cos(drawingAngle)),
                                origin.y - R*sin(drawingAngle));
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
    NSLog(@"\n%f---%f---%f---%f\n%f---%f---%f---%f"
          , origin.x - r*cos(0)
          , origin.y - r*sin(0)
          , R *(1- cos(0))
          , origin.y - R*sin(0)
          , R *(1- cos(3))
          , origin.y - R*sin(3)
          , origin.x - r*cos(3)
          , origin.y - r*sin(3));
    
    CGContextRestoreGState(context);
}



////第二种填充方式
//CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//CGFloat colors[] =
//{
//    1,1,1, 1.00,
//    1,1,0, 1.00,
//    1,0,0, 1.00,
//    1,0,1, 1.00,
//    0,1,1, 1.00,
//    0,1,0, 1.00,
//    0,0,1, 1.00,
//    0,0,0, 1.00,
//};
//CGGradientRef gradient = CGGradientCreateWithColorComponents
//(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
//CGColorSpaceRelease(rgb);
//CGContextDrawRadialGradient(context, gradient, origin, 0.0, CGPointMake(origin.x+200, origin.y), 10, kCGGradientDrawsBeforeStartLocation);



@end
