namespace :articles do
  desc "Clean up articles with 6 or more reports"
  task cleanup: :environment do
    puts "Starting article cleanup task..."
    
    articles_to_delete = Article.where('reports_count >= 6')
    count = articles_to_delete.count
    
    if count > 0
      puts "Found #{count} articles to delete"
      articles_to_delete.find_each do |article|
        puts "Deleting article: #{article.title} (Reports: #{article.reports_count})"
        article.destroy
      end
      puts "Cleanup completed. #{count} articles deleted."
    else
      puts "No articles found for cleanup."
    end
  end

  desc "Archive articles with 3 or more reports"
  task archive: :environment do
    puts "Starting article archiving task..."
    
    articles_to_archive = Article.where('reports_count >= 3 AND archived = false')
    count = articles_to_archive.count
    
    if count > 0
      puts "Found #{count} articles to archive"
      articles_to_archive.find_each do |article|
        puts "Archiving article: #{article.title} (Reports: #{article.reports_count})"
        article.archive!
      end
      puts "Archiving completed. #{count} articles archived."
    else
      puts "No articles found for archiving."
    end
  end
end