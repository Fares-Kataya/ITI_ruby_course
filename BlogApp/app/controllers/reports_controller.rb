class ReportsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @report = current_user.reports.build(report_params.merge(article: @article))

    if @report.save
      redirect_to @article, notice: 'Report submitted successfully.'
    else
      redirect_to @article, alert: @report.errors.full_messages.join(', ')
    end
  end

  private

  def report_params
    params.require(:report).permit(:reason, :description)
  end
end