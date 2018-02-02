//
//  TTFSogouResultView.m
//  TTVideoDylib
//
//  Created by huyong on 2018/1/21.
//  Copyright © 2018年 erpapa. All rights reserved.
//

#import "TTFSogouResultView.h"
#import "TTTAttributedLabel.h"
#import "TTFPoPWebView.h"

NSInteger const kTTFSogouResultViewTag = 10241024;
NSString *const kTTFSogouTableViewCellIdentifier = @"kTTFSogouTableViewCellIdentifier";

@implementation TTFSogouTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.cardView = [[UIView alloc] initWithFrame:self.bounds];
        self.cardView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
        self.cardView.layer.cornerRadius = 5.0;
        self.cardView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.cardView];
        
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.numberOfLines = 0;
        self.questionLabel.font = [UIFont systemFontOfSize:16];
        self.questionLabel.textColor = [UIColor whiteColor];
        [self.cardView addSubview:self.questionLabel];
        
        self.answerLabel = [[TTTAttributedLabel alloc] initWithFrame:self.bounds];
        self.answerLabel.numberOfLines = 0;
        self.answerLabel.font = [UIFont systemFontOfSize:20];
        self.answerLabel.textColor = [UIColor colorWithRed:252/255.0 green:217/255.0 blue:28/255.0 alpha:1.0];
        self.answerLabel.highlightedTextColor = [UIColor clearColor];
        
        NSMutableDictionary *answerLinkAttributes = [NSMutableDictionary dictionary];
        [answerLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [answerLinkAttributes setValue:(__bridge id)[[UIColor whiteColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [answerLinkAttributes setValue:(__bridge id)[[UIColor clearColor] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
        self.answerLabel.linkAttributes = answerLinkAttributes;
        self.answerLabel.activeLinkAttributes = answerLinkAttributes;
        [self.cardView addSubview:self.answerLabel];
        
        self.detailLabel = [[TTTAttributedLabel alloc] initWithFrame:self.bounds];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor = [UIColor whiteColor];
        NSMutableDictionary *detailLinkAttributes = [NSMutableDictionary dictionary];
        [detailLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [detailLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:252/255.0 green:217/255.0 blue:28/255.0 alpha:1.0] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [detailLinkAttributes setValue:(__bridge id)[[UIColor clearColor] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
        self.detailLabel.linkAttributes = detailLinkAttributes;
        self.detailLabel.activeLinkAttributes = detailLinkAttributes;
        [self.cardView addSubview:self.detailLabel];
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
    
    self.questionLabel.text = title;
    NSString *answer = result.length ? result : recommend;
    NSString *answetText = [NSString stringWithFormat:@"汪仔答案：%@",answer];
    self.answerLabel.text = answetText;
    [self.answerLabel addLinkToURL:[NSURL URLWithString:@"http://nb.sa.sogou.com/"] withRange:[answetText rangeOfString:answer]];
    
    if (summary.length && url.length) {
        NSString *summaryText = [NSString stringWithFormat:@"%@快速查看>",summary];
        NSRange summaryRange = [summaryText rangeOfString:@"快速查看>" options:NSBackwardsSearch];
        self.detailLabel.text = summaryText;
        [self.detailLabel addLinkToURL:[NSURL URLWithString:url] withRange:summaryRange];
    } else {
        self.detailLabel.text = nil;
    }
    [self layoutIfNeeded];
}

- (void)relayoutSubviews
{
    self.questionLabel.frame = CGRectInset(self.bounds, 4, 6);
    [self.questionLabel sizeToFit];
    self.questionLabel.frame = CGRectMake(4, 6, self.bounds.size.width - 8, self.questionLabel.bounds.size.height);
    
    self.answerLabel.frame = CGRectMake(26, 0, CGRectGetWidth(self.bounds) - 26 - 8, 100);
    [self.answerLabel sizeToFit];
    self.answerLabel.frame = CGRectMake(26, CGRectGetMaxY(self.questionLabel.frame) + 10, CGRectGetWidth(self.bounds) - 26 - 8, self.answerLabel.bounds.size.height);
    
    NSArray *search_infos = [self.model objectForKey:@"search_infos"];
    NSDictionary *search_info = [search_infos firstObject];
    NSString *summary = [search_info objectForKey:@"summary"];
    NSString *url = [search_info objectForKey:@"url"];
    if (summary.length && url.length) {
        self.detailLabel.hidden = NO;
        self.detailLabel.frame = CGRectMake(26, CGRectGetMaxY(self.answerLabel.frame) + 5, CGRectGetWidth(self.bounds) - 26 - 8, 100);
        [self.detailLabel sizeToFit];
        self.detailLabel.frame = CGRectMake(26, CGRectGetMaxY(self.answerLabel.frame) + 5, CGRectGetWidth(self.bounds) - 26 - 8, self.detailLabel.bounds.size.height);
    } else {
        self.detailLabel.hidden = YES;
        self.detailLabel.frame = CGRectMake(26, CGRectGetMaxY(self.answerLabel.frame) + 5, CGRectGetWidth(self.bounds) - 26 - 8, 0);
        
    }
    self.cardView.frame = CGRectMake(0, 4, CGRectGetWidth(self.bounds), CGRectGetMaxY(self.detailLabel.frame) + 6);
}

- (CGFloat)cellHieght
{
    [self relayoutSubviews];
    
    CGFloat cellHeight = CGRectGetMaxY(self.cardView.frame) + 4;
    return cellHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self relayoutSubviews];
}

@end

@interface TTFSogouResultView () <UITableViewDataSource, UITableViewDelegate,TTTAttributedLabelDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) TTFSogouTableViewCell *heightForCell;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger timeInterval;
@property (nonatomic, assign) NSInteger currentTimeInterval;

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
        self.heightForCell.frame = CGRectInset(self.bounds, 8, 0);
        
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
    NSString *urlString = [NSString stringWithFormat:@"http://140.143.49.31/api/ans2?key=xigua&wdcallback=%@&_=%ld",wdcallbackString,(long)self.currentTimeInterval];
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
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Mobile/14B100 Sogousearch/Ios/5.9.8" forHTTPHeaderField:@"User-Agent"];
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
                NSMutableArray *dataArray = [NSMutableArray array];
                for (NSString *objectString in resultArray) {
                    NSData *objectData = [objectString dataUsingEncoding:NSUTF8StringEncoding];
                    if (jsonData == nil) {
                        continue;
                    }
                    NSDictionary *objectDict = [NSJSONSerialization JSONObjectWithData:objectData options:0 error:nil];
                    if (objectDict) {
                        [dataArray addObject:objectDict];
                    }
                }
                [self refreshDataArray:dataArray];
            }
        }
        
    }];
    [task resume];
}

- (void)refreshDataArray:(NSArray *)dataArray
{
    if (dataArray.count <= 0) {
        return;
    }
    NSDictionary *lastObject = [dataArray lastObject];
    NSDictionary *currentObject = [self.dataArray lastObject];
    if ([[lastObject objectForKey:@"title"] isEqualToString:[currentObject objectForKey:@"title"]]) {
        return;
    }
    
    // 取得没有重复的项
    NSMutableArray *exitArray = [NSMutableArray arrayWithArray:self.dataArray];
    for (NSDictionary *dict in dataArray) {
        BOOL found = NO;
        for (NSDictionary *exitDict in self.dataArray) {
            if ([[dict objectForKey:@"title"] isEqualToString:[exitDict objectForKey:@"title"]]) {
                found = YES;
                break;
            }
        }
        if (found == NO) {
            [exitArray addObject:dict];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataArray = [exitArray copy];
        [self.tableView reloadData];
        if (self.dataArray.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFSogouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTTFSogouTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        cell.detailLabel.delegate = self;
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        self.heightForCell.frame = CGRectInset(self.bounds, 8, 0);
        self.heightForCell.model = [self.dataArray objectAtIndex:indexPath.row];
        return [self.heightForCell cellHieght];
    }
    return 0.0;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"didSelectLinkWithURL:%@",url.absoluteString);
    
    TTFPoPWebView *webView = [[TTFPoPWebView alloc] initWithURL:url];
    [webView show];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point
{
    NSLog(@"didLongPressLinkWithURL:%@",url.absoluteString);
    
    TTFPoPWebView *webView = [[TTFPoPWebView alloc] initWithURL:url];
    [webView show];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectInset(self.bounds, 8, 0);
}

- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
