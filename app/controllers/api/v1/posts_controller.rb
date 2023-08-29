class Api::V1::PostsController < Api::V1::AuthenticatedController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = current_user.posts.all
    render :json => PostSerializer.new(@posts, include: [:user]).serialized_json
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    render :json => PostSerializer.new(@post, include: [:user]).serialized_json
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      render :json => PostSerializer.new(@post, include: [:user]).serialized_json
    else
      render 'global/error', locals: {code: 707, message: 'Unable to create the post'}
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      format.json{
        if @post.update(post_params)
          render :json => PostSerializer.new(@post, include: [:user]).serialized_json
        else
          render 'global/error', locals: {code: 707, message: 'Unable to update the post'}
        end
      }
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    render :json => PostSerializer.new(@post, include: [:user]).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_user.posts.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :active_status)
    end
end