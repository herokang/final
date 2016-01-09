class Std_controller < ApplicationController

  def login

    @id = params[:id]
    @pwd = params[:pwd]
    ret = Std.profile(@id, @pwd)
    ret = "{'data' : #{ret[0]}, 'errno':#{ret[1]}}"
    respond_to do |format|
      format.html
      format.json { render json: ret, status: :ok }
    end


    @sort_base = params[:sort_base]
    if @sort_base == nil
      @sort_base = "title"
      if !session[:sort_base].nil?
        @sort_base = session[:sort_base]
      end
      should_redirect = true
    end
    session[:sort_base] = @sort_base

    @all_ratings = Movie.ratings
    @ratings = params[:ratings]
    if @ratings == nil || @ratings.empty?
      @ratings = @all_ratings
      if !session[:ratings].nil? && !session[:ratings].empty?
        @ratings = session[:ratings]
      end
      should_redirect = true
      # elsif @ratings.kind_of?(Hash)
      #   @ratings = @ratings.keys
    end
    session[:ratings] = @ratings

    if should_redirect
      flash.keep
      redirect_to movies_path(:sort_base => @sort_base, :ratings => @ratings)
    end


    if @sort_base == "title"
      tmp_movies = Movie.order(@sort_base)
    elsif @sort_base == "release_date"
      tmp_movies = Movie.order(@sort_base)
    else
      tmp_movies = Movie.all
    end

    if  !@ratings.nil?
      @ratings = @ratings.map { |r| r[0] }
      @movies = tmp_movies.where(rating: @ratings)
    else
      @movies = tmp_movies.all
    end

  end
end