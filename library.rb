class Inventory
  attr_accessor :books
  def initialize()
    @books = Array.new
    loadBooks()
  end
  
  def loadBooks()
    if File.exist?("BooksLib.txt")
      File.readlines("BooksLib.txt").each do |line|
        line = line.strip
        next if line.empty?
        if line.match(/Book Title: (.*?),Author: (.*?),ISBN: (.*)/)
          title = $1
          author = $2
          isbn = $3
          book = Book.new(title, author, isbn)
          @books << book
        end
      end
    end
  end
  def listBooks
    books.map do |book|
      puts book.toString
    end
  end
  def addBook(book)
    existing_book = @books.find { |b| b.isbn == book.isbn }
    if existing_book
      existing_book.title = book.title
      existing_book.author = book.author
      existing_book.count += 1
    else
      @books << book
    end
    if File.exist?("BooksLib.txt")
      File.open("BooksLib.txt", "a") do |file|
        file.puts "Book Title: #{book.title},Author: #{book.author},ISBN: #{book.isbn}"
      end
    else
      File.open("BooksLib.txt", "w") do |file|
        file.puts "Book Title: #{book.title},Author: #{book.author},ISBN: #{book.isbn}"
      end
      puts "file not found"
    end
  end
  def removeBooks(isbn)
    books.delete_if { |book| book.isbn == isbn }
    File.open("BooksLib.txt", "w") do |file|
      @books.each do |book|
        file.puts "Book Title: #{book.title},Author: #{book.author},ISBN: #{book.isbn}"
      end
    end
  end
  
def sortBooksByISBN
  @books.sort_by! { |book| book.isbn.to_i }
end

def searchByTitle(title)
  @books.select { |book| book.title.downcase.include?(title.downcase) }
end

def searchByAuthor(author)
  @books.select { |book| book.author.downcase.include?(author.downcase) }
end

def searchByISBN(isbn)
  @books.find { |book| book.isbn == isbn }
end
end

class Book
  attr_accessor :title, :author, :isbn, :count
  def initialize(title,author,isbn)
    @title = title
    @author = author
    @isbn = isbn
    @count = 1
  end
  def toObj
    {title: @title, author: @author, isbn: @isbn}
  end
  def toString
    puts "Book Title: #{@title}\nAuthor: #{@author}\nISBN: #{isbn}"
  end
end

# book1 = Book.new("asdas","asdas","1")
# book2 = Book.new("potjeroitj","weqiotjopwe","2")
# book1Obj = book1.toObj
# puts book1Obj
bookInventory = Inventory.new
# bookInventory.addBook(book1)
# bookInventory.addBook(book2)
# bookInventory.listBooks
# bookInventory.removeBooks(2)

loop do
  puts "\n--- Book Inventory Menu ---"
  puts "1. Add Book"
  puts "2. List Books"
  puts "3. Remove Book"
  puts "4. Sort Books by ISBN"
  puts "5. Search by Title"
  puts "6. Search by Author"  
  puts "7. Search by ISBN"
  puts "8. Exit"
  print "Choose an option: "
  choice = gets.chomp
  
  if choice.empty?
    puts "Please enter a valid option."
    next
  end
  
  case choice
  when "1"
    print "Enter title: "
    title = gets.chomp
    print "Enter author: "
    author = gets.chomp
    print "Enter ISBN: "
    isbn = gets.chomp
    
    if title.empty? || author.empty? || isbn.empty?
      puts "Error: All fields are required."
    else
      book = Book.new(title, author, isbn)
      bookInventory.addBook(book)
    end
  when "2"
    bookInventory.listBooks
  when "3"
    print "Enter ISBN of book to remove: "
    isbn = gets.chomp
    if isbn.empty?
      puts "Error: ISBN cannot be empty."
    else
      bookInventory.removeBooks(isbn)
    end
  when "4"
    bookInventory.sortBooksByISBN
    puts "Books sorted by ISBN."
  when "5"
    print "Enter title to search: "
    title = gets.chomp
    if title.empty?
      puts "Error: Title cannot be empty."
    else
      results = bookInventory.searchByTitle(title)
      if results.empty?
        puts "No books found."
      else
        results.each { |book| book.toString }
      end
    end
  when "6"
    print "Enter author to search: "
    author = gets.chomp
    if author.empty?
      puts "Error: Author cannot be empty."
    else
      results = bookInventory.searchByAuthor(author)
      if results.empty?
        puts "No books found."
      else
        results.each { |book| book.toString }
      end
    end
  when "7"
    print "Enter ISBN to search: "
    isbn = gets.chomp
    if isbn.empty?
      puts "Error: ISBN cannot be empty."
    else
      result = bookInventory.searchByISBN(isbn)
      if result
        result.toString
      else
        puts "No book found."
      end
    end
  when "8"
    puts "Goodbye!"
    break
  else
    puts "Invalid choice. Please try again."
  end
end