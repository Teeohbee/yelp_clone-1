class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :user
end
