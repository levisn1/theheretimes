module ApplicationHelper

  def filter_active?(number)
    number.to_s == params[:since] ? "active-font" : nil
  end
end
