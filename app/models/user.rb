# frozen_string_literal: true

class User < ApplicationRecord
  has_many :credentials, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
