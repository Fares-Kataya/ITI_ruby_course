class ArticleArchiveJob < ApplicationJob
  queue_as :default

  def perform(article)
    Rails.logger.info "Article '#{article.title}' has been archived due to reports"
  end
end