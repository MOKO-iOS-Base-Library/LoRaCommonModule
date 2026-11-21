//
//  MKLoRaAuxiliaryController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/21.
//

#import "MKBaseViewController.h"
#import "Pages/AuxiliaryPage/Model/MKLoRaAuxiliaryRowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAuxiliaryController : MKBaseViewController

/// 行配置由业务方传入，点击行为在 tapHandler 中实现
- (instancetype)initWithRows:(NSArray<MKLoRaAuxiliaryRowModel *> *)rows;

@end

NS_ASSUME_NONNULL_END
