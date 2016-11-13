class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :body, :created_at, :updated_at, :best
end
