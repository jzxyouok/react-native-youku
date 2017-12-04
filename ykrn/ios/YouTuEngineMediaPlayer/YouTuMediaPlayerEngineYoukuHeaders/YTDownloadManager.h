//
//  YTDownloadManager.h
//  YouTuEngineMediaPlayer
//
//  Created by 周娜 on 16/3/31.
//  Copyright © 2016年 Youku Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTDownloadDefine.h"

typedef void (^BackgroundCompletionHandler)(void);

typedef enum {
    YTDownloadCheckNormal  = 0,
    YTDownloadCheckNoNet,
    YTDownloadCheck3GForbidden
    
} YTDownloadManageCheckResult;

@class YTDownloadTaskModel;
@class YTDownloadModelSequence;
@class YTDownloadEngine;
@class ThreadSafeMutableArray;
@class YTEngineYoukuPlayerInstanceItem;
@class YTLocalMedia;

@protocol YTDownloadManagerDelegate
@optional
- (void)downloadManagerDidAddTask:(YTDownloadTaskModel*)aModel;
- (void)downloadManagerDidAddTasks:(NSArray*)array;

- (void)downloadManagerDidPause:(YTDownloadTaskModel*)aModel;
- (void)downloadManagerDidStart:(YTDownloadTaskModel*)aModel;

- (void)downloadManagerDidPauseAll:(NSArray *)modelArray;
- (void)downloadManagerDidStartAll:(ThreadSafeMutableArray *)modelArray;

- (void)downloadManagerWillRemove;
- (void)downloadManagerDidRemove:(YTDownloadTaskModel*)aModel;
- (void)downloadManagerDidRemoveArray:(NSArray *)deleteArray;
- (void)downloadmanagerDidRemoveAll;

- (void)downloadmanagerDidFinish:(YTDownloadTaskModel*)aModel PartSequence:(YTDownloadModelSequence*)sequence;
- (void)downloadEngineDidReceiveSequence:(YTDownloadTaskModel*)aModel PartSequence:(YTDownloadModelSequence*)sequence;
- (void)downloadManagerDidError:(YTDownloadTaskModel *)aModel Error:(YTDownloadError)error;
- (void)downloadEngineDownloadKbps:(NSNumber *)kbps bytesReceived:(long long)receivedBytes taskModel:(YTDownloadTaskModel *)aModel;

- (void)downloadManagerDidUpldateSeqenceArray:(YTDownloadTaskModel *)aModel;

@end

@interface YTDownloadManager : NSObject

@property(nonatomic, strong, readonly) ThreadSafeMutableArray * dataArray;
@property(nonatomic,assign)id <YTDownloadManagerDelegate>delegate;
@property(nonatomic,assign)BOOL isStopDownloadWhenGprs;//是否在Gprs的时候停止下载,默认YES
@property (nonatomic, assign) BOOL engineIsDownloading;
@property(nonatomic, assign) BOOL canCacheIn3G; //是否支持3G模式下载，默认是NO

@property (nonatomic, copy) BackgroundCompletionHandler backgroundSessionCompletionHandler;

+(YTDownloadManager*)shareInstance;

- (void)setEngineParamsWithClientId:(NSString *)clientid clientSecret:(NSString *)clientsecret;
- (void)addListener:(id<YTDownloadManagerDelegate>)listener;
- (void)removeListener:(id<YTDownloadManagerDelegate>)listener;
- (void)removeAllListeners;

- (void)addDownloadTaskWithTask:(YTDownloadTaskModel*)aModel;
- (void)addDownloadTaskWithTasks:(NSArray *)tasks;

- (void)pauseAllDownloadTask;
- (void)startAllDownloadTask;
- (void)pauseDownloadTasks:(NSArray *)tasks;
- (void)startDownloadTasks:(NSArray *)tasks;
- (void)pauseDownloadTask:(YTDownloadTaskModel*)aModel;
- (void)startDownloadTask:(YTDownloadTaskModel*)aModel TmpisStopWhenGprs:(BOOL)isstop;
- (void)removeDownloadTask:(YTDownloadTaskModel*)aModel;
- (void)removeAllDownloadTask;
- (void)removeDownloadTasks:(NSArray*)taskArray;

- (BOOL)isExistByRecordId:(NSString*)recordId;

- (BOOL)hasDownloadingVideo;//是否有正在下载的视频
- (int)getWaitCount;
- (int)getPauseCount;
- (int)getTotalCount;
- (void)autocheckDownload;

- (void)startDownload;

- (void)stopDownloadToPause;
- (void)stopDownloadWhenRemove;
- (void)stopDownloadWhenNotAllow;

- (void)makeAllDownloadToWait;
//恢复model
- (void)restoreTasks:(NSArray *)tasklist;

//获取等待和正在下载的model array，在开关3G缓存的时候 暂停正在下载和等待下载的任务
- (NSArray *)findPauseAndErrorModels;
- (NSArray *)findWaitAndDownloadModels;
- (NSArray *)findErrorModels;
//当删除某视频的时候，容量进行改变。需要调用此方法，来判断容量是否充足是否需要发送充足通知
- (void)checkDiskSpaceEnoughAndNotification;
- (void)applicationIdleTimerChange;


- (YTDownloadManageCheckResult)canStartDownLoad;

- (YTDownloadEngine *)runningEngine;

- (BOOL)shouldUseURLSessionDownload;

- (void)delayEndBackgroudForDelegate;

//local storage
//获取当前视频model的的media信息（本地存储信息）
- (YTLocalMedia *)getLocalMeidaFromModel:(YTDownloadTaskModel *)aModel;
//获取数据库全部视频信息
- (NSArray *)getAllDownload;
//获取数据库中已下载成功的视频信息
- (NSArray *)getDownloadFinished;
//获取数据库中未下载完的视频信息
- (NSArray *)getDownloadNotFinished;
- (void)getDownloadFinished:(void (^)(id object))success;
- (void)getDownloadNotFinished:(void (^)(id object))success;
//删除数据库中全部视频信息
- (void)removeAllDownload;
- (void)removeDownload:(id)download success:(void (^)(id object))success;
- (void)removeMultiDownload:(NSArray *)downloads success:(void (^)(id object))success;
//从数据库本地信息中恢复当前下载视频model
- (NSArray *)restoreDownloadFromDB;
//点击下载按钮视频状态变化存储
- (VideoState)videoStateTransformation:(YTLocalMedia *)localmedia;
- (YTLocalMedia *)getLocalMediaFromDBWithMedia:(YTLocalMedia *)cellMedia;
//是否存储在本地
- (id)isSavedToLocal:(NSString*)vid;
//sdk内部调用，开发者可以不关注
- (void)createLocalSequences:(YTLocalMedia *)media Model:(YTDownloadTaskModel *)aModel;
- (YTLocalMedia *)updateLocalMediaWithVideo:(YTEngineYoukuPlayerInstanceItem *)video Model:(YTDownloadTaskModel *)aModel;
- (void)updateLocalMediaNeedResume:(YTDownloadTaskModel *)aModel PartSequence:(YTDownloadModelSequence *)sequence;
//app退出保存resumeData
- (void)updateLocalMediaSequencesDidError:(YTDownloadTaskModel *)aModel ParSequence:(YTDownloadModelSequence *)sequence;
- (void)updataLocalMediaDidReceived:(YTDownloadTaskModel *)aModel;
@end
