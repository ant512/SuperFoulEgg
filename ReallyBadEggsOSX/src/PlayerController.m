#import "PlayerController.h"
#import "Pad.h"

@implementation PlayerController

- (BOOL)isLeftHeld {
	return [Pad instance].isLeftNewPress || [Pad instance].isLeftRepeat;
}

- (BOOL)isRightHeld {
	return [Pad instance].isRightNewPress || [Pad instance].isRightRepeat;
}

- (BOOL)isUpHeld {
	return [Pad instance].isUpNewPress || [Pad instance].isUpRepeat;
}

- (BOOL)isDownHeld {
	return [Pad instance].isDownNewPress || [Pad instance].isDownRepeat;
}

- (BOOL)isRotateClockwiseHeld {
	return [Pad instance].isANewPress;
}

- (BOOL)isRotateAntiClockwiseHeld {
	return [Pad instance].isBNewPress;
}

@end
