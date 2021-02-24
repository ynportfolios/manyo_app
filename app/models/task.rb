class Task < ApplicationRecord

  enum status: { なし: 0, 未着手: 1, 着手: 2, 完了: 3 }
  enum priority: { 低: 0, 中: 1, 高: 2 }

  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { minimum: 1, maximum: 200 }
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  scope :search_name_status, ->(name, status) do
    where('name LIKE ?', "%#{name}%").where(status: status)
  end

  scope :search_name, ->(name) do
    where('name LIKE ?', "%#{name}%")
  end

  scope :search_status, ->(status) do
    where(status: status)
  end
end
