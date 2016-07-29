class MoveAliasesToPeople < ActiveRecord::Migration
  def up
    change_table :aliases do |t|
      t.belongs_to :person, index: true, foreign_key: true
    end

    execute(<<-SQL)
    UPDATE aliases
    SET person_id = (
      SELECT person_id
      FROM response_plans
      WHERE response_plans.id = aliases.response_plan_id
    )
    SQL

    change_column_null :aliases, :person_id, false

    change_table :aliases do |t|
      t.remove :response_plan_id
    end
  end

  def down
    change_table :aliases do |t|
      t.belongs_to :response_plan, index: true, foreign_key: true
    end

    execute(<<-SQL)
    UPDATE aliases
    SET response_plan_id = (
      SELECT id
      FROM response_plans
      WHERE response_plans.person_id = aliases.person_id
      ORDER BY approved_at DESC
      LIMIT 1
    )
    SQL

    change_table :aliases do |t|
      t.remove :person_id
    end
  end
end
