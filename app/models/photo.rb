class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  before_create :update_file_attributes
  after_destroy :remove_file

  private
  def update_file_attributes
    if self.file.present?
      self.name         = file.file.filename
      self.size         = file.file.size
      self.content_type = file.file.content_type
      self.position     = Photo.count + 1
    end
  end

  def remove_file
    FileUtils.remove_dir("#{Rails.root}/public/uploads/room_photo/file/#{id}", true)
  end
end
