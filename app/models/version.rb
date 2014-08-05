class Version < PaperTrail::Version
  belongs_to :user
  belongs_to :model, foreign_key: 'item_id'
end
