class Article < ApplicationRecord
  belongs_to :user
  has_many :reports, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }

  scope :published, -> { where(public: true) }
  scope :not_archived, -> { where(archived: false) }
  scope :for_user, ->(user) { where(user: user) }

  def should_be_archived?
    reports_count >= 3
  end

  def should_be_deleted?
    reports_count >= 6
  end

  def archive!
    update!(archived: true)
  end
end