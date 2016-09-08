class CreateOfficers < ActiveRecord::Migration
  def up
    create_table :officers do |t|
      t.string :name, null: false
      t.string :unit, null: false
      t.string :title
      t.string :phone

      t.timestamps null: false
    end

    execute(<<-SQL)
      INSERT INTO officers (name,unit,created_at,updated_at)
      VALUES ('PLACEHOLDER - REPLACE ME','PLACEHOLDER - REPLACE ME',now(),now())
    SQL

    add_column :response_plans, :author_id, :integer
    add_column :response_plans, :approver_id, :integer
    add_column :response_plans, :approved_at, :datetime

    add_index :response_plans, :approver_id
    add_index :response_plans, :author_id

    execute(<<-SQL)
      UPDATE response_plans SET author_id = (SELECT id FROM officers LIMIT 1)
    SQL

    change_column_null :response_plans, :author_id, false
  end

  def down
    remove_index :response_plans, :approver_id
    remove_index :response_plans, :author_id

    remove_column :response_plans, :author_id
    remove_column :response_plans, :approver_id
    remove_column :response_plans, :approved_at

    drop_table :officers
  end
end
