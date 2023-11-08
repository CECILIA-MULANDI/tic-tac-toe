use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
#[starknet::interface]
// defination of my functions

trait IActions<ContractState>{
    fn move(self:@ContractState,caller:ContractAddress,game_id:felt252);
    fn spawn_game(self:@ContractState,player_o_address:ContractAddress,player_x_address:ContractAddress);
}

#[starknet::contract]
mod actions{
    use dojo::world::{IWorldDispatcher,IWorldDispatcherTrait};
    use debug::PrintTrait;
    use starknet::ContractAddress; 
    use dojo_examples::models::{Game,GameTurn,Avator,Tile};
    use super::IActions;
    use dojo_examples::utils::{is_filled,is_my_turn};

    #[storage]
    struct Storage { 
        world_dispatcher: IWorldDispatcher,
    }
        
    #[external(v0)]
    impl PlayerActionsImpl of IActions<ContractState>{
        fn spawn_game(self:@ContractState,player_o_address:ContractAddress,player_x_address:ContractAddress){
            let world = self.world_dispatcher.read();
            // the game_id is got from the hash  of the addresses of player_x and player_o
            let game_id=pedersen::pedersen(player_o_address.into(),player_x_address.into());
            set!(
                world,(
                    Game{
                        // set the game_id to the one generated after hashing
                        game_id:game_id,
                        winner:Avator::None(()),
                        playerx:player_x_address,
                        playero:player_x_address,
                    },
                     GameTurn{
                        game_id:game_id,turn:Avator::X(()),
                    },
                )
            );
                    // set up an empty grid
                    set!(world,(Tile{game_id:game_id,x:0,y:0,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:0,y:1,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:0,y:2,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:1,y:0,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:1,y:1,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:1,y:2,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:2,y:0,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:2,y:1,avator:Avator::None}));
                    set!(world,(Tile{game_id:game_id,x:2,y:2,avator:Avator::None}));
                   
            

        }
        fn move(self:@ContractState,caller:ContractAddress,game_id:felt252){
            let world = self.world_dispatcher.read();
            // check if it's your turn
            assert(is_my_turn(caller,game_id),'it is not your turn');
        
            // check if the box is filled/has an Avator
            assert(is_filled(maybe_avator), 'tile already has an avator');
            
        }
        
    }
}
