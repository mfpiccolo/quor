module ImportHelper

  def suggest_name(h)
    AttributeNameSuggestion.call(h)
  end

  def suggest_value(h)
    AttributeValueSuggestion.call(h)
  end
end
