class AddStripeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_id, :string
    add_column :users, :last_4_digits, :string
    add_column :users, :stripe_token, :string
  end
end
