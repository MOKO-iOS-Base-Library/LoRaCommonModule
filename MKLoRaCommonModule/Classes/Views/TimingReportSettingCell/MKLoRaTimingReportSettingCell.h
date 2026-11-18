//
//  MKLoRaTimingReportSettingCell.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTimingReportSettingCellModel : NSObject

/// 当前cell所处功能号
@property (nonatomic, assign)NSInteger type;

/// 当前cell在type中的index
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger hourIndex;

@property (nonatomic, assign)NSInteger timeSpaceIndex;

@end

@protocol MKLoRaTimingReportSettingCellDelegate <NSObject>

/// 删除操作
/// @param type type
/// @param index index
- (void)mk_loraModule_timingReportSettingCell_cellDeleteButtonPressed:(NSInteger)type index:(NSInteger)index;

/// 用户选择了hour事件
- (void)mk_loraModule_timingReportSettingCell_hourButtonPressed:(NSInteger)type index:(NSInteger)index;

/// 用户选择了时间间隔事件
- (void)mk_loraModule_timingReportSettingCell_timeSpaceButtonPressed:(NSInteger)type index:(NSInteger)index;

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mk_loraModule_timingReportSettingCell_cellResetFrame;

/// cell的点击事件，用来重置cell的布局
- (void)mk_loraModule_timingReportSettingCell_cellTapAction;

@end

@interface MKLoRaTimingReportSettingCell : MKBaseCell

@property (nonatomic, weak)id <MKLoRaTimingReportSettingCellDelegate>delegate;

@property (nonatomic, strong)MKLoRaTimingReportSettingCellModel *dataModel;

+ (MKLoRaTimingReportSettingCell *)initCellWithTableView:(UITableView *)tableView;

- (BOOL)canReset;
- (void)resetCellFrame;
- (void)resetFlagForFrame;

@end

NS_ASSUME_NONNULL_END
