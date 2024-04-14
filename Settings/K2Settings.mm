//
//  K2Settings.mm
//  Copyright © 2024 Ken Kocienda. All rights reserved.
//

#import <sstream>
#import <string>
#import <map>
#import <vector>

#import <assert.h>
#import <objc/runtime.h>

#import "K2ObjCProperty.h"
#import "K2Settings.h"
#import "K2StringTools.h"

using K2::cpp_str;
using K2::ns_str;
using K2::ObjCProperty;

namespace K2 {

class SettingsProperty {
public:
    enum class AccessorType { Getter, Setter };
    
    SettingsProperty() {}
    SettingsProperty(NSString *defaults_key_prefix, const std::string &property_name, const ObjCProperty &property, AccessorType type);

    const std::string &property_name() const { return m_property_name; }
    const ObjCProperty &property() const { return m_property; }
    AccessorType accessor_type() const { return m_accessor_type; }
    NSString *defaults_key() const { return m_defaults_key; }
    SEL defaults_selector() const { return m_defaults_selector; }

private:
    std::string m_property_name;
    ObjCProperty m_property;
    AccessorType m_accessor_type = AccessorType::Getter;
    __strong NSString *m_defaults_key;
    SEL m_defaults_selector = nullptr;
};

SettingsProperty::SettingsProperty(NSString *defaults_key_prefix, const std::string &property_name,
                                   const ObjCProperty &property, AccessorType type) :
    m_property_name(property_name), m_property(property), m_accessor_type(type)
{
    NSMutableString *key = [NSMutableString stringWithString:defaults_key_prefix];
    [key appendString:ns_str(m_property_name)];
    m_defaults_key = key;
    
    switch (type) {
        case AccessorType::Getter: {
            switch (property.type()) {
                case ObjCProperty::Type::Unsupported:
                    assert(false);
                    break;
                case ObjCProperty::Type::Char:
                    m_defaults_selector = @selector(getCharKey:);
                    break;
                case ObjCProperty::Type::Short:
                    m_defaults_selector = @selector(getShortKey:);
                    break;
                case ObjCProperty::Type::Int:
                    m_defaults_selector = @selector(getIntKey:);
                    break;
                case ObjCProperty::Type::Long:
                    m_defaults_selector = @selector(getLongKey:);
                    break;
                case ObjCProperty::Type::LongLong:
                    m_defaults_selector = @selector(getLongLongKey:);
                    break;
                case ObjCProperty::Type::UChar:
                    m_defaults_selector = @selector(getUnsignedCharKey:);
                    break;
                case ObjCProperty::Type::UShort:
                    m_defaults_selector = @selector(getUnsignedShortKey:);
                    break;
                case ObjCProperty::Type::UInt:
                    m_defaults_selector = @selector(getUnsignedIntKey:);
                    break;
                case ObjCProperty::Type::ULong:
                    m_defaults_selector = @selector(getUnsignedLongKey:);
                    break;
                case ObjCProperty::Type::ULongLong:
                    m_defaults_selector = @selector(getUnsignedLongLongKey:);
                    break;
                case ObjCProperty::Type::Float:
                    m_defaults_selector = @selector(getFloatKey:);
                    break;
                case ObjCProperty::Type::Double:
                    m_defaults_selector = @selector(getDoubleKey:);
                    break;
                case ObjCProperty::Type::Bool:
                    m_defaults_selector = @selector(getBoolKey:);
                    break;
                case ObjCProperty::Type::String:
                    m_defaults_selector = @selector(getStringKey:);
                    break;
                case ObjCProperty::Type::Data:
                    m_defaults_selector = @selector(getDataKey:);
                    break;
                case ObjCProperty::Type::Number:
                    m_defaults_selector = @selector(getNumberKey:);
                    break;
                case ObjCProperty::Type::Date:
                    m_defaults_selector = @selector(getDateKey:);
                    break;
                case ObjCProperty::Type::Array:
                    m_defaults_selector = @selector(getArrayKey:);
                    break;
                case ObjCProperty::Type::Dictionary:
                    m_defaults_selector = @selector(getDictionaryKey:);
                    break;
                case ObjCProperty::Type::Object:
                    m_defaults_selector = @selector(getObjectKey:);
                    break;
            }
            break;
        }
        case AccessorType::Setter: {
            switch (property.type()) {
                case ObjCProperty::Type::Unsupported:
                    assert(false);
                    break;
                case ObjCProperty::Type::Char:
                    m_defaults_selector = @selector(setChar:key:overwrite:);
                    break;
                case ObjCProperty::Type::Short:
                    m_defaults_selector = @selector(setShort:key:overwrite:);
                    break;
                case ObjCProperty::Type::Int:
                    m_defaults_selector = @selector(setInt:key:overwrite:);
                    break;
                case ObjCProperty::Type::Long:
                    m_defaults_selector = @selector(setLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::LongLong:
                    m_defaults_selector = @selector(setLongLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::UChar:
                    m_defaults_selector = @selector(setUnsignedChar:key:overwrite:);
                    break;
                case ObjCProperty::Type::UShort:
                    m_defaults_selector = @selector(setUnsignedShort:key:overwrite:);
                    break;
                case ObjCProperty::Type::UInt:
                    m_defaults_selector = @selector(setUnsignedInt:key:overwrite:);
                    break;
                case ObjCProperty::Type::ULong:
                    m_defaults_selector = @selector(setUnsignedLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::ULongLong:
                    m_defaults_selector = @selector(setUnsignedLongLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::Float:
                    m_defaults_selector = @selector(setFloat:key:overwrite:);
                    break;
                case ObjCProperty::Type::Double:
                    m_defaults_selector = @selector(setDouble:key:overwrite:);
                    break;
                case ObjCProperty::Type::Bool:
                    m_defaults_selector = @selector(setBool:key:overwrite:);
                    break;
                case ObjCProperty::Type::String:
                case ObjCProperty::Type::Data:
                case ObjCProperty::Type::Number:
                case ObjCProperty::Type::Date:
                case ObjCProperty::Type::Array:
                case ObjCProperty::Type::Dictionary:
                case ObjCProperty::Type::Object:
                    m_defaults_selector = @selector(setObject:key:overwrite:);
                    break;
            }
        }
    }
}

}  // namespace K2

using K2::SettingsProperty;

@interface K2SettingsProperty ()

+ (K2SettingsProperty *)settingsPropertyWithInner:(const K2::SettingsProperty &)inner;
- (instancetype)initWithInner:(const K2::SettingsProperty &)inner;

@end

@implementation K2SettingsProperty

+ (K2SettingsProperty *)settingsPropertyWithInner:(const K2::SettingsProperty &)inner
{
    return [[self alloc] initWithInner:inner];
}

- (instancetype)initWithInner:(const K2::SettingsProperty &)inner
{
    self = [super init];

    self.name = K2::ns_str(inner.property_name());
    self.propertyType = static_cast<K2SettingsPropertyType>(inner.property().type());
    self.defaultsKey = inner.defaults_key();
    switch (inner.accessor_type()) {
        case K2::SettingsProperty::AccessorType::Getter:
            self.getterSelector = inner.defaults_selector();
            break;
        case K2::SettingsProperty::AccessorType::Setter:
            self.setterSelector = inner.defaults_selector();
            break;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<K2SettingsPropertyAccessor: %p> %@ : %@ : %@ : %@",
            self,
            self.name,
            self.defaultsKey,
            NSStringFromSelector(self.getterSelector),
            NSStringFromSelector(self.setterSelector)];
}

@end

// =========================================================================================================================================

using SettingsPropertyMap = std::map<std::string, SettingsProperty>;
using SettingsMap = std::map<Class, SettingsPropertyMap>;
using SettingsPropertyNameOrderingMap = std::map<Class, std::vector<std::string>>;

static SettingsMap m_settings_map;
static SettingsPropertyNameOrderingMap m_name_ordering_map;

@interface K2Settings ()
{
    BOOL m_setter_always_overwrites;
}
@end

@implementation K2Settings

+ (void)initialize
{
    std::vector<std::string> cls_names;
    Class settings_cls = objc_getClass("K2Settings");
    Class cls = self.class;
    while (cls != Nil && settings_cls != cls) {
        cls_names.push_back(class_getName(cls));
        cls = class_getSuperclass(cls);
    }
    std::ostringstream sstr;
    sstr << "/";
    for (auto it = cls_names.rbegin(); it != cls_names.rend(); ++it) {
        sstr << *it << "/";
    }
    NSString *defaults_key_prefix = [NSString stringWithUTF8String:sstr.str().c_str()];
    
    SettingsPropertyMap property_map;
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    std::vector<std::string> name_ordering_vector;
    for (unsigned int idx = 0; idx < outCount; idx++) {
        objc_property_t property = properties[idx];
        std::string property_name = property_getName(property);
        std::string getter_name = property_name;
        std::string setter_name = K2::property_setter_name(property_name);
        ObjCProperty ph4_objc_property(property);
        name_ordering_vector.push_back(property_name);
        property_map.emplace(getter_name, SettingsProperty(defaults_key_prefix, property_name, ph4_objc_property,
                                                           SettingsProperty::AccessorType::Getter));
        property_map.emplace(setter_name, SettingsProperty(defaults_key_prefix, property_name, ph4_objc_property,
                                                           SettingsProperty::AccessorType::Setter));
    }
    
    m_settings_map.emplace(self.class, property_map);
    m_name_ordering_map.emplace(self.class, name_ordering_vector);
}

- (instancetype)init
{
    self = [super init];
    
    [self ensureDefaultValues];
    
    m_setter_always_overwrites = YES;
    
    return self;
}

- (void)ensureDefaultValues
{
    m_setter_always_overwrites = NO;
    [self resetDefaultValues];
    m_setter_always_overwrites = YES;
}

- (void)resetDefaultValues
{
    Class cls = self.class;
    SEL sel = @selector(setDefaultValues);
    do {
        IMP imp = [cls instanceMethodForSelector:sel];
        typedef void (*fn)(id, SEL);
        fn f = (fn)imp;
        f(self, sel);
        cls = class_getSuperclass(cls);
    } while (cls != [K2Settings class]);
}

- (void)setDefaultValues
{
    // for subclasses
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    std::string selector_name = cpp_str(NSStringFromSelector(invocation.selector));

    Class cls = self.class;
    do {
        SettingsPropertyMap selector_map = m_settings_map[cls];
        const auto it = selector_map.find(selector_name);
        if (it != selector_map.end()) {
            //NSLog(@"forwardInvocation: %s", selector_name.c_str());
            const SettingsProperty &settings_property = it->second;
            invocation.selector = settings_property.defaults_selector();
            NSString *key = settings_property.defaults_key();
            //NSLog(@"   key: %@", key);
            switch (settings_property.accessor_type()) {
                case SettingsProperty::AccessorType::Getter:
                    [invocation setArgument:&key atIndex:2];
                    break;
                case SettingsProperty::AccessorType::Setter:
                    [invocation setArgument:&key atIndex:3];
                    [invocation setArgument:&m_setter_always_overwrites atIndex:4];
                    break;
            }
            break;
        }
        cls = class_getSuperclass(cls);
    } while (cls != [K2Settings class]);

    [invocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    //NSLog(@"methodSignatureForSelector: %@ : %@", self, NSStringFromSelector(selector));

    std::string selector_name = cpp_str(NSStringFromSelector(selector));
    Class cls = self.class;
    do {
        SettingsPropertyMap selector_map = m_settings_map[cls];
        const auto it = selector_map.find(selector_name);
        if (it != selector_map.end()) {
            const SettingsProperty &settings_property = it->second;
            return [cls instanceMethodSignatureForSelector:settings_property.defaults_selector()];
        }
        cls = class_getSuperclass(cls);
    } while (cls != [K2Settings class]);

    return [super methodSignatureForSelector:selector];
}

- (NSArray<K2SettingsProperty *> *)settingsProperties
{
    NSMutableArray<K2SettingsProperty *> *result = [NSMutableArray<K2SettingsProperty *> array];
    
    Class cls = self.class;
    do {
        SettingsPropertyMap &selector_map = m_settings_map[cls];
        const auto &name_ordering_vector = m_name_ordering_map[cls];
        for (const auto &it : name_ordering_vector) {
            const SettingsProperty &settings_property = selector_map[it];
            NSString *name = ns_str(settings_property.property_name());
            BOOL found = NO;
            for (K2SettingsProperty *sp in result) {
                if ([sp.name isEqual:name]) {
                    found = YES;
                    switch (settings_property.accessor_type()) {
                        case K2::SettingsProperty::AccessorType::Getter:
                            sp.getterSelector = settings_property.defaults_selector();
                            break;
                        case K2::SettingsProperty::AccessorType::Setter:
                            sp.setterSelector = settings_property.defaults_selector();
                            break;
                    }
                    break;
                }
            }
            if (!found) {
                K2SettingsProperty *settingsProperty = [K2SettingsProperty settingsPropertyWithInner:settings_property];
                NSString *humanReadableName = [self humanReadableNameForProperty:name];
                settingsProperty.humanReadableName = humanReadableName ? humanReadableName : name;
                [result addObject:settingsProperty];
            }
        }
        cls = class_getSuperclass(cls);
    } while (cls != [K2Settings class]);

    return result;
}

- (NSString *)humanReadableNameForProperty:(NSString *)name
{
    return nil;
}

@end

@implementation K2Settings (NSUserDefaults)

- (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (char)getCharKey:(NSString *)key
{
    //NSLog(@"getCharKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val charValue] : 0;
}

- (void)setChar:(char)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setChar: %hhd on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (short)getShortKey:(NSString *)key
{
    //NSLog(@"getShortKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val shortValue] : 0;
}

- (void)setShort:(short)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setShort: %hd on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (int)getIntKey:(NSString *)key
{
    //NSLog(@"getIntKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val intValue] : 0;
}

- (void)setInt:(int)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setInt: %d on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (long)getLongKey:(NSString *)key
{
    //NSLog(@"getLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val longValue] : 0;
}

- (void)setLong:(long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setLong: %ld on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (long long)getLongLongKey:(NSString *)key
{
    //NSLog(@"getLongLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val longLongValue] : 0;
}

- (void)setLongLong:(long long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setLongLong: %lld on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned char)getUnsignedCharKey:(NSString *)key
{
    //NSLog(@"getUnsignedCharKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedCharValue] : 0;
}

- (void)setUnsignedChar:(unsigned char)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setUnsignedChar: %hhu on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned short)getUnsignedShortKey:(NSString *)key
{
    //NSLog(@"getUnsignedShortKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedShortValue] : 0;
}

- (void)setUnsignedShort:(unsigned short)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setUnsignedShort: %hu on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned int)getUnsignedIntKey:(NSString *)key
{
    //NSLog(@"getUnsignedIntKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedIntValue] : 0;
}

- (void)setUnsignedInt:(unsigned int)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setUnsignedInt: %u on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned long)getUnsignedLongKey:(NSString *)key
{
    //NSLog(@"getUnsignedLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedLongValue] : 0;
}

- (void)setUnsignedLong:(unsigned long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setUnsignedLong: %ld on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned long long)getUnsignedLongLongKey:(NSString *)key
{
    //NSLog(@"getUnsignedLongLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedLongLongValue] : 0;
}

- (void)setUnsignedLongLong:(unsigned long long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setUnsignedLongLong: %llu on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (float)getFloatKey:(NSString *)key
{
    //NSLog(@"getFloatKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val floatValue] : 0;
}

- (void)setFloat:(float)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setFloat: %.3f on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (double)getDoubleKey:(NSString *)key
{
    //NSLog(@"getDoubleKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val doubleValue] : 0;
}

- (void)setDouble:(double)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setDouble: %.3f on %@ (%@)", value, key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (BOOL)getBoolKey:(NSString *)key
{
    //NSLog(@"getBoolKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val boolValue] : 0;
}

- (void)setBool:(BOOL)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setBool: %@ on %@ (%@)", value ? @"Y" : @"N", key, overwrite ? @"Y" : @"N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (NSString *)getStringKey:(NSString *)key
{
    //NSLog(@"getStringKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSString class]] ? (NSString *)val : @"";
}

- (NSData *)getDataKey:(NSString *)key
{
    //NSLog(@"getDataKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSData class]] ? (NSData *)val : [NSData data];
}

- (NSNumber *)getNumberKey:(NSString *)key
{
    //NSLog(@"getNumberKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSNumber class]] ? (NSNumber *)val : @(0);
}

- (NSDate *)getDateKey:(NSString *)key
{
    //NSLog(@"getDateKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSDate class]] ? (NSDate *)val : [NSDate date];
}

- (NSArray *)getArrayKey:(NSString *)key
{
    //NSLog(@"getArrayKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSArray class]] ? (NSArray *)val : @[];
}

- (NSDictionary *)getDictionaryKey:(NSString *)key
{
    //NSLog(@"getDictionaryKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSDictionary class]] ? (NSDictionary *)val : @{};
}

- (id)getObjectKey:(NSString *)key
{
    //NSLog(@"getObjectKey: on %@", key);
    id val = [self valueForKey:key];
    return val ?: nil;
}

- (void)setObject:(NSObject *)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        //NSLog(@"setObject: %@ on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
}

@end
