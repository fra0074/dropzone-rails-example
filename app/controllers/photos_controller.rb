class PhotosController < ApplicationController
  before_action :set_photo, :only => [:destroy]

  def index
    respond_to do |format|
      format.html
      format.json {
        photos = Photo.order(:position).map {|photo| {pid: photo.id, url: photo.file.url, name: photo.name, size: photo.size} }
        render json: photos
      }
    end
  end

  def create
    photo = Photo.new(photo_params)
    if photo.save
      result = {success: true, pid: photo.id}
    else
      result = {success: false, error: photo.errors.full_messages.join(';')}
    end
    render json: result
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.json {
        render json: {success: true}
      }
    end
  end

  def update_position
    positions = params[:positions]
    if positions.present?
      photo_update_attributes = positions.values.map {|val| {position: val} }
      Photo.update(positions.keys, photo_update_attributes)
    end

    respond_to do |format|
      format.json { render json: {success: true} }
    end
  end

  private
  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:file)
  end
end
