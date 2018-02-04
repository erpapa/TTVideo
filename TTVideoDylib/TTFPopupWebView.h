//
//  TTFPopupWebView.h
//  TTVideoDylib
//
//  Created by erpapa on 2018/1/22.
//  Copyright © 2018年 erpapa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTFPopupWebView : UIView

- (instancetype)initWithURL:(NSURL *)url;

- (void)show;

@end
