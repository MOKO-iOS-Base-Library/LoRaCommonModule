//
//  MKLoRaTimeSegmentedAddCell.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTimeSegmentedAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKLoRaTimeSegmentedAddCellDelegate <NSObject>

- (void)mk_loraModule_timeSegmentedAddCell_addPressed;

@end

@interface MKLoRaTimeSegmentedAddCell : MKBaseCell

@property (nonatomic, strong)MKLoRaTimeSegmentedAddCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaTimeSegmentedAddCellDelegate>delegate;

+ (MKLoRaTimeSegmentedAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
