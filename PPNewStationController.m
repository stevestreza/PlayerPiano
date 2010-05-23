//
//  PPNewStationController.m
//  PlayerPiano
//
//  Created by Matt Ball on 5/22/10.
//

#import "PPNewStationController.h"
#import <PianoBar/PPSearchResult.h>
#import <PianoBar/PPStation.h>

@interface PPNewStationController ()
@property (nonatomic, retain, readwrite) NSArray *searchResults;
@end

@implementation PPNewStationController

@synthesize searchField=_searchField, artistItem=_artistItem, songItem=_songItem,
			arrayController=_arrayController;
@synthesize pianobar=_pianobar, searchResults=_searchResults, searchType=_searchType;

- (void)dealloc
{
	[_searchField release];
	_searchField = nil;
	[_artistItem release];
	_artistItem = nil;
	[_songItem release];
	_songItem = nil;
	[_arrayController release];
	_arrayController = nil;
	[_pianobar release];
	_pianobar = nil;
	[_searchResults release];
	_searchResults = nil;
	[super dealloc];
}

- (IBAction)search:(id)sender
{
	if ([[self.searchField stringValue] length] == 0) {
		self.searchResults = nil;
		return;
	}
	
	if (self.searchType == PPNewStationSearchTypeArtist) {
		self.searchResults = [self.pianobar stationsSimilarToArtist:[self.searchField stringValue]];
	} else if (self.searchType == PPNewStationSearchTypeSong) {
		self.searchResults = [self.pianobar stationsSimilarToSong:[self.searchField stringValue]];
	}
}

- (IBAction)cancel:(id)sender
{
	[NSApp endSheet:[self window]];
}

- (IBAction)addStation:(id)sender
{
	if ([[self.arrayController selectedObjects] count] == 0) {
		NSLog(@"No selection");
		return;
	}
	
	PPSearchResult *result = [[self.arrayController selectedObjects] objectAtIndex:0];
	NSString *musicID = result.musicID;
	[self.pianobar createStationForMusicID:musicID];
	
	// Find out what station number it is
	NSString *stationPrefix = result.title;
	if (self.searchType == PPNewStationSearchTypeArtist) {
		stationPrefix = result.artist;
	}
	
	PPStation *newStation = nil;
	for (PPStation *station in self.pianobar.stations) {
		if ([station.name hasPrefix:stationPrefix]) {
			newStation = station;
			break;
		}
	}
	if (newStation) {
		self.pianobar.selectedStation = newStation;
	}
	
	[NSApp endSheet:[self window]];
}

- (IBAction)setSearchTypeArtist:(id)sender
{
	self.searchType = PPNewStationSearchTypeArtist;
	[[self.searchField cell] setPlaceholderString:NSLocalizedString(@"Artist", @"New Station search placeholder: Artist")];
	[self.artistItem setState:NSOnState];
	[self.songItem setState:NSOffState];
	[[self.searchField cell] setSearchMenuTemplate:[[self.searchField cell] searchMenuTemplate]];
}

- (IBAction)setSearchTypeSong:(id)sender
{
	self.searchType = PPNewStationSearchTypeSong;
	[[self.searchField cell] setPlaceholderString:NSLocalizedString(@"Song", @"New Station search placeholder: Song")];
	[self.artistItem setState:NSOffState];
	[self.songItem setState:NSOnState];
	[[self.searchField cell] setSearchMenuTemplate:[[self.searchField cell] searchMenuTemplate]];
}

@end
