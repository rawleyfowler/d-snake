module dsnake.strategy.context;

import dsnake.strategy.strategy : Strategy;
import dsnake.strategy.flood : Flood;

class StrategyContext
{
static:

    private immutable Strategy[] STRATEGIES = [new Flood()];

    public Strategy[] strategies()
    {
        return STRATEGIES;
    }
}
