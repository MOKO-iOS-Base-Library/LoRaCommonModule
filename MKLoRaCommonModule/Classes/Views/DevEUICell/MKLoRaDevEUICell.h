//
//  MKLoRaDevEUICell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDevEUICellModel : NSObject

@property (nonatomic, copy)NSString *devEUI;

@end

@interface MKLoRaDevEUICell : MKBaseCell

@property (nonatomic, strong)MKLoRaDevEUICellModel *dataModel;

+ (MKLoRaDevEUICell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
