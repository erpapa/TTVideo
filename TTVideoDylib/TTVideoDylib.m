//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  TTVideoDylib.m
//  TTVideoDylib
//
//  Created by huyong on 2018/1/21.
//  Copyright (c) 2018年 erpapa. All rights reserved.
//

#import "TTVideoDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import "TTFSogouResultView.h"

static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {

        CYListenServer(6666);
    }];
}

/** 学习笔记
 *  1.声明CHDeclareClass
 *    1.1 CHClassMethod是重写类方法(不方便直接拿到Class指针)
 *    1.2 CHOptimizedClassMethod也是重写类方法(可以直接取到Class指针self)
 *    1.3 CHOptimizedMethod是重写实例方法(self是当前实例变量)
 *  2.CHConstructor
 *    2.1 加载类CHLoadLateClass
 *    2.2 hook类方法CHClassHook(等同于CHHook)
 *    2.3 hook实例方法CHHook
 **/

//@interface WTWatermarkCalculator
//
//+ (CGRect)calculateNormalizedRectWithWatermark:(id)watermark contextRect:(CGRect)rect;
//+ (CGFloat)helperSizeHypotenuse:(CGSize)size;
//+ (CGRect)normalizeRect:(CGRect)nRect inRect:(CGRect)rect;
//
//@end
//
//@interface IndexViewController
//
//- (void)clickCamera;
//
//- (void)baner:(UIView *)view didSelectItemAtIndex:(NSInteger)index;
//
//@end
//
//CHDeclareClass(WTWatermarkCalculator)
//
//// 以下两个方法基本上是等价的，建议用下一个
////CHClassMethod2(CGRect, WTWatermarkCalculator, calculateNormalizedRectWithWatermark, id, watermark, contextRect, CGRect, rect){
////    return CGRectZero;
////}
//CHOptimizedClassMethod2(self, CGRect, WTWatermarkCalculator, calculateNormalizedRectWithWatermark, id, watermark, contextRect, CGRect, rect){
//    return CGRectZero;
//}
//
////CHClassMethod1(CGFloat, WTWatermarkCalculator, helperSizeHypotenuse, CGSize, size){
////    return 0.0;
////}
//
//CHOptimizedClassMethod1(self, CGFloat, WTWatermarkCalculator, helperSizeHypotenuse, CGSize, size){
//    return 0.0;
//}
////CHClassMethod2(CGRect, WTWatermarkCalculator, normalizeRect, CGRect, nRect, inRect, CGRect, rect){
////    return CGRectZero;
////}
//CHOptimizedClassMethod2(self, CGRect, WTWatermarkCalculator, normalizeRect, CGRect, nRect, inRect, CGRect, rect){
//    return CGRectZero;
//}
//
//CHDeclareClass(IndexViewController)
//
//CHOptimizedMethod(0, self, void, IndexViewController, clickCamera){
//
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要跳转吗？" preferredStyle:UIAlertControllerStyleAlert];
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        CHSuper(0, IndexViewController, clickCamera);
//    }]];
//    [((UIViewController *)self) presentViewController:alertVC animated:YES completion:NULL];
//
//}
//
//CHOptimizedMethod2(self, void, IndexViewController, baner, UIView *, view, didSelectItemAtIndex, NSInteger, index){
//
//    CHSuper2(IndexViewController, baner,view,didSelectItemAtIndex,index);
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"didSelectItemAtIndex:%ld", index] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//}
//
//CHConstructor{
//    CHLoadLateClass(WTWatermarkCalculator);
//    CHLoadLateClass(IndexViewController);
//
//    CHClassHook2(WTWatermarkCalculator, calculateNormalizedRectWithWatermark, contextRect);
//    CHClassHook1(WTWatermarkCalculator, helperSizeHypotenuse);
//    CHClassHook2(WTWatermarkCalculator, normalizeRect, inRect);
//
//    CHHook0(IndexViewController, clickCamera);
//    CHHook2(IndexViewController, baner, didSelectItemAtIndex);
//}


/**
 *  直播控制器
 **/
@interface TTFQuizShowLiveRoomViewController

// 接收消息
- (void)fetchedLivingStreamInfo:(id)info;

@end

/**
 *  问题
 **/
@interface TTFQuestionStruct

- (void)setTimeLimit:(long)limit;

- (long)timeLimit;

@end

@interface TTFAnswerStruct

@end

@interface TTFQuestionAnswerUnit

- (void)setQuestion:(TTFQuestionStruct *)question;

- (void)setAnswer:(TTFAnswerStruct *)answer;

- (void)setQuestionTrace:(id)trace;

- (void)setStatus:(NSInteger)status;

- (void)setUserChoosen:(id)model;

- (void)setUserNeedAnswer:(BOOL)need;

- (void)setViewMoel:(id)model;

- (void)submitAnswerWithOptions:(id)options;

@end

//// 问题view
//@interface TTFQuestionAnswerView
//
//
//@end

/**
 *  底部view
 **/
@interface TTFTalkBoardContainerView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(id)model;

- (void)layoutSubviews;

@end

CHDeclareClass(TTFQuizShowLiveRoomViewController)

CHOptimizedMethod1(self, void, TTFQuizShowLiveRoomViewController, fetchedLivingStreamInfo, id, info){
    CHSuper1(TTFQuizShowLiveRoomViewController, fetchedLivingStreamInfo, info);
    NSLog(@"fetchedLivingStreamInfo:%@",info);
}

CHDeclareClass(TTFQuestionStruct)

CHDeclareClass(TTFAnswerStruct)

