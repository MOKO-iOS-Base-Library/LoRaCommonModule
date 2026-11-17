//
//  MKLoRaTimingModeAddCell.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2025/5/25.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTimingModeAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKLoRaTimingModeAddCellDelegate <NSObject>

- (void)mk_loraModule_addButtonPressed;

@end

@interface MKLoRaTimingModeAddCell : MKBaseCell

@property (nonatomic, strong)MKLoRaTimingModeAddCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaTimingModeAddCellDelegate>delegate;

+ (MKLoRaTimingModeAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
