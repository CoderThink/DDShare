//
//  DDShareItemCell.h
//  DDShareDemo
//
//  Created by Think on 2017/3/5.
//  Copyright © 2017年 Think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDShareItem.h"

@interface DDShareItemCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) DDShareItem *shareItem;

@property (nonatomic) CGSize itemImageSize; //item中image大小
@property (nonatomic) CGFloat itemImageTopSpace; //item图片距离顶部大小
@property (nonatomic) CGFloat iconAndTitleSpace; //item图片和文字距离
@property (nonatomic, assign) BOOL showBorderLine; //是否显示边界线
@end
