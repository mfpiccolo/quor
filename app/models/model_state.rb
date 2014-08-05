class ModelState < ActiveRecord::Base
  has_many :models

  def state
    name
  end
end
