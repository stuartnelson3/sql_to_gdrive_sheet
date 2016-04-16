require 'mysql2'
# Follow instructions here: https://github.com/gimite/google-drive-ruby
require "google/api_client"
require 'google_drive'

# Enter your MySQL connection details
client = Mysql2::Client.new(
  :host => "",
  :username => "",
  :password => "",
  :database => "",
)

# This is unsafe, but OS X is stupid.
if RUBY_PLATFORM.include? "darwin"
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end

session = GoogleDrive.saved_session("config.json")
# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=[spreadsheet-key]
ws = session.spreadsheet_by_key("").worksheets[0]

# Enter your query. :stream => true means it will only fetch rows
# from MySQL when they're requested, which will use less memory
# on your computer.
query = "select * from slogs join tags on tags.slog_id=slogs.id order by created_at desc limit 5"
result = client.query(query, :stream => true)

result.each_with_index do |row, idx|
  # 0-based index. Increment by 2 so that we never write to row 0
  # (doesn't exist) or row 1 (the header)
  ws_row = idx + 2
  ws[ws_row, 1] = row["id"]
  ws[ws_row, 2] = row["message"]
  ws[ws_row, 3] = row["created_at"].to_s
  ws[ws_row, 4] = row["name"]
  ws.save
end
