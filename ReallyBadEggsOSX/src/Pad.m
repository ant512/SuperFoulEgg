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

- (void)holdUp { ++_up; }
- (void)holdDown { ++_down; }
- (void)holdLeft { ++_left; }
- (void)holdRight { ++_right; }
- (void)holdA { ++_a; }
- (void)holdB { ++_b; }
- (void)holdX { ++_x; }
- (void)holdY { ++_y; }
- (void)holdStart { ++_start; }
- (void)holdSelect { ++_select; }
- (void)holdL { ++_l; }
- (void)holdR { ++_r; }

- (void)releaseUp { _up = -1; }
- (void)releaseDown { _down = -1; }
- (void)releaseLeft { _left = -1; }
- (void)releaseRight { _right = -1; }
- (void)releaseA { _a = -1; }
- (void)releaseB { _b = -1; }
- (void)releaseX { _x = -1; }
- (void)releaseY { _y = -1; }
- (void)releaseStart { _start = -1; }
- (void)releaseSelect { _select = -1; }
- (void)releaseL { _l = -1; }
- (void)releaseR { _r = -1; }

@end
