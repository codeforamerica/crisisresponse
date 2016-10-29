# frozen_string_literal: true

class OfficerSearch
  include ActiveModel::Model

  attr_accessor :name

  def results
    officers = Officer.all

    if name
      officers = officers.search(name)
    end

    officers
  end
end
