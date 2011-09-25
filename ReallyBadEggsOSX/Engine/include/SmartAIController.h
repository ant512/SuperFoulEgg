#import <Foundation/NSObject.h>

#import "ControllerProtocol.h"
#import "Grid.h"
#import "BlockBase.h"
#import "SZPoint.h"

/**
 * Artificial intelligence controller.  Analyses the state of the grid it is
 * controlling in order to determine what action to take next.
 */
@interface SmartAIController : NSObject <ControllerProtocol> {
	Grid* _grid;				/**< The Grid that the AI is controlling. */
	int _lastLiveBlockY;		/**< The last observed y co-ordinate of the first live block. */
	int _targetX;				/**< The x co-ordinate the AI is trying to move the live block to. */
	int _targetRotations;		/**< Number of clockwise rotations needed before correct live block
									 orientation is achieved. */
	int _hesitation;			/**< Chance that the AI will hesitate (larger value = more likely;
									 0 = no hesitation). */
}

/**
 * Initialises a new instance of the class.
 * @param hesitation The chance of the AI hesitating when given the option to
 * make a move.  A high value makes the AI being slower.  A low value makes the
 * AI faster.
 * @param grid The grid that the AI will control.
 */
- (id)initWithHesitation:(int)hesitation grid:(Grid*)grid;

/**
 * Deallocates the instance.
 */
- (void)dealloc;

/**
 * Analyses the state of the grid and determines what action to take.  Called
 * every time the AI has the opportunity to move, but the grid is only analysed
 * when a new pair of blocks has been added to the grid.  The analysis is very
 * simple.  For every possible end position for this pair (every location and
 * rotation that the pair can end up in when they land), score the position.
 * Score is simply the number of blocks that connect to the landed live block.
 * Choose the best position and remember the rotation/location.  Whenever the
 * opportunity to move is given, move towards the desired position.
 */
- (void)analyseGrid;

/**
 * Determines the total number of connections between blocks created by placing
 * the two blocks at the specified co-ordinates.
 * @param block1 The first block to score.
 * @param block2 The second block to score.
 * @param point1 The location of the first block.
 * @param point2 The location of the second block.
 * @return The total number of connections.
 */
- (int)scoreShapeX:(int)x rotation:(int)rotation;


/**
 * Is left held?
 */
- (BOOL)isLeftHeld;

/**
 * Is right held?
 */
- (BOOL)isRightHeld;

/**
 * Is up held?
 */
- (BOOL)isUpHeld;

/**
 * Is down held?
 */
- (BOOL)isDownHeld;

/**
 * Is the rotate clockwise button held?
 */
- (BOOL)isRotateClockwiseHeld;

/**
 * Is the rotate anticlockwise button held?
 */
- (BOOL)isRotateAntiClockwiseHeld;

@end
