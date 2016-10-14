class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.belongs_to :votable, polymorphic: true, index: true
      t.integer :rating, limit: 1
      t.timestamps
    end
  end
end
