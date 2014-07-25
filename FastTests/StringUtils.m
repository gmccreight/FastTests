#import "StringUtils.h"

@implementation StringUtils

+ countObjectsWithFormat:(NSString *)formatString andCount:(int)count
{
    NSString *maybeS = (count == 1) ? @"" : @"s";
    return [NSString stringWithFormat:formatString, count, maybeS];
}

+ maybePluralizeWord:(NSString *)formatString forCount:(int)count
{
    NSString *maybeS = (count == 1) ? @"" : @"s";
    return [NSString stringWithFormat:@"%@%@", formatString, maybeS];
}

+ (NSString *)getUserFirstName:(NSString *)userName
{
    NSArray *components = [userName componentsSeparatedByString:@" "];
    NSString *result = @"";
    if ([components count] > 0) {
        result = components[0];
    }
    return result;
}

+ (NSString *)getUserLastName:(NSString *)userName
{
    if (userName == nil)
        return @"";
    
    NSRange space = [userName rangeOfString:@" "];
    NSString *result = @"";
    if (space.location != NSNotFound) {
        result = [userName substringFromIndex:space.location+1];
    }
    return result;
}

+ (NSString *)stringByReplacingBlankSpacesForPlus:(NSString *)input
{
    return [input stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

@end
