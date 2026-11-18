//
//  MKLoRaTextButtonCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTextButtonCellModel : NSObject

/// cell唯一识别号
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

@property (nonatomic, copy)NSString *rightButtonTitle;

@end

@protocol MKLoRaTextButtonCellDelegate <NSObject>

/// 用户点击了右侧按钮
/// @param index cell所在序列号
- (void)mk_lora_textButtonCell_buttonAction:(NSInteger)index;

@end

@interface MKLoRaTextButtonCell : MKBaseCell

@property (nonatomic, strong)MKLoRaTextButtonCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaTextButtonCellDelegate>delegate;

+ (MKLoRaTextButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
