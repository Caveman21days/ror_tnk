class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.integer :question_id
      t.integer :user_id

      t.timestamps
    end
    add_index :subscribes, [:question_id, :user_id]
  end
end
