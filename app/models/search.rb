class Search < ApplicationRecord
  class << self
    def find(params)
      ThinkingSphinx.search(
        ThinkingSphinx::Query.escape(params[:query]),
        classes: constantize_classes(params[:classes])
      )
    end

    def search_classes
      %w(User Question Answer Comment)
    end

    private

    def constantize_classes(classes)
      return [] unless classes
      classes.select { |class_name|
        Search.search_classes.include? class_name
      }.map { |class_name| class_name.constantize }
    end
  end
end
