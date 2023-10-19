use array::ArrayTrait;
use debug::PrintTrait;
use starknet::ContractAddress;
use dojo::database::schema::{SchemaIntrospection, Ty, Enum, serialize_member_type};


#[derive(Model, Drop, Serde)]

struct GridSquare{
    #[key]
    game_id:felt252,
    avator:Avator
}
#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum Avator{
    X:(),
    O:(),
}


#[derive(Model, Drop, Serde)]
struct Game {
    
    #[key]
    game_id: felt252,
    winner: Avator,
    x: ContractAddress,
    o: ContractAddress
}

#[derive(Model, Drop, Serde)]
struct GameTurn {
    #[key]
    game_id: felt252,
    turn: Avator
}