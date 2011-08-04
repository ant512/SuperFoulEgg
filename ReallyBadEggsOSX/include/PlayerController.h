#import <Foundation/NSObject.h>

#import "ControllerProtocol.h"

/**
 * Controller that reads the state of the Pad singleton in order to determine
 * what the human player is doing.
 */
@interface PlayerController : NSObject <ControllerProtocol> {
}

/**
 * Is left held?
 */
- (BOOL)isLeftHeld;

/**
 * Is right held?
 */
- (BOOL)isRightHeld;

/**
 * Is up held?
 */
- (BOOL)isUpHeld;

/**
 * Is down held?
 */
- (BOOL)isDownHeld;

/**
 * Is the rotate clockwise button held?
 */
- (BOOL)isRotateClockwiseHeld;

/**
 * Is the rotate anticlockwise button held?
 */
- (BOOL)isRotateAntiClockwiseHeld;

@end
