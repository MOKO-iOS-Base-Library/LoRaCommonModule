//
//  MKLoRaAuxiliaryRowModel.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAuxiliaryRowModel : NSObject

/// 行标题
@property (nonatomic, copy) NSString *title;

/// 点击回调，fromViewController 为当前Auxiliary页面
@property (nonatomic, copy, nullable) void (^tapHandler)(UIViewController *fromViewController);

+ (instancetype)rowWithTitle:(NSString *)title
                  tapHandler:(nullable void (^)(UIViewController *fromViewController))tapHandler;

@end

NS_ASSUME_NONNULL_END
