#import "NSDictionary+HYPNestedAttributes.h"

#import "HYPParsedRelationship.h"

#import "NSString+HYPRelationshipParser.h"

static NSString * const HYPNestedAttributesRailsKey = @"_attributes";

typedef NS_ENUM(NSInteger, HYPNestedAttributesType) {
    HYPJSONNestedAttributesType,
    HYPRailsNestedAttributesType
};

@implementation NSDictionary (HYPNestedAttributes)

#pragma mark - Public methods

- (NSDictionary *)hyp_JSONNestedAttributes
{
    return [self nestedAttributes:HYPJSONNestedAttributesType];
}

- (NSDictionary *)hyp_railsNestedAttributes
{
    return [self nestedAttributes:HYPRailsNestedAttributesType];
}

- (NSDictionary *)hyp_flatAttributes
{
    NSMutableDictionary *flatAttributes = [NSMutableDictionary new];

    [self enumerateKeysAndObjectsUsingBlock:^(NSString *attributeKey, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *elements = [self objectForKey:attributeKey];
            NSInteger relationshipIndex = 0;
            for (NSDictionary *element in elements) {
                for (NSString *key in element) {
                    NSString *relationshipKey = [NSString stringWithFormat:@"%@[%ld].%@", attributeKey, (long)relationshipIndex, key];
                    flatAttributes[relationshipKey] = element[key];
                }
                relationshipIndex++;
            }
        } else {
            flatAttributes[attributeKey] = obj;
        }
    }];

    return [flatAttributes copy];
}

#pragma mark - Private methods

- (NSDictionary *)nestedAttributes:(HYPNestedAttributesType)type
{
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary new];
    NSMutableArray *nestedArrayAttributes;
    NSMutableDictionary *nestedDictionaryAttributes;

    NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *currentRelation;
    NSString *currentRelationIndex;
    NSInteger index = 0;

    for (NSString *key in sortedKeys) {
        HYPParsedRelationship *parsed = [key hyp_parseRelationship];
        if (parsed.toMany) {
            if (type == HYPJSONNestedAttributesType) {
                HYPParsedRelationship *parsedRelationshipPrefix = [key hyp_parseRelationship];
                parsedRelationshipPrefix.attribute = nil;
                NSString *relationshipPrefix = [parsedRelationshipPrefix key];
                BOOL hasTheSameRelationshipPrefix = (currentRelationIndex &&
                                                     ![currentRelationIndex isEqualToString:relationshipPrefix]);
                if (hasTheSameRelationshipPrefix) {
                    index++;
                }

                BOOL hasTheSameRelationship = (currentRelation &&
                                               ![currentRelation isEqualToString:parsedRelationshipPrefix.relationship]);
                if (hasTheSameRelationship) {
                    index = 0;
                }

                currentRelation = parsedRelationshipPrefix.relationship;
                currentRelationIndex = relationshipPrefix;

                nestedArrayAttributes = attributesDictionary[parsed.relationship] ?: [NSMutableArray new];
                nestedArrayAttributes = [[self JSONProcessNestedAttributes:nestedArrayAttributes
                                                                    parsed:parsed
                                                                       key:key
                                                                     index:index] mutableCopy];

                attributesDictionary[parsed.relationship] = nestedArrayAttributes;
            } else if (type == HYPRailsNestedAttributesType) {
                NSString *attributesKey = [NSString stringWithFormat:@"%@%@", parsed.relationship, HYPNestedAttributesRailsKey];
                nestedDictionaryAttributes = attributesDictionary[attributesKey] ?: [NSMutableDictionary new];
                nestedDictionaryAttributes = [[self railsProcessNestedAttributes:nestedDictionaryAttributes
                                                                parsed:parsed
                                                                   key:key] mutableCopy];
                attributesDictionary[attributesKey] = nestedDictionaryAttributes;
            }
        } else {
            NSString *attributeKey = [self valueForKey:key];
            attributesDictionary[parsed.attribute] = attributeKey;
        }
    }

    return attributesDictionary;
}

- (NSArray *)JSONProcessNestedAttributes:(NSArray *)nestedAttributes
                                  parsed:(HYPParsedRelationship *)parsed
                                     key:(NSString *)key
                                   index:(NSInteger)index
{
    NSMutableArray *processedNestedAttributes = [nestedAttributes mutableCopy];
    NSMutableDictionary *foundDictionary;

    BOOL isExistingRelationshipItem = (nestedAttributes.count > index);
    if (isExistingRelationshipItem) {
        foundDictionary = [[nestedAttributes objectAtIndex:index] mutableCopy];
    } else {
        foundDictionary = [NSMutableDictionary new];
    }

    NSString *attributeKey = [self valueForKey:key];
    foundDictionary[parsed.attribute] = attributeKey;

    if (isExistingRelationshipItem) {
        [processedNestedAttributes replaceObjectAtIndex:index withObject:foundDictionary];
    } else {
        [processedNestedAttributes addObject:foundDictionary];
    }

    return [processedNestedAttributes copy];
}

- (NSDictionary *)railsProcessNestedAttributes:(NSMutableDictionary *)nestedAttributes
                                        parsed:(HYPParsedRelationship *)parsed
                                           key:(NSString *)key
{
    NSMutableDictionary *processedNestedAttributes = [nestedAttributes mutableCopy];
    NSString *indexString = [parsed.index stringValue];

    NSMutableDictionary *attributesDictionary = [processedNestedAttributes[indexString] mutableCopy];
    if (!attributesDictionary) {
        attributesDictionary = [NSMutableDictionary new];
    }

    NSString *attributeKey = [self valueForKey:key];
    attributesDictionary[parsed.attribute] = attributeKey;
    processedNestedAttributes[indexString] = [attributesDictionary copy];

    return [processedNestedAttributes copy];
}

@end
