uint16 constant SHOOT_DAMAGE = 1;
uint16 constant PUNCH_DAMAGE = 2;
uint16 constant BLAST_DAMAGE = 3;

//uint16 constant SHOOT_RADIUS = 3;
uint16 constant BLAST_RADIUS = 3;

// CHARGING_TIME must be a multiple of DISCHARGE_SPEED
uint8 constant CHARGING_TIME = 2;
uint8 constant DISCHARGE_SPEED = 1;

uint8 constant MAP_HEIGHT = 50;
uint8 constant MAP_WIDTH = 50;

//uint16 constant MOVE_DISTANCE = 1;
uint16 constant DASH_DISTANCE = 3;
uint8 constant DASH_COOLDOWN = 7;

uint16 constant MIN_BOTS = 4;
uint16 constant MAX_BOTS = 255;

//uint16 constant INITIAL_HEALTH = 10;
uint16 constant INITIAL_AMMO = 20;
uint16 constant INITIAL_ROCKETS = 3;

uint16 constant MAX_ROUND = 5000;

// Overrides for a fast game
uint16 constant INITIAL_HEALTH = 1;
uint16 constant SHOOT_RADIUS = 6;
uint16 constant MOVE_DISTANCE = 3;