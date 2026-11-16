//
//  MKDeviceInfoController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2025/xx/xx.
//

#import "MKBaseViewController.h"
#import "MKDeviceInfoPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKDeviceInfoController : MKBaseViewController

@property (nonatomic, strong) id <MKDeviceInfoPageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
