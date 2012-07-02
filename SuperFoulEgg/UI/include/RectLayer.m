#import "RectLayer.h"

@implementation RectLayer

@synthesize rectangles = _rectangles;

- (id)init {
	if ((self = [super init])) {
		_rectangles = [[NSMutableArray array] retain];
	}

	return self;
}

- (void)draw {
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(1);

	for (NSValue *value in _rectangles) {
		NSRect rect = [value rectValue];
		
		ccDrawRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
		
		ccDrawSolidRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height), ccc4f(0.5, 0.5, 0.0, 0.5));
	}
}

- (void)dealloc {
	[_rectangles release];
	
	[super dealloc];
}

@end
