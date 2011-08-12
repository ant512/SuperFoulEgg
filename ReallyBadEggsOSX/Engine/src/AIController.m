#import <Foundation/NSArray.h>

#import "AIController.h"

@implementation AIController

- (id)initWithHesitation:(int)hesitation grid:(Grid*)grid {
	if ((self = [super init])) {
		[_grid = grid retain];
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
	
	SZPoint* point1 = [[SZPoint alloc] initWithX:0 y:0];
	SZPoint* point2 = [[SZPoint alloc] initWithX:0 y:0];
	
	for (int x = leftBoundary + 1; x < rightBoundary; ++x) {
		for (int rotation = 0; rotation < 4; ++rotation) {
			
			// Work out where the shapes will be if they move, rotation occurs
			// and they land
			switch (rotation) {
				case 0:
					point1.x = x;
					point1.y = columnYCoords[x];
					
					point2.x = x + 1;
					point2.y = columnYCoords[x + 1];
					break;
	
				case 1:
					// Although the code below allows the AI to rotate shapes
					// vertically, testing indicates that the AI is considerably
					// more effective if only horizontal rotations are
					// considered.  This is probably because horizontal
					// placements promote the accidental creation of chain
					// sequences.  The continue statement prevents the code from
					// executing.
					//
					// If planning is ever implemented, this code will be useful
					// again.
					continue;
					point1.x = x;
					point1.y = columnYCoords[x] - 1;
					
					point2.x = x;
					point2.y = columnYCoords[x];
					break;
				
				case 2:
					// If the blocks are the same colour there's no point in
					// checking this rotation
					if ([block1 class] == [block2 class]) continue;
					
					point1.x = x + 1;
					point1.y = columnYCoords[x + 1];
					
					point2.x = x;
					point2.y = columnYCoords[x];
					break;
					
				case 3:
					// Vertical rotation is disabled
					continue;
					point1.x = x;
					point1.y = columnYCoords[x];
					
					point2.x = x;
					point2.y = columnYCoords[x] - 1;
					break;
			}
			
			// Check if the new co-ords are valid
			if (point1.x < 0 || point1.x >= GRID_WIDTH) continue;
			if (point1.y < 0 || point1.y >= GRID_HEIGHT) continue;
			if (point2.x < 0 || point2.x >= GRID_WIDTH) continue;
			if (point2.y < 0 || point2.y >= GRID_HEIGHT) continue;
			
			int score = [self scoreShapePositionForBlock1:block1 block2:block2 atPoint1:point1 point2:point2];
			
			// Introduce a horrendous penalty if the block is being placed in
			// the live block entry position unless the blocks make a chain
			if ((point1.y == 0 && (point1.x == 2 || point1.x == 3)) || (point2.y == 0 && (point2.x == 2 || point2.x == 3))) {				
				if (score < 1 << 4) score = -1;
			}
			
			// Bonus for not increasing the height of the target column
			int heightBonus = 1 + ((point1.y + point2.y) / 2);
			
			score *= heightBonus;
			
			// Check if the score for this position and rotation beats the
			// current best
			if (score > bestScore) {
				bestScore = score;
				_targetX = point1.x < point2.x ? point1.x : point2.x;
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
	
	[point1 release];
	[point2 release];
}

- (int)scoreShapePositionForBlock1:(BlockBase*)block1 block2:(BlockBase*)block2 atPoint1:(SZPoint*)point1 point2:(SZPoint*)point2 {
	
	BOOL checkedData[GRID_SIZE];
	
	for (int i = 0; i < GRID_SIZE; ++i) {
		checkedData[i] = NO;
	}
	
	// Unfortunately, we can't get the score for each possible single block
	// position, then add together pairs and see what the total score would be
	// for each possible rotation (this would have the number of times we walk
	// the grid graph).  If blocks are the same colour, and we do not examine
	// the same checkedData array whilst checking for chain lengths, we may end
	// up walking over the same blocks twice.  They will therefore be included
	// in the score multiple times (once for each block and once when the scores
	// are added together).  This would lead to positions where both blocks
	// touched same colour blocks being massively overweighted and possibly
	// supplant better positions.
	int score1 = [_grid getPotentialExplodedBlockCount:point1.x y:point1.y block:block1 checkedData:checkedData];
	int score2 = [_grid getPotentialExplodedBlockCount:point2.x y:point2.y block:block2 checkedData:checkedData];
	
	int score = 0;
	
	if (([block1 class] == [block2 class]) && ((point1.x == point2.x) || (point1.y == point2.y))) {

		// Blocks are the same colour, so we can connect the two chains together
		score = 1 << (score1 + score2);
	} else {
		score = 1 << score1;
		score += 1 << score2;
	}
	
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
