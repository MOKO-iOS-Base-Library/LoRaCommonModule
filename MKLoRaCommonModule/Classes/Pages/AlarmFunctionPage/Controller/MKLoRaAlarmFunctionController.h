//
//  MKLoRaAlarmFunctionController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "Pages/AlarmFunctionPage/Protocol/MKLoRaAlarmFunctionPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAlarmFunctionController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaAlarmFunctionPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
