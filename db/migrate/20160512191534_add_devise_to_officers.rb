class AddDeviseToOfficers < ActiveRecord::Migration
  def self.up
    change_table :officers do |t|
      ## Database authenticatable
      t.string :email
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Rememberable
      # t.datetime :remember_created_at

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
    end

    add_index :officers, :email
    add_index :officers, :reset_password_token, unique: true
    # add_index :officers, :confirmation_token,   unique: true
    # add_index :officers, :unlock_token,         unique: true
  end

  def self.down
    remove_column :officers, :email
    remove_column :officers, :encrypted_password
    remove_column :officers, :reset_password_token
    remove_column :officers, :reset_password_sent_at
  end
end
