//
//  MKLoRaPeriodicImmediatelyController.h
//  MKLoRaCommonModule_Example
//
//  Created by aa on 2026/11/18.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKBaseViewController.h"
#import "Pages/PeriodicImmediatelyPage/Protocol/MKLoRaPeriodicImmediatelyPageProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MKLoRaPeriodicImmediatelyController : MKBaseViewController
@property (nonatomic, strong) id <MKLoRaPeriodicImmediatelyPageProtocol> protocol;
@end
NS_ASSUME_NONNULL_END
