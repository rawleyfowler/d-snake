module dsnake.strategy.hungry;

import std.math;
import std.typecons;
import std.algorithm;
import std.array;
import std.container;
import std.stdio;
import dsnake.priority_queue;
import dsnake.constant;
import dsnake.reason;
import dsnake.point : Point;
import dsnake.util : makePotentials;
import dsnake.constant;
import dsnake.snake : Snake;
import dsnake.movement : Movement;
import dsnake.board : Board;
import dsnake.strategy.strategy : Strategy;

class Hungry : Strategy
{

    double heuristic(Point a, Point b)
    {
        return sqrt(cast(float)((a.x - b.x) ^^ 2 + (a.y - b.y) ^^ 2));
    }

    private bool valid(scope Point p, scope uint height, scope uint width, scope Point[] obstacles)
    {
        if (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height || obstacles.canFind(p))
            return false;
        return true;
    }

    private Movement findClosestFood(Board b, Point[] obstacles, Point start)
    {
        PriorityQueue!(double, Point) pq;
        pq.insert(0.0, start);

        Point[Point] came_from;
        bool[Point] seen;
        double[Point] g_score;
        double[Point] f_score;

        ulong t = ulong.max;
        Point closest_food;
        seen[start] = true;
        g_score[start] = 0.0;

        foreach (Point p; b.food)
        {
            auto l = abs(p.x - start.x) + abs(p.y - start.y);
            if (l < t)
            {
                t = l;
                closest_food = p;
            }
        }

        f_score[start] = heuristic(start, closest_food);

        if (closest_food is null)
            return null;

        while (!pq.empty)
        {
            auto curr = pq.front[1];
            pq.popFront();

            if (curr == closest_food)
            {
                Point[] path;
                auto tmp = curr;
                while (came_from.get(tmp, null) !is null)
                {
                    path ~= tmp;
                    tmp = came_from[tmp];
                }

                return makeMovement("FOOD", path[$ - 1], start, cast(int) path.length);
            }

            foreach (Point neighbour; getNeighbours(curr))
            {
                if (!valid(neighbour, b.height, b.width, obstacles))
                    continue;

                // 1.0 is base "cost"
                auto tg = g_score[curr] + 1.0;

                if (tg < g_score.get(neighbour, double.infinity))
                {
                    came_from[neighbour] = curr;
                    g_score[neighbour] = tg;
                    f_score[neighbour] = g_score[neighbour] + heuristic(neighbour, closest_food);

                    if (!seen.get(neighbour, false))
                    {
                        pq.insert(f_score[neighbour], neighbour);
                    }
                }
            }
        }

        return null;
    }

    override const(string) strategy()
    {
        return "hungry";
    }

    override Movement[] analyze(Board b)
    {
        auto potentials = makePotentials([b.me], b.height, b.width)[SNAKE_NAME];
        auto obstacles = reduce!((a, b) => a ~ b)(cast(Point[])[],
                b.snakes.map!(s => s.body[1 .. $]).array);

        foreach (Point[] ps; makePotentials(b.snakes.filter!(s => !s.me
                && s.health > b.me.health).array, b.height, b.width).byValue())
            obstacles ~= ps;

        Movement[] movements;
        foreach (Point potential; potentials)
        {
            scope auto m = findClosestFood(b, obstacles, b.me.head);
            if (m is null)
                continue;
            movements ~= m;
        }

        return movements;
    }

private:
    Point[] getNeighbours(Point p)
    {
        return [
            new Point(p.x + 1, p.y), new Point(p.x - 1, p.y),
            new Point(p.x, p.y + 1), new Point(p.x, p.y - 1)
        ];
    }
}
