class User < ApplicationRecord
  before_validation { email.downcase! }
  before_update :not_update_admin_flg
  before_destroy :not_destroy_admin_flg

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, 
                    uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_many :tasks, dependent: :destroy

  private
  def not_update_admin_flg
    user = User.where(id: self.id).where(admin_flg: true)
    if User.where(admin_flg: true).count == 1 && user.present? && self.admin_flg == false
     throw(:abort)
    end
  end

  def not_destroy_admin_flg
    if self.admin_flg && User.where(admin_flg: true).count == 1
      throw(:abort)
    end
  end
end
