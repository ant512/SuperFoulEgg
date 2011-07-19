#import "PlayerController.h"

@implementation PlayerController

- (BOOL)isLeftHeld {
	return _isLeftHeld;
}

- (BOOL)isRightHeld {
	return _isRightHeld;
}

- (BOOL)isUpHeld {
	return _isUpHeld;
}

- (BOOL)isDownHeld {
	return _isDownHeld;
}

- (BOOL)isRotateClockwiseHeld {
	return _isRotateClockwiseHeld;
}

- (BOOL)isRotateAntiClockwiseHeld {
	return _isRotateAntiClockwiseHeld;
}

- (void)setLeftHeld:(BOOL)held {
	_isLeftHeld = held;
	
}

- (void)setRightHeld:(BOOL)held {
	_isRightHeld = held;
	
}

- (void)setUpHeld:(BOOL)held {
	_isUpHeld = held;
	
}

- (void)setDownHeld:(BOOL)held {
	_isDownHeld = held;
	
}

- (void)setRotateClockwiseHeld:(BOOL)held {
	_isRotateClockwiseHeld = held;
	
}

- (void)setRotateAntiClockwiseHeld:(BOOL)held {
	_isRotateAntiClockwiseHeld = held;
	
}

@end
