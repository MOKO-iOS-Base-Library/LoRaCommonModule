//
//  MKLoRaFilterEditSectionHeaderView.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaFilterEditSectionHeaderViewModel : NSObject

/// sectionHeader所在index
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)UIColor *contentColor;

@end

@protocol MKLoRaFilterEditSectionHeaderViewDelegate <NSObject>

/// 加号点击事件
/// @param index 所在index
- (void)mk_lora_filterEditSectionHeaderView_addButtonPressed:(NSInteger)index;

/// 减号点击事件
/// @param index 所在index
- (void)mk_lora_filterEditSectionHeaderView_subButtonPressed:(NSInteger)index;

@end

@interface MKLoRaFilterEditSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)MKLoRaFilterEditSectionHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKLoRaFilterEditSectionHeaderViewDelegate>delegate;

+ (MKLoRaFilterEditSectionHeaderView *)initHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
