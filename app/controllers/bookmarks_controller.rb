class BookmarksController < ApplicationController

  def index
    @user = current_user
    @bookmarks = current_user.bookmarks
    # authorize @bookmarks
  end

  # def new
  #   @bookmark = current_user.bookmarks.new
  #   authorize @bookmark
  # end

  def create
    @bookmark = current_user.bookmarks.new(bookmarks_params)
    if @bookmark.save
      redirect_to bookmarks_path
    end
  end

  def destroy
    @bookmark.destroy
    redirect_to bookmarks_path
  end

  def edit
  end

  def update
  end

  def show
  end


  private

  def bookmarks_params
    params.permit(:user_id, :URL, :title, :category, :lat, :lng)
  end

end
