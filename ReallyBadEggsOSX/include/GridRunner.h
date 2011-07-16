#import <Foundation/NSObject.h>

#import "Grid.h"
#import "ControllerProtocol.h"
#import "BlockBase.h"
#import "BlockFactory.h"

#define AUTO_DROP_TIME 2
#define CHAIN_SEQUENCE_GARBAGE_BONUS 6
#define GARBAGE_FACE_BOULDER_VALUE 24
#define GARBAGE_LARGE_BOULDER_VALUE 6
#define MAXIMUM_DROP_SPEED 2
#define MINIMUM_DROP_SPEED 38
#define DROP_SPEED_MULTIPLIER 4

/**
 * All possible states of the state machine.
 */
typedef enum {
	GridRunnerDropState = 0,					/**< Blocks are dropping automatically. */
	GridRunnerLiveState = 1,					/**< Live, user-controlled blocks are in play. */
	GridRunnerLandingState = 2,					/**< Blocks are running their landing animations. */
	GridRunnerExplodingState = 3,				/**< Blocks are running their exploding animations. */
	GridRunnerDeadState = 4,					/**< Game is over. */
} GridRunnerState;

/**
 * All types of game that can be played.
 */
typedef enum {
	GameTypeTwoPlayer = 0,						/**< Player vs AI. */
	GameTypeSinglePlayer = 1					/**< Single player. */
} GameType;

/**
 * Controls a grid.  Maintains a state machine that tracks what should happen
 * currently and next as the game progresses.
 */
@interface GridRunner : NSObject {
	Grid* _grid;								/**< The grid the runner controls. */
	GridRunnerState _state;						/**< The state of the state machine. */
	int _timer;									/**< Frames since the last event took place. */
	id <ControllerProtocol> _controller;		/**< Controller that feeds user input to live blocks. */
	BlockFactory* _blockFactory;				/**< Produces next blocks for the grid. */
	BlockBase* _nextBlocks[LIVE_BLOCK_COUNT];	/**< Array of 2 blocks that will be placed next. */
	int _playerNumber;							/**< Unique number of the player using this runner. */
	int _x;										/**< The x co-ordinate to render at. */

	int _score;									/**< Current score. */
	int _speed;									/**< Current speed. */
	int _chains;								/**< Number of chains exploded. */
	int _scoreMultiplier;						/**< Increases when multiple chains are exploded in one move. */

	int _accumulatingGarbageCount;				/**< Outgoing garbage blocks that accumulate during chain
													 sequences.  At the end of a sequence they are moved to the
													 _outgoinggGarbageCount member. */
	int _outgoingGarbageCount;					/**< Number of garbage blocks to send to the other player. */
	int _incomingGarbageCount;					/**< Number of garbage blocks sent from the other player. */

	GameType _gameType;							/**< The type of game being played. */

	BOOL _droppingLiveBlocks;					/**< True if live blocks are dropping automatically. */
}

@property(readonly) int outgoingGarbageCount;
@property(readonly) int incomingGarbageCount;
@property(readonly) int score;
@property(readonly) int chains;
@property(readonly) int playerNumber;
@property(readonly) Grid* grid;

/**
 * Initialise a new instance of the class.
 * @param controller A controller object that will provide input for the
 * movement of live blocks.
 * @param grid Grid to run.
 * @param blockFactory The block factory to use to produce next blocks for the
 * grid.
 * @param playerNumber The unique number of the player using this runner.
 * @param x The x co-ordinate to render at.
 * @param gameType The type of game to play.
 * @param speed The auto drop speed.
 */
- (id)initWithController:(id <ControllerProtocol>)controller
					grid:(Grid*)grid
					blockFactory:(BlockFactory*)blockFactory
					playerNumber:(int)playerNumber
					x:(int)x
					gameType:(GameType)gameType
					speed:(int)speed;

/**
 * Deallocates the object.
 */
- (void)dealloc;

/**
 * Process a single iteration of the state machine/grid logic.  This model
 * enables other code to be run between iterations of the grid (for example,
 * if two grids are running because we've got a two-player game).
 */
- (void)iterate;

/**
 * Increase the amount of incoming garbage blocks by the specified amount.
 * Garbage can only be added when the grid runner is in its "live" state.
 * @param count The number of incoming garbage blocks to increase by.
 * @return True if the garbage was added; false if not.
 */
- (BOOL)addIncomingGarbage:(int)count;

/**
 * Resets the number of outgoing garbage blocks to 0.
 */
- (void)clearOutgoingGarbageCount;

/**
 * Check if the game is over for this grid runner.
 * @return True if the game is over.
 */
- (BOOL)isDead;

/**
 * Drops blocks in the grid.  Called when the grid is in drop mode.
 */
- (void)drop;

/**
 * Lands blocks in the grid.  Called when the grid is in land mode.
 */
- (void)land;

/**
 * Process live blocks in the grid.  Called when the grid is in live mode.
 */
- (void)live;

/**
 * Check if the grid can receive garbage.  Grid can only receive garbage
 * whilst in the live state.  If garbage is received at other times it is
 * possible that the player will forever be stuck watching garbage dropping
 * down the screen.
 * @return True if the grid can receive garbage.
 */
- (BOOL)canReceiveGarbage;


@end
