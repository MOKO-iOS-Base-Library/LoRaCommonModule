//
//  MKLoRaSynDataCell.h
//  MKLoRaCommonModule
//
//  Created by Trae on 2026/11/22.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaSynDataCell : MKBaseCell

@property (nonatomic, strong)NSDictionary *dataModel;

@property (nonatomic, assign)BOOL showMacAddress;

@property (nonatomic, assign)BOOL showRSSI;

@property (nonatomic, assign)BOOL showDeviceType;

@property (nonatomic, copy)NSString *macTitle;

+ (MKLoRaSynDataCell *)initCellWithTableView:(UITableView *)tableView;

+ (CGFloat)fetchCellHeight:(NSDictionary *)dataDic
                   showMac:(BOOL)showMac
                  showRSSI:(BOOL)showRSSI
            showDeviceType:(BOOL)showDeviceType;

/// 统一的时间展示字符串，兼容 date / dateDic / timestamp + timezone 三种存储格式
+ (NSString *)timeStringWithData:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
