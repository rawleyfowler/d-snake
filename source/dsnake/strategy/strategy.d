module dsnake.strategy.strategy;

import std.typecons;
import std.array;
import std.algorithm;
import dsnake.direction : Direction;
import dsnake.snake : Snake;
import dsnake.point : Point;
import dsnake.movement : Movement;
import dsnake.board : Board;

abstract class Strategy
{
    protected static uint DEFAULT_COST = 10_000;
    protected auto DIRECTIONS = [
        0: [1: Direction.UP, -1: Direction.DOWN], 1: [0: Direction.RIGHT],
        1: [0: Direction.LEFT]
    ];

@safe:
    protected Point[][string] makePotentials(immutable Snake[] snakes,
            scope int height, scope int width) immutable @trusted
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

    protected immutable(Movement) makeMovement(const string reason, Point to,
            immutable(Point) from, const uint cost)
    {
        int x = to.x - from.x;
        int y = to.y - from.y;
        return new immutable Movement(this.strategy(), reason, DIRECTIONS[x][y], cost);
    }

    protected abstract const(string) strategy();

public:
    abstract Movement[] analyze(Board b);
}
