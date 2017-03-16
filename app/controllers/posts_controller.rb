class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if current_user != @post.user
      redirect_to account_posts_path, alert: "你没有编辑权限！"
    end
    if @post.update(post_params)
      redirect_to account_posts_path, notice: "编辑成功！"
    else
      render :edit
    end
  end


  def destroy
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if current_user == @post.user
      @post.destroy
      redirect_to account_posts_path, alert: "删除文章成功！"
    else
      redirect_to account_posts_path, alert: "你没有相应权限！"
    end
  end


  private

  def post_params
    params.require(:post).permit(:content)
  end
end
