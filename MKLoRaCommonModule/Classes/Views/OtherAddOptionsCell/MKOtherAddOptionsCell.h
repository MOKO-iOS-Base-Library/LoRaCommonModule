//
//  MKOtherAddOptionsCell.h
//  MKLoRaCommonModule
//

#import <UIKit/UIKit.h>
#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKOtherAddOptionsCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKOtherAddOptionsCellDelegate <NSObject>

- (void)mk_otherAddOptionsCellAddPressed:(NSInteger)index;

@end

@interface MKOtherAddOptionsCell : MKBaseCell

@property (nonatomic, weak)id <MKOtherAddOptionsCellDelegate>delegate;

@property (nonatomic, strong)MKOtherAddOptionsCellModel *dataModel;

+ (MKOtherAddOptionsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
