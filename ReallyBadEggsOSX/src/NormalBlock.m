#import "NormalBlock.h"

@implementation NormalBlock

- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left {
	
	BOOL topSet = top != NULL && [top class] == [self class] && top.state == BlockStateNormal;
	BOOL rightSet = right != NULL && [right class] == [self class] && right.state == BlockStateNormal;
	BOOL bottomSet = bottom != NULL && [bottom class] == [self class] && bottom.state == BlockStateNormal;
	BOOL leftSet = left != NULL && [left class] == [self class] && left.state == BlockStateNormal;
	
	[self setConnectionTop:topSet right:rightSet bottom:bottomSet left:leftSet];
}

@end
