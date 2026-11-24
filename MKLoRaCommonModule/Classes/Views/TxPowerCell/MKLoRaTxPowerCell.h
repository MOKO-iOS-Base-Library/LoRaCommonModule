//
//  MKLoRaTxPowerCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/20.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTxPowerCellModel : NSObject

/// 当前Tx Power数值索引
@property (nonatomic, assign)NSInteger txPower;

/// 各档位dBm文案，顺序与设备数值索引一致，各产品档位不同由业务传入
@property (nonatomic, copy)NSArray <NSString *>*txPowerList;

/// 可选自定义括号说明文字；不设置则由基础库根据 txPowerList 动态生成
@property (nonatomic, copy, nullable) NSString *customNoteText;

@end

@protocol MKLoRaTxPowerCellDelegate <NSObject>

/// 用户拖动slider改变了Tx Power
/// @param txPower 当前Tx Power数值索引
- (void)mk_lora_txPowerCell_valueChanged:(NSInteger)txPower;

@end

@interface MKLoRaTxPowerCell : MKBaseCell

@property (nonatomic, strong)MKLoRaTxPowerCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaTxPowerCellDelegate>delegate;

+ (MKLoRaTxPowerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
