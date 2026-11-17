
NS_ASSUME_NONNULL_BEGIN

@protocol MKLoRaPayloadContentPageProtocol <NSObject>

@optional

- (UIViewController * _Nullable)beaconContentViewController;
- (UIViewController * _Nullable)uidContentViewController;
- (UIViewController * _Nullable)urlContentViewController;
- (UIViewController * _Nullable)tlmContentViewController;
- (UIViewController * _Nullable)bxpBeaconContentViewController;
- (UIViewController * _Nullable)bxpInfoContentViewController;
- (UIViewController * _Nullable)bxpAccContentViewController;
- (UIViewController * _Nullable)bxpTHContentViewController;
- (UIViewController * _Nullable)bxpButtonContentViewController;
- (UIViewController * _Nullable)bxpTagContentViewController;
- (UIViewController * _Nullable)otherContentViewController;
- (UIViewController * _Nullable)tofContentViewController;
- (UIViewController * _Nullable)pirContentViewController;
- (UIViewController * _Nullable)nanoBeaconContentViewController;

@end

NS_ASSUME_NONNULL_END
