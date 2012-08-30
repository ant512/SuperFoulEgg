#import <Foundation/NSObject.h>

@protocol ControllerProtocol <NSObject>

- (BOOL)isLeftHeld;
- (BOOL)isRightHeld;
- (BOOL)isUpHeld;
- (BOOL)isDownHeld;
- (BOOL)isRotateClockwiseHeld;
- (BOOL)isRotateAntiClockwiseHeld;

@end
