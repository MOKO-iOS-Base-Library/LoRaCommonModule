//
//  MKAboutController.m
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKAboutController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@implementation MKAboutController

- (void)dealloc {
    NSLog(@"MKAboutController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - event method
- (void)openWebBrowser {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.mokosmart.com"]
                                       options:@{}
                             completionHandler:nil];
}

#pragma mark - ui
- (void)loadSubViews {
    self.defaultTitle = @"ABOUT";
    [self.rightButton setHidden:YES];
    
    UIImageView *aboutIcon = [[UIImageView alloc] init];
    aboutIcon.image = [self aboutIconImage];
    [self.view addSubview:aboutIcon];
    
    UILabel *appNameLabel = [[UILabel alloc] init];
    appNameLabel.textColor = DEFAULT_TEXT_COLOR;
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.font = MKFont(20.f);
    appNameLabel.text = self.protocol.appName;
    [self.view addSubview:appNameLabel];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.textColor = RGBCOLOR(189, 189, 189);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = MKFont(16.f);
    versionLabel.text = [@"APP Version:" stringByAppendingString:kAppVersion];
    [self.view addSubview:versionLabel];
    
    UILabel *firmwareLabel = [[UILabel alloc] init];
    firmwareLabel.textColor = RGBCOLOR(189, 189, 189);
    firmwareLabel.textAlignment = NSTextAlignmentCenter;
    firmwareLabel.font = MKFont(16.f);
    firmwareLabel.text = self.protocol.firmwareLabel;
    [self.view addSubview:firmwareLabel];
    
    UILabel *companyNameLabel = [[UILabel alloc] init];
    companyNameLabel.textColor = DEFAULT_TEXT_COLOR;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.font = MKFont(16.f);
    companyNameLabel.text = @"MOKO TECHNOLOGY LTD.";
    [self.view addSubview:companyNameLabel];
    
    UILabel *companyNetLabel = [[UILabel alloc] init];
    companyNetLabel.textAlignment = NSTextAlignmentCenter;
    companyNetLabel.textColor = NAVBAR_COLOR_MACROS;
    companyNetLabel.font = MKFont(16.f);
    companyNetLabel.text = @"www.mokosmart.com";
    [companyNetLabel addTapAction:self selector:@selector(openWebBrowser)];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBCOLOR(3, 191, 234);
    [companyNetLabel addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(companyNetLabel.mas_centerX);
        make.width.mas_equalTo(155);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
    }];
    [self.view addSubview:companyNetLabel];
    
    UIImageView *bottomIcon = [[UIImageView alloc] init];
    bottomIcon.userInteractionEnabled = YES;
    bottomIcon.image = [self bottomIconImage];
    [self.view addSubview:bottomIcon];
    
    [aboutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(110.f);
        make.top.equalTo(self.view).offset(kTopBarHeight + 40.f);
        make.height.mas_equalTo(110.f);
    }];
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(aboutIcon.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(20.f).lineHeight);
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(appNameLabel.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(16.f).lineHeight);
    }];
    [firmwareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(versionLabel.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(16.f).lineHeight);
    }];
    [companyNetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.height.mas_equalTo(MKFont(16).lineHeight);
    }];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(companyNetLabel.mas_top).mas_offset(-17);
        make.height.mas_equalTo(MKFont(17).lineHeight);
    }];
    [bottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.view).offset(-kSafeAreaHeight);
        make.height.mas_equalTo(213.f);
    }];
}

#pragma mark - Subclass Override
/// 子类 override 提供 App 图标
- (UIImage *)aboutIconImage {
    return nil;
}

/// 子类 override 提供底部图标
- (UIImage *)bottomIconImage {
    return nil;
}

@end
