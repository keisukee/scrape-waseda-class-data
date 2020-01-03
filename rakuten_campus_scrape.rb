require 'open-uri'
require 'nokogiri'
require "selenium-webdriver"
require "dotenv"

Dotenv.load

def url(page)
  # 早稲田大学の授業評価一覧ページ。だいたい75000件ぐらいのデータがあり、1ページあたり10件掲載されている。2020/01/03現在では、7567ページまである。2005年からデータがあるが、授業内容・教授・授業名などが変わっていると思われるので、すべてのデータを使うのは危険。直近数年のデータだけでもいいかも
  "https://campus.nikki.ne.jp/?module=lesson&action=index&univ=%C1%E1%B0%F0%C5%C4%C2%E7%B3%D8&lname=&fname=&lesson_name=&faculty1=&id=&order=1&page=#{page}"
end

options = Selenium::WebDriver::Firefox::Options.new
options.add_argument('-headless')
driver = Selenium::WebDriver.for :firefox, options: options
login_url = "https://www.nikki.ne.jp/login/?return_url_nikki=https://campus.nikki.ne.jp/"
driver.get login_url
inputs = driver.find_elements(:class, 'textBox')

inputs[0].send_keys ENV['RAKUTEN_EMAIL']
inputs[1].send_keys ENV['RAKUTEN_PASSWORD']

login_btn = driver.find_elements(:class, 'loginButton')
login_btn[0].click # ログイン

sleep 1


7500.times do |i|
  driver.get url(i)

  class_items = driver.find_elements(:class, 'list')
  class_items.each do |class_item|
    class_name = class_item.find_element(:tag_name, 'dt')
    if class_name.find_element(:tag_name, 'a').text == ""
    puts class_name.find_element(:tag_name, 'a').text

    class_info = class_item.find_element(:class, 'college')
    puts class_info.text

    class_content = class_item.find_element(:class, 'value')
    class_content_images = class_content.find_elements(:tag_name, 'img')

    puts "内容充実度:" + class_content_images[0].attribute(:alt)
    puts "単位取得度:" + class_content_images[1].attribute(:alt)

    class_specific_info = class_item.find_element(:class, 'apartContents')
    class_specific_info_attend = class_specific_info.find_element(:class, 'attend')
    class_specific_info_book = class_specific_info.find_element(:class, 'book')
    class_specific_info_test = class_specific_info.find_element(:class, 'test')
    class_specific_info_message = class_specific_info.find_element(:class, 'message')

    puts "出席:" + class_specific_info_attend.text
    puts "教科書:" + class_specific_info_book.text
    puts "テスト情報:" + class_specific_info_test.text
    puts "メッセージ:" + class_specific_info_message.text

    class_content = class_item.find_element(:class, 'subject')
    class_content_date = class_content.find_element(:tag_name, 'span')
    puts "日付:" + class_content_date.text
  end
end

# 3.times do |i|

#   items = driver.find_elements(tag_name: "tr")
#   pagenation = items[items.length - 1]
#   pagenation_buttons = pagenation.find_elements(tag_name: "td")

#   # 最初の2つと最後の2つは授業の情報ではないのでいらない
#   items.delete(items[0])
#   items.delete(items[0])
#   items.delete(items[items.length-1])
#   items.delete(items[items.length-1])

#   items.each do |item|
#     infos = item.find_elements(tag_name: "td")
#     infos.each do |info|
#       if info.text == " " # データが入っていない場合の比較
#         puts "仮テキスト"
#       else
#         puts info.text
#       end

#       begin
#         link = info.find_element(tag_name: "a")
#         code = link.attribute(:onclick)
#         array = code.split("'")
#         pkey = array[3].to_s
#         puts syllabus_url(pkey)
#       rescue => e
#       end
#     end
#     puts "-------"
#   end
#   sleep 2
#   pagenation_buttons[8 + i].click # 7番目がつねに、現在の表示ページの次になっている
# end


driver.quit

# charset = nil
# 100.times do |i|
#   html = open(url(i)).read
#   doc = Nokogiri::HTML.parse(html, nil, charset)
#   doc.css('ul.list').each do |node|
#     puts node.css('dt.lecture/a').inner_text
#   end
# end
