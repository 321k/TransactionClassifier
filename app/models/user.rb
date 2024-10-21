class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :household, optional: true

  # Define which associations are searchable.
  def self.ransackable_associations(auth_object = nil)
    # List the associations you want to be searchable. For example:
    ['household', 'user_feedbacks']
    # Make sure to exclude sensitive associations like 'encrypted_password' or any other sensitive information.
  end

  def self.ransackable_attributes(auth_object = nil)
    # List the attributes you want to be searchable. For example:
    super - ['encrypted_password', 'reset_password_token']
    # This removes sensitive attributes from being searchable.
  end

end
