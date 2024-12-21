module dsnake.movement;

import dsnake.analyzer.dangeranalyzer : DangerAnalyzer;
import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.context : StrategyContext;
import dsnake.board;
import dsnake.direction;
import dsnake.reason;
import std.array;
import std.algorithm;
import std.typecons;
import std.json;

class Movement
{
    static Movement[] from(ref Board board)
    {
        auto context = new StrategyContext();

        Movement[] moves;
        if (board.me.health < 75 || board.me.length < 6)
        {
            moves ~= context.hungry().analyze(board);
        }
        else
        {
            moves ~= context.flood().analyze(board);
        }

        // If there is only one valid move there is no need to do analysis.
        if (moves.length == 1)
            return moves;

        auto danger_analyzer = new DangerAnalyzer(board);
        return moves.map!(move => danger_analyzer.analyze(move)).array;
    }

    @safe static Movement random()
    {
        return new Movement("random", Reason.RANDOM, Direction.UP, int.max);
    }

    private
    {
        string _strategy;
        string _reason;
        Direction _direction;
        int _cost;
    }

@safe:

public:

    this(const(string) strategy, const(string) reason, Direction direction, const(int) cost)
    {
        _strategy = strategy;
        _reason = reason;
        _direction = direction;
        _cost = cost;
    }

    JSONValue json()
    {
        return JSONValue([
            "direction": JSONValue(_direction),
            "cost": JSONValue(_cost),
            "reason": JSONValue(_reason),
            "strategy": JSONValue(_strategy)
        ]);
    }

    @disable this();

@property:
    string strategy()
    {
        return _strategy;
    }

    string reason()
    {
        return _reason;
    }

    Direction direction()
    {
        return _direction;
    }

    int cost()
    {
        return _cost;
    }

}
