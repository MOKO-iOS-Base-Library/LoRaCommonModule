//
//  MKLoRaDeviceInfoCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2023/8/1.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDeviceInfoCellModel : NSObject

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width;

@end

@interface MKLoRaDeviceInfoCell : MKBaseCell

@property (nonatomic, strong)MKLoRaDeviceInfoCellModel *dataModel;

+ (MKLoRaDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
