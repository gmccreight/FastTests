@interface AlbumOrAllPostsViewModel : NSObject

@property (nonatomic) NSInteger num_photos;
@property (nonatomic) NSInteger num_notes;
@property (nonatomic) NSDate *date;

- (NSString *)photoAndNotesCount;
- (NSString *)dateAndPhotoAndNotesCount;

@end

