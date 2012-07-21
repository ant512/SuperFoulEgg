#import "MenuRectLayer.h"

@implementation MenuRectLayer

@synthesize rectangles = _rectangles;
@synthesize selectedIndex = _selectedIndex;

- (id)init {
	if ((self = [super init])) {
		_rectangles = [[NSMutableArray array] retain];
		_selectedIndex = 0;
	}

	return self;
}

- (void)dealloc {
	[_rectangles release];
	
	_rectangles = nil;
	
	[super dealloc];
}

- (void)selectPrevious {
	--_selectedIndex;
	
	if (_selectedIndex < 0) _selectedIndex = _rectangles.count - 1;
}

- (void)selectNext {
	++_selectedIndex;
	
	if (_selectedIndex == _rectangles.count) _selectedIndex = 0;
}

- (void)draw {
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(1);

	for (NSValue *value in _rectangles) {
		CGRect rect = NSRectToCGRect([value rectValue]);
		
		int index = [_rectangles indexOfObject:value];

		ccColor4F colour = index == _selectedIndex ? ccc4f(0.5, 0.5, 0.0, 0.5) : ccc4f(0, 0, 0, 0.5);
		
		ccDrawRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
		
		ccDrawSolidRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height), colour);
	}
}

@end
