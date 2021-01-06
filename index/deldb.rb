#!/usr/bin/env ruby
# vim:ts=2 sw=2 et
# adddb.rb : 刪除 cstrokes.db 內容
# Edward G.J. Lee (09/05/07)

if ARGV.length != 1
  puts
  puts "Usage: #{File.basename($0)} hex"
  puts
  exit
end

require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.open("cstrokes.db")
u = ARGV[0].hex
if db.execute("SELECT stroke FROM st WHERE uni=#{u};") == []
  puts "We don't have this record."
else
  db.execute("DELETE FROM st WHERE uni=#{u};")
end
db.close
