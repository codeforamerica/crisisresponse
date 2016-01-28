require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  describe "GET #index" do
    it "assigns all people as @people" do
      person = Person.create! attributes_for(:person)
      get :index
      expect(assigns(:people)).to eq([person])
    end
  end

  describe "GET #show" do
    it "assigns the requested person as @person" do
      person = Person.create! attributes_for(:person)
      get :show, {:id => person.to_param}
      expect(assigns(:person)).to eq(person)
    end
  end
end
