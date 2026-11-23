//
//  MKLoRaFilterRelationshipCell.h
//  MKLoRaCommonModule
//
//  Created by aa on 2026/11/23.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaFilterRelationshipCellModel : NSObject

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger dataListIndex;

@property (nonatomic, strong) NSArray *dataList;

@end

@protocol MKLoRaFilterRelationshipCellDelegate <NSObject>

- (void)mk_loraFilterRelationshipChanged:(NSInteger)index dataListIndex:(NSInteger)dataListIndex;

@end

@interface MKLoRaFilterRelationshipCell : MKBaseCell

@property (nonatomic, strong) MKLoRaFilterRelationshipCellModel *dataModel;

@property (nonatomic, weak) id <MKLoRaFilterRelationshipCellDelegate> delegate;

+ (MKLoRaFilterRelationshipCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
