#import "BlockBase.h"

@implementation BlockBase

@synthesize isExploding = _isExploding;
@synthesize hasExploded = _hasExploded;
@synthesize isLanding = _isLanding;
@synthesize isFalling = _isFalling;
@synthesize hasDroppedHalfBlock = _hasDroppedHalfBlock;

@synthesize x = _x;
@synthesize y = _y;

@synthesize onExplode = _onExplode;
@synthesize onLand = _onLand;
@synthesize onFall = _onFall;
@synthesize onMove = _onMove;

@synthesize sprite = _sprite;

- (id)init {
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

- (void)dealloc {
	[_sprite.parent removeChild:_sprite cleanup:YES];
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

- (BOOL)isConnectable {
	return !_isLanding && !_isFalling && !_isExploding;
}

- (void)fall {
	_isFalling = YES;
	_isLanding = NO;

	if (_onFall != nil) _onFall(self);
}

- (void)explode {
	_isExploding = YES;

	if (_onExplode != nil) {
        _onExplode(self);
    } else {
        // If we haven't got anything to listen to this event,
        // we need to force the block to explode automatically
        _isExploding = NO;
        _hasExploded = YES;
    }
}

- (void)land {
	_isFalling = NO;
	_isLanding = YES;

	if (_onLand != nil) {
        _onLand(self);
    } else {
        // If we haven't got anything to listen to this event,
        // we need to force the block to land automatically
        _isLanding = NO;
    }
}

- (void)dropHalfBlock {
	_hasDroppedHalfBlock = !_hasDroppedHalfBlock;
	
	int extraY = _hasDroppedHalfBlock ? 8 : 0;
	
	_sprite.position = ccp(100 + (_x * 16), 200 - ((_y * 16) + extraY));

	if (_onMove != nil) _onMove(self);
}

- (void)setConnectionTop:(BOOL)top right:(BOOL)right bottom:(BOOL)bottom left:(BOOL)left {
	_connections = top | (left << 1) | (right << 2) | (bottom << 3);
	
	[_sprite setTextureRect:CGRectMake((_connections % 4) * 16, (_connections / 4) * 16, 16, 16)];
}

- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left {
}

- (void)setX:(int)x andY:(int)y {
	_x = x;
	_y = y;
	
	int extraY = _hasDroppedHalfBlock ? 8 : 0;

	_sprite.position = ccp(100 + (_x * 16), 200 - ((_y * 16) + extraY));

	if (_onMove != nil) _onMove(self);
}

@end
