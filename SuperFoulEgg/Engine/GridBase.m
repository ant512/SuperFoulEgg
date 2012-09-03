#import <Foundation/Foundation.h>

#import "GridBase.h"

@implementation GridBase

- (id)init {
	if ((self = [super init])) {
		for (int i = 0; i < GRID_SIZE; ++i) {
			_data[i] = nil;
		}
	}
	
	return self;
}

- (void)dealloc {
	[self clear];
	[super dealloc];
}

- (void)clear {
	for (int i = 0; i < GRID_SIZE; ++i) {
		[_data[i] release];
		_data[i] = nil;
	}
}

- (BlockBase*)blockAtX:(int)x y:(int)y {
	if (![self isValidCoordinateX:x y:y]) return nil;

	return _data[x + (y * GRID_WIDTH)];
}

- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY {

	NSAssert([self isValidCoordinateX:sourceX y:sourceY], @"Invalid source co-ordinates supplied.");
	NSAssert([self isValidCoordinateX:destinationX y:destinationY], @"Invalid destination co-ordinates supplied.");

	if (sourceX == destinationX && sourceY == destinationY) return;

	int srcIndex = sourceX + (sourceY * GRID_WIDTH);
	int destIndex = destinationX + (destinationY * GRID_WIDTH);

	NSAssert(_data[destIndex] == nil, @"Attempt to move block to non-empty grid location.");
	NSAssert(_data[srcIndex] != nil, @"Attempt to move nil block to new location.");

	_data[destIndex] = _data[srcIndex];
	_data[srcIndex] = nil;

	[_data[destIndex] setX:destinationX andY:destinationY];
}

- (BOOL)isValidCoordinateX:(int)x y:(int)y {
	if (x < 0) return NO;
	if (x >= GRID_WIDTH) return NO;
	if (y < 0) return NO;
	if (y >= GRID_HEIGHT) return NO;

	return YES;
}

- (void)addBlock:(BlockBase*)block x:(int)x y:(int)y {
	
	NSAssert([self blockAtX:x y:y] == nil, @"Attempt to add block at non-empty grid location");
	
	int index = x + (y * GRID_WIDTH);
	_data[index] = [block retain];
    
    [block setX:x andY:y];
}

- (void)removeBlockAtX:(int)x y:(int)y {
	int index = x + (y * GRID_WIDTH);
	
	BlockBase* block = _data[index];
	_data[index] = nil;
	[block release];
}


- (int)heightOfColumnAtIndex:(int)index {

	NSAssert(index < GRID_WIDTH, @"Invalid column index supplied.");

	int height = 0;

	for (int y = GRID_ENTRY_Y - 1; y >= 0; --y) {
		BlockBase* block = [self blockAtX:index y:y];
		if (block != nil && block.state == BlockNormalState) {
			++height;
		} else {
			break;
		}
	}

	return height;
}

@end
