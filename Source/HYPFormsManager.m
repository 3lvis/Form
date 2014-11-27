#import "HYPFormsManager.h"

@interface HYPFormsManager ()

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSArray *disabledFieldsIDs;

@end

@implementation HYPFormsManager

- (instancetype)initWithJSON:(id)JSON
               initialValues:(NSDictionary *)initialValues
            disabledFieldIDs:(NSArray *)disabledFieldIDs
{
    self = [super init];
    if (!self) return nil;

    [self.values addEntriesFromDictionary:initialValues];

    _disabledFieldsIDs = disabledFieldIDs;

    [self updateFormsWithJSON:JSON];

    return self;
}

- (NSMutableDictionary *)values
{
    if (_values) return _values;

    _values = [NSMutableDictionary new];

    return _values;
}

- (NSMutableArray *)forms
{
    if (_forms) return _forms;

    _forms = [NSMutableArray new];

    return _forms;
}

- (void)updateFormsWithJSON:(NSArray *)JSON
{
    /*NSMutableArray *forms = [NSMutableArray array];

    NSMutableArray *targetsToRun = [NSMutableArray array];

    NSMutableArray *fieldsWithFormula = [NSMutableArray array];

    [JSON enumerateObjectsUsingBlock:^(NSDictionary *formDict, NSUInteger formIndex, BOOL *stop) {

        HYPForm *form = [HYPForm new];
        form.formID = [formDict andy_valueForKey:@"id"];
        form.title = [formDict andy_valueForKey:@"title"];
        form.position = @(formIndex);

        NSMutableArray *sections = [NSMutableArray array];
        NSArray *dataSourceSections = [formDict andy_valueForKey:@"sections"];
        NSDictionary *lastObject = [dataSourceSections lastObject];

        [dataSourceSections enumerateObjectsUsingBlock:^(NSDictionary *sectionDict, NSUInteger sectionIndex, BOOL *stop) {

            HYPFormSection *section = [HYPFormSection new];
            section.sectionID = [sectionDict andy_valueForKey:@"id"];
            section.position = @(sectionIndex);

            BOOL isLastSection = (lastObject == sectionDict);

            if (isLastSection) section.isLast = YES;

            NSArray *dataSourceFields = [sectionDict andy_valueForKey:@"fields"];
            NSMutableArray *fields = [NSMutableArray array];

            [dataSourceFields enumerateObjectsUsingBlock:^(NSDictionary *fieldDict, NSUInteger fieldIndex, BOOL *stop) {

                NSString *remoteID = [fieldDict andy_valueForKey:@"id"];

                HYPFormField *field = [HYPFormField new];
                field.fieldID   = remoteID;
                field.title = [fieldDict andy_valueForKey:@"title"];
                field.typeString  = [fieldDict andy_valueForKey:@"type"];
                field.type = [field typeFromTypeString:[fieldDict andy_valueForKey:@"type"]];
                NSNumber *width = [fieldDict andy_valueForKey:@"size.width"];
                NSNumber *height = [fieldDict andy_valueForKey:@"size.height"];
                if (!height || !width) abort();

                field.size = CGSizeMake([width floatValue], [height floatValue]);
                field.position = @(fieldIndex);
                field.validations = [fieldDict andy_valueForKey:@"validations"];
                field.disabled = [[fieldDict andy_valueForKey:@"disabled"] boolValue];
                field.formula = [fieldDict andy_valueForKey:@"formula"];
                field.targets = [self targetsUsingArray:[fieldDict andy_valueForKey:@"targets"]];

                BOOL shouldDisable = (disabled || [disabledFieldsIDs containsObject:field.fieldID]);

                if (shouldDisable) field.disabled = YES;

                NSMutableArray *values = [NSMutableArray array];
                NSArray *dataSourceValues = [fieldDict andy_valueForKey:@"values"];

                if (dataSourceValues) {
                    for (NSDictionary *valueDict in dataSourceValues) {
                        HYPFieldValue *fieldValue = [HYPFieldValue new];
                        fieldValue.valueID = [valueDict andy_valueForKey:@"id"];
                        fieldValue.title = [valueDict andy_valueForKey:@"title"];
                        fieldValue.value = [valueDict andy_valueForKey:@"value"];

                        BOOL needsToRun = NO;

                        if ([dictionary andy_valueForKey:remoteID]) {
                            if ([fieldValue identifierIsEqualTo:[dictionary andy_valueForKey:remoteID]]) {
                                needsToRun = YES;
                            }
                        }

                        NSArray *targets = [self targetsUsingArray:[valueDict andy_valueForKey:@"targets"]];
                        for (HYPFormTarget *target in targets) {
                            target.value = fieldValue;

                            if (needsToRun && target.actionType == HYPFormTargetActionHide) [targetsToRun addObject:target];
                        }

                        fieldValue.targets = targets;
                        fieldValue.field = field;
                        [values addObject:fieldValue];
                    }
                }

                if ([dictionary andy_valueForKey:remoteID]) {
                    if (field.type == HYPFormFieldTypeSelect) {
                        for (HYPFieldValue *value in values) {

                            BOOL isInitialValue = ([value identifierIsEqualTo:[dictionary andy_valueForKey:remoteID]]);

                            if (isInitialValue) field.fieldValue = value;
                        }
                    } else {
                        field.fieldValue = [dictionary andy_valueForKey:remoteID];
                    }
                }

                field.values = values;
                field.section = section;
                [fields addObject:field];

                if (field.formula) [fieldsWithFormula addObject:field];
            }];

            if (!isLastSection) {
                HYPFormField *field = [HYPFormField new];
                field.sectionSeparator = YES;
                field.position = @(fields.count);
                field.section = section;
                [fields addObject:field];
            }

            section.fields = fields;
            section.form = form;
            [sections addObject:section];
        }];

        form.sections = sections;
        [forms addObject:form];
    }];

    [self processFieldsWithFormula:fieldsWithFormula inForms:forms usingValues:dictionary];

    [self processHiddenFieldsInTargets:targetsToRun
                               inForms:forms
                            completion:^(NSMutableDictionary *fields, NSMutableDictionary *sections) {
                                [self removeHiddenFieldsInTargets:targetsToRun inForms:forms];

                                if (additionalValues) additionalValues(fields, sections);
                            }];

    return forms;*/
}

@end
