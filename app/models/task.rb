class Task < ApplicationRecord

  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { minimum: 1, maximum: 200 }
end
