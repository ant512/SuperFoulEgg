#import "PlayerTwoController.h"
#import "Pad.h"

@implementation PlayerTwoController

- (BOOL)isLeftHeld {
	return [Pad instanceTwo].isLeftNewPress || [Pad instanceTwo].isLeftRepeat;
}

- (BOOL)isRightHeld {
	return [Pad instanceTwo].isRightNewPress || [Pad instanceTwo].isRightRepeat;
}

- (BOOL)isUpHeld {
	return [Pad instanceTwo].isUpNewPress || [Pad instanceTwo].isUpRepeat;
}

- (BOOL)isDownHeld {
	return [Pad instanceTwo].isDownHeld;
}

- (BOOL)isRotateClockwiseHeld {
	return [Pad instanceTwo].isANewPress;
}

- (BOOL)isRotateAntiClockwiseHeld {
	return [Pad instanceTwo].isBNewPress;
}

@end
