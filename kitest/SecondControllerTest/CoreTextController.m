//
//  CoreTextController.m
//  kitest
//
//  Created by Huamo on 15/11/17.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "CoreTextController.h"

@interface CoreTextController ()

@end

@implementation CoreTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCoreText];
    
    
    
}

- (void)initCoreText{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:10.0] range:NSMakeRange(0, 5)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(6, 12)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:15] range:NSMakeRange(19, 6)];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 50)];
    [self.view addSubview:label];
    label.attributedText = str;
    
    
    
    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:@"This is a test of characterAttribute. 中文字符"];
    //红色
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)[UIColor redColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    //斜体
    CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 40, NULL);
    [attributes setObject:(__bridge id)font forKey:(id)kCTFontAttributeName];
    //下划线
    [attributes setObject:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(id)kCTUnderlineStyleAttributeName];
    
    [mabstring addAttributes:attributes range:NSMakeRange(0, 4)];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 300, 50)];
    [self.view addSubview:label2];
    label2.attributedText = mabstring;
    
    
    
    
    
/**
  NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
  NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
  NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
  NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
  NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
  NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
  NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
  NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
  NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
  NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
  NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
  NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
  NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
  NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
  NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
  NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
  NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
  NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
  NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
  NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
  NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象　
 */
    
    NSMutableAttributedString *buttonStr = [[NSMutableAttributedString alloc] initWithString:@"获取精准报价"];
    NSRange strRange = {0,[buttonStr length]};
    [buttonStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [buttonStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:strRange];
    [buttonStr addAttribute:NSBackgroundColorAttributeName value:[UIColor greenColor] range:strRange];
    [buttonStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"www.baidu.com"] range:strRange];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 300, 50)];
    label3.userInteractionEnabled = YES;
    label3.enabled = YES;
    [self.view addSubview:label3];
    label3.attributedText = buttonStr;
}

@end
