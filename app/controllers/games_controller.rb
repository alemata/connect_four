class GamesController < ApplicationController

  def user
    @current_player = User.find params[:id]
    @game = Game.first
  end

  def user_play
    @current_player = User.find params[:user]
    column = params[:column].to_i
    @game = Game.first
    @game.play(@current_player, column)

    @game.reload
  end

end
