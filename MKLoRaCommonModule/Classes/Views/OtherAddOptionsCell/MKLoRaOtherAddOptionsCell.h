//
//  MKLoRaOtherAddOptionsCell.h
//  MKLoRaCommonModule
//

#import <UIKit/UIKit.h>
#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaOtherAddOptionsCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKLoRaOtherAddOptionsCellDelegate <NSObject>

- (void)mk_loraModule_otherAddOptionsCellAddPressed:(NSInteger)index;

@end

@interface MKLoRaOtherAddOptionsCell : MKBaseCell

@property (nonatomic, weak)id <MKLoRaOtherAddOptionsCellDelegate>delegate;

@property (nonatomic, strong)MKLoRaOtherAddOptionsCellModel *dataModel;

+ (MKLoRaOtherAddOptionsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
