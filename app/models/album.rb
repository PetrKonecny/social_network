class Album < ActiveRecord::Base
  include PublicActivity::Model
  validates :name, :pictures, presence: true
  tracked owner: Proc.new{ |controller, model| controller.current_user }, only: :create
  has_many :images, dependent: :destroy
  belongs_to :user
  attr_accessor :pictures
  after_save :save_images

  def save_images
    self.pictures.each { |image|
      self.images.create(image: image)
    }
  end

end
