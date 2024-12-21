module dsnake.strategy.strategy;

import std.typecons;
import std.array;
import std.algorithm;
import std.stdio;
import dsnake.reason;
import dsnake.direction : Direction;
import dsnake.snake : Snake;
import dsnake.point : Point;
import dsnake.movement : Movement;
import dsnake.board : Board;

abstract class Strategy
{
    protected static const int DEFAULT_COST = 100_000;

    @property protected auto directions()
    {
        return [
            0: [1: Direction.UP, -1: Direction.DOWN],
            1: [0: Direction.RIGHT],
            -1: [0: Direction.LEFT]
        ];
    }

    @safe protected Movement makeMovement(string reason, Point to, Point from, const int cost)
    {
        writeln("TO: ", to.x, " ", to.y);
        writeln("FROM: ", from.x, " ", from.y);
        int x = to.x - from.x;
        int y = to.y - from.y;
        auto dirs = directions();
        return new Movement(this.strategy(), reason, dirs[x][y], cost);
    }

    @safe protected abstract const(string) strategy();

public:
    abstract Movement[] analyze(Board b);

}
