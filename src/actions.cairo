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
              let mut current_move_tile = get!(world,(game_id,current_x,current_y),(GameBoard));

              if current_move_tile.avator==Avators::None(()){
                assert(is_move_within_board(current_move_tile.avator,(current_x,current_y)),'this move is outside the board');
              }

              //if all conditions==true(thus valid--make a move)
              set!(world,(current_move_tile));

              //check if there is a possibility for a winner
              let mut tile_one=get!(world,(game_id,0,0),(GameBoard));
              let mut tile_two=get!(world,(game_id,0,1),(GameBoard));
              let mut tile_three=get!(world,(game_id,0,2),(GameBoard));
              let mut tile_four=get!(world,(game_id,1,0),(GameBoard));
              let mut tile_five=get!(world,(game_id,1,1),(GameBoard));
              let mut tile_six=get!(world,(game_id,1,2),(GameBoard));
              let mut tile_seven=get!(world,(game_id,2,0),(GameBoard));
              let mut tile_eight=get!(world,(game_id,2,1),(GameBoard));
              let mut tile_nine=get!(world,(game_id,2,2),(GameBoard));
              if tile_one.avator == tile_two.avator && tile_one.avator == tile_three.avator
        || tile_four.avator == tile_five.avator && tile_four.avator == tile_six.avator
        || tile_seven.avator == tile_eight.avator && tile_seven.avator == tile_nine.avator
        || tile_one.avator == tile_four.avator && tile_one.avator == tile_seven.avator
        || tile_two.avator == tile_five.avator && tile_two.avator == tile_eight.avator
        || tile_three.avator == tile_six.avator && tile_three.avator == tile_nine.avator
        || tile_one.avator == tile_five.avator && tile_one.avator == tile_nine.avator
        || tile_three.avator == tile_five.avator && tile_three.avator == tile_seven.avator
    {
        'winner'.print();
        // Update the game state with the winner
        // Read the Game struct
        let mut current_game= get!(world, (game_id), (Game));

        // Update the winner field
        current_game.winner = turn.player_turn;

    // Update the Game struct in storage
        set!(world, (current_game));
        // Update the TrackGameState to winner state
        set!(
            world,
            (TrackGameState {
                game_id,
                game_state: GameState::winner(()),
            })
        );
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

