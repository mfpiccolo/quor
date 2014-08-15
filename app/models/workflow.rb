class Workflow < ActiveRecord::Base

  belongs_to :model

  # TODO should be before_save
  # before_save :build_workflow_process
  # before_save :check_for_bad_attributes

  def triggered?(model)
    val = model.public_send(trigger_subject.to_sym)
    if trigger_function == "changes_to"
      model.changes.keys.include?(trigger_subject) && val == trigger_arg
    else
      false
    end
  end

  def conditions_met?(model)
    val = model.public_send(condition_subject.to_sym)
    case condition_function
    when "="
      val == condition_arg
    when "!="
      val != condition_arg
    when "<="
      val <= condition_arg.to_i
    when ">="
      val >= condition_arg.to_i
    end
  end

  def action
    if action_function == "change_to"
      -> (m) { m.public_send((action_subject + "=").to_sym, action_arg) }
    end
  end

  # def build_workflow_process
  #   build_out_trigger
  #   build_out_conditions
  #   build_out_action
  # end

  # def build_out_trigger
  #   split_text = trigger_text.split(" ")

  #   self.trigger_subject = split_text[0]
  #   self.trigger_function  = split_text[1]
  #   self.trigger_arg       = split_text[2]
  # end

  # def build_out_conditions
  #   split_text = condition_text.split(" ")

  #   self.condition_subject = split_text[0]
  #   self.condition_function  = split_text[1]
  #   self.condition_arg       = split_text[2]
  # end

  # def build_out_action
  #   split_text = action_text.split(" ")

  #   self.action_subject  = split_text[0]
  #   self.action_function   = split_text[1]
  #   self.action_arg        = split_text[2]
  # end

  # def sendables
  #   [
  #     action_subject, action_subject + "=", trigger_subject,
  #     condition_subject
  #   ].delete_if {|s| s == "state"}.map(&:to_sym)
  # end

  # def check_for_bad_attributes
  #   bad_attrs = Model.new.bad_attribute_names
  #   if (bad_attrs & sendables).present?
  #     raise "Cannot use attribute named #{action_subject}"
  #   end
  # end
end
