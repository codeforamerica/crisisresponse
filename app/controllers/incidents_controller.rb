class IncidentsController < ApplicationController
  def show
    @incident = RMS::CrisisIncident.find(params[:id])
  end
end
