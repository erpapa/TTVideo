//
//  TTFSogouResultView.m
//  TTVideoDylib
//
//  Created by huyong on 2018/1/21.
//  Copyright © 2018年 erpapa. All rights reserved.
//

#import "TTFSogouResultView.h"
#import "XXLinkLabel.h"

NSInteger const kTTFSogouResultViewTag = 10241024;
NSString *const kTTFSogouTableViewCellIdentifier = @"kTTFSogouTableViewCellIdentifier";

@implementation TTFSogouTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.questionLable = [[UILabel alloc] init];
        self.questionLable.numberOfLines = 0;
        self.questionLable.font = [UIFont systemFontOfSize:16];
        self.questionLable.textColor = [UIColor whiteColor];
        [self addSubview:self.questionLable];
        
        self.answerLable = [[XXLinkLabel alloc] init];
        self.answerLable.numberOfLines = 0;
        self.answerLable.font = [UIFont systemFontOfSize:20];
        self.answerLable.textColor = [UIColor colorWithRed:252/255.0 green:217/255.0 blue:28/255.0 alpha:1.0];
        self.answerLable.linkTextColor = [UIColor whiteColor];
        self.answerLable.selectedBackgroudColor = [UIColor clearColor];
        [self addSubview:self.answerLable];
        
        self.detailView = [[UIView alloc] init];
        self.detailView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        self.detailView.layer.cornerRadius = 4;
        self.detailView.layer.masksToBounds = YES;
        [self addSubview:self.detailView];
        
        self.detailLabel = [[XXLinkLabel alloc] init];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.linkTextColor = [UIColor colorWithRed:252/255.0 green:217/255.0 blue:28/255.0 alpha:1.0];
        self.detailLabel.selectedBackgroudColor = [UIColor clearColor];
        [self.detailView addSubview:self.detailLabel];
    }
    return self;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    
    NSString *title = [model objectForKey:@"title"];
    NSString *result = [model objectForKey:@"result"];
    NSString *recommend = [model objectForKey:@"recommend"];
    NSArray *search_infos = [model objectForKey:@"search_infos"];
    NSDictionary *search_info = [search_infos firstObject];
    NSString *summary = [search_info objectForKey:@"summary"];
    NSString *url = [search_info objectForKey:@"url"];
    
    self.questionLable.text = title;
    XXLinkLabelModel *answerModel = [[XXLinkLabelModel alloc] init];
    answerModel.message = @"汪仔答案：";
    XXLinkLabelModel *resultModel = [[XXLinkLabelModel alloc] init];
    resultModel.message = @"http://nb.sa.sogou.com/";
    [resultModel replaceUrlWithString:result.length ? result : recommend];
    self.answerLable.messageModels = @[answerModel, resultModel];
    
    if (summary.length && url.length) {
        XXLinkLabelModel *summaryModel = [[XXLinkLabelModel alloc] init];
        summaryModel.message = summary;
        XXLinkLabelModel *urlModel = [[XXLinkLabelModel alloc] init];
        urlModel.message = url;
        [urlModel replaceUrlWithString:@"快速查看>"];
        self.detailLabel.messageModels = @[summaryModel, urlModel];
    } else {
        self.detailLabel.messageModels = nil;
    }
    [self layoutIfNeeded];
}

- (void)relayoutSubviews
{
    self.questionLable.frame = self.bounds;
    [self.questionLable sizeToFit];
    self.questionLable.frame = CGRectMake(0, 0, self.bounds.size.width, self.questionLable.bounds.size.height);
    
    self.answerLable.frame = CGRectMake(26, 0, CGRectGetWidth(self.bounds) - 26, 100);
    [self.answerLable sizeToFit];
    self.answerLable.frame = CGRectMake(26, CGRectGetMaxY(self.questionLable.frame) + 8, CGRectGetWidth(self.bounds) - 26, self.answerLable.bounds.size.height);
    
    if (self.detailLabel.attributedText.length == 0) {
        self.detailView.hidden = YES;
        self.detailView.frame = CGRectMake(26, CGRectGetMaxY(self.answerLable.frame), CGRectGetWidth(self.bounds) - 26, 0);
        self.detailLabel.frame = CGRectMake(8, 0, CGRectGetWidth(self.detailView.frame) - 16, 0);
    } else {
        self.detailView.hidden = NO;
        self.detailLabel.frame = CGRectMake(34, 0, CGRectGetWidth(self.bounds) - 34 - 8, 100);
        [self.detailLabel sizeToFit];
        self.detailView.frame = CGRectMake(26, CGRectGetMaxY(self.answerLable.frame) + 5, CGRectGetWidth(self.bounds) - 26, CGRectGetHeight(self.detailLabel.frame) + 16);
        self.detailLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.detailView.frame) - 16, self.detailLabel.bounds.size.height);
    }
}

