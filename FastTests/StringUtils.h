@interface StringUtils : NSObject
+ countObjectsWithFormat:(NSString *)formatString andCount:(int)count;
+ maybePluralizeWord:(NSString *)formatString forCount:(int)count;
+ (NSString *)getUserFirstName:(NSString *)userName;
+ (NSString *)getUserLastName:(NSString *)userName;
+ (NSString *)stringByReplacingBlankSpacesForPlus:(NSString *)input;
@end
