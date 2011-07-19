#import <Foundation/NSObject.h>

#import "ControllerProtocol.h"

@interface PlayerController : NSObject <ControllerProtocol> {
	BOOL _isLeftHeld;
	BOOL _isRightHeld;
	BOOL _isUpHeld;
	BOOL _isDownHeld;
	BOOL _isRotateClockwiseHeld;
	BOOL _isRotateAntiClockwiseHeld;
}

- (void)setLeftHeld:(BOOL)held;
- (void)setRightHeld:(BOOL)held;
- (void)setUpHeld:(BOOL)held;
- (void)setDownHeld:(BOOL)held;
- (void)setRotateClockwiseHeld:(BOOL)held;
- (void)setRotateAntiClockwiseHeld:(BOOL)held;

- (BOOL)isLeftHeld;
- (BOOL)isRightHeld;
- (BOOL)isUpHeld;
- (BOOL)isDownHeld;
- (BOOL)isRotateClockwiseHeld;
- (BOOL)isRotateAntiClockwiseHeld;

@end
