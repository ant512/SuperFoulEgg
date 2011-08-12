#import <Foundation/NSObject.h>

#import "BlockBase.h"

/**
 * Maintains the list of blocks that make up the playing grid.
 */
@interface Grid : NSObject {
@private
	BlockBase* _data[GRID_SIZE];	/**< The array of blocks that constitutes the grid. */
	int _width;						/**< The width of the grid. */
	int _height;					/**< The height of the grid. */
}

@property(readonly) int width;
@property(readonly) int height;

- (id)initWithWidth:(int)width height:(int)height;
- (void)dealloc;

- (void)clear;
- (BlockBase*)blockAtX:(int)x y:(int)y;
- (BOOL)addBlock:(BlockBase*)block x:(int)x y:(int)y;
- (int)heightOfColumnAtIndex:(int)column;
- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY;
- (BOOL)isValidCoordinateX:(int)x y:(int)y;

@end
