module LocationsHelper
  def icon_for(location)
    if location.indoor?
      image_tag 'images/toilette.png'
    else
      image_tag 'images/tree.png'
    end
  end
end
