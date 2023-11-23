use starknet::ContractAddress;


//if i call say id (1)...i want to get the players for that game and the address that won
//what if it was a draw---it will return None
#[derive(Model,Copy,Drop,Serde,SerdeLen)]
struct Game{
    #[key]
    game_id:felt252,
    playerX:ContractAddress,
    playerO:ContractAddress,
    winner:Avators,

}

//the 3*3 grid
//if i called the id i'd expect the board and the specific tile
#[derive(Model,Copy,Drop,Serde,SerdeLen)]
struct GameBoard{
    #[key]
    game_id:felt252,
    #[key]
    x:u32,
    #[key]
    y:u32,
    avator:Avators,
}
#[derive(Model, Copy,Drop, Serde)]
struct PlayersTurn{
    #[key]
    game_id:felt252,
    player_turn:Avators,
}
#[derive(Model, Copy,Drop, Serde)]
struct Player{
    #[key]
    player_addres:ContractAddress,
    isPlayerX:bool,
    username:felt252,
}
//avator for the game...'X' AND 'O'
#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum Avators{
    Avator_X:(),
    Avator_O:(),
    None:(),
}


#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum GameState{
    ongoing:(),
    draw:(),
    winner:(),
}
#[derive(Model, Copy,Drop, Serde)]
struct TrackGameState{
    #[key]
    game_id:felt252,
    game_state:GameState
}
