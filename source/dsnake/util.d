module dsnake.util;

import std.algorithm;
import std.array;
import dsnake.point : Point;
import dsnake.snake : Snake;

Point[][string] makePotentials(Snake[] snakes, scope int height, scope int width)
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
