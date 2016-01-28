class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :insert_user_to_group, :remove_user_from_group]

  helper_method :insert_user_to_group
  helper_method :remove_user_from_group

  def index
    @groups = Group.with_member(current_user.profile)
  end

  def new
    @profile = Profile.find(params[:profile_id])
    @group = @profile.groups.build
  end

  def create
    @profile = Profile.find(params[:profile_id])
    @group = @profile.groups.new(profile_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_groups_path, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @members = Profile.in_group(@group)
  end

  def edit
    @profile = Profile.find(params[:profile_id])
  end

  def update
    @group.update(profile_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to profile_groups_path, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :update }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.delete
    @groups = Group.with_member(current_user.profile)
    respond_to do |format|
      format.html { render :index }
      format.json { redirect_to profile_groups_path, notice: 'Group successfully removed.' }
    end
  end

  def insert_user_to_group
    @members = Profile.in_group(@group)
    new_user = User.where(:email => params[:group_members]).first
    if new_user.nil?
      respond_to do |format|
        format.html { render :show }
        format.json { redirect_to profile_group_path(@group), notice: 'User not found.' }
      end
    else
      @group.add new_user.profile
      @group.save
      respond_to do |format|
        format.html { render :show }
        format.json { redirect_to profile_group_path(@group), notice: 'User successfully added.' }
      end
    end
  end

  def remove_user_from_group
    new_group = Group.find(@group.id).member.delete(Profile.find(params[:remove_profile]))
    new_group.save
    @members = Profile.in_group(@group)
    respond_to do |format|
      format.html { render :show }
      format.json { redirect_to profile_group_path(@group), notice: 'User successfully removed.' }
    end
  end

  private    
    def set_group
      @group = Group.find(params[:id])
    end

      # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:group).permit(:name)
    end

end