# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :person, foreign_key: true, null: false
      t.belongs_to :created_by, foreign_key: { to_table: :officers }, null: false
      t.text :notes

      t.timestamps
    end
  end
end
