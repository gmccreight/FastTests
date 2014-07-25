#import "AlbumOrAllPostsViewModel.h"

#import "DateUtils.h"
#import "StringUtils.h"

@implementation AlbumOrAllPostsViewModel

- (NSString *)photoAndNotesCount
{
    NSString *countsString = [StringUtils countObjectsWithFormat:@"%d photo%@" andCount:self.num_photos];
    
    if (self.num_notes > 0) {
        NSString *notesCountString = [StringUtils countObjectsWithFormat:@"%d note%@" andCount:self.num_notes];
        countsString = [NSString stringWithFormat:@"%@ & %@", countsString, notesCountString];
    }
    
    return countsString;
}

- (NSString *)dateAndPhotoAndNotesCount
{
    if (self.date) {
        NSString *dateString = [DateUtils getMediumStyleStringForDate:self.date];
        return [NSString stringWithFormat:@"%@ • %@", dateString, [self photoAndNotesCount]];
    } else {
        return [self photoAndNotesCount];
    }
}

@end
