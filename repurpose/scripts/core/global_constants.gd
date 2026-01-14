extends Node

## tile size of map in px
const TILE_SIZE = 16
## tile size in world units
const TILE_SIZE_WORLD = 0.25
## speed at which nav agents move
const NAV_SPEED = 50.0
const DELTA = 0.0167

# stats etc
enum ResourceType { MP, HP, GOLD, }
enum MapRoomType { PRESENT, EMPTY }

# VIZ
const MOVE_TWEEN_DURATION = 0.15
