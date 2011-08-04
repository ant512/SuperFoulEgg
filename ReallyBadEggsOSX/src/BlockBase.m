#import "BlockBase.h"

@implementation BlockBase

@synthesize isExploding = _isExploding;
@synthesize hasExploded = _hasExploded;
@synthesize isLanding = _isLanding;
@synthesize isFalling = _isFalling;
@synthesize hasDroppedHalfBlock = _hasDroppedHalfBlock;
@synthesize connections = _connections;

@synthesize x = _x;
@synthesize y = _y;

@synthesize onStartExploding = _onStartExploding;
@synthesize onStopExploding = _onStopExploding;
@synthesize onStartLanding = _onStartLanding;
@synthesize onStopLanding = _onStopLanding;
@synthesize onStartFalling = _onStartFalling;
@synthesize onMove = _onMove;
@synthesize onConnect = _onConnect;

@synthesize grid = _grid;

- (id)initWithGrid:(Grid*)grid {
	if ((self = [super init])) {
		_isExploding = NO;
		_hasExploded = NO;
		_isLanding = NO;
		_isFalling = NO;
		_hasDroppedHalfBlock = NO;
		_connections = ConnectionNoneMask;

		_x = -1;
		_y = -1;
	}

	return self;
}

- (BOOL)hasLeftConnection {
	return _connections & ConnectionLeftMask;
}

- (BOOL)hasRightConnection {
	return _connections & ConnectionRightMask;
}

- (BOOL)hasTopConnection {
	return _connections & ConnectionTopMask;
}

- (BOOL)hasBottomConnection {
	return _connections & ConnectionBottomMask;
}

- (BOOL)isConnectable {
	return !_isLanding && !_isFalling && !_isExploding;
}

- (void)startFalling {
	_isFalling = YES;
	_isLanding = NO;

	if (_onFall != nil) _onFall(self);
}

- (void)stopExploding {
	NSAssert(_isExploding == YES, @"Cannot stop exploding blocks that aren't exploding.");

	_isExploding = NO;
	_hasExploded = YES;

	if (_onStopExploding != nil) _onStopExploding(self);
}

- (void)startExploding {
	
	//Cannot start exploding blocks that are already exploding
	if (_isExploding == YES) return; 
	
	_isExploding = YES;

	if (_onStartExploding != nil) {
		_onStartExploding(self);
	} else {
		// If we haven't got anything to listen to this event,
		// we need to force the block to explode automatically
		[self stopExploding];
	}
}

- (void)startLanding {

	NSAssert(_isFalling == YES, @"Cannot start landing blocks that aren't falling.");
	NSAssert(_isLanding == NO, @"Cannot start landing blocks that are already landing.");

	_isFalling = NO;
	_isLanding = YES;

	if (_onStartLanding != nil) {
		_onStartLanding(self);
	} else {
		// If we haven't got anything to listen to this event,
		// we need to force the block to land automatically
		[self stopLanding];
	}
}

- (void)stopLanding {
	NSAssert(_isLanding == YES, @"Cannot stop landing blocks that aren't landing.");

	_isFalling = NO;
	_isLanding = NO;

	if (_onStopLanding != nil) _onStopLanding(self);
}

- (void)dropHalfBlock {
	_hasDroppedHalfBlock = !_hasDroppedHalfBlock;

	// Call the set co-ords method in order to trigger the movement event
	[self setX:_x andY:_y];
}

- (void)setConnectionTop:(BOOL)top right:(BOOL)right bottom:(BOOL)bottom left:(BOOL)left {
	_connections = top | (left << 1) | (right << 2) | (bottom << 3);

	if (_onConnect != nil) _onConnect(self);
}

- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left {
}

- (void)setX:(int)x andY:(int)y {

	_x = x;
	_y = y;

	if (_onMove != nil) _onMove(self);
}

@end
