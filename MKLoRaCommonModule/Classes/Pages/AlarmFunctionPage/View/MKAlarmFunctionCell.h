//
//  MKAlarmFunctionCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAlarmFunctionCellModel : NSObject

@property (nonatomic, copy)NSString *exitTime;

@end

@protocol MKAlarmFunctionCellDelegate <NSObject>

- (void)mk_exitAlarmTypeChanged:(NSString *)value;

@end

@interface MKAlarmFunctionCell : MKBaseCell

@property (nonatomic, strong)MKAlarmFunctionCellModel *dataModel;

@property (nonatomic, weak)id <MKAlarmFunctionCellDelegate>delegate;

+ (MKAlarmFunctionCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
