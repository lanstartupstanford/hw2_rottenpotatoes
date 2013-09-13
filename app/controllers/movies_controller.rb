class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    @movies = Movie.all

    @ratings = params[:ratings]
    if !@ratings
      @ratings = session[:ratings]
    end
    if @ratings
      @selected_ratings = @ratings.keys
      @movies = Movie.filter_by_ratings(@selected_ratings)
      session[:ratings] = @ratings
    end

    @sort = params[:sort]
    if !@sort
      @sort = session[:sort]
    end
    @hilite = nil
    if @sort
      if @sort == "title"
        @movies.sort! do |a,b|
          a.title <=> b.title
        end
        @hilite = "title"
        session[:sort] = "title"
      elsif @sort == "release"
        @movies.sort! do |a,b|
          a.release_date <=> b.release_date
        end
        @hilite = "release"
        session[:sort] = "release"
      end   
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
