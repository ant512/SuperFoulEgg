#import <Foundation/NSObject.h>

@interface SZPoint : NSObject {
	int _x;			/**< The x co-ordinate of the point. */
	int _y;			/**< The y co-ordinate of the point. */
}

@property(readwrite) int x;
@property(readwrite) int y;

- (id)initWithX:(int)x y:(int)y;

@end
