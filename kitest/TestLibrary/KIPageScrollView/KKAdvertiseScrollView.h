//
//  KKCircleScrollView.h
//  Assistant
//
//  Created by bearmac on 14-4-22.
//  Copyright (c) 2014年 beartech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KKAdvertiseScrollViewDelegate ;

@interface KKAdvertiseScrollView : UIView{
    
}
@property (nonatomic , assign) id<KKAdvertiseScrollViewDelegate> delegate;
@property (nonatomic , retain) NSMutableArray *dataArray;

/**
 *  初始化
 *
 *  @param frame        frame
 *  @param array        数组信息
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)array;

- (void)setDataArray:(NSMutableArray *)dataArray;

@end


@protocol KKAdvertiseScrollViewDelegate <NSObject>

- (void)kkAdvertiseScrollView:(KKAdvertiseScrollView *)kkAdvertiseScrollView didSelectedViewWithInfomation:(NSDictionary *)info;

@end


//{
//    cover = "/img/667b5b4a2addc4696602b498a73c0d04.jpg";
//    detail =         (
//                      {
//                          description = "00\U6d3b\U52a8\U5185\U5bb9\U63cf\U8ff000";
//                          image = "/img/243f6827fe80944b6bb26e80e175c713.jpg";
//                          "serial_number" = 0;
//                      },
//                      {
//                          description = "11\U6d3b\U52a8\U5185\U5bb9\U63cf\U8ff011";
//                          image = "/img/174509341416b35b7cf23cf41b04906c.jpg";
//                          "serial_number" = 1;
//                      }
//                      );
//    id = 2;
//    name = "banner-2";
//    "serial_number" = 1;
//    url = "http://photo.cankaoxiaoxi.com/roll10/2015/0324/717027_2.shtml";
//}

