class AddBackgroundInfoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :background_info, :text
  end
end
