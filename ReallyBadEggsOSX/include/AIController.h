#import <Foundation/NSObject.h>

#import "ControllerProtocol.h"
#import "GridRunner.h"
#import "BlockBase.h"
#import "SZPoint.h"

@interface AIController : NSObject <ControllerProtocol> {
	GridRunner* _gridRunner;	/**< The GridRunner that the AI is controlling. */
	int _lastLiveBlockY;		/**< The last observed y co-ordinate of the first live block. */
	int _targetX;				/**< The x co-ordinate the AI is trying to move the live block to. */
	int _targetRotations;		/**< Number of clockwise rotations needed before correct live block
									 orientation is achieved. */
	int _hesitation;			/**< Chance that the AI will hesitate (larger value = more likely;
									 0 = no hesitation). */
}

@property(readwrite, assign) GridRunner* gridRunner;

- (id)initWithHesitation:(int)hesitation;
- (void)dealloc;

- (void)analyseGrid;
- (int)scoreShapePositionForBlock1:(BlockBase*)block1 block2:(BlockBase*)block2 atPoint1:(SZPoint*)point1 point2:(SZPoint*)point2;

- (BOOL)isLeftHeld;
- (BOOL)isRightHeld;
- (BOOL)isUpHeld;
- (BOOL)isDownHeld;
- (BOOL)isRotateClockwiseHeld;
- (BOOL)isRotateAntiClockwiseHeld;

@end
