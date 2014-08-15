module ActivityHelper

  Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e at %l:%M") + time.strftime("%p").downcase }

  def filter_changes(hash)
    # TODO make version actually save this string so it dosnt have to query for model state
    if hash.present? && hash["last_version_changes"].present?
      html = ""
      hash["last_version_changes"][1].each_pair do |attr, changed_to_from|
        if attr == "model_state_id"
          from_state = ModelState.find(changed_to_from[0]).name if changed_to_from[0].present?
          to_state = ModelState.find(changed_to_from[1]).name if changed_to_from[1].present?
          html << "- state changed from #{from_state} to #{to_state}"
        else
          html << "- #{attr} changed from #{changed_to_from[0]} to #{changed_to_from[1]}</br>"
        end
      end
      html.html_safe
    else
      html = ""
      hash.each_pair do |attr, changed_to_from|
        if attr == "model_state_id"
          from_state = ModelState.find(changed_to_from[0]).name if changed_to_from[0].present?
          to_state = ModelState.find(changed_to_from[1]).name if changed_to_from[1].present?
          html << "- state changed from #{from_state} to #{to_state}"
        else
          html << "- #{attr} changed from #{changed_to_from[0]} to #{changed_to_from[1]}</br>"
        end
      end
      html.html_safe
    end
  end

end
