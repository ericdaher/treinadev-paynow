class ReceiptsController < ApplicationController
  def index
    @receipt = Receipt.search(params[:id])
  end
end