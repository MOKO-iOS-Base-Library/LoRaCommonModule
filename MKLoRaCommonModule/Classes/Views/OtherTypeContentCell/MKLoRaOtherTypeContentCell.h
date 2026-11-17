//
//  MKLoRaOtherTypeContentCell.h
//  MKLoRaCommonModule
//

#import <UIKit/UIKit.h>
#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaOtherTypeContentCellModel : NSObject

/// 当前cell所处Block号
@property (nonatomic, assign)NSInteger blockNumber;

/// 当前cell在blockNumber中的index
@property (nonatomic, assign)NSInteger blockIndex;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *dataType;

@property (nonatomic, copy)NSString *startIndex;

@property (nonatomic, copy)NSString *endIndex;

@property (nonatomic, copy)NSString *unitMsg;

@end

@protocol MKLoRaOtherTypeContentCellDelegate <NSObject>

- (void)mk_loraModule_otherCellDeletedWithNumber:(NSInteger)blockNumber
                           blockIndex:(NSInteger)blockIndex;

- (void)mk_loraModule_otherCellDataTypeChanged:(NSString *)dataType
                        blockNumber:(NSInteger)blockNumber
                         blockIndex:(NSInteger)blockIndex;

- (void)mk_loraModule_otherCellStartIndexChanged:(NSString *)startIndex
                          blockNumber:(NSInteger)blockNumber
                           blockIndex:(NSInteger)blockIndex;

- (void)mk_loraModule_otherCellEndIndexChanged:(NSString *)endIndex
                        blockNumber:(NSInteger)blockNumber
                         blockIndex:(NSInteger)blockIndex;

@end

@interface MKLoRaOtherTypeContentCell : MKBaseCell

@property (nonatomic, weak)id <MKLoRaOtherTypeContentCellDelegate>delegate;

@property (nonatomic, strong)MKLoRaOtherTypeContentCellModel *dataModel;

+ (MKLoRaOtherTypeContentCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
