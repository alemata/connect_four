class GamesController < ApplicationController

  def user
    @current_player = User.find params[:id]
    @game = Game.first
  end

  def user_play
    @current_player = User.find params[:user]
    column = params[:column].to_i
    @game = Game.first
    @info = @game.play(@current_player, column)

    @game.reload
  end

  def new_game
    @user = User.find params[:user_id]
    game = Game.first
    game = game.reset

    redirect_to "/users/#{@user.id}"
  end

end
