#import <Foundation/Foundation.h>

#import "GridBase.h"

@implementation GridBase

@synthesize width = _width;
@synthesize height = _height;

- (id)initWithWidth:(int)width height:(int)height {
	if ((self = [super init])) {
		_width = width;
		_height = height;

		for (int i = 0; i < _width * _height; ++i) {
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
	for (int i = 0; i < _width * _height; ++i) {
		if (_data[i] != nil) {
			[_data[i] release];
			_data[i] = nil;
		}
	}
}

- (BlockBase*)blockAtX:(int)x y:(int)y {
	NSAssert([self isValidCoordinateX:x y:y], @"Invalid co-ordinate supplied.");

	return _data[x + (y * _width)];
}

- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY {

	NSAssert([self isValidCoordinateX:sourceX y:sourceY], @"Invalid source co-ordinate supplied.");
	NSAssert([self isValidCoordinateX:destinationX y:destinationY], @"Invalid destination co-ordinate supplied.");

	if (sourceX == destinationX && sourceY == destinationY) return;

	int srcIndex = sourceX + (sourceY * _width);
	int destIndex = destinationX + (destinationY * _width);

	NSAssert(_data[destIndex] == nil, @"Attempt to move block to non-empty grid location");

	_data[destIndex] = _data[srcIndex];
	_data[srcIndex] = nil;

	[_data[destIndex] setX:destinationX andY:destinationY];
}

- (BOOL)isValidCoordinateX:(int)x y:(int)y {
	if (x < 0) return NO;
	if (x >= _width) return NO;
	if (y < 0) return NO;
	if (y >= _height) return NO;

	return YES;
}

- (BOOL)addBlockAtX:(BlockBase*)block x:(int)x y:(int)y {
	
	NSAssert([self blockAtX:x y:x] == nil, @"Attempt to add block at non-empty grid location");
	
	int index = x + (y * _width);
	_data[index] = [block retain];;
	
	return YES;
}

- (int)heightOfColumnAtIndex:(int)column {

	NSAssert(column < _width, @"Invalid column value supplied.");

	int height = 0;

	for (int y = _height - 1; y >= 0; --y) {
		BlockBase* block = [self blockAtX:column y:y];
		if (block != nil && block.state == BlockNormalState) {
			++height;
		} else {
			break;
		}
	}

	return height;
}

@end
