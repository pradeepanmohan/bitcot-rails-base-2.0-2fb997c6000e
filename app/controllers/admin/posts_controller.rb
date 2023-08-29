class Admin::PostsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :find_all_posts
  before_action :find_post, except: [:new, :create, :index]

  def index
    # @user = current_user
    # @posts = @user.posts
    # @posts = Post.search(params)
    @posts = Post.all
    @posts = @posts.paginate(page: params[:page], per_page: 5)

  end

  def audit_changes
    @post = Post.find(params[:id])
    @audits = @post.audits
  end

  def show
    @post = Post.where(id: params.require(:id))
  end

  def new
    @post = Post.new
    @posts = @posts.paginate(page: params[:page], per_page: 5)
  end

  def edit
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to [:admin, @post], notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post removed"
    render turbo_stream: [
      turbo_stream.update("flash", partial: "shared/flash"),
      turbo_stream.remove(dom_id(@post)),
      turbo_stream.update("posts-count", partial: "posts/count", locals: { posts: @posts })
    ]
  end

  private

    def post_params
      params.require(:post).permit!
    end

    def find_all_posts
      @posts = Post.all
    end

    def find_post
      @post = Post.find(params.require(:id))
    end
end
