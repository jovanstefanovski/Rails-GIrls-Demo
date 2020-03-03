class Idea < ApplicationRecord
  mount_uploader :picture, PictureUploader
  has_many :comments
  validates_presence_of :name, :description, :picture
end
