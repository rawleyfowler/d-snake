module dsnake.analyzer.dangeranalyzer;

import dsnake.movement : Movement;
import dsnake.analyzer.analyzer : Analyzer;
import dsnake.board : Board;
import dsnake.util : makePotentials;
import std.algorithm;

/*

   Looks ahead 5 turns, and increases the cost of a given movement
   based on the perceived future danger.

 */

class DangerAnalyzer : Analyzer
{
    this(Board b)
    {
        super(b);
    }

    override Movement analyze(Movement movement)
    {
        auto new_point = _board.me.head.move(movement.direction);
        auto will_eat = false;

        if (_board.food.canFind(new_point))
            will_eat = true;

        return movement;
    }

@safe:
@disable:
    this();
}
