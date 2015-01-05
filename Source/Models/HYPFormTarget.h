@import Foundation;

#import "HYPFieldValue.h"

typedef NS_ENUM(NSInteger, HYPFormTargetType) {
    HYPFormTargetTypeField = 0,
    HYPFormTargetTypeSection,
    HYPFormTargetTypeNone
};

typedef NS_ENUM(NSInteger, HYPFormTargetActionType) {
    HYPFormTargetActionShow = 0,
    HYPFormTargetActionHide,
    HYPFormTargetActionUpdate,
    HYPFormTargetActionEnable,
    HYPFormTargetActionDisable,
    HYPFormTargetActionNone
};

@interface HYPFormTarget : NSObject

@property (nonatomic, copy) NSString *targetID;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *actionTypeString;

@property (nonatomic, strong) HYPFieldValue *value;
@property (nonatomic) HYPFormTargetType type;
@property (nonatomic) HYPFormTargetActionType actionType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets))filtered;

+ (HYPFormTarget *)showFieldTargetWithID:(NSString *)targetID;
+ (HYPFormTarget *)hideFieldTargetWithID:(NSString *)targetID;
+ (HYPFormTarget *)enableFieldTargetWithID:(NSString *)targetID;
+ (HYPFormTarget *)disableFieldTargetWithID:(NSString *)targetID;

+ (NSArray *)showFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)hideFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)enableFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)disableFieldTargetsWithIDs:(NSArray *)targetIDs;

+ (HYPFormTarget *)showSectionTargetWithID:(NSString *)targetID;
+ (HYPFormTarget *)hideSectionTargetWithID:(NSString *)targetID;

+ (NSArray *)showSectionTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)hideSectionTargetsWithIDs:(NSArray *)targetIDs;

@end
