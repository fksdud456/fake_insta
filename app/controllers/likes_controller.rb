class LikesController < ApplicationController

  def create
    Like.create(user_id: current_user.id,
                post_id: params[:post_id])

    redirect_to '/'
  end

  def destroy
    Like.find_by(user_id: current_user.id, post_id: params[:post_id]).destroy
    redirect_to '/'
  end
end
