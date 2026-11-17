//
//  MKTimingReportSettingCell.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKTimingReportSettingCellModel : NSObject

/// 当前cell所处功能号
@property (nonatomic, assign)NSInteger type;

/// 当前cell在type中的index
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger hourIndex;

@property (nonatomic, assign)NSInteger timeSpaceIndex;

@end

@protocol MKTimingReportSettingCellDelegate <NSObject>

/// 删除操作
/// @param type type
/// @param index index
- (void)mk_timingReportSettingCell_cellDeleteButtonPressed:(NSInteger)type index:(NSInteger)index;

/// 用户选择了hour事件
- (void)mk_timingReportSettingCell_hourButtonPressed:(NSInteger)type index:(NSInteger)index;

/// 用户选择了时间间隔事件
- (void)mk_timingReportSettingCell_timeSpaceButtonPressed:(NSInteger)type index:(NSInteger)index;

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mk_timingReportSettingCell_cellResetFrame;

/// cell的点击事件，用来重置cell的布局
- (void)mk_timingReportSettingCell_cellTapAction;

@end

@interface MKTimingReportSettingCell : MKBaseCell

@property (nonatomic, weak)id <MKTimingReportSettingCellDelegate>delegate;

@property (nonatomic, strong)MKTimingReportSettingCellModel *dataModel;

+ (MKTimingReportSettingCell *)initCellWithTableView:(UITableView *)tableView;

- (BOOL)canReset;
- (void)resetCellFrame;
- (void)resetFlagForFrame;

@end

NS_ASSUME_NONNULL_END
