class AssociateRmsPeopleWithPeople < ActiveRecord::Migration
  def change
    change_table :rms_people do |t|
      t.belongs_to :person, index: true, foreign_key: true
    end
  end
end
