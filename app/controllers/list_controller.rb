class ListController < ApplicationController
  def index
    @lists = List.all
  end
end
