module dsnake.strategy.strategy;

import std.typecons;
import std.array;
import std.algorithm;
import std.stdio;
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

    protected Point[][string] makePotentials(Snake[] snakes, scope int height, scope int width)
    {
        auto usable_height = height - 1;
        auto usable_width = width - 1;

        Point[][string] potentials;

        foreach (Snake s; snakes)
        {
            auto head = s.head;
            auto neck = s.body[1];
            auto nexts = [
                new Point(head.x + 1, head.y), new Point(head.x - 1, head.y),
                new Point(head.x, head.y + 1), new Point(head.x, head.y - 1)
            ].filter!(p => p != neck)
                .filter!(p => p.x >= 0 && p.x <= usable_width)
                .filter!(p => p.y >= 0 && p.y <= usable_height)
                .array;
            potentials[s.name] = nexts;
        }

        return potentials;
    }

    @safe protected Movement makeMovement(const string reason, Point to, Point from, const int cost)
    {
        int x = to.x - from.x;
        int y = to.y - from.y;
        auto dirs = directions();
        return new Movement(this.strategy(), reason, dirs[x][y], cost);
    }

    @safe protected abstract const(string) strategy();

public:
    abstract Movement[] analyze(Board b);

}