CHDeclareClass(TTFQuestionAnswerUnit)
/**
 @property(nonatomic) long long activityId;
 @property(nonatomic) long long commitDelay;
 @property(retain, nonatomic) NSMutableArray *imageURLArray;
 @property(readonly, nonatomic) unsigned long long imageURLArray_Count;
 @property(retain, nonatomic) NSMutableArray *optionsArray;
 @property(readonly, nonatomic) unsigned long long optionsArray_Count;
 @property(nonatomic) long long questionId;
 @property(nonatomic) long long questionStartTsMs;
 @property(nonatomic) int random;
 @property(copy, nonatomic) NSString *text;
 @property(nonatomic) long long timeLimit;
 @property(nonatomic) long long uuQuestionId;
 @property(retain, nonatomic) NSMutableArray *videoURLArray;
 @property(readonly, nonatomic) unsigned long long videoURLArray_Count;

 **/
CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setQuestion, TTFQuestionStruct *, question){
    long limit = [question timeLimit] * 1.5;
    [question setTimeLimit:limit];
    CHSuper1(TTFQuestionAnswerUnit, setQuestion, question);
    NSLog(@"setQuestion:%@",question);
}

/**
 @property(nonatomic) long long activityId;
 @property(nonatomic) long long answerStartTsMs;
 @property(retain, nonatomic) NSMutableArray *optionsArray;
 @property(readonly, nonatomic) unsigned long long optionsArray_Count;
 @property(nonatomic) long long questionId;
 @property(nonatomic) long long useLifeUsers;
 @property(nonatomic) long long uuQuestionId;
 **/
CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setAnswer, id, answer){
    CHSuper1(TTFQuestionAnswerUnit, setAnswer, answer);
    NSLog(@"setAnswer:%@",answer);
}

CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setQuestionTrace, id, trace){
    CHSuper1(TTFQuestionAnswerUnit, setQuestionTrace, trace);
    NSLog(@"setQuestionTrace:%@",trace);
}

CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setStatus, NSInteger, status){
    CHSuper1(TTFQuestionAnswerUnit, setStatus, status);
    NSLog(@"setStatus:%ld",status);
}

CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setUserChoosen, id, model){
    CHSuper1(TTFQuestionAnswerUnit, setUserChoosen, model);
    NSLog(@"setUserChoosen:%@",model);
}

CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setUserNeedAnswer, BOOL, need){
    CHSuper1(TTFQuestionAnswerUnit, setUserNeedAnswer, need);
    NSLog(@"setUserNeedAnswer:%d",need);
}

CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, setViewMoel, id, model){
    CHSuper1(TTFQuestionAnswerUnit, setViewMoel, model);
    NSLog(@"setViewMoel:%@",model);
}

CHOptimizedMethod1(self, void, TTFQuestionAnswerUnit, submitAnswerWithOptions, id, options){
    CHSuper1(TTFQuestionAnswerUnit, submitAnswerWithOptions, options);
    NSLog(@"submitAnswerWithOptions:%@",options);
}

CHDeclareClass(TTFTalkBoardContainerView)

CHOptimizedMethod2(self, TTFTalkBoardContainerView *, TTFTalkBoardContainerView, initWithFrame, CGRect, frame, viewModel, id, model){
    
    self = (TTFTalkBoardContainerView *)CHSuper2(TTFTalkBoardContainerView, initWithFrame, frame, viewModel, model);
    if (self) {
        UIView *selfView = (UIView *)self;
        
        UIPageControl *pageDotView = [selfView valueForKey:@"_pageDotView"];
        pageDotView.hidden = YES;
        UILabel *slideTipLabel = [selfView valueForKey:@"_slideTipLabel"];
        slideTipLabel.hidden = YES;
        
        TTFSogouResultView *resultView = [[TTFSogouResultView alloc] initWithFrame:CGRectMake(0, 0, selfView.frame.size.width, selfView.frame.size.height)];
        resultView.backgroundColor = [UIColor whiteColor];
        [selfView addSubview:resultView];
    }
    return self;
}

CHOptimizedMethod0(self, void, TTFTalkBoardContainerView, layoutSubviews){
    CHSuper0(TTFTalkBoardContainerView, layoutSubviews);
    
    UIView *selfView = (UIView *)self;
    TTFSogouResultView *resultView = (TTFSogouResultView *)[selfView viewWithTag:kTTFSogouResultViewTag];
    resultView.frame = CGRectMake(0, 0, selfView.frame.size.width, selfView.frame.size.height);
}

CHConstructor{
    CHLoadLateClass(TTFQuizShowLiveRoomViewController);
    CHLoadLateClass(TTFQuestionStruct);
    CHLoadLateClass(TTFAnswerStruct);
    CHLoadLateClass(TTFQuestionAnswerUnit);
    CHLoadLateClass(TTFTalkBoardContainerView);
    
    CHHook1(TTFQuizShowLiveRoomViewController, fetchedLivingStreamInfo);
    
    CHHook1(TTFQuestionAnswerUnit, setQuestion);
    CHHook1(TTFQuestionAnswerUnit, setAnswer);
    CHHook1(TTFQuestionAnswerUnit, setQuestionTrace);
    CHHook1(TTFQuestionAnswerUnit, setStatus);
    CHHook1(TTFQuestionAnswerUnit, setUserChoosen);
    CHHook1(TTFQuestionAnswerUnit, setUserNeedAnswer);
    CHHook1(TTFQuestionAnswerUnit, setViewMoel);
    CHHook1(TTFQuestionAnswerUnit, submitAnswerWithOptions);
    
    CHHook2(TTFTalkBoardContainerView, initWithFrame, viewModel);
    CHHook0(TTFTalkBoardContainerView, layoutSubviews);
}

