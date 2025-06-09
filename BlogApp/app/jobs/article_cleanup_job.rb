class ArticleCleanupJob < ApplicationJob
  queue_as :default

  def perform
    articles_to_delete = Article.where('reports_count >= 6')
    
    articles_to_delete.find_each do |article|
      Rails.logger.info "Deleting article '#{article.title}' (ID: #{article.id}) due to excessive reports"
      article.destroy
    end
  end
end