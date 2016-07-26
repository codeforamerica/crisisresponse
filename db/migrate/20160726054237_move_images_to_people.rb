class MoveImagesToPeople < ActiveRecord::Migration
  def up
    change_table :images do |t|
      t.belongs_to :person, index: true, foreign_key: true
    end

    execute(<<-SQL)
    UPDATE images
    SET person_id = (
      SELECT person_id
      FROM response_plans
      WHERE response_plans.id = images.response_plan_id
    )
    SQL

    change_column_null :images, :person_id, false

    change_table :images do |t|
      t.remove :response_plan_id
    end
  end

  def down
    change_table :images do |t|
      t.belongs_to :response_plan, index: true, foreign_key: true
    end

    execute(<<-SQL)
    UPDATE images
    SET response_plan_id = (
      SELECT id
      FROM response_plans
      WHERE response_plans.person_id = images.person_id
      ORDER BY approved_at DESC
      LIMIT 1
    )
    SQL

    change_column_null :images, :response_plan_id, false

    change_table :images do |t|
      t.remove :person_id
    end
  end
end
