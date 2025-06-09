class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  load_and_authorize_resource

  def index
    @articles = if params[:my_articles]
                  current_user.articles.not_archived
    else
                  Article.published.not_archived.includes(:user)
    end
    @articles = @articles.order(created_at: :desc)
  end

  def show
    authorize! :read, @article
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new
    end
  end

  def edit
    authorize! :update, @article
  end

  def update
    authorize! :update, @article

    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @article
    @article.destroy
    redirect_to articles_path, notice: "Article was successfully deleted."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :public, :image)
  end
end
