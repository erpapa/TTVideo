//
//  TTFQuizHelperView.m
//  TTVideoDylib
//
//  Created by erpapa on 2018/1/24.
//  Copyright © 2018年 erpapa. All rights reserved.
//

#import "TTFQuizHelperView.h"
#import "TTTAttributedLabel.h"

NSInteger const kTTFQuizHelperViewTag = 10041004;

@implementation TTFQuizHelperOptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
        self.layer.cornerRadius = 18.0;
        self.layer.masksToBounds = YES;
        
        self.gradientLayer = [[CAGradientLayer alloc] init];
        self.gradientLayer.frame = self.bounds;
        self.gradientLayer.locations = @[@(0),@(1)];
        self.gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
        self.gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
        [self.layer addSublayer:self.gradientLayer];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.textColor = [UIColor whiteColor];
        self.scoreLabel.font = [UIFont systemFontOfSize:16];
        self.scoreLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.scoreLabel];
    }
    return self;
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    
    self.gradientLayer.colors = colors;
}

- (void)setScore:(float)score
{
    _score = score;
    
    self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * score / 100.0, CGRectGetHeight(self.bounds));
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f%%", score];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds) - 100, CGRectGetHeight(self.bounds));
    self.scoreLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 82, 0, 72, CGRectGetHeight(self.bounds));
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) * 0.5;
}

@end

@interface TTFQuizHelperView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) TTFQuizHelperOptionView *optionView0;
@property (nonatomic, strong) TTFQuizHelperOptionView *optionView1;
@property (nonatomic, strong) TTFQuizHelperOptionView *optionView2;
@property (nonatomic, strong) TTFQuizHelperOptionView *optionView3;
@property (nonatomic, strong) UIView *personalizeView;
@property (nonatomic, strong) UILabel *personalizeLabel;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger currentTimeInterval;

@end

@implementation TTFQuizHelperView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = kTTFQuizHelperViewTag;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.numberOfLines = 0;
        self.questionLabel.font = [UIFont systemFontOfSize:18];
        self.questionLabel.textColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.questionLabel];
        
        self.optionView0 = [[TTFQuizHelperOptionView alloc] initWithFrame:CGRectMake(8, 25, CGRectGetWidth(self.frame) - 16, 36)];
        [self.scrollView addSubview:self.optionView0];
        
        self.optionView1 = [[TTFQuizHelperOptionView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.optionView0.frame) + 10, CGRectGetWidth(self.frame) - 16, 36)];
        [self.scrollView addSubview:self.optionView1];
        
        self.optionView2 = [[TTFQuizHelperOptionView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.optionView1.frame) + 10, CGRectGetWidth(self.frame) - 16, 36)];
        [self.scrollView addSubview:self.optionView2];
        
        self.optionView3 = [[TTFQuizHelperOptionView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.optionView2.frame) + 10, CGRectGetWidth(self.frame) - 16, 36)];
        self.optionView3.hidden = YES;
        [self.scrollView addSubview:self.optionView3];
        
        self.personalizeView = [[UIView alloc] initWithFrame:CGRectMake(12, 25, CGRectGetWidth(self.frame) - 24, 100)];
        self.personalizeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
        self.personalizeView.layer.cornerRadius = 8;
        self.personalizeView.layer.masksToBounds = YES;
        self.personalizeView.hidden = YES;
        [self.scrollView addSubview:self.personalizeView];

        self.personalizeLabel = [[UILabel alloc] initWithFrame:self.personalizeView.bounds];
        self.personalizeLabel.textAlignment = NSTextAlignmentCenter;
        self.personalizeLabel.numberOfLines = 0;
        self.personalizeLabel.font = [UIFont systemFontOfSize:20];
        self.personalizeLabel.textColor = [UIColor colorWithRed:252/255.0 green:217/255.0 blue:28/255.0 alpha:1.0];
        [self.personalizeView addSubview:self.personalizeLabel];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(requestDataFromServer:)];
        self.displayLink.frameInterval = 60;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}


- (void)requestDataFromServer:(id)sender
{
    self.currentTimeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *urlString = [NSString stringWithFormat:@"http://answer.sm.cn/answer/curr?format=json&_t=1%ld&activity=million",(long)self.currentTimeInterval];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // GET请求
    request.HTTPMethod = @"GET";
    // 将需要的信息放入请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"zh-CN,zh;q=0.9,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"http://answer.sm.cn/answer/index?activity=million" forHTTPHeaderField:@"Referer"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Mobile/14B100" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"sm_uuid=9910281345f04bd4193171fbe2b89271%7C%7C%7C1516799668; sm_diu=9910281345f04bd4193171fbe2b89271%7C%7C1Fe0ffe0457799ab3a%7C1516799668" forHTTPHeaderField:@"Cookie"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
            return;
        }
        NSDictionary *objectDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *dataDict = [objectDict objectForKey:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshContentView:dataDict];
        });
    }];
    [task resume];
}

