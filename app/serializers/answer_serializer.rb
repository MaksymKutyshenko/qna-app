class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :user_id, :body, :created_at, :updated_at, :best
  has_many :comments
  has_many :attachments
end
