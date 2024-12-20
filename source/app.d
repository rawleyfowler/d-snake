import vibe.vibe;
import vibe.core.log;
import dsnake.board;
import dsnake.movement : Movement;
import std.json;
import std.functional;
import std.algorithm.iteration;
import std.stdio;

const string VERSION = "1";

void main()
{
    auto settings = new HTTPServerSettings;
    settings.port = 3000;
    settings.bindAddresses = ["0.0.0.0"];
    auto listener = listenHTTP(settings, (scope req, scope res) {
        switch (req.requestPath.toString())
        {
        case "/":
            index(req, res);
            break;
        case "/end":
            end(req, res);
            break;
        case "/start":
            start(req, res);
            break;
        case "/move":
            move(req, res);
            break;
        default:
            break;
        }
    });

    scope (exit)
        listener.stopListening();

    runApplication();
}

void index(scope HTTPServerRequest _, scope HTTPServerResponse res)
{
    JSONValue response = [
        "apiversion": VERSION, "author": "rawley fowler", "color": "#FF6962",
        "head": "all-seeing", "tail": "mystic-moon"
    ];
    res.writeJsonBody(response);
}

void end(scope HTTPServerRequest _, scope HTTPServerResponse res)
{
    logInfo("DONE GAME!");
    res.writeJsonBody(JSONValue(["message": "DONE!"]));
}

void start(scope HTTPServerRequest _, scope HTTPServerResponse res)
{
    logInfo("STARTING GAME!");
    res.writeJsonBody(JSONValue(["message": "STARTING!"]));
}

void move(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
    // TODO: (RF) This is ugly, we should just use vibe's JSON.
    auto json = parseJSON(req.json().toString());
    auto board = new Board(json);

    auto movements = Movement.from(board);

    logInfo("Potential moves:");
    foreach (Movement m; movements)
    {
        if (m is null)
        {
            throw new Exception("A MOVEMENT IS NULL!");
        }
        logInfo("\t Strategy: %s, Reason: %s, Direction: %s, Cost: %d",
                m.strategy, m.reason, m.direction, m.cost);
    }
    auto best_move = reduce!((a, b) => b.cost < a.cost ? b : a)(Movement.random(), movements);

    if (best_move is null)
        throw new Exception("best_move is null somehow!");

    logInfo("MOVING %s REASONING: %s", best_move.direction, best_move.reason);

    auto best_move_json = best_move.json();

    res.writeJsonBody(JSONValue([
            "move": best_move_json["direction"],
            "shout": JSONValue("Foo!")
    ]));
}
