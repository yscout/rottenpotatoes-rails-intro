class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if params[:ratings].blank? && params[:sort_by].blank? &&
      (session[:ratings].present? || session[:sort_by].present?)
     redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings]) and return
    end

    @ratings_to_show =
      if params[:ratings].present?
        params[:ratings].keys
      else
        @all_ratings
      end

    allowed_sort_columns = %w[title release_date]
    @sort_by = allowed_sort_columns.include?(params[:sort_by]) ? params[:sort_by] : nil

    @movies = Movie.with_ratings(@ratings_to_show)
    @movies = @movies.order(@sort_by => :asc) if @sort_by.present?

    session[:ratings] = @ratings_to_show.map { |r| [r, '1'] }.to_h
    session[:sort_by] = @sort_by
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
