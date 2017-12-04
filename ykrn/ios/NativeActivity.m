//
//  NativeActivity.m
//  rntest
//
//  Created by mini on 2017/11/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NativeActivity.h"
#import "YTEngineOpenViewManager.h"
#import "YYMediaPlayerEvents.h"

#define MARGIN (DEVICE_TYPE_IPAD ? 15 : 10)
#define BACK_WIDTH (DEVICE_TYPE_IPAD ? 30 : 20)
#define TEXTVIEW_FONT (DEVICE_TYPE_IPAD ? 15 : 12)
#define TEXTVIEW_WIDTH (DEVICE_TYPE_IPAD ? 400 : 250)
#define TEXTVIEW_HEIGHT (DEVICE_TYPE_IPAD ? 45 : 30)
#define TOPVIEW_HEIGHT_SMALL (DEVICE_TYPE_IPAD ? 54 : 44)
#define TOPVIEW_HEIGHT_FULL (DEVICE_TYPE_IPAD ? 88 : 50)
#define STATUS_HEIGHT (DEVICE_TYPE_IPAD ? 25 : 20)

@interface NativeActivity () <YYMediaPlayerEvents>

@property (nonatomic, strong) NSString *itemid; //视频id
@property (nonatomic, strong) NSString *itemPf; // 播放平台
@property (nonatomic, strong) NSString *itemQuality; // 清晰度
@property (nonatomic, strong) YTEngineOpenViewManager *viewManager;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) YYMediaPlayer *cloudPlayer;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) CGRect playerFrame;
@property (nonatomic, assign) CGRect cloudPlayerFrame;

@end

@implementation NativeActivity

@synthesize player = _player;
@synthesize islocal;
@synthesize videoItem;

#pragma mark - init & dealloc
- (id)initWithVid:(NSString *)vid platform:(NSString *)platform quality:(NSString *)quality
{
  self = [super init];
  _itemid = vid;
  _itemPf = platform;
  _itemQuality = quality;
  NSLog(@"videoid:%@, platform:%@, quality:%@",vid,platform,quality);
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenChangeButtonClicked) name:kYYScreenChangeButtonClickedNotification object:nil];
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:kYYScreenChangeButtonClickedNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.view.backgroundColor = [UIColor blackColor];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
  _playerView = [[UIView alloc] init];
  _playerView.backgroundColor = [UIColor whiteColor];
  
  _cloudPlayer = [[YYMediaPlayer alloc] init];
  
  _cloudPlayer.controller = self;
  _cloudPlayer.view.clipsToBounds = YES;
  _cloudPlayer.fullscreen = NO;
  
  CGSize size = self.view.bounds.size;
  CGRect frame = CGRectMake(0,0,size.width,size.height);
  self.view.frame = frame;
  
  CGFloat width = 0.f;
  if (DEVICE_TYPE_IPAD) {
    width = 681.f;
  } else {
    width = size.width;
  }
  CGFloat height = width * 9.0f / 16.0f;
  _playerView.frame = CGRectMake(0, STATUS_HEIGHT, size.width, size.height - STATUS_HEIGHT);
  _cloudPlayer.view.frame = CGRectMake(0, 0, width, height);
  
  _playerFrame = _playerView.frame;
  _cloudPlayerFrame = _cloudPlayer.view.frame;
  
  [_playerView addSubview:_cloudPlayer.view];
  [self.view addSubview:_playerView];
  
//  UILabel *nLabel = [[UILabel alloc] init];
//  nLabel.text =@"小明";
//  nLabel.textColor = [UIColor blueColor];
//  nLabel.frame = CGRectMake(0,height,100,100) ;
//  nLabel.backgroundColor = [UIColor redColor];
//  [self.view addSubview:nLabel];
  
  [self initViews];
  
  [_cloudPlayer addEventsObserver:self];
  
  _cloudPlayer.clientId = @"e7e4d0ee1591b0bf";
  _cloudPlayer.clientSecret = @"1fbf633f8a55fa1bfabf95729d8e259a";
  
  // 初始化播放器界面管理器
  _viewManager = [[YTEngineOpenViewManager alloc] initWithPlayer:_cloudPlayer];
  [_cloudPlayer addEventsObserver:_viewManager];
  
  // 播放视频
  if (!_itemid) {
    _itemid = @"XMzA1NzYwMTQxNg==";
  }
  
  if (!_itemQuality) {
    _itemQuality = kYYVideoQualityFLV;
  }
  
  if (!islocal) {
    [_cloudPlayer playVid:_itemid quality:_itemQuality language:@"default" password:@"4224211" from:0];
  } else {
    if (self.videoItem) {
      [_cloudPlayer playVideo:(id<YYMediaPlayerItem>)self.videoItem quality:_itemQuality language:@"default" from:0 oldEncrypt:NO];
    }
  }
  
}

