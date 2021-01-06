#!/usr/bin/env ruby
# vim:ts=2 sw=2 et
# strokes.rb : 判斷 UTF-8 字元的筆劃數。Unihan 中有許多字並無筆劃數。
# wget http://unicode.org/Public/UNIDATA/Unihan.txt
# Edward G.J. Lee (09/03/07)

# 判斷 locale 以便決定要用哪一種筆劃表格。
locale = `echo $LC_ALL`.chomp
if locale == ""
  locale = `echo $LC_CTYPE`.chomp
  if locale == ""
    locale = `echo $LANG`.chomp
  end
end
enc = locale.split('.')[1]

pname = File.basename($0)
if ARGV.length == 0 or ARGV[0] =~ /-*[Hh].*/
  puts
  puts "Usage: #{pname} your_character"
  puts
  exit
elsif (enc !~ /UTF|BIG/i)
  puts
  puts "I can support UTF-8 and Big-5 locale only."
  puts
  exit
elsif !File.exist?("cstrokes.db") || File.zero?("cstrokes.db")
  puts
  puts "Please build database from Unihan.txt:"
  puts "http://unicode.org/Public/UNIDATA/Unihan.txt"
  puts
  exit
end

require 'rubygems'
require 'sqlite3'
require 'iconv'

# 大量資料運作時，database 維持一直開著備查較有效率。
DB = SQLite3::Database.open("cstrokes.db")

def strokes(c)
  ucs = c.unpack('U*')
  puts DB.execute("SELECT stroke FROM st WHERE uni=#{ucs};")
end

# 字元筆劃數分佈表，區分 UTF-8 及 Big-5 兩種表格。
# UTF-8 的部份使用 sqlite3，Big-5 的部份，由於有規律，直接使用範圍條件。

if enc =~ /UTF/i
  $KCODE='u'
  strokes(ARGV[0].chomp)
elsif enc =~ /BIG/i
  b5 = Iconv.new('utf-8', 'cp950').iconv(ARGV[0])
  strokes(b5)
end
DB.close
