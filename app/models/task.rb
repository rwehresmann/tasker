class Task < ApplicationRecord
  belongs_to :list
  belongs_to :creator, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :completer, class_name: "User", optional: true

  has_many :comments, -> { order(created_at: :asc) }, as: :commentable

  validates :name, presence: true

  scope :incomplete, -> { where(completed_at: nil).order(position: :asc) }
  scope :complete, -> { where.not(completed_at: nil).order(updated_at: :asc) }

  acts_as_list scope: [:list_id, completed_at: nil], top_of_list: 0

  delegate :name, to: :assignee, prefix: true, allow_nil: true
  delegate :name, to: :completer, prefix: true, allow_nil: true

  def complete?
    completed_at.present?
  end
end
