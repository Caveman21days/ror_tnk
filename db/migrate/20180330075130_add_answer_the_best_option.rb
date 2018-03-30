class AddAnswerTheBestOption < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :the_best, :boolean
  end
end
