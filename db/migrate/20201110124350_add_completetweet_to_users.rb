class AddCompletetweetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :completetweet, :string
  end
end
