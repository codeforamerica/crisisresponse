class CreatePageViews < ActiveRecord::Migration
  def change
    create_table :page_views do |t|
      t.references :officer, index: true, foreign_key: true
      t.references :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
