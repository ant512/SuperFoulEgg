#import "BlockBase.h"

@implementation BlockBase

@synthesize state = _state;
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

- (id)init {
	if ((self = [super init])) {
		_state = BlockNormalState;
		_hasDroppedHalfBlock = NO;
		_connections = ConnectionNoneMask;

		_x = -1;
		_y = -1;
	}

	return self;
}

- (void)dealloc {
	[_onStartExploding release];
	[_onStopExploding release];
	[_onStartLanding release];
	[_onStopLanding release];
	[_onStartFalling release];
	[_onMove release];
	[_onConnect release];
	[super dealloc];
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

- (void)startFalling {
	if (_state == BlockFallingState) return;
	
	//NSAssert(_state == BlockNormalState, @"Cannot make blocks fall that aren't in the normal state.");

	_state = BlockFallingState;
	_connections = ConnectionNoneMask;

	if (_onStartFalling != nil) _onStartFalling(self);
}

- (void)stopExploding {
	NSAssert(_state == BlockExplodingState, @"Cannot stop exploding blocks that aren't exploding.");

	_state = BlockExplodedState;

	if (_onStopExploding != nil) _onStopExploding(self);
}

- (void)startExploding {
	
	if (_state == BlockExplodingState) return;
	
	NSAssert(_state == BlockNormalState, @"Cannot explode blocks that aren't at rest.");
	
	_state = BlockExplodingState;

	if (_onStartExploding != nil) {
		_onStartExploding(self);
	} else {
		// If we haven't got anything to listen to this event,
		// we need to force the block to explode automatically
		[self stopExploding];
	}
}

- (void)startLanding {

	NSAssert(_state == BlockFallingState, @"Cannot start landing blocks that aren't falling.");

	_state = BlockLandingState;

	if (_onStartLanding != nil) {
		_onStartLanding(self);
	} else {
		// If we haven't got anything to listen to this event,
		// we need to force the block to land automatically
		[self stopLanding];
	}
}

- (void)stopLanding {
	NSAssert(_state == BlockLandingState, @"Cannot stop landing blocks that aren't landing.");

	_state = BlockNormalState;

	if (_onStopLanding != nil) _onStopLanding(self);
}

- (void)startRecoveringFromGarbageHit {
	_state = BlockRecoveringFromGarbageHitState;
}

- (void)stopRecoveringFromGarbageHit {
	NSAssert(_state == BlockRecoveringFromGarbageHitState, @"Cannot stop a non-recovering block from recovering.");

	_state = BlockNormalState;
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
