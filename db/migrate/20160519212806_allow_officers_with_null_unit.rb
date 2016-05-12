class AllowOfficersWithNullUnit < ActiveRecord::Migration
  def up
    change_column_null :officers, :unit, true
  end

  def down
    change_column_null :officers, :unit, false, "TEMPORARY - REPLACE ME"
  end
end
