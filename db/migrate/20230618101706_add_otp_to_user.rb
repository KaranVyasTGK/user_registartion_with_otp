class AddOtpToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp, :integer
    add_column :users, :valid_till, :datetime
  end
end
