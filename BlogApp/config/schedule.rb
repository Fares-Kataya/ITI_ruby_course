every 5.minutes do
  runner "ArticleCleanupJob.perform_later"
end

set :environment, 'development'
set :output, 'log/cron.log'