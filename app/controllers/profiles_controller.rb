class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  # GET /profiles
  # GET /profiles.json
  def index
    if params[:search]
      @profiles = Profile.search(params[:search]).order("surname ASC")
    else
      @profiles = Profile.all.order("surname ASC")
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def friend
    respond_to do |format|
      if current_user.friend_request(@profile.user)
        format.html { redirect_to @profile, notice: "Friend request to #{@profile.full_name} was sent"  }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { redirect_to @profile, notice: "You must wait on #{@profile.full_name} to accept your friend request"  }
        format.json { render :show, status: :ok, location: @profile }
      end
    end
  end

  def unfriend
    respond_to do |format|
      if current_user.remove_friend(@profile.user)
        format.html { redirect_to @profile, notice: "Friendship with #{@profile.full_name} was canceled"  }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { redirect_to @profile, notice: 'You can`t cancel friendship unless you are already friends'  }
        format.json { render :show, status: :ok, location: @profile }
      end
    end
  end

  def friend_accept
    friend = User.find(params[:friend])
    respond_to do |format|
      current_user.accept_request(friend)
      format.html { redirect_to @profile, notice: "Friend request from #{friend.profile.full_name} was accepted"  }
      format.json { render :show, status: :ok, location: @profile }
    end
  end

  def friend_decline
    friend = Profile.find(params[:friend])
    respond_to do |format|
      current_user.decline_request(friend.user)
      format.html { redirect_to @profile, notice: "Friend request from #{friend.full_name} was declined"  }
      format.json { render :show, status: :ok, location: @profile }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:user_id, :name, :surname, :age, :profile_picture)
    end
end
