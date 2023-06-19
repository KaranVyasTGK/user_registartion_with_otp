class AddTwoFaToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :two_factor, :boolean, default: true
  end
end
