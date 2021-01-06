#!/usr/bin/env ruby
# vim:ts=2 sw=2 et
# adddb.rb : 新增 cstrokes.db 內容
# Edward G.J. Lee (09/05/07)

if ARGV.length != 2
  puts
  puts "Usage: #{File.basename($0)} hex strokes"
  puts
  exit
end

require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.open("cstrokes.db")
u = ARGV[0].hex
s = ARGV[1].to_i
if db.execute("SELECT stroke FROM st WHERE uni=#{u};") == []
  db.execute("INSERT INTO st (uni,stroke) VALUES (#{u}, #{s});")
else
  puts "We have this record."
end
db.close
