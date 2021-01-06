#!/usr/bin/env ruby
=begin
 vim:ts=2 sw=2 et
 builddb.rb : 製作 Unihan.txt 筆劃紀錄 db（sqlite3）
 ind 索引
 uni 碼位（十進位）
 stroke 總筆劃數

 似應增加部首的索引，排序時總筆劃數為第一優先，再來是部首排列
 再來才是依 ascii。或者，總筆劃數後就依 ascii 來排？UTF-8 的話
 依 ascii 就是自動依部首來排。所以，似無需部首欄位。

 應該是取第二個字的筆劃來排，如果相同，再取第三個字的筆劃來排，
 依此類推，如果下一個字可取，再依 ascii 來排，這樣較合理。

 Edward G.J. Lee (09/04/07)
=end

if File.exist?("cstrokes.db")
  puts "File(cstrokes.db) exist, abort!"
  exit
elsif !File.exist?("Unihan.txt")
  puts "Please get the Unihan.txt from:"
  puts "http://unicode.org/Public/UNIDATA/Unihan.txt"
  exit
end

require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new("cstrokes.db")
db.execute("CREATE TABLE st (ind INTEGER PRIMARY KEY, uni INT, stroke INT);")

open("Unihan.txt").each do |line|
  if line =~ /kTotalStrokes/ and line =~ /^U/
    a = line.split("\t")
    a[0].slice!(0..1)
    u = a[0].hex
    s = a[2].to_i
    db.execute("INSERT INTO st (uni,stroke) VALUES (#{u}, #{s});")
  end
end
db.close
