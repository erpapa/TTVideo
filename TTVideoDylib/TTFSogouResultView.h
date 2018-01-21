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

@class XXLinkLabel;
@interface TTFSogouTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *questionLable;
@property (nonatomic, strong) XXLinkLabel *answerLable;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) XXLinkLabel *detailLabel;

@property (nonatomic, strong) NSDictionary *model;
- (CGFloat)cellHieght;

@end

@interface TTFSogouResultView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) TTFSogouTableViewCell *heightForCell;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger timeInterval;
@property (nonatomic, assign) NSInteger currentTimeInterval;
@end
