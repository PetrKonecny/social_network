class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :destroy, :like, :dislike]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])
    @commentable = @image
    @comment = Comment.new
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    @image.reactions.create(reaction_type: :like, user: current_user)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image}
        format.json { render :show, image: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def dislike
    @image.reactions.create(reaction_type: :dislike, user: current_user)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image}
        format.json { render :show, image: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params[:image]
    end
end
