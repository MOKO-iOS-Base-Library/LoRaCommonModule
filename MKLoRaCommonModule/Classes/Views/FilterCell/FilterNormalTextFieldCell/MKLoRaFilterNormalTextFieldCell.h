//
//  MKLoRaFilterNormalTextFieldCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseCell.h"

#import "MKTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaFilterNormalTextFieldCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 当前textField的值
@property (nonatomic, copy)NSString *textFieldValue;

/// textField的占位符
@property (nonatomic, copy)NSString *textPlaceholder;

/// 当前textField的输入类型
@property (nonatomic, assign)mk_textFieldType textFieldType;

/// textField的最大输入长度,对于textFieldType == mk_uuidMode无效
@property (nonatomic, assign)NSInteger maxLength;

@end

@protocol MKLoRaFilterNormalTextFieldCellDelegate <NSObject>

- (void)mk_lora_filterNormalTextFieldValueChanged:(NSString *)text index:(NSInteger)index;

@end

@interface MKLoRaFilterNormalTextFieldCell : MKBaseCell

@property (nonatomic, strong)MKLoRaFilterNormalTextFieldCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaFilterNormalTextFieldCellDelegate>delegate;

+ (MKLoRaFilterNormalTextFieldCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
