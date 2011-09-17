#import "PlayerOneController.h"
#import "Pad.h"

@implementation PlayerOneController

- (BOOL)isLeftHeld {
	return [Pad instanceOne].isLeftNewPress || [Pad instanceOne].isLeftRepeat;
}

- (BOOL)isRightHeld {
	return [Pad instanceOne].isRightNewPress || [Pad instanceOne].isRightRepeat;
}

- (BOOL)isUpHeld {
	return [Pad instanceOne].isUpNewPress || [Pad instanceOne].isUpRepeat;
}

- (BOOL)isDownHeld {
	return [Pad instanceOne].isDownHeld;
}

- (BOOL)isRotateClockwiseHeld {
	return [Pad instanceOne].isANewPress;
}

- (BOOL)isRotateAntiClockwiseHeld {
	return [Pad instanceOne].isBNewPress;
}

@end
