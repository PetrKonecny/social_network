class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :insert_user_to_group, :remove_user_from_group, :create_status, :show_members]

  helper_method :insert_user_to_group
  helper_method :remove_user_from_group
  helper_method :show_members
  helper_method :create_status

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
        @group.add current_user.profile, as: 'admin'
        @group.save
        format.html { redirect_to profile_groups_path, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @statuses = Status.where(group_id: @group.id)
    @activities = PublicActivity::Activity.where(owner_id: current_user.friends_and_mine_ids, owner_type: "User").order('created_at DESC').limit(20)
  end

  def show_members
    @members = Profile.in_group(@group)
  end

  def edit
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
      @group.add new_user.profile, as: 'other'
      @group.save
      respond_to do |format|
        format.html { render :show }
        format.json { redirect_to profile_group_path(@group), notice: 'User successfully added.' }
      end
    end
  end

  def remove_user_from_group
    @group.group_memberships.delete(GroupMembership.where(:group_id => @group.id, :member_id => params[:remove_profile]).first)
    @group.save
    @members = Profile.in_group(@group)
    respond_to do |format|
      format.html { render :show }
      format.json { redirect_to profile_group_path(@group), notice: 'User successfully removed.' }
    end
  end

  def create_status
    @members = Profile.in_group(@group)
    @status = Status.new(:body => params[:status], :group_id => params[:id])
    @status.user = current_user
    respond_to do |format|
      if @status.save
        @statuses = Status.where(group_id: @group.id)
        format.json { redirect_to profile_group_path(@group), notice: 'Status was successfully created.' }
        format.html { render :show }
      else
        @statuses = Status.where(group_id: @group.id)
        format.html { render :show }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
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