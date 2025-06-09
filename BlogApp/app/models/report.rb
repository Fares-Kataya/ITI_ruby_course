class Report < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: :reports_count

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: :article_id, message: "You have already reported this article" }

  REASONS = [
    'Spam',
    'Inappropriate Content',
    'Harassment',
    'False Information',
    'Copyright Violation',
    'Other'
  ].freeze

  validates :reason, inclusion: { in: REASONS }

  after_create :check_article_status

  private

  def check_article_status
    if article.should_be_archived? && !article.archived?
      article.archive!
      ArticleArchiveJob.perform_later(article)
    end
  end
end