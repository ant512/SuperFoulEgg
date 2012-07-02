#import <Foundation/NSObject.h>

/**
 * Represents a pair of co-ordinates.
 */
@interface SZPoint : NSObject {
	int _x;			/**< The x co-ordinate of the point. */
	int _y;			/**< The y co-ordinate of the point. */
}

/**
 * The x co-ordinate.
 */
@property(readwrite) int x;

/**
 * The y co-ordinate.
 */
@property(readwrite) int y;

/**
 * Initialise a new instance of the class.
 * @param x The x co-ordinate of the point.
 * @param y The y co-ordinate of the point.
 */
- (id)initWithX:(int)x y:(int)y;

@end
