#import <Foundation/NSObject.h>

#import "BlockBase.h"

#define GRID_WIDTH 6
#define GRID_HEIGHT 13
#define GRID_SIZE 78

/**
 * Maintains the list of blocks that make up the playing grid.
 */
@interface GridBase : NSObject {
@private
	BlockBase* _data[GRID_SIZE];	/**< The array of blocks that constitutes the grid. */
}

- (id)init;
- (void)dealloc;

- (void)clear;
- (BlockBase*)blockAtX:(int)x y:(int)y;
- (void)addBlock:(BlockBase*)block x:(int)x y:(int)y;
- (void)removeBlockAtX:(int)x y:(int)y;
- (int)heightOfColumnAtIndex:(int)index;
- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY;
- (BOOL)isValidCoordinateX:(int)x y:(int)y;

@end
