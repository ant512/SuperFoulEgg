#import <Foundation/NSObject.h>

#import "ControllerProtocol.h"

@interface PlayerController : NSObject <ControllerProtocol> {
}

- (BOOL)isLeftHeld;
- (BOOL)isRightHeld;
- (BOOL)isUpHeld;
- (BOOL)isDownHeld;
- (BOOL)isRotateClockwiseHeld;
- (BOOL)isRotateAntiClockwiseHeld;

@end
