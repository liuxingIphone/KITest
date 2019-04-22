//
//  KITabViewItem.m
//  HA
//
//  Created by chen on 13-3-7.
//  
//

#import "KITabViewItem.h"
#import "KIThemeManager.h"



@implementation KITabViewItem

@synthesize index = _index;
@synthesize title = _title;
@synthesize image = _image;
@synthesize selectedImage = _selectedImage;
@synthesize backgroundImage = _backgroundImage;
@synthesize selectedBackgroundImage = _selectedBackgroundImage;
@synthesize viewController = _viewController;
@synthesize deselectable = _deselectable;
@synthesize badge = _badge;
@synthesize titleColor = _titleColor;
@synthesize selectedTitleColor = _selectedTitleColor;


- (id)init {
    return [self initWithViewController:nil];
}

- (id)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _viewController = viewController;
        [self setDeselectable:NO];
        
        
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_backgroundImageView];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:KIThemeColor(@"subTabViewItemTitleColor")];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self addSubview:_titleLabel];
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_backgroundImageView setFrame:self.bounds];
    [_titleLabel setFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLabel setText:title];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    if (!self.selected) {
        [_titleLabel setTextColor:_titleColor];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = selectedTitleColor;
    if (self.selected) {
        [_titleLabel setTextColor:_selectedTitleColor];
    }
}


- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [_backgroundImageView setImage:self.backgroundImage];
}


- (void)setSelected:(BOOL)selected {
    if (selected) {
        if (_selectedBackgroundImage) {
            [_backgroundImageView setImage:self.selectedBackgroundImage];
        }
        if (_selectedTitleColor) {
            [_titleLabel setTextColor:_selectedTitleColor];
        }
    } else {
        [_backgroundImageView setImage:self.backgroundImage];
        if (_titleColor) {
            [_titleLabel setTextColor:_titleColor];
        }
    }
}

@end
