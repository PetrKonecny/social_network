class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @friends = current_user.friends
    @conversation = params[:format].nil? ? Conversation.first : Conversation.find(params[:format])
    @conversations = Conversation.involving(current_user).select { |x| !x.messages.empty? }.sort { |x, y| y.messages.last.created_at <=> x.messages.last.created_at }
    @message = Message.new
  end
end
