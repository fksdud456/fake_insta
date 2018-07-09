class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post_id = params[:post_id]
    @like = Like.create(user_id: current_user.id,
                post_id: @post_id)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}  # {} 명시하지 않는경우 create.js.erb 로 매칭됨
    end
  end

  def destroy
    @post_id = params[:post_id]
    Like.find_by(user_id: current_user.id, post_id: @post_id).destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.js {}
    end
  end
end
