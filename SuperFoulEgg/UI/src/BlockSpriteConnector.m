#import "BlockSpriteConnector.h"

@implementation BlockSpriteConnector

@synthesize block = _block;
@synthesize sprite = _sprite;
@synthesize isDead = _isDead;
@synthesize gridX = _gridX;
@synthesize gridY = _gridY;

- (void)kill {
	[_sprite.parent removeChild:_sprite cleanup:YES];
	
	[_sprite release];
	[_block release];
	
	_sprite = nil;
	_block = nil;
	
	_isDead = YES;
}

- (void)resetTimer {
	_timer = 0;
}

- (void)resetYOffset {
	_yOffset = 0;
}

- (id)initWithBlock:(BlockBase*)block sprite:(CCSprite*)sprite gridX:(int)gridX gridY:(int)gridY {
	if ((self = [super init])) {
		_block = [block retain];
		_sprite = [sprite retain];
		_isDead = NO;
		_timer = 0;
		_yOffset = 0;
		_gridX = gridX;
		_gridY = gridY;

		[self updateSpritePosition];
		[self setSpriteFrame:0];
		
		__block BlockSpriteConnector* connector = self;

		_block.onConnect = ^(BlockBase* block) {
			[connector setSpriteFrame:block.connections];
		};

		_block.onMove = ^(BlockBase* block) {
			[connector updateSpritePosition];
		};

		_block.onStopExploding = ^(BlockBase* block) {
			[connector kill];
		};

		_block.onStartExploding = ^(BlockBase* block) {
			[connector resetTimer];
		};

		_block.onStartLanding = ^(BlockBase* block) {
			[connector resetTimer];
			
			[connector setSpriteFrame:BLOCK_LAND_START_FRAME];
		};

		_block.onStopLanding = ^(BlockBase* block) {
			// Don't care about this
		};

		_block.onStartFalling = ^(BlockBase* block) {

			// Prevent blocks in the grid from being displaced if their garbage
			// hit bounce is interrupted
			[connector resetYOffset];
			
			[connector setSpriteFrame:block.connections];
		};
	}
	
	return self;
}

- (void)dealloc {
	[_sprite removeFromParentAndCleanup:YES];
	[_sprite release];
	[_block release];
	[super dealloc];
}

- (void)updateSpritePosition {

	// Co-ords are adjusted so that the sprite is relative to the containing
	// grid
	int x = _gridX + (_block.x * BLOCK_SIZE) + (BLOCK_SIZE / 2);
	int y = _gridY + (GRID_HEIGHT * BLOCK_SIZE) - (BLOCK_SIZE / 2) - ((_block.y * BLOCK_SIZE) + _yOffset);

	// Add an extra half block's height if the block has fallen a half block
	y -= _block.hasDroppedHalfBlock ? BLOCK_SIZE / 2 : 0;

	_sprite.position = ccp(x, y);
}

- (void)setSpriteFrame:(int)frame {
	[_sprite setTextureRect:CGRectMake((frame % 5) * BLOCK_SIZE, (frame / 5) * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)];
	_frame = frame;
}

- (void)update {

	switch (_block.state) {
		case BlockExplodingState:

			// The block is exploding.  We run through the frames of explosion
			// animation each time this method is called until we run out of
			// frames, whereupon we tell the block that it has finished
			// exploding.  The block's explosion stopped event will fire and
			// this object and its components will eventually be deallocated

			if (_timer % BLOCK_ANIMATION_SPEED == 0) {
				
				if (_frame < BLOCK_EXPLODE_START_FRAME || _frame >= BLOCK_EXPLODE_START_FRAME + BLOCK_EXPLODE_FRAME_COUNT) {
					[self setSpriteFrame:BLOCK_EXPLODE_START_FRAME];
				} else if (_frame == BLOCK_EXPLODE_START_FRAME + BLOCK_EXPLODE_FRAME_COUNT - 1) {

					// Reached the end of the explosion frames
					[_block stopExploding];
				} else {

					// Move to the next explosion frame
					[self setSpriteFrame:_frame + 1];
				}
			}
			
			++_timer;
			
			break;

		case BlockLandingState:

			// The block is landing.  We run through the animation until we run
			// out of frames.  At that point, the block is told that it is no
			// longer landing.

			if (_timer == BLOCK_LAND_FRAME_COUNT * BLOCK_ANIMATION_SPEED) {

				// Reached the end of the landing animation, so tell the block
				// it has finished landing
				[_block stopLanding];
			} else if (_timer % BLOCK_ANIMATION_SPEED == 0) {

				// List of landing animation frames
				static int landingSequence[BLOCK_LAND_FRAME_COUNT] = { 0, 22, 23, 22, 23, 22, 0 };

				// Move to the frame appropriate to the current timer
				[self setSpriteFrame:landingSequence[_timer / BLOCK_ANIMATION_SPEED]];
			}
			
			++_timer;
			
			break;
		
		case BlockRecoveringFromGarbageHitState:

			// Block has been hit by a garbage block from above and is being
			// eased back to its correct position.
			
			if (_timer % 2 == 0) {
				
				if (_timer < 12) {
				
					static int offsets[6] = { 6, 3, 0, 3, 1, 0 };
					
					_yOffset = offsets[_timer / 2];
				} else {
					[_block stopRecoveringFromGarbageHit];
				}
			
				[self updateSpritePosition];
			}
			
			++_timer;

			break;

		default:

			// Block isn't doing anything interesting
			break;
	}
}

- (void)hitWithGarbage {
	if (_block.state != BlockNormalState && _block.state != BlockLandingState && _block.state != BlockRecoveringFromGarbageHitState) return;
	
	_timer = 0;

	[_block startRecoveringFromGarbageHit];
}

@end
