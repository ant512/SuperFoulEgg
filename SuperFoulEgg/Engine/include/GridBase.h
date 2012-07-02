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

/**
 * Initialises a new instance of the class.
 */
- (id)init;

/**
 * Deallocates the instance of the class.
 */
- (void)dealloc;

/**
 * Clears the grid of all blocks.
 */
- (void)clear;

/**
 * Gets the block at the specified co-ordinates.
 * @param x The x co-ordinate of the block to retrieve.
 * @param y The y co-ordinate of the block to retrieve.
 */
- (BlockBase*)blockAtX:(int)x y:(int)y;

/**
 * Add a block to the grid.  The grid assumes ownership of the block.
 * @param x The x co-ordinate of the block.
 * @param y The y co-ordinate of the block.
 */
- (void)addBlock:(BlockBase*)block x:(int)x y:(int)y;

/**
 * Removes and deallocates the block at the specified co-ordinates.
 * @param x The x co-ordinate of the block to remove.
 * @param y The y co-ordinate of the block to remove.
 */
- (void)removeBlockAtX:(int)x y:(int)y;

/**
 * Gets the height of the specified column.
 * @param index The column index.
 * @return The height of the column.
 */
- (int)heightOfColumnAtIndex:(int)index;

/**
 * Moves the block at the specified source co-ordinates to the destination
 * co-ordinates.
 * @param sourceX The source x co-ordinate.
 * @param sourceY The source y co-ordinate.
 * @param destinationX The destination x co-ordinate.
 * @param destinationY The destination y co-ordinate.
 */
- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY;

/**
 * Checks if the specified co-ordinates fall inside the grid.
 * @param x The x co-ordinate to check.
 * @param y The y co-ordinate to check.
 * @return True if the co-ordinates are valid; false if not.
 */
- (BOOL)isValidCoordinateX:(int)x y:(int)y;

@end
