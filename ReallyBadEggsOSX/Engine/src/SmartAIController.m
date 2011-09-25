#import <Foundation/NSArray.h>

#import "SmartAIController.h"

@implementation SmartAIController

- (id)initWithHesitation:(int)hesitation grid:(Grid*)grid {
	if ((self = [super init])) {
		_grid = [grid retain];
		_lastLiveBlockY = GRID_HEIGHT;
		_targetX = 0;
		_targetRotations = 0;
		_hesitation = hesitation;
	}
	
	return self;
}

- (void)dealloc {
	[_grid release];
	[super dealloc];
}

- (void)analyseGrid {
	
	BlockBase* block1 = [_grid liveBlock:0];
	BlockBase* block2 = [_grid liveBlock:1];
	
	// If last observed y is greater than current live block y, we'll need
	// to choose a new move
	if (_lastLiveBlockY <= block1.y) {
		_lastLiveBlockY = block1.y < block2.y ? block1.y : block2.y;

		return;
	}
	
	_lastLiveBlockY = block1.y < block2.y ? block1.y : block2.y;
	
	// Get the y co-ords of the topmost blank block in each column
	int columnYCoords[GRID_WIDTH];
	
	for (int i = 0; i < GRID_WIDTH; ++i) {
		columnYCoords[i] = (GRID_HEIGHT - [_grid heightOfColumnAtIndex:i]) - 1;
	}
	
	// Work out which columns have heights equal to or greater than the current
	// live block Y co-ordinates and constrain the search to within the
	// boundaries that they create
	int leftBoundary = -1;
	int rightBoundary = GRID_WIDTH;
	int lowestYCoord = block1.y > block2.y ? block1.y : block2.y;
	int leftBlockXCoord = block1.x < block2.x ? block1.x : block2.x;
	int rightBlockXCoord = block1.x > block2.x ? block1.x : block2.x;
	
	for (int i = leftBlockXCoord; i >= 0; --i) {
		
		if (i == block1.x) continue;
		if (i == block2.x) continue;
		
		if (columnYCoords[i] <= lowestYCoord) {
			leftBoundary = i;
			break;
		}
	}
	
	for (int i = rightBlockXCoord; i < GRID_WIDTH; ++i) {
		
		if (i == block1.x) continue;
		if (i == block2.x) continue;
		
		if (columnYCoords[i] <= lowestYCoord) {
			rightBoundary = i;
			break;
		}
	}	
	
	int bestScore = 0;
	
	for (int x = leftBoundary + 1; x < rightBoundary; ++x) {
		for (int rotation = 0; rotation < 4; ++rotation) {
			
			int blockX = x;
			
			// Compensate for the fact that horizontal rotations can lead to us
			// checking illegal co-ordinates
			if (rotation == 0 && blockX >= rightBoundary - 1) {
				continue;
			} else if (rotation == 2 && blockX >= rightBoundary - 1) {
				continue;
			}
			
			int score = [self scoreShapeX:blockX rotation:rotation];
			
			// Check if the score for this position and rotation beats the
			// current best
			if (score > bestScore) {
				bestScore = score;
				_targetX = blockX;
				_targetRotations = rotation;
			}
		}
	}
	
	// We need to determine if the shape has already been rotated and adjust
	// accordingly
	if (block1.x == block2.x) {
		if (block1.y == block2.y - 1) {
			
			// Block 1 is above block 2, therefore exising rotation is 1
			--_targetRotations;
		} else {
			
			// Block 1 is below block 2, therefore existing rotation is 3
			_targetRotations -= 3;
		}
	} else if (block1.x == block2.x + 1) {
		
		// Block 1 is on the right of block 2, therefore existing rotation is 2
		_targetRotations -= 2;
	}
	
	// We can rotate to the correct orientation faster by rotating anticlockwise
	// if necessary
	if (_targetRotations == 3) _targetRotations = -1;
}

- (int)scoreShapeX:(int)x rotation:(int)rotation {

	int score = 0;
	int exploded = 0;
	int iteration = 1;
	
	Grid* gridCopy = [_grid copy];
	
	while (rotation > 0) {
		[gridCopy rotateLiveBlocksClockwise];
		--rotation;
	}
	
	if ([gridCopy liveBlock:0].x > x) {
		while ([gridCopy liveBlock:0].x > x) {
			[gridCopy moveLiveBlocksLeft];
		}
	} else if ([gridCopy liveBlock:0].x < x) {
		while ([gridCopy liveBlock:0].x < x) {
			[gridCopy moveLiveBlocksRight];
		}
	}
	
	while (gridCopy.hasLiveBlocks) [gridCopy dropLiveBlocks];
	
	do {
		while ([gridCopy dropBlocks]);
		while ([gridCopy iterate]);
	
		[gridCopy connectBlocks];
	
		exploded = [gridCopy explodeBlocks];
		while ([gridCopy iterate]);
		
		if (exploded > 0) {
			
			//score += exploded << (6 + (iteration * 3));
			score += exploded << iteration;
			
			// Ensure a possible explosion is always favoured by setting the top
			// bit (not the sign bit)
			score = score | (1 << 30);
		} else {
			score += [gridCopy score] * iteration;
		}
		
		++iteration;
	} while (exploded > 0);
	
	[gridCopy release];
	
	return score;
}

- (BOOL)isLeftHeld {
	[self analyseGrid];
	
	if (_targetRotations != 0) return NO;
	
	BlockBase* block1 = [_grid liveBlock:0];
	
	BOOL result = block1.x > _targetX;
	
	return _hesitation == 0 ? result : result && (rand() % _hesitation == 0);
}

- (BOOL)isRightHeld {
	[self analyseGrid];
	
	if (_targetRotations != 0) return NO;
	
	BlockBase* block1 = [_grid liveBlock:0];
	
	BOOL result = block1.x < _targetX;
	
	return _hesitation == 0 ? result : result && (rand() % _hesitation == 0);
}

- (BOOL)isUpHeld {
	return NO;
}

- (BOOL)isDownHeld {
	[self analyseGrid];
	
	if (_targetRotations != 0) return NO;
	
	BlockBase* block1 = [_grid liveBlock:0];
	
	BOOL result = block1.x == _targetX;
	
	return _hesitation == 0 ? result : result && (rand() % _hesitation == 0);
}

- (BOOL)isRotateClockwiseHeld {
	[self analyseGrid];
	
	if (_targetRotations > 0) {
		--_targetRotations;
		
		return YES;
	}
	
	return NO;
}

- (BOOL)isRotateAntiClockwiseHeld {
	[self analyseGrid];
	
	if (_targetRotations < 0) {
		++_targetRotations;
		
		return YES;
	}
	
	return NO;
}

@end
