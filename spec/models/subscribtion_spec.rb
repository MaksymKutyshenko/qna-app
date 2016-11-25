require 'rails_helper'

RSpec.describe Subscribtion, type: :model do
  it { belong_to :user }
  it { belong_to :subscribable }
  it { validate_presence_of :user }
  it { validate_uniqueness_of(:user_id).scoped_to(:subscribable_id) }
end
