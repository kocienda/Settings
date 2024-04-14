//
//  K2Settings.h
//  Copyright © 2024 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class K2SettingsProperty;

@interface K2Settings : NSObject

- (void)ensureDefaultValues;
- (void)resetDefaultValues;

- (NSArray<K2SettingsProperty *> *)settingsProperties;

// for subclasses
- (void)setDefaultValues;

@end

// =========================================================================================================================================

@interface K2Settings (NSUserDefaults)

- (id)valueForKey:(NSString *)key;

- (char)getCharKey:(NSString *)key;
- (void)setChar:(char)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (int)getIntKey:(NSString *)key;
- (void)setInt:(int)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (short)getShortKey:(NSString *)key;
- (void)setShort:(short)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (long)getLongKey:(NSString *)key;
- (void)setLong:(long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (long long)getLongLongKey:(NSString *)key;
- (void)setLongLong:(long long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned char)getUnsignedCharKey:(NSString *)key;
- (void)setUnsignedChar:(unsigned char)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned short)getUnsignedShortKey:(NSString *)key;
- (void)setUnsignedShort:(unsigned short)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned int)getUnsignedIntKey:(NSString *)key;
- (void)setUnsignedInt:(unsigned int)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned long)getUnsignedLongKey:(NSString *)key;
- (void)setUnsignedLong:(unsigned long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned long long)getUnsignedLongLongKey:(NSString *)key;
- (void)setUnsignedLongLong:(unsigned long long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (float)getFloatKey:(NSString *)key;
- (void)setFloat:(float)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (double)getDoubleKey:(NSString *)key;
- (void)setDouble:(double)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (BOOL)getBoolKey:(NSString *)key;
- (void)setBool:(BOOL)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (NSString *)getStringKey:(NSString *)key;
- (NSData *)getDataKey:(NSString *)key;
- (NSNumber *)getNumberKey:(NSString *)key;
- (NSDate *)getDateKey:(NSString *)key;
- (NSArray *)getArrayKey:(NSString *)key;
- (NSDictionary *)getDictionaryKey:(NSString *)key;

- (id)getObjectKey:(NSString *)key;
- (void)setObject:(NSObject *)value key:(NSString *)key overwrite:(BOOL)overwrite;

@end

// =========================================================================================================================================

typedef NS_ENUM(NSInteger, K2SettingsPropertyType) {
    K2SettingsPropertyTypeUnsupported,
    K2SettingsPropertyTypeBool,
    K2SettingsPropertyTypeChar,
    K2SettingsPropertyTypeShort,
    K2SettingsPropertyTypeInt,
    K2SettingsPropertyTypeLong,
    K2SettingsPropertyTypeLongLong,
    K2SettingsPropertyTypeUChar,
    K2SettingsPropertyTypeUShort,
    K2SettingsPropertyTypeUInt,
    K2SettingsPropertyTypeULong,
    K2SettingsPropertyTypeULongLong,
    K2SettingsPropertyTypeFloat,
    K2SettingsPropertyTypeDouble,
    K2SettingsPropertyTypeString,
    K2SettingsPropertyTypeData,
    K2SettingsPropertyTypeNumber,
    K2SettingsPropertyTypeDate,
    K2SettingsPropertyTypeArray,
    K2SettingsPropertyTypeDictionary,
    K2SettingsPropertyTypeObject,
};

// =========================================================================================================================================

@interface K2SettingsProperty : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *humanReadableName;
@property (nonatomic) K2SettingsPropertyType propertyType;
@property (nonatomic) NSString *defaultsKey;
@property (nonatomic) SEL getterSelector;
@property (nonatomic) SEL setterSelector;
@end

// =========================================================================================================================================
