//
//  MKLoRaSettingAccountCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaSettingAccountCellModel : NSObject

@property (nonatomic, copy)NSString *account;

@end

@protocol MKLoRaSettingAccountCellDelegate <NSObject>

- (void)mk_loraSettingAccountCell_logoutBtnPressed;

@end

@interface MKLoRaSettingAccountCell : MKBaseCell

@property (nonatomic, strong)MKLoRaSettingAccountCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaSettingAccountCellDelegate>delegate;

+ (MKLoRaSettingAccountCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
