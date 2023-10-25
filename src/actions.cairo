use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
#[starknet::interface]
// defination of my functions

trait IActions<ContractState>{
    fn move(self:@ContractState,caller:ContractAddress,game_id:felt252);
    fn spawn_game(self:@ContractState,player_o:ContractAddress,player_x:ContractAddress);
}

#[starknet::contract]
mod actions{
    use dojo::world::{IWorldDispatcher,IWorldDispatcherTrait};
    use debug::PrintTrait;
    use starknet::ContractAddress; 
    // use another::models::{Game,GameTurn,Avator,Tile};
    use super::IActions;

    #[storage]
    struct Storage {
        world_dispatcher: IWorldDispatcher,
    }
    #[external(v0)]
    impl PlayerActionsImpl of IActions<ContractState>{
        fn spawn_game(self:@ContractState,player_o:ContractAddress,player_x:ContractAddress){

        }
        fn move(self:@ContractState,caller:ContractAddress,game_id:felt252){
            
        }
        
    }
}