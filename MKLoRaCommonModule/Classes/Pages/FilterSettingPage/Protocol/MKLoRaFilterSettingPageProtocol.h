//
//  MKLoRaFilterSettingPageProtocol.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaFilterSettingPageProtocol <NSObject>

#pragma mark - required

/// -127~0
@property (nonatomic, assign) NSInteger rssi;

/// 0:1M PHY (BLE 4.x)  1:1M PHY (BLE 5)  2:1M PHY (BLE 4.x + BLE 5)  3:Coded PHY(BLE 5)
@property (nonatomic, assign) NSInteger phy;

/// 0:Null  1:Only MAC  2:Only ADV Name  3:Only Raw Data
/// 4:ADV Name & Raw Data  5:MAC & ADV Name & Raw Data  6:ADV Name | Raw Data
@property (nonatomic, assign) NSInteger relationship;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

@optional

#pragma mark - Duplicate Data Filter（部分设备支持）

- (BOOL)filterSettingPageShowDuplicateDataFilter;

@property (nonatomic, assign) NSInteger dataFilter;

- (NSArray<NSString *> *)dataFilterList;

#pragma mark - 子页面跳转

- (void)filterSettingPagePushFilterByMacFromController:(UIViewController *)controller;

- (void)filterSettingPagePushFilterByAdvNameFromController:(UIViewController *)controller;

- (void)filterSettingPagePushFilterByRawDataFromController:(UIViewController *)controller;

#pragma mark - 文案

- (NSString *)filterSettingPageTitle;

@end

NS_ASSUME_NONNULL_END
