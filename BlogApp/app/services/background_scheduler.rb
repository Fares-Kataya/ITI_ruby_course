class BackgroundScheduler
  def self.start
    Thread.new do
      loop do
        begin
          Rails.logger.info "Running article cleanup task..."
          ArticleCleanupJob.perform_now
          sleep 300 # Sleep for 5 minutes
        rescue => e
          Rails.logger.error "Error in background scheduler: #{e.message}"
          sleep 60
        end
      end
    end
  end
end