class ModelState < ActiveRecord::Base
  has_many :models

  before_create :set_draft

  def state
    name
  end


  private

  def set_draft

  end

end
