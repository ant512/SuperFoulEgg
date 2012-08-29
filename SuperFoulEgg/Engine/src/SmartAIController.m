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
	
	int bestScore = INT_MIN;
	
	int *scores = malloc(sizeof(int) * GRID_WIDTH * 4);
	
	// We can multithread the AI so that it can analyse GRID_WIDTH * 4 grids
	// simultaneously.
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	dispatch_apply(GRID_WIDTH * 4, queue, ^(size_t i) {
		int x = i / 4;
		int rotation = i % 4;
			
		// Skip rotations 2 and 3 if blocks are the same colour, as they
		// are identical to rotations 0 and 1
		if ([block1 isKindOfClass:[block2 class]] && rotation > 1) return;
		
		// Compensate for the fact that horizontal rotations can lead to us
		// checking illegal co-ordinates
		if (rotation == 0 && x >= GRID_WIDTH - 1) {
			scores[i] = INT_MIN;
			return;
		} else if (rotation == 2 && x >= GRID_WIDTH - 1) {
			scores[i] = INT_MIN;
			return;
		}
		
		scores[i] = [self scoreShapeX:x rotation:rotation];
	});
	
	for (int i = 0; i < GRID_WIDTH * 4; ++i) {

		int x = i / 4;
		int rotation = i % 4;
		
		// Check if the score for this position and rotation beats the
		// current best
		if (scores[i] > bestScore) {
			
			bestScore = scores[i];
			_targetX = x;
			_targetRotations = rotation;
		}
	}
	
	NSLog(@"%d %d", _targetX, _targetRotations);
	
	free(scores);
		
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
			
			// Give up if the block won't move
			if (![gridCopy moveLiveBlocksLeft]) {
				[gridCopy release];
				return 0;
			}
		}
	} else if ([gridCopy liveBlock:0].x < x) {
		while ([gridCopy liveBlock:0].x < x) {
			
			// Give up if the block won't move
			if (![gridCopy moveLiveBlocksRight]) {
				[gridCopy release];
				return 0;
			}
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
			score += exploded << iteration;
			
			// Ensure a possible explosion is always favoured by setting the top
			// bit (not the sign bit)
			score = score | (1 << 30);
		} else {
			score += [gridCopy score] * iteration;
		}
		
		++iteration;
	} while (exploded > 0);
	
	// If the grid entry point is blocked, this move must have the lowest
	// priority possible
	if ([gridCopy blockAtX:2 y:0] != nil || [gridCopy blockAtX:3 y:0] != nil) {
		score = INT_MIN;
	}
	
	[gridCopy release];
	
	return score;
}

- (BOOL)isLeftHeld {
	[self analyseGrid];
	
	// We rotate before we move.  This can produce a situation at the top of the
	// grid wherein the AI rotates a block and then can't move the rotated shape
	// to its chosen destination because another block is in the way.  It
	// shouldn't really get into this situation because the moves are all
	// simulated, but it seems to do so anyway.  The AI will just bash the shape
	// up against the blocking area until it hits the bottom.  At this point in
	// a game it's probably a good thing that the AI can't recover or the hard
	// AI would be unbeatable.  I'm not going to fix the issue.
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
