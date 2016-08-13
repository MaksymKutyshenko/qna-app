class AddForeignKeyToAnswers < ActiveRecord::Migration[5.0]
  def change
  	add_reference :answers, :question, index: true, foreign_key: true
  end
end