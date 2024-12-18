module dsnake.movement;

import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.context : StrategyContext;
import dsnake.entity : Entity;
import dsnake.board;
import dsnake.direction;
import std.typecons;
import std.json;

class Movement : Entity
{
@safe:

    static Movement[] from(Board board)
    {
        static auto strategies = StrategyContext.strategies();

        Movement[] moves;

        foreach (Strategy s; strategies)
            moves ~= s.analyze(board);

        return moves;
    }

    private
    {
        string _strategy;
        string _reason;
        Direction _direction;
        uint _cost;
    }

public:

    this(string strategy, string reason, Direction direction, uint cost) immutable
    {
        _strategy = strategy;
        _reason = reason;
        _direction = direction;
        _cost = cost;
    }

    override JSONValue json()
    {
        auto reason = _reason == "" ? "UNKNOWN" : _reason;
        return JSONValue([
            "direction": JSONValue(this.direction),
            "cost": JSONValue(this.cost),
            "reason": JSONValue(reason),
            "strategy": JSONValue(this.strategy)
        ]);
    }

    @disable this();

@property:
    string strategy()
    {
        return strategy;
    }

    string reason()
    {
        return _reason;
    }

    Direction direction()
    {
        return _direction;
    }

    uint cost()
    {
        return _cost;
    }

}
