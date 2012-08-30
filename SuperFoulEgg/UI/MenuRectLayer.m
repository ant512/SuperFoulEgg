#import "MenuRectLayer.h"

@implementation MenuRectLayer

@synthesize rectangleGroups = _rectangleGroups;
@synthesize selectedRectangleIndexes = _selectedRectangleIndexes;
@synthesize selectedGroupIndex = _selectedGroupIndex;

- (id)init {
	if ((self = [super init])) {
		_rectangleGroups = [[NSMutableArray array] retain];
		_selectedRectangleIndexes = [[NSMutableArray array] retain];
		_selectedGroupIndex = 0;
	}

	return self;
}

- (void)dealloc {
	[_rectangleGroups release];
	[_selectedRectangleIndexes release];
	
	_rectangleGroups = nil;
	_selectedRectangleIndexes = nil;
	
	[super dealloc];
}

- (void)ensureRectangleIndexesExist {
	for (NSUInteger i = _selectedRectangleIndexes.count; i < _rectangleGroups.count; ++i) {
		[_selectedRectangleIndexes addObject:@0];
	}
}

- (void)selectPreviousRectangle {
	
	[self ensureRectangleIndexesExist];
	
	NSUInteger index = [[_selectedRectangleIndexes objectAtIndex:_selectedGroupIndex] intValue];
	
	if (index == 0) {
		index = [[_rectangleGroups objectAtIndex:_selectedGroupIndex] count] - 1;
	} else {
		--index;
	}
	
	[_selectedRectangleIndexes setObject:[NSNumber numberWithUnsignedInteger:index] atIndexedSubscript:_selectedGroupIndex];
}

- (void)selectNextRectangle {
	
	NSUInteger index = [[_selectedRectangleIndexes objectAtIndex:_selectedGroupIndex] intValue];
	
	++index;
	
	if (index == [[_rectangleGroups objectAtIndex:_selectedGroupIndex] count]) index = 0;
	
	[_selectedRectangleIndexes setObject:[NSNumber numberWithUnsignedInteger:index] atIndexedSubscript:_selectedGroupIndex];
}

- (BOOL)selectBelowRectangle {
	
	NSUInteger index = [[_selectedRectangleIndexes objectAtIndex:_selectedGroupIndex] intValue];
	NSArray *group = [_rectangleGroups objectAtIndex:_selectedGroupIndex];
	
	CGRect selectedRect = NSRectToCGRect([[group objectAtIndex:index] rectValue]);
	
	for (NSUInteger i = index + 1; i < group.count; ++i) {
		CGRect rect = NSRectToCGRect([[group objectAtIndex:i] rectValue]);
		
		if (rect.origin.x == selectedRect.origin.x && rect.origin.y == selectedRect.origin.y - selectedRect.size.height) {
			[_selectedRectangleIndexes setObject:[NSNumber numberWithUnsignedInteger:i] atIndexedSubscript:_selectedGroupIndex];
			
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)selectAboveRectangle {
	
	NSUInteger index = [[_selectedRectangleIndexes objectAtIndex:_selectedGroupIndex] intValue];
	NSArray *group = [_rectangleGroups objectAtIndex:_selectedGroupIndex];
	
	CGRect selectedRect = NSRectToCGRect([[group objectAtIndex:index] rectValue]);
	
	for (NSUInteger i = index; i > 0; --i) {
		CGRect rect = NSRectToCGRect([[group objectAtIndex:i - 1] rectValue]);
		
		if (rect.origin.x == selectedRect.origin.x && rect.origin.y == selectedRect.origin.y + selectedRect.size.height) {
			[_selectedRectangleIndexes setObject:[NSNumber numberWithUnsignedInteger:i - 1] atIndexedSubscript:_selectedGroupIndex];
			
			return YES;
		}
	}
	
	return NO;
}

- (void)selectPreviousGroup {
	if (_selectedGroupIndex == 0) {
		_selectedGroupIndex = _rectangleGroups.count - 1;
	} else {
		--_selectedGroupIndex;
	}
}

- (void)selectNextGroup {
	++_selectedGroupIndex;
	
	if (_selectedGroupIndex == _rectangleGroups.count) _selectedGroupIndex = 0;
}

- (NSUInteger)selectedIndexInGroup:(NSUInteger)groupIndex {
	[self ensureRectangleIndexesExist];
	return [[_selectedRectangleIndexes objectAtIndex:groupIndex] intValue];
}

- (void)draw {
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(1);

	for (NSArray *group in _rectangleGroups) {
		
		NSUInteger groupIndex = [_rectangleGroups indexOfObject:group];
		
		for (NSValue *value in group) {
			CGRect rect = NSRectToCGRect([value rectValue]);
			
			NSUInteger rectangleIndex = [group indexOfObject:value];

			ccColor4F colour = ccc4f(0, 0, 0, 0);
			
			if (groupIndex == _selectedGroupIndex) {
				colour = rectangleIndex == [self selectedIndexInGroup:groupIndex] ? ccc4f(0.5, 0.5, 0.0, 0.5) : ccc4f(0, 0, 0, 0.5);
			} else {
				colour = rectangleIndex == [self selectedIndexInGroup:groupIndex] ? ccc4f(0.2, 0.2, 0.2, 0.5) : ccc4f(0.1, 0.1, 0.1, 0.5);
			}
			
			ccDrawRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
			
			ccDrawSolidRect(rect.origin, ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height), colour);
		}
	}
}

@end
