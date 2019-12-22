require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox
def url(page)
  "https://www.wsl.waseda.jp/syllabus/JAA101.php"
end

def syllabus_url(pkey)
  "https://www.wsl.waseda.jp/syllabus/JAA104.php?pKey=#{pkey}&pLng=jp"
end

# 最初のページで全学科を選択して授業一覧を表示するところまで
driver.get url(1)
driver.find_element(:id, 'p_bunya1').click
driver.find_element(id: "big_select_all").click
driver.find_element(name: "btnSubmit").click

a_tags = driver.find_elements(tag_name: "a")
a_tags[5].click
sleep 3

# 1から6ページ目まで
5.times do |i|

  items = driver.find_elements(tag_name: "tr")
  pagenation = items[items.length - 1]
  pagenation_buttons = pagenation.find_elements(tag_name: "td")


  # puts pagenation_buttons.length

  # pagenation_buttons.each do |btn|
  #   puts btn.text
  # end

  # pagenation_numbers = pagenation[1] # 1, ..., 2, 3, 4, 5, 6, 7, 8

  # 最初の2つと最後の2つは授業の情報ではないのでいらない
  items.delete(items[0])
  items.delete(items[0])
  items.delete(items[items.length-1])
  items.delete(items[items.length-1])
  items.each do |item|
    infos = item.find_elements(tag_name: "td")
    infos.each do |info|
      if info.text == " " # データが入っていない場合の比較
        puts "仮テキスト"
      else
        puts info.text
      end

      # シラバスのURLを取得
      begin
        link = info.find_element(tag_name: "a")
        code = link.attribute(:onclick)
        array = code.split("'")
        pkey = array[3].to_s # もともとは "post_submit('JAA104DtlSubCon', '1200007B110220201200007B1112')" という形だったものを、splitで分割し、そのarray[3]がpkeyとなる
        puts syllabus_url(pkey)
      rescue => e
      end
    end
    puts "-------"
  end
  sleep 2
  pagenation_buttons[i+1].click # 最初はページ1, 次は2, ... ページ5+1=6まで
end

# 6から373ページ目まで
368.times do |i|

  items = driver.find_elements(tag_name: "tr")
  # puts items.length
  pagenation = items[items.length - 1]
  pagenation_buttons = pagenation.find_elements(tag_name: "td")
  # puts pagenation_buttons.length

  # pagenation_buttons.each do |btn|
  #   puts btn.text
  # end

  # pagenation_numbers = pagenation[1] # 1, ..., 3767, 3768, 3769, 3770, 3771, 3771(表示), 3772, 3773...

  # 最初の2つと最後の2つは授業の情報ではないのでいらない
  items.delete(items[0])
  items.delete(items[0])
  items.delete(items[items.length-1])
  items.delete(items[items.length-1])

  items.each do |item|
    infos = item.find_elements(tag_name: "td")
    infos.each do |info|
      if info.text == " " # データが入っていない場合の比較
        puts "仮テキスト"
      else
        puts info.text
      end
      begin
        link = info.find_element(tag_name: "a")
        code = link.attribute(:onclick)
        array = code.split("'")
        pkey = array[3].to_s
        puts syllabus_url(pkey)
      rescue => e
      end
    end
    puts "-------"
  end

  sleep 1
  pagenation_buttons[7].click # 7番目がつねに、現在の表示ページの次になっている
end
# ここまでで、ページ373までが終了。そして、画面には374が表示されている


# 374から378ページ目まで
4.times do |i|

  items = driver.find_elements(tag_name: "tr")
  # puts items.length
  pagenation = items[items.length - 1]
  pagenation_buttons = pagenation.find_elements(tag_name: "td")
  # puts pagenation_buttons.length

  # pagenation_buttons.each do |btn|
  #   puts btn.text
  # end

  # pagenation_numbers = pagenation[1] # 1, ..., 3767, 3768, 3769, 3770, 3771, 3771(表示), 3772, 3773...

  # 最初の2つと最後の2つは授業の情報ではないのでいらない
  items.delete(items[0])
  items.delete(items[0])
  items.delete(items[items.length-1])
  items.delete(items[items.length-1])

  items.each do |item|
    infos = item.find_elements(tag_name: "td")
    infos.each do |info|
      if info.text == " " # データが入っていない場合の比較
        puts "仮テキスト"
      else
        puts info.text
      end

      begin
        link = info.find_element(tag_name: "a")
        code = link.attribute(:onclick)
        array = code.split("'")
        pkey = array[3].to_s
        puts syllabus_url(pkey)
      rescue => e
      end
    end
    puts "-------"
  end
  sleep 2
  pagenation_buttons[8 + i].click # 7番目がつねに、現在の表示ページの次になっている
end


driver.quit
