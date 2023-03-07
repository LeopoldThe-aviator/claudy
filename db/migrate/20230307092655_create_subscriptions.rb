class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.boolean :newsletter

      t.timestamps
    end
  end
end
