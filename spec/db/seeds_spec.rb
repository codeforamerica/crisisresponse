# frozen_string_literal: true

require "rails_helper"

describe "db/seeds" do
  it "completes successfully" do
    load Rails.root.join("db/seeds.rb")
  end
end
