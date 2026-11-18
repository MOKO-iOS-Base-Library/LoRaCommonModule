//
//  MKLoRaUpdateController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/UpdatePage/Protocol/MKLoRaUpdatePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// OTA 升级页面
@interface MKLoRaUpdateController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaUpdatePageProtocol> protocol;

@end

NS_ASSUME_NONNULL_END
