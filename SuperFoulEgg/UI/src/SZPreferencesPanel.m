#import "SZPreferencesPanel.h"
#import "Settings.h"

@implementation SZPreferencesPanel

@synthesize oneUpButton = _oneUpButton;
@synthesize oneDownButton = _oneDownButton;
@synthesize oneLeftButton = _oneLeftButton;
@synthesize oneRightButton = _oneRightButton;
@synthesize oneAButton = _oneAButton;
@synthesize oneBButton = _oneBButton;

@synthesize twoUpButton = _twoUpButton;
@synthesize twoDownButton = _twoDownButton;
@synthesize twoLeftButton = _twoLeftButton;
@synthesize twoRightButton = _twoRightButton;
@synthesize twoAButton = _twoAButton;
@synthesize twoBButton = _twoBButton;

@synthesize controller = _controller;

- (void)makeKeyAndOrderFront:(id)sender {
	[super makeKeyAndOrderFront:sender];
	
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeTwoUp forButton:_oneUpButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeTwoDown forButton:_oneDownButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeTwoLeft forButton:_oneLeftButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeTwoRight forButton:_oneRightButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeTwoA forButton:_oneAButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeTwoB forButton:_oneBButton];
	
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeOneUp forButton:_twoUpButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeOneDown forButton:_twoDownButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeOneLeft forButton:_twoLeftButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeOneRight forButton:_twoRightButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeOneA forButton:_twoAButton];
	[self setTitleFromCharacter:[Settings sharedSettings].keyCodeOneB forButton:_twoBButton];
}

- (void)keyDown:(NSEvent *)theEvent {
	[_controller didReceiveKeyDown:theEvent sender:self];
	[super keyUp:theEvent];
}

- (void)setTitleFromCharacter:(unichar)character forButton:(NSButton *)button {
	switch (character) {
		case DEFAULT_KEY_CODE_TWO_LEFT:
			button.title = @"←";
			break;
		case DEFAULT_KEY_CODE_TWO_RIGHT:
			button.title = @"→";
			break;
		case DEFAULT_KEY_CODE_TWO_UP:
			button.title = @"↑";
			break;
		case DEFAULT_KEY_CODE_TWO_DOWN:
			button.title = @"↓";
			break;
			
		default:
			button.title = [NSString stringWithFormat:@"%C", character];
			break;
	}
}

@end
