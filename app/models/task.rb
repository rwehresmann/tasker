class Task < ApplicationRecord
  belongs_to :list

  validates :name, presence: true

  scope :incomplete_first, -> { order(completed_at: :desc) }

  acts_as_list scope: [:list_id, completed_at: nil], top_of_list: 0

  def complete?
    completed_at.present?
  end
end
