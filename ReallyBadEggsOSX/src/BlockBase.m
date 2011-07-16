#import "BlockBase.h"

@implementation BlockBase

@synthesize isExploding = _isExploding;
@synthesize isLanding = _isLanding;
@synthesize isFalling = _isFalling;
@synthesize hasDroppedHalfBlock = _hasDroppedHalfBlock;

- (id)init {
	if ((self = [super init])) {
		_isExploding = NO;
		_isLanding = NO;
		_isFalling = NO;
		_hasDroppedHalfBlock = NO;
		_connections = ConnectionNoneMask;
	}

	return self;
}

- (void)dealloc {
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
}

- (void)explode {
	_isExploding = YES;
}

- (void)land {
	_isFalling = NO;
	_isLanding = YES;
}

- (void)animate {
	if (_isExploding) {
		//_explodingAnim->run();
	} else if (_isLanding) {
		//_landingAnim->run();
		
		//if (_landingAnim->getStatus() == WoopsiGfx::Animation::ANIMATION_STATUS_STOPPED) {
			_isLanding = false;
		//}
	}
}

- (BOOL)isExploded {
	return _isExploding;// && _explodingAnim->getStatus() == WoopsiGfx::Animation::ANIMATION_STATUS_STOPPED;
}

- (void)dropHalfBlock {
	_hasDroppedHalfBlock = !_hasDroppedHalfBlock;
}

- (void)setConnectionTop:(BOOL)top right:(BOOL)right bottom:(BOOL)bottom left:(BOOL)left {
	_connections = top | (left << 1) | (right << 2) | (bottom << 3);
}

- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left {
}


@end
