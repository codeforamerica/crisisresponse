class IncidentsController < ApplicationController
  def show
    @incident = CrisisIncident.find(params[:id])
  end
end
