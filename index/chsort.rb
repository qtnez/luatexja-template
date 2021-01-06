#!/usr/bin/env ruby
# vim:ts=2 sw=2 et
# chsort.rb : 將中文排序
# Edward G.J. Lee (09/12/07)

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
  puts "Usage: #{pname} your characters"
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

$KCODE = 'u'
# 區分一個層次來分別排序
Sym = []  # 符號及歐州字母
Eng = []  # 英數字
Han = {}  # 漢字
require 'rubygems'
require 'sqlite3'
require 'iconv'

# 大量資料運作時，database 維持一直開著備查較有效率。
DB = SQLite3::Database.open("cstrokes.db")

def strokes(c)
  ucs = c.unpack('U*')[0]
  DB.execute("SELECT stroke FROM st WHERE uni=#{ucs};").to_s
end

if enc =~ /UTF/i
  open(ARGV[0]).each do |line|
    if line[0,1].match(/^\w/)
      Eng << line
    elsif line[0,1].match(/^\\|^%|^\$/)
      Sym << line
    else
      Han.store(line, strokes(line).to_i)
    end
  end
  puts Sym.sort
  puts Eng.sort_by{|l| l.downcase}
  Han.sort{|a,b| a[1]<=>b[1]}.each do |a|  # 完全相同的列會捨去
    print a[0]
  end
elsif enc =~ /BIG/i
  open(ARGV[0]).each do |line|
    if line[0,1].match(/^\w/)
      Eng << line
    elsif line[0,1].match(/^\\|^%|^\$/)
      Sym << line
    else
      b5 = Iconv.new('utf-8', 'cp950').iconv(line)
      Han.store(b5, strokes(b5).to_i)
    end
  end
  puts Sym.sort
  puts Eng.sort_by{|l| l.downcase}
  Han.sort{|a,b| a[1]<=>b[1]}.each do |a|
    print Iconv.new('cp950', 'utf-8').iconv(a[0])
  end
end

DB.close
