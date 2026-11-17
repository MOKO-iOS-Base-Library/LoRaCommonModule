//
//  MKLoRaReportTimePointCell.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaReportTimePointCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger timeSpace;

@end

@protocol MKLoRaReportTimePointCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)mk_loraModule_cellDeleteButtonPressed:(NSInteger)index;

/// 用户选择了hour事件
- (void)mk_loraModule_hourButtonPressed:(NSInteger)index hour:(NSInteger)hour;

/// 用户选择了时间间隔事件
- (void)mk_loraModule_timeSpaceButtonPressed:(NSInteger)index timeSpace:(NSInteger)timeSpace;

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mk_loraModule_cellResetFrame;

/// cell的点击事件，用来重置cell的布局
- (void)mk_loraModule_cellTapAction;

@end

@interface MKLoRaReportTimePointCell : MKBaseCell

@property (nonatomic, weak)id <MKLoRaReportTimePointCellDelegate>delegate;

@property (nonatomic, strong)MKLoRaReportTimePointCellModel *dataModel;

+ (MKLoRaReportTimePointCell *)initCellWithTableView:(UITableView *)tableView;

- (BOOL)canReset;
- (void)resetCellFrame;
- (void)resetFlagForFrame;

@end

NS_ASSUME_NONNULL_END
