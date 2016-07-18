class ResponsePlan < ActiveRecord::Base; end
class Person < ActiveRecord::Base; end

class ExtractPeopleFromResponsePlans < ActiveRecord::Migration
  PERSON_ATTRS = [
    :analytics_token,
    :created_at,
    :date_of_birth,
    :eye_color,
    :first_name,
    :hair_color,
    :height_in_inches,
    :last_name,
    :location_address,
    :location_name,
    :race,
    :scars_and_marks,
    :sex,
    :updated_at,
    :weight_in_pounds,
  ]

  def up
    # create table
    create_table :people do |t|
      t.timestamps null: false
      t.string   :first_name
      t.string   :last_name
      t.string   :sex
      t.string   :race
      t.integer  :height_in_inches
      t.integer  :weight_in_pounds
      t.string   :hair_color
      t.string   :eye_color
      t.date     :date_of_birth
      t.string   :scars_and_marks
      t.string   :analytics_token
      t.string   :location_name
      t.string   :location_address
    end

    # copy attributes from response_plan to person
    execute(<<-SQL)
      INSERT INTO people (#{PERSON_ATTRS.join(',')})
      SELECT #{PERSON_ATTRS.join(',')}
      FROM response_plans
    SQL

    # add person_id to response_plan
    add_reference :response_plans, :person, index: true, foreign_key: true

    # associate response_plan with person
    execute(<<-SQL)
    UPDATE response_plans
    SET person_id = (
      SELECT id FROM people
      WHERE analytics_token = response_plans.analytics_token
    );
    SQL

    # remove attributes from response plan
    change_table :response_plans do |t|
      t.remove :first_name
      t.remove :last_name
      t.remove :sex
      t.remove :race
      t.remove :height_in_inches
      t.remove :weight_in_pounds
      t.remove :hair_color
      t.remove :eye_color
      t.remove :date_of_birth
      t.remove :scars_and_marks
      t.remove :analytics_token
      t.remove :location_name
      t.remove :location_address
    end
  end

  def down
    # add attributes to response plan
    change_table :response_plans do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :sex
      t.string   :race
      t.integer  :height_in_inches
      t.integer  :weight_in_pounds
      t.string   :hair_color
      t.string   :eye_color
      t.date     :date_of_birth
      t.string   :scars_and_marks
      t.string   :analytics_token
      t.string   :location_name
      t.string   :location_address
    end

    # copy attributes from person to response_plan
    PERSON_ATTRS.each do |attr|
      execute(<<-SQL)
        UPDATE response_plans
        SET #{attr} = (
          SELECT #{attr} FROM people
          WHERE response_plans.person_id = people.id
        );
      SQL
    end

    # remove person_id from response_plan
    remove_reference :response_plans, :person

    # drop table
    drop_table :people
  end
end
