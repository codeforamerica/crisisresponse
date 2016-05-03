class Officer < ActiveRecord::Base; end
class ResponsePlan < ActiveRecord::Base; end

class CreateOfficers < ActiveRecord::Migration
  def up
    create_table :officers do |t|
      t.string :name, null: false
      t.string :unit, null: false
      t.string :title
      t.string :phone

      t.timestamps null: false
    end

    officer = Officer.create(
      name: "TEMPORARY - REPLACE ME",
      unit: "TEMPORARY - REPLACE ME",
    )

    add_column :response_plans, :author_id, :integer
    add_column :response_plans, :approver_id, :integer
    add_column :response_plans, :approved_at, :datetime

    add_index :response_plans, :approver_id
    add_index :response_plans, :author_id

    ResponsePlan.update_all(author_id: officer.id)

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
