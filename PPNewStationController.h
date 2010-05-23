//
//  PPNewStationController.h
//  PlayerPiano
//
//  Created by Matt Ball on 5/22/10.
//

#import <Cocoa/Cocoa.h>
#import <PianoBar/PPPianobarController.h>

typedef enum {
	PPNewStationSearchTypeArtist = 0,
	PPNewStationSearchTypeSong = 1
} PPNewStationSearchType;

@interface PPNewStationController : NSWindowController {
	PPPianobarController *_pianobar;
	NSArray *_searchResults;
	NSSearchField *_searchField;
	PPNewStationSearchType _searchType;
	
	NSMenuItem *_artistItem;
	NSMenuItem *_songItem;
	NSArrayController *_arrayController;
}

@property (nonatomic, retain) IBOutlet NSSearchField *searchField;
@property (nonatomic, retain) IBOutlet NSMenuItem *artistItem;
@property (nonatomic, retain) IBOutlet NSMenuItem *songItem;
@property (nonatomic, retain) IBOutlet NSArrayController *arrayController;

@property (nonatomic, retain) PPPianobarController *pianobar;
@property (nonatomic, retain, readonly) NSArray *searchResults;
@property (nonatomic, assign) PPNewStationSearchType searchType;

- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addStation:(id)sender;

- (IBAction)setSearchTypeArtist:(id)sender;
- (IBAction)setSearchTypeSong:(id)sender;

@end
