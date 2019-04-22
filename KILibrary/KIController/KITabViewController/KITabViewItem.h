//
//  KITabViewItem.h
//  HA
//
//  Created by chen on 13-3-7.
//  
//

#import <UIKit/UIKit.h>


@interface KITabViewItem : UIControl {
    NSUInteger          _index;
    NSString            *_title;
    UIImage             *_image;
    UIImage             *_selectedImage;
    UIImage             *_backgroundImage;
    UIImage             *_selectedBackgroundImage;
    UIViewController    *_viewController;
    BOOL                _deselectable;
    NSString            *_badge;
    UIColor     *_titleColor;
    UIColor     *_selectedTitleColor;
    
    UIImageView *_backgroundImageView;
    UILabel     *_titleLabel;
}

@property (nonatomic, assign) NSUInteger            index;
@property (nonatomic, retain) NSString              *title;
@property (nonatomic, retain) UIImage               *image;
@property (nonatomic, retain) UIImage               *selectedImage;
@property (nonatomic, retain) UIImage               *backgroundImage;
@property (nonatomic, retain) UIImage               *selectedBackgroundImage;
@property (nonatomic, retain) UIViewController      *viewController;
@property (nonatomic, assign) BOOL                  deselectable;
@property (nonatomic, retain) NSString              *badge;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,strong)UIColor *selectedTitleColor;


@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)UILabel *titleLabel;



- (id)initWithViewController:(UIViewController *)viewController;

@end
