#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

#import "BlockBase.h"
#import "Grid.h"

/**
 * Each time a new set of blocks is added to a grid, the grid asks an instance
 * of this class for the blocks.  All grids must share the same BlockFactory
 * instance.
 *
 * This class maintains a blocks and the position in the list of each player.
 * Thus, player 1 could request a block.  If no blocks exist in the list a
 * random block is added.  When player 2 requests a block he will receive the
 * block previously given to player 1.  If there are no more players in the list
 * then that block is forgotten.  If there are more players, the block is
 * retained in the list until all players have used it.  If player 1 requests 10
 * blocks whilst player 2 is working on his first block, the 9 blocks between
 * the two players are retained until both players have used them.  This ensures
 * that all players are given the same set of blocks in the same order.
 */
@interface BlockFactory : NSObject {
@private
	NSMutableArray* _blockList;		/**< List of block classes that haven't been used by all players yet. */
	int* _playerBlockListIndices;	/**< Each item in the array represents the index within
										 _blockList that each player is currently using. */
	int _blockColourCount;			/**< Number of colours that the factory can produce. */
	int _playerCount;				/**< Number of players in the game. */
}

/**
 * Initialise a new BlockFactory object.
 * @param playerCount The number of players in the game.
 * @param blockColourCount The number of block colours available.
 * @return A newly initialised object.
 */
- (id)initWithPlayerCount:(int)playerCount blockColourCount:(int)blockColourCount;

/**
 * Deallocates the object.
 */
- (void)dealloc;

/**
 * Clears all data in the BlockFactory.
 */
- (void)clear;

/**
 * Creates and returns the next block for the specified grid.
 * @param grid The grid that will contain the block.
 * @return The next block.
 */
- (BlockBase*)newBlockForGrid:(Grid*)grid;

/**
 * Adds a random block class to the block list.
 */
- (void)addRandomBlockClass;

/**
 * Removes all block classes from the block list that have been used by all
 * players.
 */
- (void)expireUsedBlockClasses;

/**
 * Returns a block class at random.
 * @return A random block class.
 */
- (Class)randomBlockClass;

@end
