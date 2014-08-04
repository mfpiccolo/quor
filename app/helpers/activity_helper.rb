module ActivityHelper

  Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e at %l:%M") + time.strftime("%p").downcase }

  def filter_changes(hash)
    if hash.present? && hash["last_version_changes"].present?
      html = ""
      hash["last_version_changes"][1].each_pair do |attr, changed_to_from|
        html << "- #{attr} changed from #{changed_to_from[0]} to #{changed_to_from[1]}</br>"
      end
      html.html_safe
    end
  end

end
