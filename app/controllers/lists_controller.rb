class ListsController < ApplicationController
  before_action :authenticate_user!
  def today
  end

  def upcoming
  end

  def inbox
  end
end
