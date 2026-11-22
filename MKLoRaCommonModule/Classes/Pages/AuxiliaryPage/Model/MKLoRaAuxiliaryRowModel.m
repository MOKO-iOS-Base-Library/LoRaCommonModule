//
//  MKLoRaAuxiliaryRowModel.m
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/21.
//

#import "MKLoRaAuxiliaryRowModel.h"

@implementation MKLoRaAuxiliaryRowModel

+ (instancetype)rowWithTitle:(NSString *)title
                  tapHandler:(void (^)(UIViewController *))tapHandler {
    MKLoRaAuxiliaryRowModel *model = [[MKLoRaAuxiliaryRowModel alloc] init];
    model.title = title;
    model.tapHandler = tapHandler;
    return model;
}

@end
