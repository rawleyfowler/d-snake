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
    private
    {
        string _strategy;
        Nullable!string _reason;
        Direction _direction;
        uint _cost;
    }

public:

    this(string strategy, Nullable!string _reason, Direction direction, uint cost)
    {
        _strategy = strategy;
        _reason = reason;
        _direction = direction;
        _cost = cost;
    }

    override JSONValue json()
    {
        auto reason = this.reason.get("UNKNOWN");
        return JSONValue([
            "direction": JSONValue(this.direction),
            "cost": JSONValue(this.cost),
            "reason": JSONValue(reason),
            "strategy": JSONValue(this.strategy)
        ]);
    }

    @property string strategy()
    {
        return strategy;
    }

    @property Nullable!string reason()
    {
        return _reason;
    }

    @property Direction direction()
    {
        return _direction;
    }

    @property uint cost()
    {
        return _cost;
    }

    static Movement[] from(immutable Board board)
    {
        static immutable auto strategies = StrategyContext.getStrategies();

        Movement[] moves;

        foreach (immutable Strategy s; strategies)
            moves ~= s.analyze(board);

        return moves;
    }
}
