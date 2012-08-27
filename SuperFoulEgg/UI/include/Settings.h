#import <Foundation/Foundation.h>

#define DEFAULT_KEY_CODE_ONE_LEFT 2
#define DEFAULT_KEY_CODE_ONE_RIGHT 5
#define DEFAULT_KEY_CODE_ONE_UP 15
#define DEFAULT_KEY_CODE_ONE_DOWN 3
#define DEFAULT_KEY_CODE_ONE_A 1
#define DEFAULT_KEY_CODE_ONE_B 0
#define DEFAULT_KEY_CODE_ONE_START 49

#define DEFAULT_KEY_CODE_TWO_LEFT 123
#define DEFAULT_KEY_CODE_TWO_RIGHT 124
#define DEFAULT_KEY_CODE_TWO_UP 126
#define DEFAULT_KEY_CODE_TWO_DOWN 125
#define DEFAULT_KEY_CODE_TWO_A 47
#define DEFAULT_KEY_CODE_TWO_B 43
#define DEFAULT_KEY_CODE_TWO_START 36

#define DEFAULT_KEY_CODE_QUIT 53

typedef enum {
	AIInsaneType = 0,
	AIHardType = 2,
	AIMediumType = 3,
	AIEasyType = 6
} AIType;

typedef enum {
	GamePracticeType = 0,
	GameSinglePlayerType = 1,
	GameTwoPlayerType = 2,
} GameType;

@interface Settings : NSObject {
	AIType _aiType;
	GameType _gameType;
	int _height;
	int _speed;
	int _gamesPerMatch;
	int _blockColours;
	
	unsigned short _keyCodeOneLeft;
	unsigned short _keyCodeOneRight;
	unsigned short _keyCodeOneUp;
	unsigned short _keyCodeOneDown;
	unsigned short _keyCodeOneA;
	unsigned short _keyCodeOneB;
	unsigned short _keyCodeOneStart;
	
	unsigned short _keyCodeTwoLeft;
	unsigned short _keyCodeTwoRight;
	unsigned short _keyCodeTwoUp;
	unsigned short _keyCodeTwoDown;
	unsigned short _keyCodeTwoA;
	unsigned short _keyCodeTwoB;
	unsigned short _keyCodeTwoStart;
	
	unsigned short _keyCodeQuit;
}

@property(readwrite) AIType aiType;
@property(readwrite) GameType gameType;
@property(readwrite) int height;
@property(readwrite) int speed;
@property(readwrite) int gamesPerMatch;
@property(readwrite) int blockColours;

@property(readwrite) unsigned short keyCodeOneLeft;
@property(readwrite) unsigned short keyCodeOneRight;
@property(readwrite) unsigned short keyCodeOneUp;
@property(readwrite) unsigned short keyCodeOneDown;
@property(readwrite) unsigned short keyCodeOneA;
@property(readwrite) unsigned short keyCodeOneB;
@property(readwrite) unsigned short keyCodeOneStart;

@property(readwrite) unsigned short keyCodeTwoLeft;
@property(readwrite) unsigned short keyCodeTwoRight;
@property(readwrite) unsigned short keyCodeTwoUp;
@property(readwrite) unsigned short keyCodeTwoDown;
@property(readwrite) unsigned short keyCodeTwoA;
@property(readwrite) unsigned short keyCodeTwoB;
@property(readwrite) unsigned short keyCodeTwoStart;

@property(readwrite) unsigned short keyCodeQuit;

+ (Settings*)sharedSettings;
- (id)init;

@end
