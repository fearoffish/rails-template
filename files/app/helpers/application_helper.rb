module ApplicationHelper
  def style_with_staging_color
    if Rails.env.development? || Rails.env.staging?
      raw('style="background-color: #ff7573;"')
    end
  end
end
