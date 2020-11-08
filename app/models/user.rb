class User < ApplicationRecord
  validates :twitterhandle, presence: true, uniqueness: true
end
