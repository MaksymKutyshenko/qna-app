class CreateSubscribtions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribtions do |t|
      t.belongs_to :user
      t.belongs_to :subscribable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