- (void)layout:(BOOL)fullscreen
{
  CGFloat backHeight = _backButton.bounds.size.height;
  CGFloat y = 0;
  
  if (!fullscreen) {
    _playerView.frame = _playerFrame;
    _cloudPlayer.view.frame = _cloudPlayerFrame;
    y = (TOPVIEW_HEIGHT_SMALL - backHeight) / 2;
    _backButton.frame = CGRectMake(MARGIN, y , BACK_WIDTH, backHeight);
  } else {
    _playerView.frame = self.view.frame;
    _cloudPlayer.view.frame = self.view.frame;
    y = (TOPVIEW_HEIGHT_FULL - STATUS_HEIGHT - backHeight) / 2 + STATUS_HEIGHT;
    _backButton.frame = CGRectMake(MARGIN, y, BACK_WIDTH, _backButton.bounds.size.height);
  }
  _textView.frame = CGRectMake(_cloudPlayer.view.center.x - TEXTVIEW_WIDTH/2, _cloudPlayer.view.center.y - TEXTVIEW_HEIGHT/2, TEXTVIEW_WIDTH, TEXTVIEW_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orien
{
  if (DEVICE_TYPE_IPAD) {
    if (orien == UIInterfaceOrientationPortrait || orien == UIInterfaceOrientationPortraitUpsideDown) {
      return NO;
    } else {
      return [self rotatePlayer:orien];
    }
  } else {
    if (orien == UIInterfaceOrientationPortraitUpsideDown) {
      return NO;
    } else {
      return [self rotatePlayer:orien];
    }
  }
}

- (BOOL)shouldAutorotate
{
  UIInterfaceOrientation orien = [self interfaceOrientation:[UIDevice currentDevice].orientation];
  return [self rotatePlayer:orien];
}

- (BOOL)rotatePlayer:(UIInterfaceOrientation)orien
{
  if (!DEVICE_TYPE_IPAD) {
    if (orien == UIInterfaceOrientationPortrait &&
        self.interfaceOrientation != orien) {
      [_cloudPlayer setFullscreen:NO];
    } else if (UIInterfaceOrientationIsLandscape(orien)) {
      UIInterfaceOrientation corien = self.interfaceOrientation;
      if (!UIInterfaceOrientationIsLandscape(corien)) {
        [_cloudPlayer setFullscreen:YES];
      }
    }
  }
  return YES;
}

- (NSInteger)interfaceOrientation:(UIDeviceOrientation)orien
{
  if (DEVICE_TYPE_IPAD) {
    switch (orien) {
      case UIDeviceOrientationLandscapeLeft:
        return UIInterfaceOrientationLandscapeRight;
      case UIDeviceOrientationLandscapeRight:
        return UIInterfaceOrientationLandscapeLeft;
      default:
        return -1;
    }
  } else {
    switch (orien) {
      case UIDeviceOrientationPortrait:
        return UIInterfaceOrientationPortrait;
      case UIDeviceOrientationLandscapeLeft:
        return UIInterfaceOrientationLandscapeRight;
      case UIDeviceOrientationLandscapeRight:
        return UIInterfaceOrientationLandscapeLeft;
      default:
        return -1;
    }
  }
}

- (void)initViews
{
  _backButton = [[UIButton alloc] init];
  UIImage *backImg = [UIImage imageNamed:@"back"];
  [_backButton setImage:backImg
               forState:UIControlStateNormal];
  _backButton.adjustsImageWhenHighlighted = NO;
  [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
  _backButton.bounds = CGRectMake(0, 0, BACK_WIDTH, backImg.size.height);
  [_playerView addSubview:_backButton];
  
  // 返回错误码
  _textView = [[UITextView alloc] init];
  _textView.backgroundColor = [UIColor clearColor];
  _textView.textColor = [UIColor whiteColor];
  _textView.font = [UIFont systemFontOfSize:TEXTVIEW_FONT];
  _textView.editable = NO;
  _textView.userInteractionEnabled = NO;
  [_textView setTextAlignment:NSTextAlignmentCenter];
  [_cloudPlayer.view addSubview:_textView];
}

- (void)backAction:(UIButton *)sender {
  if (_cloudPlayer.fullscreen) {
    if (DEVICE_TYPE_IPAD) {
      [_cloudPlayer setFullscreen:!_cloudPlayer.fullscreen];
    } else {
      [self setNewOrientation:!_cloudPlayer.fullscreen];
    }
  } else {
    [_cloudPlayer removeEventsObserver:_viewManager];
    [_cloudPlayer.controller.navigationController popViewControllerAnimated:YES];
    [_cloudPlayer stop];
    [_cloudPlayer deinit];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
  }
}

- (void)setNewOrientation:(BOOL)fullscreen
{
  UIDeviceOrientation lastDeviceOrien = [UIDevice currentDevice].orientation;
  UIDeviceOrientation deviceOiren = fullscreen ?
  UIDeviceOrientationLandscapeLeft : UIDeviceOrientationPortrait;
  
  if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    NSNumber *oiren = [NSNumber numberWithInt:deviceOiren];
    [[UIDevice currentDevice] setValue:oiren forKey:@"orientation"];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:oiren];
  }
  if (lastDeviceOrien == deviceOiren) {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {
      [UIViewController attemptRotationToDeviceOrientation];
    }
  }
}

- (void)endPlayCode:(YYErrorCode)err
{
  NSString *tip;
  switch (err) {
    case YYPlayCompleted:
      tip = @"该视频已播放完成，点击重新播放";
      _textView.text = tip;
      break;
    case YYPlayCanceled:
      break;
    case YYErrorClientFormat:
      tip = [NSString stringWithFormat:@"client参数格式错误，错误码：%ld", (long)err];
      _textView.text = tip;
      break;
    case YYErrorInvalidClient:
      tip = [NSString stringWithFormat:@"client无效或sdk版本过低，错误码：%ld", (long)err];
      _textView.text = tip;
      break;
    case YYErrorPermissionDeny:
      tip = [NSString stringWithFormat:@"视频无权限播放，错误码：%ld", (long)err];
      _textView.text = tip;
      break;
    case YYErrorInitOpenView:
      tip = [NSString stringWithFormat:@"初始化界面无效，错误码：%ld", (long)err];
      _textView.text = tip;
      break;
    case YYDataSourceError:
      tip = [NSString stringWithFormat:@"媒体文件错误,错误码：%ld", (long)err];
      _textView.text = tip;
      break;
    case YYNetworkError:
      tip = [NSString stringWithFormat:@"网络连接超时，错误码：%ld, 点击重试", (long)err];
      _textView.text = tip;
      break;
    case YYErrorBundleTempered:
      tip = [NSString stringWithFormat:@"资源加载无效，错误码：%ld", (long)err];
      _textView.text = tip;
      break;
      
    default:
      tip = [NSString stringWithFormat:@"播放发生错误，错误码：%ld, 点击重试", (long)err];
      _textView.text = tip;
      break;
  }
}

- (void)startPlay
{
  if (_viewManager) {
    _textView.hidden = YES;
  }
  //    [_player pause]; // 播放开始后暂停
}

- (void)screenWillChange:(BOOL)fullscreen
{
  if (fullscreen) {
    UIImage *backImg = [UIImage imageNamed:@"back_full"];
    [_backButton setImage:backImg
                 forState:UIControlStateNormal];
  } else {
    UIImage *backImg = [UIImage imageNamed:@"back"];
    [_backButton setImage:backImg
                 forState:UIControlStateNormal];
  }
}

- (void)screenChangeButtonClicked {
  NSLog(@"ZN screen did clicked, old screen status:%@",self.player.fullscreen ? @"full" : @"small");
}

@end
