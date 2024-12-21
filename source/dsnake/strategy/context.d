module dsnake.strategy.context;

import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.flood : Flood;
import dsnake.strategy.hungry : Hungry;

struct StrategyContext
{
@safe:
    Strategy hungry()
    {
        return new Hungry();
    }

    Strategy flood()
    {
        return new Flood;
    }
}
