//
//  MKLoRaSynDataController.h
//  MKLoRaCommonModule
//
//  Created by Trae on 2026/11/22.
//

#import "MKBaseViewController.h"

#import "Pages/SynDataPage/Protocol/MKLoRaSynDataPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaSynDataController : MKBaseViewController

@property (nonatomic, strong)id <MKLoRaSynDataPageProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
