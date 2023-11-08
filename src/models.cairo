use starknet::ContractAddress;
use debug::PrintTrait;
use dojo::database::schema::{SchemaIntrospection, Ty, Enum, serialize_member_type};
#[derive(Model, Drop, Serde)]
struct Game{
     /// game id, computed as follows pedersen_hash(player1_address, player2_address)
    #[key]
    game_id:felt252,
    winner:Avator,
    playerx:ContractAddress,
    playero:ContractAddress,


}

#[derive(Model, Drop, Serde)]
struct Tile{
    #[key]
    game_id:felt252,
    #[key]
    x:u32,
    #[key]
    y:u32,
    avator:Avator,


}


#[derive(Serde,Drop,Copy,PartialEq,Introspect)]
enum Avator{
    X:(),
    O:(),
    None:()
}

#[derive(Model, Drop, Serde)]
struct GameTurn {
    #[key]
    game_id: felt252,
    turn: Avator,
}

// print traits
impl AvatorPrintTrait of PrintTrait<Avator>{
        #[inline(always)]
        fn print(self:Avator){
            match self{
                Avator::X(_)=>{
                    'X player'.print();
                },
                Avator::O(_)=>{
                    'O player'.print();
                },
                Avator::None(_)=>{
                    'No player'.print();
                }
            }
        }

}
impl BoardPrintTrait of PrintTrait<(u32, u32)> {
    #[inline(always)]
    fn print(self: (u32, u32)) {
        let (x, y): (u32, u32) = self;
        x.print();
        y.print();
    }
}
// flow here is this/what the models are doing :
// 1. we get  game Struct: it has the game id and the winnner and addresses:
// so for every game if I made a query i would get who were the players for that game and who won that game
// 2.we have a Struct for the tiles... we have a tile
// 3. Game turn struct 
// 4.enum for the choice of avators..in this case x and y
