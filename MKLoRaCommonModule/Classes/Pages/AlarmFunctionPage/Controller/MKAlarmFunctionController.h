//
//  MKAlarmFunctionController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "MKAlarmFunctionPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAlarmFunctionController : MKBaseViewController

@property (nonatomic, strong) id <MKAlarmFunctionPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
