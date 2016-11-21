class Subscribtion < ApplicationRecord
  belongs_to :user
  belongs_to :subscribable, polymorphic: true
  validates :user, presence: true, uniqueness: { scope: :subscribable_id }
end
