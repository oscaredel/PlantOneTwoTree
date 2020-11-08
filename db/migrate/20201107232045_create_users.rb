class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :twitterhandle
      t.integer :amount
      t.string :status

      t.timestamps
    end
  end
end
