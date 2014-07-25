#import <XCTest/XCTest.h>

#import "AlbumOrAllPostsViewModel.h"
#import "DateUtils.h"

@interface AlbumOrAllPostsViewModelTests : XCTestCase {
AlbumOrAllPostsViewModel *viewModel;
}
@end


@implementation AlbumOrAllPostsViewModelTests

- (void)setUp
{
    [super setUp];
    viewModel = [[AlbumOrAllPostsViewModel alloc] init];
    viewModel.num_photos = 0;
    viewModel.num_notes = 0;
    viewModel.date = nil;
}

- (void)testPhotoAndNotesCountWithNoPhotoShouldMentionTheLackOfThePhoto
{
    XCTAssertEqualObjects([viewModel photoAndNotesCount], @"0 photos", @"");
}

- (void)testPhotoAndNotesCountWithOnePhotoAndNoNoteShouldNotMentionNote
{
    viewModel.num_photos = 1;
    XCTAssertEqualObjects([viewModel photoAndNotesCount], @"1 photo", @"");
}

- (void)testPhotoAndNotesCountWithOneEach
{
    viewModel.num_photos = 1;
    viewModel.num_notes = 1;
    XCTAssertEqualObjects([viewModel photoAndNotesCount], @"1 photo & 1 note", @"");
}

- (void)testPhotoAndNotesCountWithMultipleOfEach
{
    viewModel.num_photos = 3;
    viewModel.num_notes = 2;
    XCTAssertEqualObjects([viewModel photoAndNotesCount], @"3 photos & 2 notes", @"");
}

#pragma mark -
#pragma mark with date

- (void)testDateAndPhotoAndNotesCountWithNoDateAndSomePhotosAndNotes
{
    viewModel.num_photos = 3;
    viewModel.num_notes = 1;
    XCTAssertEqualObjects([viewModel dateAndPhotoAndNotesCount], @"3 photos & 1 note", @"");
}

- (void)testDateAndPhotoAndNotesCountWithDateAndNoPhotos
{
    viewModel.date = [NSDate dateWithTimeIntervalSince1970:1576800000];
    viewModel.num_photos = 0;
    XCTAssertEqualObjects([viewModel dateAndPhotoAndNotesCount], @"Dec 20, 2019 • 0 photos", @"");
}

- (void)testDateAndPhotoAndNotesCountWithDateAndOnePhotoAndThreeNotes
{
    viewModel.date = [NSDate dateWithTimeIntervalSince1970:1576800000];
    viewModel.num_photos = 1;
    viewModel.num_notes = 3;
    XCTAssertEqualObjects([viewModel dateAndPhotoAndNotesCount], @"Dec 20, 2019 • 1 photo & 3 notes", @"");
}

@end
