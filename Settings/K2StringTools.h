//
//  K2StringTools.h
//  Copyright © 2024 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <codecvt>
#import <locale>
#import <sstream>
#import <string>
#import <string_view>
#import <vector>

namespace K2 {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
static inline std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> &utf8_char32_conv() {
    static std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
    return conv;
}
#pragma clang diagnostic pop

static inline std::string cpp_str(const std::u32string &str) {
    return utf8_char32_conv().to_bytes(str);
}
static inline std::string cpp_str(const std::u32string_view &str) {
    return cpp_str(std::u32string(str));
}
static inline std::u32string cpp_u32str(const std::string &str) {
    return utf8_char32_conv().from_bytes(str);
}

#if __OBJC__
static inline NSString *ns_str(const char *str) { return [NSString stringWithUTF8String:str]; }
static inline NSString *ns_str(const std::string &str) { return [NSString stringWithUTF8String:str.c_str()]; }
static inline NSString *ns_str(const std::u32string &str) {
    return ns_str(utf8_char32_conv().to_bytes(str));
}
static inline NSString *ns_str(char32_t c) {
    std::u32string str(1, c);
    return ns_str(str);
}
static inline NSString *ns_str_with_number(int n) {
    return [[NSString alloc] initWithFormat:@"%d", n];
}
static inline std::string cpp_str(NSString *str) { return std::string([str UTF8String]); }
static inline std::u32string cpp_u32str(NSString *str) {
    return utf8_char32_conv().from_bytes(cpp_str(str));
}
static inline std::string_view cpp_str_view(NSString *str) {
    const char *s = [str UTF8String];
    return std::string_view(s, strlen(s));
}
#endif  // __OBJC__

// https://stackoverflow.com/a/1493195
template <class ContainerT>
void tokenize(const std::string &str, ContainerT &tokens, const std::string &delimiters = " ", bool trim_empty = false)
{
    using value_type = typename ContainerT::value_type;
    using size_type  = typename ContainerT::size_type;

    const std::string::size_type length = str.length();
    std::string::size_type last_pos = 0;
    
    while (last_pos < length + 1) {
        std::string::size_type pos = str.find_first_of(delimiters, last_pos);
        if (pos == std::string::npos) {
            pos = length;
        }
        if (pos != last_pos || !trim_empty) {
            tokens.push_back(value_type(str.data() + last_pos, (size_type)pos - last_pos));
        }
        last_pos = pos + 1;
    }
}

static inline std::string property_setter_name(const std::string &property_name)
{
    std::string upper_property_name = property_name;
    upper_property_name[0] = static_cast<std::string::value_type>(std::toupper(upper_property_name[0]));
    
    std::ostringstream sstr;
    sstr << "set" << upper_property_name << ":";
    
    return sstr.str();
}

}  // namespace K2
