module dsnake.strategy.flood;

import std.math.algebraic;
import std.container.dlist;
import std.conv;
import std.array;
import std.algorithm;
import dsnake.reason;
import dsnake.constant;
import dsnake.point : Point;
import dsnake.snake : Snake;
import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.context : StrategyContext;
import dsnake.movement : Movement;
import dsnake.board : Board;
import dsnake.util : makePotentials;

/*
   Battlesnake Strategy: Flood

   This strategy aims to take up as much space as possible, via being greedy for food,
   and filling the board with its huge mass. It only takes head to heads if its the biggest snake.

 */

class Flood : Strategy
{
    private Movement makeMovementFromPoint(Point p, Board b, Point[] food, Point[] opponent_potential_moves,
            Point[] opponent_heads, Point[] opponent_tails, Point[] opponent_bodies, Snake me)
    {
        auto open = 0;
        auto food_count = 0;
        auto queue = DList!Point(p);
        auto iter = 0;
        DList!int iterc;
        bool[int][int] seen;
        while (!queue.empty())
        {
            auto point = queue.front();
            queue.removeFront();

            auto k = point.x in seen;
            if (k !is null)
            {
                bool* j;
                j = point.y in *k;
                if (j !is null)
                    continue;
            }

            seen[point.x][point.y] = true;

            if (point.x >= b.width || point.x < 0 || point.y >= b.height || point.y < 0)
            {
                continue;
            }

            if (opponent_bodies.canFind(point)
                    || opponent_heads.canFind(point) || me.body.canFind(point))
            {
                continue;
            }

            iter++;
            if (food.canFind(point))
            {
                food_count++;
                iterc.insertBack(cast(int) sqrt(cast(float) iter));
            }

            open++;

            Point[] nexts = [
                new Point(point.x + 1, point.y), new Point(point.x - 1, point.y),
                new Point(point.x, point.y + 1), new Point(point.x, point.y - 1)
            ];

            foreach (Point po; nexts)
            {
                if (po.x in seen && po.y in seen[po.x])
                    continue;
                queue.insertBack!Point(po);
            }
        }

        int delta = 2 * (open * food_count);
        return this.makeMovement("CALCULATED MOVEMENT (open: " ~ to!string(
                open) ~ ", food: " ~ to!string(food_count) ~ ")", p, me.head,
                this.DEFAULT_COST - delta);
    }

    protected override const(string) strategy()
    {
        return "Flood";
    }

    override Movement[] analyze(Board b)
    {
        auto opponents = b.snakes.filter!(s => !s.me).array;
        auto me = b.snakes.filter!(s => s.me).array[0];
        Point[][string] opponent_potential_moves_hash = makePotentials(opponents, b.height, b.width);
        Point[] opponent_bodies = reduce!((a, b) => a ~ b)(cast(Point[])[],
                opponents.map!(s => s.body[0 .. $]).array);
        Point[] opponent_tails = opponents.map!(s => s.body[$ - 1]).array;
        Point[] opponent_heads = opponents.map!(s => s.body[0]).array;
        Point[] me_potential_moves = makePotentials([me], b.height, b.width)[SNAKE_NAME];
        Point[] opponent_potential_moves;
        foreach (Point[] points; opponent_potential_moves_hash.byValue)
        {
            opponent_potential_moves ~= points;
        }
        opponent_potential_moves = opponent_potential_moves.uniq!().array;

        Movement[] movements;
        foreach (scope Point p; me_potential_moves)
        {
            if (opponent_bodies.canFind(p) || opponent_heads.canFind(p))
            {
                continue;
            }

            if (b.food.canFind(p) && !opponent_potential_moves.canFind(p))
            {
                movements ~= this.makeMovement("FOOD!", p, me.head, this.DEFAULT_COST / 10);
            }

            if (opponent_tails.canFind(p) || me.body[$ - 1] == p)
            {
                movements ~= this.makeMovement("TAIL FOLLOW!", p, me.head, this.DEFAULT_COST / 2);
            }

            movements ~= this.makeMovementFromPoint(p, b, b.food, opponent_potential_moves,
                    opponent_heads, opponent_tails, opponent_bodies, me);
        }

        return movements;
    }
}
