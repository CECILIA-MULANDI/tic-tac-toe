use tictactoe::models::{Game,GameBoard,GameState,Avators,Player,PlayersTurn};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

use debug::PrintTrait;
fn is_player_turn(game_id:felt252,player_address:ContractAddress,avator:Avators)->bool{
    true
}
fn is_move_within_board(avator:Avators,current_tile:(u32,u32))->bool{
    let (current_x,current_y)=current_tile;

    match avator{
        Avators::Avator_X=>{
            if current_x<0 && current_y<0|| current_x>2 && current_y>2{
                return false;
            }
            true
        },
        Avators::Avator_O=>{
            if current_x<0 && current_y<0|| current_x>2 && current_y>2{
                return false;

            }
            true
            },
        Avators::None=>{
            true
        }
    }
}