class Task < ApplicationRecord

  validates :name, presence: true, length: { maximum: 50 }
  validates :content, length: { maximum: 200 }
end
