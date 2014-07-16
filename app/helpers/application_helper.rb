module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def activity_message(trackable, params, ignore=nil)
    messages = []

    case params[:action]
    when "update"
      new_attributes = trackable.attributes
      trackable.revert_to(trackable.version - 1)
      old_attributes = trackable.attributes

      difference = hash_difference(old_attributes, new_attributes)

      difference[:new].keys.each do |k|
        old_model = trackable.class.new(difference[:old])
        new_model = trackable.class.new(difference[:new])
        if k.match(/cents/)
          changed = k.gsub("cents", "").gsub("_", "").capitalize
          new_dif_val = "$" + Money.new(difference[:new][k]).to_s
          old_dif_val = "$" + Money.new(difference[:old][k]).to_s
        else
          changed = k.gsub("_", "").capitalize
          old_dif_val = old_model.send(k.to_sym).to_s
          new_dif_val = new_model.send(k.to_sym).to_s
        end

        unless k == ignore.to_s
          messages << changed + " changed from " + old_dif_val + " to " + new_dif_val
        end
      end
    when "create"
      # TODO add better message here
      messages << "Proerty was created"
    end

    messages
  end


  private

  def hash_difference(old_hash, new_hash)
    dif = Hash[*(
     (new_hash.size > old_hash.size)    \
         ? new_hash.to_a - old_hash.to_a \
         : old_hash.to_a - new_hash.to_a
     ).flatten]

    old_hash_dif = {}
    new_hash_dif = {}
    dif.keys.each do |k|
      old_hash_dif[k] = old_hash[k]
      new_hash_dif[k] = new_hash[k]
    end

    {old: old_hash_dif, new: new_hash_dif}
  end

end
