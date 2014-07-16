class Ply < Pliable::Ply
  after_initialize :set_ply_attributes

  def to_param
    id.to_s
  end


  private

  def set_ply_attributes
    if data.present?
      data.each do |key,value|
        # instance_variable_set(('@' + key.to_s).to_sym, value)
        define_singleton_method(key.to_s) { self.data[key] }
        define_singleton_method(key.to_s + "=") {|a| self.data[key] = a}
      end
    end
  end

end
