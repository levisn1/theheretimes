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

  # def create
  #   @bookmark = current_user.bookmarks.new(bookmarks_params)
  #   if @bookmark.save
  #     redirect_to bookmarks_path
  #   end
  # end


  def create
    @bookmark = current_user.bookmarks.new(bookmarks_params)
    if @bookmark.save
      respond_to do |format|
      format.html { redirect_to articles_path }
      format.js {}
      end
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to bookmarks_path
  end


  private

  def bookmarks_params
    params.permit(:user_id, :url, :city, :title, :category, :source, :lat, :lng)
  end

end
