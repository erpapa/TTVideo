# TTVideo

[![CI Status](http://img.shields.io/travis/chenhong/TTVideo.svg?style=flat)](https://travis-ci.org/chenhong/TTVideo)
[![Version](https://img.shields.io/cocoapods/v/TTVideo.svg?style=flat)](http://cocoapods.org/pods/TTVideo)
[![License](https://img.shields.io/cocoapods/l/TTVideo.svg?style=flat)](http://cocoapods.org/pods/TTVideo)
[![Platform](https://img.shields.io/cocoapods/p/TTVideo.svg?style=flat)](http://cocoapods.org/pods/TTVideo)


# 更新记录
v0.2.7 为获取视频的GET请求添加host
v0.2.8 禁用 automaticallyWaitsToMinimizeStalling 新功能
v0.2.8.2 AVPlayer play 替换为 AVPlay playImmediatelyAtRate: 尝试解决iOS10播放失败的问题
v0.2.8.3 在暂停状态下,做seek操作有bug,一直loading,不消失.
v0.2.8.4 去掉_isPrerolling判断 有潜在问题
v0.2.8.5 iOS10播放器状态判断api修改
v0.2.8.6 返回isPrerolling
v0.2.8.7 在7 8 系统上 如果seekTime中,loadStatus为playable ,导致seekTime结束的时候,willPlable 不会调用,(loadStatus相同的判断条件)
v1.0.0 增加自定义播放器 ,去掉统计代码
v1.0.0.1 固定playsdk版本号
v1.0.0.2 更新playsdk版本号
v1.0.0.3 playerController属性放到协议里面
v1.0.0.4 currentCDNHost死循环
v1.0.0.5 增加直播使用的通知
v1.0.0.6 系统播放器加载缓存的时候,会不短的设置 _player.rate = _playbackRate
v1.0.0.7 playsdk 1.0.7
v1.0.0.8 playsdk 1.0.8 解决低性能手机切入后台crash + 黑屏
v1.0.0.9 playsdk 1.0.9 iOS7 crash
v1.0.1   notification 修改为 delegate
v1.0.1.1   增加 isReadyForDisplay for 火山
v1.0.1.2 升级playersdk1.0.9.1 滑动视频 ,死循环
v1.0.2.5 播放器 automaticallyWaitsToMinimizeStalling 崩溃
2016.12.14 代码及spec迁移至gitlab
v1.0.2.7 播放器内核 回退到2053
v1.1.0 播放器内核 264 去掉通知.AVPlayerItemFailedToPlayToEndTimeNotification 和 AVPlayerItemDidPlayToEndTimeNotification
v1.1.0 playersdk 2.6.10播放时间计算错误修复

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TTVideo is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTVideo"
```

## Author

chenhong, chenhong@bytedance.com

## License

TTVideo is available under the MIT license. See the LICENSE file for more info.
