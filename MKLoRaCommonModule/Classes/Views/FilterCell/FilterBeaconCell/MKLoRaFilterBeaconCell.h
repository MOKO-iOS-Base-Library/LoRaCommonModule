//
//  MKLoRaFilterBeaconCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2023/7/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKLoRaFilterBeaconCellDelegate <NSObject>

- (void)mk_lora_filterBeaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_lora_filterBeaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKLoRaFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKLoRaFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaFilterBeaconCellDelegate>delegate;

+ (MKLoRaFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
