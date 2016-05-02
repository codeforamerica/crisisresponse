class Officer < ActiveRecord::Base; end
class Person < ActiveRecord::Base; end

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

    add_column :people, :author_id, :integer
    add_column :people, :approver_id, :integer
    add_column :people, :approved_at, :datetime

    add_index :people, :approver_id
    add_index :people, :author_id

    Person.update_all(author_id: officer.id)

    change_column_null :people, :author_id, false
  end

  def down
    remove_index :people, :approver_id
    remove_index :people, :author_id

    remove_column :people, :author_id
    remove_column :people, :approver_id
    remove_column :people, :approved_at

    drop_table :officers
  end
end
