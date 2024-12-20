module dsnake.strategy.context;

import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.flood : Flood;

struct StrategyContext
{
@safe:
    Strategy[] strategies()
    {
        return [new Flood];
    }
}
