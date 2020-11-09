class AddRequesttweetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :requesttweet, :string
  end
end
