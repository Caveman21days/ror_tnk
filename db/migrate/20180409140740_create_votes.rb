class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :votable_id
      t.string  :votable_type
      t.integer :user_id
      t.boolean :vote

      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type, :user_id]
  end
end
