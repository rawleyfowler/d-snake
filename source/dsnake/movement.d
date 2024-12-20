module dsnake.movement;

import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.context : StrategyContext;
import dsnake.board;
import dsnake.direction;
import std.algorithm;
import std.typecons;
import std.json;

class Movement
{
    static Movement[] from(Board board)
    {
        auto strategies = new StrategyContext().strategies;

        Movement[] moves;

        foreach (Strategy s; strategies)
            moves ~= s.analyze(board);

        auto danger_analyzer = new DangerAnalyzer(board);
        return moves.map!(move => danger_analyzer.analyze(move));
    }

    @safe static Movement random()
    {
        return new Movement("random", "random", Direction.UP, 99_999);
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

    this(string strategy, string reason, Direction direction, int cost)
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
