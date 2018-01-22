//
//  TTFSogouResultView.h
//  TTVideoDylib
//
//  Created by huyong on 2018/1/21.
//  Copyright © 2018年 erpapa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const kTTFSogouResultViewTag;
extern NSString *const kTTFSogouTableViewCellIdentifier;

@class TTTAttributedLabel;
@interface TTFSogouTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *questionLable;
@property (nonatomic, strong) TTTAttributedLabel *answerLable;
@property (nonatomic, strong) TTTAttributedLabel *detailLabel;

@property (nonatomic, strong) NSDictionary *model;

- (CGFloat)cellHieght; // 计算高度

@end

@interface TTFSogouResultView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end
