//
//  MKLoRaTofContentController.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/18.
//

#import "MKBaseViewController.h"
#import "Pages/PayloadContentSelections/MKTofContentPage/Protocol/MKLoRaTofContentPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaTofContentController : MKBaseViewController

@property (nonatomic, strong) id <MKLoRaTofContentPageProtocol> protocol;
@end

NS_ASSUME_NONNULL_END
