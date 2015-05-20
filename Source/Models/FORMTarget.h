@import Foundation;

#import "FORMFieldBase.h"
#import "FORMFieldValue.h"

typedef NS_ENUM(NSInteger, FORMTargetType) {
    FORMTargetTypeField = 0,
    FORMTargetTypeSection,
    FORMTargetTypeNone
};

typedef NS_ENUM(NSInteger, FORMTargetActionType) {
    FORMTargetActionShow = 0,
    FORMTargetActionHide,
    FORMTargetActionUpdate,
    FORMTargetActionEnable,
    FORMTargetActionDisable,
    FORMTargetActionClear,
    FORMTargetActionNone
};

@interface FORMTarget : FORMFieldBase

@property (nonatomic, copy) NSString *targetID;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *actionTypeString;
@property (nonatomic, copy) NSString *condition;

@property (nonatomic) FORMTargetType type;
@property (nonatomic) FORMTargetActionType actionType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (NSDictionary *)fieldPropertiesToUpdate;

+ (void)filteredTargets:(NSArray*)targets
               filtered:(void (^)(NSArray *shownTargets,
                                  NSArray *hiddenTargets,
                                  NSArray *updatedTargets,
                                  NSArray *enabledTargets,
                                  NSArray *disabledTargets))filtered;

+ (FORMTarget *)showFieldTargetWithID:(NSString *)targetID;
+ (FORMTarget *)hideFieldTargetWithID:(NSString *)targetID;
+ (FORMTarget *)enableFieldTargetWithID:(NSString *)targetID;
+ (FORMTarget *)disableFieldTargetWithID:(NSString *)targetID;
+ (FORMTarget *)updateFieldTargetWithID:(NSString *)targetID;
+ (FORMTarget *)clearFieldTargetWithID:(NSString *)targetID;

+ (NSArray *)showFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)hideFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)enableFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)disableFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)updateFieldTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)clearFieldTargetsWithIDs:(NSArray *)targetIDs;

+ (FORMTarget *)showSectionTargetWithID:(NSString *)targetID;
+ (FORMTarget *)hideSectionTargetWithID:(NSString *)targetID;
+ (FORMTarget *)enableSectionTargetWithID:(NSString *)targetID;
+ (FORMTarget *)disableSectionTargetWithID:(NSString *)targetID;
+ (FORMTarget *)updateSectionTargetWithID:(NSString *)targetID;

+ (NSArray *)showSectionTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)hideSectionTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)enableSectionTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)disableSectionTargetsWithIDs:(NSArray *)targetIDs;
+ (NSArray *)updateSectionTargetsWithIDs:(NSArray *)targetIDs;

@end
