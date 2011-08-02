#import <Foundation/NSObject.h>

#define PAD_REPEAT_TIME 10

@interface Pad : NSObject {
@private
	int _up;		/**< Is up held? */
	int _down;		/**< Is down held? */
	int _left;		/**< Is left held? */
	int _right;		/**< Is right held? */
	int _a;			/**< Is a held? */
	int _b;			/**< Is b held? */
	int _x;			/**< Is x held? */
	int _y;			/**< Is y held? */
	int _l;			/**< Is l held? */
	int _r;			/**< Is r held? */
	int _start;		/**< Is start held? */
	int _select;	/**< Is select held? */
}

@property(readonly) BOOL isUpNewPress;
@property(readonly) BOOL isDownNewPress;
@property(readonly) BOOL isLeftNewPress;
@property(readonly) BOOL isRightNewPress;
@property(readonly) BOOL isANewPress;
@property(readonly) BOOL isBNewPress;
@property(readonly) BOOL isXNewPress;
@property(readonly) BOOL isYNewPress;
@property(readonly) BOOL isStartNewPress;
@property(readonly) BOOL isSelectNewPress;
@property(readonly) BOOL isLNewPress;
@property(readonly) BOOL isRNewPress;

@property(readonly) BOOL isUpReleased;
@property(readonly) BOOL isDownReleased;
@property(readonly) BOOL isLeftReleased;
@property(readonly) BOOL isRightReleased;
@property(readonly) BOOL isAReleased;
@property(readonly) BOOL isBReleased;
@property(readonly) BOOL isXReleased;
@property(readonly) BOOL isYReleased;
@property(readonly) BOOL isStartReleased;
@property(readonly) BOOL isSelectReleased;
@property(readonly) BOOL isLReleased;
@property(readonly) BOOL isRReleased;

@property(readonly) BOOL isUpHeld;
@property(readonly) BOOL isDownHeld;
@property(readonly) BOOL isLeftHeld;
@property(readonly) BOOL isRightHeld;
@property(readonly) BOOL isAHeld;
@property(readonly) BOOL isBHeld;
@property(readonly) BOOL isXHeld;
@property(readonly) BOOL isYHeld;
@property(readonly) BOOL isStartHeld;
@property(readonly) BOOL isSelectHeld;
@property(readonly) BOOL isLHeld;
@property(readonly) BOOL isRHeld;

@property(readonly) BOOL isUpRepeat;
@property(readonly) BOOL isDownRepeat;
@property(readonly) BOOL isLeftRepeat;
@property(readonly) BOOL isRightRepeat;
@property(readonly) BOOL isARepeat;
@property(readonly) BOOL isBRepeat;
@property(readonly) BOOL isXRepeat;
@property(readonly) BOOL isYRepeat;
@property(readonly) BOOL isStartRepeat;
@property(readonly) BOOL isSelectRepeat;
@property(readonly) BOOL isLRepeat;
@property(readonly) BOOL isRRepeat;

@property(readonly) BOOL isMostRecentDirectionVertical;

- (id)init;

- (void)holdUp;
- (void)holdDown;
- (void)holdLeft;
- (void)holdRight;
- (void)holdA;
- (void)holdB;
- (void)holdX;
- (void)holdY;
- (void)holdStart;
- (void)holdSelect;
- (void)holdL;
- (void)holdR;

- (void)releaseUp;
- (void)releaseDown;
- (void)releaseLeft;
- (void)releaseRight;
- (void)releaseA;
- (void)releaseB;
- (void)releaseX;
- (void)releaseY;
- (void)releaseStart;
- (void)releaseSelect;
- (void)releaseL;
- (void)releaseR;


@end
