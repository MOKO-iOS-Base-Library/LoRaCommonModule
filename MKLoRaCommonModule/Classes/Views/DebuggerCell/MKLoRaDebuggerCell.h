#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaDebuggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *timeMsg;

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *logInfo;

@end

@protocol MKLoRaDebuggerCellDelegate <NSObject>

- (void)mk_loraModule_debuggerCellSelectedChanged:(NSInteger)index selected:(BOOL)selected;

@end

@interface MKLoRaDebuggerCell : MKBaseCell

@property (nonatomic, strong)MKLoRaDebuggerCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaDebuggerCellDelegate>delegate;

+ (MKLoRaDebuggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
