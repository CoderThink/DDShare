//
//  DDShareItemCell.m
//  DDShareDemo
//
//  Created by Think on 2017/3/5.
//  Copyright © 2017年 Think. All rights reserved.
//

#import "DDShareItemCell.h"
#import "UIView+Extension.h"

@interface DDShareItemCell ()
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *rightLine;
@end

@implementation DDShareItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        _titleLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLable];
    }
    return self;
}

- (void)setShowBorderLine:(BOOL)showBorderLine{
    _showBorderLine = showBorderLine;
    if (_showBorderLine) {
        [self addSubview:self.bottomLine];
        [self addSubview:self.rightLine];
    }
}
- (void)setShareItem:(DDShareItem *)shareItem{
    _shareItem = shareItem;
    _imageView.image = shareItem.image;
    _titleLable.text = shareItem.title;
    [_titleLable sizeToFit];
}

- (void)layoutSubviews{
    
    _imageView.frame = CGRectMake(0, 0 ,_itemImageSize.width, _itemImageSize.height);
    
    CGPoint imageCenter = self.center;
    imageCenter.y = _imageView.dd_height * 0.5 + _itemImageTopSpace;
    imageCenter.x = self.dd_width * 0.5;
    _imageView.center = imageCenter;
    
    [_titleLable sizeToFit];
    CGPoint titleCenter = _imageView.center;
    titleCenter.y = imageCenter.y + _imageView.dd_height * 0.5 + _iconAndTitleSpace + _titleLable.dd_height * 0.5;
    _titleLable.center = titleCenter;
}


- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.dd_height-0.5, self.dd_width, 0.5)];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    }
    return _bottomLine;
}
- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.dd_width-0.5, 0, 0.5, self.dd_height)];
        _rightLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    }
    return _rightLine;
}
@end
