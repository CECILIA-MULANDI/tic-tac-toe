use starknet::ContractAddress;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
#[starknet::interface]

trait IActions<ContractState>{
    fn Begin_Game(self:@ContractState,playerX:ContractAddress,playerO:ContractAddress);
    fn Make_Moves(self:@ContractState,game_id:felt252,current_tile:(u32,u32),player:ContractAddress);
}

#[starknet::contract]
mod actions{
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use debug::PrintTrait;
    use starknet::ContractAddress;
    use tictactoe::models::{Game,GameBoard,GameState,Avators,Player,PlayersTurn,TrackGameState};
    use tictactoe::utils::{is_player_turn,is_move_within_board};
    

     #[storage]
    struct Storage {
        world_dispatcher: IWorldDispatcher, 
    }


    fn Begin_Game(self:@ContractState,playerX:ContractAddress,playerO:ContractAddress){
        
        //set the board -- 3*3 grid
        let world = self.world_dispatcher.read();
        let game_id=pedersen::pedersen(playerX.into(), playerO.into());
        set!(world,(GameBoard{game_id:game_id,x:0,y:0,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:0,y:1,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:0,y:2,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:1,y:0,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:1,y:1,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:1,y:2,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:2,y:0,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:2,y:1,avator:Avators::None}));
        set!(world,(GameBoard{game_id:game_id,x:2,y:2,avator:Avators::None}));

        //when the game starts the first player should be x and there should be no winner

        set!(world,(PlayersTurn{game_id:game_id,player_turn:Avators::Avator_X(())},
        Game{
            game_id:game_id,
            playerX:playerX,
            playerO:playerO,
            winner:Avators::None(()),
        },
        TrackGameState{
            game_id:game_id,
            game_state:GameState::ongoing(()),

        },

        
        ));
    }



    //here the player can place either an X or an O

    fn Make_Moves(self:@ContractState,game_id:felt252,current_tile:(u32,u32),player:ContractAddress){
        
        let world = self.world_dispatcher.read();
        let(current_x,current_y )=current_tile;
        //check game_state

        let track_game_state=get!(world, (game_id),(TrackGameState));

        // Access the game_state field using pattern matching or if statements
        match track_game_state.game_state {
            GameState::ongoing => {
                // Handle the ongoing state
              'ongoing'.print();
              //check if it's their player_turn

              let mut turn=get!(world,(game_id),(PlayersTurn));
              assert(is_player_turn(game_id,player,turn.player_turn),'it is not your turn');

              //check if that box/tile/grid-space is empty
              let current_move_tile = get!(world,(game_id,current_x,current_y),(GameBoard));

              if current_move_tile.avator==Avators::None(()){
                assert(is_move_within_board(current_move_tile.avator,(current_x,current_y)),'this move is outside the board');
              }


            },
            GameState::draw => {
                // Handle the draw state
                'draw'.print()
            },
            GameState::winner => {
                // Handle the winner state
               'winner'.print()
            }
        }

       
        


    }




}

