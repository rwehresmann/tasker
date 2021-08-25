class ListController < ApplicationController
  def index
    @lists = List.all
    @new_task ||= Task.new
  end
end
