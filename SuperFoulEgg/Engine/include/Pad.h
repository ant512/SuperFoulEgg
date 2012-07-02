#import <Foundation/NSObject.h>

/**
 * Number of frames before a held-down key is considered to have repeated.
 */
#define PAD_REPEAT_TIME 10

/**
 * Model of a joypad, based on the layout of the Nintendo DS.  Implements
 * a singleton pattern so that the Pad is easily available everywhere.  The
 * state of the various joypad buttons needs to be managed with the pressXXX
 * and releaseXXX methods, and the update method needs to be called once per
 * frame to ensure that the internal logic runs correctly.
 */
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

/**
 * Has up been newly pressed on this frame?
 */
@property(readonly) BOOL isUpNewPress;

/**
 * Has down been newly pressed on this frame?
 */
@property(readonly) BOOL isDownNewPress;

/**
 * Has left been newly pressed on this frame?
 */
@property(readonly) BOOL isLeftNewPress;

/**
 * Has right been newly pressed on this frame?
 */
@property(readonly) BOOL isRightNewPress;

/**
 * Has A been newly pressed on this frame?
 */
@property(readonly) BOOL isANewPress;

/**
 * Has B been newly pressed on this frame?
 */
@property(readonly) BOOL isBNewPress;

/**
 * Has X been newly pressed on this frame?
 */
@property(readonly) BOOL isXNewPress;

/**
 * Has Y been newly pressed on this frame?
 */
@property(readonly) BOOL isYNewPress;

/**
 * Has Start been newly pressed on this frame?
 */
@property(readonly) BOOL isStartNewPress;

/**
 * Has Select been newly pressed on this frame?
 */
@property(readonly) BOOL isSelectNewPress;

/**
 * Has L been newly pressed on this frame?
 */
@property(readonly) BOOL isLNewPress;

/**
 * Has R been newly pressed on this frame?
 */
@property(readonly) BOOL isRNewPress;

/**
 * Has up been newly released on this frame?
 */
@property(readonly) BOOL isUpReleased;

/**
 * Has down been newly released on this frame?
 */
@property(readonly) BOOL isDownReleased;

/**
 * Has left been newly released on this frame?
 */
@property(readonly) BOOL isLeftReleased;

/**
 * Has right been newly released on this frame?
 */
@property(readonly) BOOL isRightReleased;

/**
 * Has A been newly released on this frame?
 */
@property(readonly) BOOL isAReleased;

/**
 * Has B been newly released on this frame?
 */
@property(readonly) BOOL isBReleased;

/**
 * Has X been newly released on this frame?
 */
@property(readonly) BOOL isXReleased;

/**
 * Has Y been newly released on this frame?
 */
@property(readonly) BOOL isYReleased;

/**
 * Has Start been newly released on this frame?
 */
@property(readonly) BOOL isStartReleased;

/**
 * Has Select been newly released on this frame?
 */
@property(readonly) BOOL isSelectReleased;

/**
 * Has L been newly released on this frame?
 */
@property(readonly) BOOL isLReleased;

/**
 * Has R been newly released on this frame?
 */
@property(readonly) BOOL isRReleased;

/**
 * Is up held?
 */
@property(readonly) BOOL isUpHeld;

/**
 * Is down held?
 */
@property(readonly) BOOL isDownHeld;

/**
 * Is left held?
 */
@property(readonly) BOOL isLeftHeld;

/**
 * Is right held?
 */
@property(readonly) BOOL isRightHeld;

/**
 * Is A held?
 */
@property(readonly) BOOL isAHeld;

/**
 * Is B held?
 */
@property(readonly) BOOL isBHeld;

/**
 * Is X held?
 */
@property(readonly) BOOL isXHeld;

/**
 * Is Y held?
 */
@property(readonly) BOOL isYHeld;

/**
 * Is Start held?
 */
@property(readonly) BOOL isStartHeld;

/**
 * Is Select held?
 */
@property(readonly) BOOL isSelectHeld;

/**
 * Is L held?
 */
@property(readonly) BOOL isLHeld;

/**
 * Is R held?
 */
@property(readonly) BOOL isRHeld;

/**
 * Is up repeating?
 */
@property(readonly) BOOL isUpRepeat;

/**
 * Is down repeating?
 */
@property(readonly) BOOL isDownRepeat;

/**
 * Is left repeating?
 */
@property(readonly) BOOL isLeftRepeat;

/**
 * Is right repeating?
 */
@property(readonly) BOOL isRightRepeat;

/**
 * Is A repeating?
 */
@property(readonly) BOOL isARepeat;

/**
 * Is B repeating?
 */
@property(readonly) BOOL isBRepeat;

/**
 * Is X repeating?
 */
@property(readonly) BOOL isXRepeat;

/**
 * Is Y repeating?
 */
@property(readonly) BOOL isYRepeat;

/**
 * Is Start repeating?
 */
@property(readonly) BOOL isStartRepeat;

/**
 * Is Select repeating?
 */
@property(readonly) BOOL isSelectRepeat;

/**
 * Is L repeating?
 */
@property(readonly) BOOL isLRepeat;

/**
 * Is R repeating?
 */
@property(readonly) BOOL isRRepeat;

/**
 * True if the most recently-pressed direction was vertical; false if it was
 * horizontal.
 */
@property(readonly) BOOL isMostRecentDirectionVertical;

/**
 * Get the Pad singleton instance for player 1.
 * @return The pad singleton instance for player 1.
 */
+ (Pad*)instanceOne;

/**
 * Get the Pad singleton instance for player 2.
 * @return The pad singleton instance for player 2.
 */
+ (Pad*)instanceTwo;

- (id)init;
- (void)update;
- (void)reset;

- (void)pressUp;
- (void)pressDown;
- (void)pressLeft;
- (void)pressRight;
- (void)pressA;
- (void)pressB;
- (void)pressX;
- (void)pressY;
- (void)pressStart;
- (void)pressSelect;
- (void)pressL;
- (void)pressR;

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
