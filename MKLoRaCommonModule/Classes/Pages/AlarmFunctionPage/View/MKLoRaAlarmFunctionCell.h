//
//  MKLoRaAlarmFunctionCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAlarmFunctionCellModel : NSObject

@property (nonatomic, copy)NSString *exitTime;

@end

@protocol MKLoRaAlarmFunctionCellDelegate <NSObject>

- (void)mk_loraModule_exitAlarmTypeChanged:(NSString *)value;

@end

@interface MKLoRaAlarmFunctionCell : MKBaseCell

@property (nonatomic, strong)MKLoRaAlarmFunctionCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaAlarmFunctionCellDelegate>delegate;

+ (MKLoRaAlarmFunctionCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
