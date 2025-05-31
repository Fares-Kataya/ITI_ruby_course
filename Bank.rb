require 'date'

module Logger
  def log(log_type, message) 
    timestamp = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S%z")
    File.open("app.logs", "a+") do |f|
      f.puts("#{timestamp} -- #{log_type.downcase} -- #{message}")
    end
  end

  [:info, :warning, :error].each do |type|
    define_method("log_#{type}") do |message|
      log(type, message)
    end
  end
end

class User
  attr_accessor :name, :balance
  def initialize(name,balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value
  def initialize(user,value)
    @user = user
    @value = value
  end
end

class Bank
  def process_transactions(transaction_Arr,&block)
    raise "Method #{__method__} is abstract, please override this method"
  end
end

class CBABank < Bank
  include Logger
  def initialize(users)
    @users = users
  end

  def find_user_by_name(name)
    @users.find{|user| user.name == name}
  end

  def process_transactions(transaction_Arr, &block)
    transaction_summary = transaction_Arr.map do |tr|
      "User #{tr.user.name} transaction with value #{tr.value}"
    end.join(", ")

    log_info("Processing Transactions #{transaction_summary}...")

    transaction_Arr.each do |t|
      begin
        bank_user = find_user_by_name(t.user.name)

        if bank_user.nil?
          log_error("User #{t.user.name} transaction with value #{t.value} failed with message #{t.user.name} not exist in the bank!!")
          puts "Call endpoint for failure of User #{t.user.name} transaction with value #{t.value} with reason #{t.user.name} not exist in the bank!!"
          block.call(:failure, t) if block_given?
          next
        end

        if bank_user.balance + t.value < 0
          log_error("User #{bank_user.name} transaction with value #{t.value} failed with message Not enough balance")
          puts "Call endpoint for failure of User #{bank_user.name} transaction with value #{t.value} with reason Not enough balance"
          block.call(:failure, t) if block_given?
          next
        end

        bank_user.balance += t.value
        log_info("User #{t.user.name} transaction with value #{t.value} succeeded")
        puts "Call endpoint for success of User #{t.user.name} transaction with value #{t.value}"

        if bank_user.balance == 0 
          log_warning("#{t.user.name} has 0 balance")
        end

        block.call(:success, t) if block_given?

      rescue => e
        log_error("User #{t.user.name} transaction with value #{t.value} failed with message #{e.message}")
        block.call(:failure, t) if block_given?
      end
    end
  end
end

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

bank = CBABank.new(users)

bank.process_transactions(transactions) do |status, transaction|
  case status
  when :success
    puts "Callback: Transaction succeeded for #{transaction.user.name} with value #{transaction.value}"
  when :failure
    puts "Callback: Transaction failed for #{transaction.user.name} with value #{transaction.value}"
  end
end