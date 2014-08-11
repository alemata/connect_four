class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status
      t.integer :current_player_id
      t.integer :player_1_id
      t.integer :player_2_id
      t.string :board

      t.timestamps
    end
  end
end
