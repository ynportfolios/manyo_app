class Task < ApplicationRecord

  enum status: { 未着手: 0, 着手: 1, 完了: 2 }

  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { minimum: 1, maximum: 200 }
  validates :deadline, presence: true
  validates :status, presence: true
end