- (CGFloat)cellHieght
{
    [self relayoutSubviews];
    
    CGFloat cellHeight = CGRectGetMaxY(self.detailView.frame) + 20;
    return cellHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self relayoutSubviews];
}

@end

@implementation TTFSogouResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = kTTFSogouResultViewTag;
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TTFSogouTableViewCell class] forCellReuseIdentifier:kTTFSogouTableViewCellIdentifier];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        
        self.heightForCell = [[TTFSogouTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTTFSogouTableViewCellIdentifier];
        self.heightForCell.frame = CGRectInset(self.bounds, 8, 12);
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(requestDataFromServer:)];
        self.displayLink.frameInterval = 60;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
        self.currentTimeInterval = self.timeInterval;
        
    }
    return self;
}

- (void)requestDataFromServer:(id)sender
{
    self.currentTimeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *wdcallbackString = [NSString stringWithFormat:@"jQuery321007116257213056087_%ld",self.timeInterval];
    NSString *urlString = [NSString stringWithFormat:@"http://140.143.49.31/api/ans2?key=xigua&wdcallback=%@&_=%ld",wdcallbackString,self.currentTimeInterval];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // GET请求
    request.HTTPMethod = @"GET";
    // 将需要的信息放入请求头
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"http://nb.sa.sogou.com/" forHTTPHeaderField:@"Referer"];
    [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_1_2 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12B440 Sogousearch/Ios/5.9.8" forHTTPHeaderField:@"User-Agent"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
            return;
        }
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *repResult = [result stringByReplacingOccurrencesOfString:wdcallbackString withString:@""];
        if (repResult.length > 2) {
            repResult = [repResult substringWithRange:NSMakeRange(1, repResult.length - 2)];
        }
        NSData *jsonData = [repResult dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData == nil) {
            return;
        }
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSArray *resultArray = [object objectForKey:@"result"];
            if ([resultArray isKindOfClass:[NSArray class]]) {
                self.dataArray = resultArray;
            }
        }
        
    }];
    [task resume];
}

- (void)setDataArray:(NSArray *)dataArray
{
    NSString *lastModelString = [dataArray lastObject];
    NSString *currentModelString = [_dataArray lastObject];
    NSData *lastJsonData = [lastModelString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *currentJsonData = [currentModelString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (lastJsonData && currentJsonData) {
        NSDictionary *lastObject = [NSJSONSerialization JSONObjectWithData:lastJsonData options:0 error:&error];
        NSDictionary *currentObject = [NSJSONSerialization JSONObjectWithData:currentJsonData options:0 error:&error];
        if ([[lastObject objectForKey:@"title"] isEqualToString:[currentObject objectForKey:@"title"]]) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = [dataArray copy];
            [self.tableView reloadData];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = [dataArray copy];
            [self.tableView reloadData];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFSogouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTTFSogouTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        __weak typeof(self) weakSelf = self;
        NSString *jsonString = [self.dataArray objectAtIndex:indexPath.row];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            cell.model = dict;
            cell.detailLabel.linkClickBlock = ^(XXLinkLabelModel *linkInfo, NSString *linkUrl) {
                [weakSelf didClickLinkModel:linkInfo linkUrl:linkUrl];
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        self.heightForCell.frame = CGRectInset(self.bounds, 8, 10);
        NSString *jsonString = [self.dataArray objectAtIndex:indexPath.row];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            self.heightForCell.model = dict;
        }
        return [self.heightForCell cellHieght];
    }
    return 0.0;
}

- (void)didClickLinkModel:(XXLinkLabelModel *)linkInfo linkUrl:(NSString *)linkUrl
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = CGRectInset(self.bounds, 8, 12);
}

- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
