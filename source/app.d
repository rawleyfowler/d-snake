import archttp;
import dsnake.board;
import dsnake.movement : Movement;
import std.logger;
import std.json;
import std.functional;
import std.algorithm.iteration;
import std.stdio;

const string VERSION = "1";

void main()
{
    auto app = new Archttp;

    app.get("/", toDelegate(&index));
    app.get("/end", toDelegate(&end));
    app.get("/start", toDelegate(&start));

    app.listen(3000);
}

void index(scope HttpRequest _, scope HttpResponse res)
{
    JSONValue response = [
        "apiversion": VERSION, "author": "rawley fowler", "color": "#FF6962",
        "head": "all-seeing", "tail": "mystic-moon"
    ];
    res.send(response);
}

void end(scope HttpRequest _, scope HttpResponse res)
{
    log("DONE GAME!");
    res.send(JSONValue(["message": "DONE!"]));
}

void start(scope HttpRequest _, scope HttpResponse res)
{
    log("STARTING GAME!");
    res.send(JSONValue(["message": "STARTING!"]));
}

void move(scope HttpRequest req, scope HttpResponse res)
{
    auto board = new immutable Board(parseJSON(req.body));
    auto movements = Movement.from(board);
    auto best_move = movements.reduce!((a, b) => a.cost < b.cost ? b : a);
    auto best_move_json = best_move.json;

    log(best_move_json);

    res.send(JSONValue([
            "move": best_move_json["direction"],
            "shout": JSONValue("Foo!")
    ]));
}
