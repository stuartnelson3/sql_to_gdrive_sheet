require 'mysql2'

# Enter your MySQL connection details
client = Mysql2::Client.new(
  :host => "",
  :username => "",
  :password => "",
  :database => "",
)

# Enter your query. :stream => true means it will only fetch rows
# from MySQL when they're requested, which will use less memory
# on your computer.
query = "select * from slogs join tags on tags.slog_id=slogs.id order by created_at desc limit 5"
result = client.query(query, :stream => true)

result.each do |row|
  p row
end
