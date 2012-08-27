#import "SZPreferencesPanel.h"

@implementation SZPreferencesPanel

- (void)keyDown:(NSEvent *)theEvent {
	[_controller didReceiveKeyDown:theEvent sender:self];
	[super keyUp:theEvent];
}

@end
