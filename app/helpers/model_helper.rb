module ModelHelper

  def relation_data?(key)
    key.match(/_id$/) && @current_model_names.include?(ActiveSupport::Inflector.humanize(key.to_sym))
  end

  def relation_path(model, key)
    id = model.send(key.to_sym)
    related_model = current_user.models
                                .where(otype: ActiveSupport::Inflector.humanize(key.to_sym))
                                .where("(data->>'external_id')::integer = #{id.to_i}").first
    model_path(related_model)
  end

end
