//
//  TTFQuizHelperView.h
//  TTVideoDylib
//
//  Created by erpapa on 2018/1/24.
//  Copyright © 2018年 erpapa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const kTTFQuizHelperViewTag;

@interface TTFQuizHelperOptionView : UIView

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) float score;

@end

@interface TTFQuizHelperView : UIView

@end
