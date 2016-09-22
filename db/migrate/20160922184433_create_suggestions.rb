class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.belongs_to :officer, foreign_key: true
      t.belongs_to :person, foreign_key: true
      t.text :body
      t.boolean :urgent

      t.timestamps
    end
  end
end
