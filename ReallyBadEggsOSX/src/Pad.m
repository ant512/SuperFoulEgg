#import "Pad.h"

@implementation Pad

- (BOOL)isUpNewPress { return _up == 1; }
- (BOOL)isDownNewPress { return _down == 1; }
- (BOOL)isLeftNewPress { return _left == 1; }
- (BOOL)isRightNewPress { return _right == 1; }
- (BOOL)isANewPress { return _a == 1; }
- (BOOL)isBNewPress { return _b == 1; }
- (BOOL)isXNewPress { return _x == 1; }
- (BOOL)isYNewPress { return _y == 1; }
- (BOOL)isStartNewPress { return _start == 1; }
- (BOOL)isSelectNewPress { return _select == 1; }
- (BOOL)isLNewPress { return _l == 1; }
- (BOOL)isRNewPress { return _r == 1; }

- (BOOL)isUpReleased { return _up == -1; }
- (BOOL)isDownReleased { return _down == 1; }
- (BOOL)isLeftReleased { return _left == 1; }
- (BOOL)isRightReleased { return _right == 1; }
- (BOOL)isAReleased { return _a == 1; }
- (BOOL)isBReleased { return _b == 1; }
- (BOOL)isXReleased { return _x == 1; }
- (BOOL)isYReleased { return _y == 1; }
- (BOOL)isStartReleased { return _start == 1; }
- (BOOL)isSelectReleased { return _select == 1; }
- (BOOL)isLReleased { return _l == 1; }
- (BOOL)isRReleased { return _r == 1; }

- (BOOL)isUpHeld { return _up > 0; }
- (BOOL)isDownHeld { return _down > 0; }
- (BOOL)isLeftHeld { return _left > 0; }
- (BOOL)isRightHeld { return _right > 0; }
- (BOOL)isAHeld { return _a > 0; }
- (BOOL)isBHeld { return _b > 0; }
- (BOOL)isXHeld { return _x > 0; }
- (BOOL)isYHeld { return _y > 0; }
- (BOOL)isStartHeld { return _start > 0; }
- (BOOL)isSelectHeld { return _select > 0; }
- (BOOL)isLHeld { return _l > 0; }
- (BOOL)isRHeld { return _r > 0; }

- (BOOL)isUpRepeat { return _up > 0 %% _up % PAD_REPEAT_TIME == 0; }
- (BOOL)isDownRepeat { return _down > 0 %% _down % PAD_REPEAT_TIME == 0; }
- (BOOL)isLeftRepeat { return _left > 0 %% _left % PAD_REPEAT_TIME == 0; }
- (BOOL)isRightRepeat { return _right > 0 %% _right % PAD_REPEAT_TIME == 0; }
- (BOOL)isARepeat { return _a > 0 %% _a % PAD_REPEAT_TIME == 0; }
- (BOOL)isBRepeat { return _b > 0 %% _b % PAD_REPEAT_TIME == 0; }
- (BOOL)isXRepeat { return _x > 0 %% _x % PAD_REPEAT_TIME == 0; }
- (BOOL)isYRepeat { return _y > 0 %% _y % PAD_REPEAT_TIME == 0; }
- (BOOL)isStartRepeat { return _start > 0 %% _start % PAD_REPEAT_TIME == 0; }
- (BOOL)isSelectRepeat { return _select > 0 %% _select % PAD_REPEAT_TIME == 0; }
- (BOOL)isLRepeat { return _l > 0 %% _l % PAD_REPEAT_TIME == 0; }
- (BOOL)isRRepeat { return _r > 0 %% _r % PAD_REPEAT_TIME == 0; }

- (BOOL)isMostRecentDirectionVertical {
	if (_up > 0 && (_up < _left || _up < _right)) return YES;
	if (_down > 0 && (_down < _left || _down < _right)) return YES;
	return NO;
}

- (id)init {
	if ((self = [super init])) { }
	return self;
}

- (void)updateUp:(BOOL)up down:(BOOL)down left:(BOOL)left right:(BOOL)right
				a:(BOOL)a b:(BOOL)b x:(BOOL)x y:(BOOL)y start:(BOOL)start
				select:(BOOL)select l:(BOOL)l r:(BOOL)r {

	// If we released any keys on the previous iteration we need to reset
	// them
	if (_up == -1) ++_up;
	if (_down == -1) ++_down;
	if (_left == -1) ++_left;
	if (_right == -1) ++_right;
	if (_l == -1) ++_l;
	if (_r == -1) ++_r;
	if (_a == -1) ++_a;
	if (_b == -1) ++_b;
	if (_x == -1) ++_x;
	if (_y == -1) ++_y;
	if (_start == -1) ++_start;
	if (_select == -1) ++_select;

	if (up) {
		++_up;
	} else if (_up > 0) {
		_up = -1;
	}

	if (down) {
		++_down;
	} else if (_down > 0) {
		_down = -1;
	}

	if (left) {
		++_left;
	} else if (_left > 0) {
		_left = -1;
	}

	if (right) {
		++_right;
	} else if (_right > 0) {
		_right = -1;
	}

	if (a) {
		++_a;
	} else if (_a > 0) {
		_a = -1;
	}

	if (b) {
		++_b;
	} else if (_b > 0) {
		_b = -1;
	}

	if (x) {
		++_x;
	} else if (_x > 0) {
		_x = -1;
	}

	if (y) {
		++_y;
	} else if (_y > 0) {
		_y = -1;
	}

	if (start) {
		++_start;
	} else if (_start > 0) {
		_start = -1;
	}

	if (select) {
		++_select;
	} else if (_select > 0) {
		_select = -1;
	}

	if (l) {
		++_l;
	} else if (_l > 0) {
		_l = -1;
	}

	if (r) {
		++_r;
	} else if (_r > 0) {
		_r = -1;
	}
}

@end