- (void)refreshContentView:(NSDictionary *)dict
{
    if (dict.allKeys.count <= 0) {
        return;
    }
    
    NSString *round = [dict objectForKey:@"round"];
    NSString *title = [dict objectForKey:@"title"];
    NSArray *options = [dict objectForKey:@"options"];
    // NSString *official = [dict objectForKey:@"official"];
    // NSString *correct = [dict objectForKey:@"correct"];
    NSInteger correct = [[dict objectForKey:@"correct"] integerValue];
    if (title.length == 0 || options.count == 0 || correct >= options.count) {
        return;
    }
    self.questionLabel.text = [NSString stringWithFormat:@"%@.%@",round,title];
    self.questionLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame) - 16, 100);
    [self.questionLabel sizeToFit];
    self.questionLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame) - 16, self.questionLabel.frame.size.height);
    
    if (options.count >= 3) {
        NSDictionary *option0 = [options objectAtIndex:0];
        NSDictionary *option1 = [options objectAtIndex:1];
        NSDictionary *option2 = [options objectAtIndex:1];
        NSString *title0 = [option0 objectForKey:@"title"];
        NSString *title1 = [option1 objectForKey:@"title"];
        NSString *title2 = [option2 objectForKey:@"title"];
        if ([title1 hasPrefix:@"NONE"] || [title2 hasPrefix:@"NONE"]) {
            self.optionView0.hidden = YES;
            self.optionView1.hidden = YES;
            self.optionView2.hidden = YES;
            self.optionView3.hidden = YES;
            self.personalizeView.hidden = NO;
            self.personalizeView.frame = CGRectMake(12, CGRectGetMaxY(self.questionLabel.frame) + 12, CGRectGetWidth(self.frame) - 24, 100);
            self.personalizeLabel.frame = CGRectInset(self.personalizeView.bounds, 5, 5);
            if (title0.length <= 24) {
                NSString *titleString = [title0 stringByReplacingOccurrencesOfString:@"|-|" withString:@">---<"];
                self.personalizeLabel.attributedText = nil;
                self.personalizeLabel.text = titleString;
            } else {
                NSString *titleString = [title0 stringByReplacingOccurrencesOfString:@"|-|" withString:@"\n"];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 8.0;
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping; // 分割模式
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleString length])];
                self.personalizeLabel.text = nil;
                self.personalizeLabel.attributedText = attributedString;
            }
            self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.personalizeView.frame) + 18);
            return;
        }
    }
    self.personalizeView.hidden = YES;
    // 颜色渐变
    NSArray *defaultColors = @[(__bridge id)[UIColor colorWithRed:124.0/255.0 green:14.0/255.0 blue:244.0/255.0 alpha:0.5].CGColor,(__bridge id)[UIColor colorWithRed:124.0/255.0 green:14.0/255.0 blue:244.0/255.0 alpha:0.75].CGColor];
    NSArray *correctColors = @[(__bridge id)[UIColor colorWithRed:251.0/255.0 green:0.0 blue:112.0/255.0 alpha:0.5].CGColor,(__bridge id)[UIColor colorWithRed:251.0/255.0 green:0.0 blue:112.0/255.0 alpha:0.75].CGColor];
    if (correct == 0) {
        self.optionView0.colors = correctColors;
        self.optionView1.colors = defaultColors;
        self.optionView2.colors = defaultColors;
        self.optionView3.colors = defaultColors;
    } else if (correct == 1) {
        self.optionView0.colors = defaultColors;
        self.optionView1.colors = correctColors;
        self.optionView2.colors = defaultColors;
        self.optionView3.colors = defaultColors;
    } else if (correct == 2) {
        self.optionView0.colors = defaultColors;
        self.optionView1.colors = defaultColors;
        self.optionView2.colors = correctColors;
        self.optionView3.colors = defaultColors;
    } else {
        self.optionView0.colors = defaultColors;
        self.optionView1.colors = defaultColors;
        self.optionView2.colors = defaultColors;
        self.optionView3.colors = correctColors;
    }
    if (options.count == 1) {
        self.optionView0.hidden = NO;
        self.optionView1.hidden = YES;
        self.optionView2.hidden = YES;
        self.optionView3.hidden = YES;
        
        NSDictionary *option0 = [options objectAtIndex:0];
        self.optionView0.titleLabel.text = [NSString stringWithFormat:@"A: %@",[option0 objectForKey:@"title"]];
        self.optionView0.score = [[option0 objectForKey:@"score"] floatValue];
        self.optionView0.frame = CGRectMake(8, CGRectGetMaxY(self.questionLabel.frame) + 12, CGRectGetWidth(self.frame) - 20, 36);
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.optionView0.frame) + 18);
    } else if (options.count == 2) {
        self.optionView0.hidden = NO;
        self.optionView1.hidden = NO;
        self.optionView2.hidden = YES;
        self.optionView3.hidden = YES;
        NSDictionary *option0 = [options objectAtIndex:0];
        self.optionView0.titleLabel.text = [NSString stringWithFormat:@"A: %@",[option0 objectForKey:@"title"]];
        self.optionView0.score = [[option0 objectForKey:@"score"] floatValue];
        self.optionView0.frame = CGRectMake(8, CGRectGetMaxY(self.questionLabel.frame) + 12, CGRectGetWidth(self.frame) - 20, 36);
        
        NSDictionary *option1 = [options objectAtIndex:1];
        self.optionView1.titleLabel.text = [NSString stringWithFormat:@"B: %@",[option1 objectForKey:@"title"]];
        self.optionView1.score = [[option1 objectForKey:@"score"] floatValue];
        self.optionView1.frame = CGRectMake(8, CGRectGetMaxY(self.optionView0.frame) + 8, CGRectGetWidth(self.frame) - 20, 36);
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.optionView1.frame) + 18);
    } else if (options.count == 3) {
        self.optionView0.hidden = NO;
        self.optionView1.hidden = NO;
        self.optionView2.hidden = NO;
        self.optionView3.hidden = YES;
        NSDictionary *option0 = [options objectAtIndex:0];
        self.optionView0.titleLabel.text = [NSString stringWithFormat:@"A: %@",[option0 objectForKey:@"title"]];
        self.optionView0.score = [[option0 objectForKey:@"score"] floatValue];
        self.optionView0.frame = CGRectMake(8, CGRectGetMaxY(self.questionLabel.frame) + 12, CGRectGetWidth(self.frame) - 20, 36);
        
        NSDictionary *option1 = [options objectAtIndex:1];
        self.optionView1.titleLabel.text = [NSString stringWithFormat:@"B: %@",[option1 objectForKey:@"title"]];
        self.optionView1.score = [[option1 objectForKey:@"score"] floatValue];
        self.optionView1.frame = CGRectMake(8, CGRectGetMaxY(self.optionView0.frame) + 8, CGRectGetWidth(self.frame) - 20, 36);
        
        NSDictionary *option2 = [options objectAtIndex:2];
        self.optionView2.titleLabel.text = [NSString stringWithFormat:@"C: %@",[option2 objectForKey:@"title"]];
        self.optionView2.score = [[option2 objectForKey:@"score"] floatValue];
        self.optionView2.frame = CGRectMake(8, CGRectGetMaxY(self.optionView1.frame) + 8, CGRectGetWidth(self.frame) - 20, 36);
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.optionView2.frame) + 18);
    } else {
        self.optionView0.hidden = NO;
        self.optionView1.hidden = NO;
        self.optionView2.hidden = NO;
        self.optionView3.hidden = NO;
        
        NSDictionary *option0 = [options objectAtIndex:0];
        self.optionView0.titleLabel.text = [NSString stringWithFormat:@"A: %@",[option0 objectForKey:@"title"]];
        self.optionView0.score = [[option0 objectForKey:@"score"] floatValue];
        self.optionView0.frame = CGRectMake(8, CGRectGetMaxY(self.questionLabel.frame) + 12, CGRectGetWidth(self.frame) - 20, 36);
        
        NSDictionary *option1 = [options objectAtIndex:1];
        self.optionView1.titleLabel.text = [NSString stringWithFormat:@"B: %@",[option1 objectForKey:@"title"]];
        self.optionView1.score = [[option1 objectForKey:@"score"] floatValue];
        self.optionView1.frame = CGRectMake(8, CGRectGetMaxY(self.optionView0.frame) + 8, CGRectGetWidth(self.frame) - 20, 36);
        
        NSDictionary *option2 = [options objectAtIndex:2];
        self.optionView2.titleLabel.text = [NSString stringWithFormat:@"C: %@",[option2 objectForKey:@"title"]];
        self.optionView2.score = [[option2 objectForKey:@"score"] floatValue];
        self.optionView2.frame = CGRectMake(8, CGRectGetMaxY(self.optionView1.frame) + 8, CGRectGetWidth(self.frame) - 20, 36);
        
        NSDictionary *option3 = [options objectAtIndex:3];
        self.optionView3.titleLabel.text = [NSString stringWithFormat:@"D: %@",[option3 objectForKey:@"title"]];
        self.optionView3.score = [[option3 objectForKey:@"score"] floatValue];
        self.optionView3.frame = CGRectMake(8, CGRectGetMaxY(self.optionView2.frame) + 8, CGRectGetWidth(self.frame) - 20, 36);
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.optionView3.frame) + 18);
    }
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
