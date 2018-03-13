class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, foreign_Key: true
      t.text :body

      t.timestamps
    end
  end
end
