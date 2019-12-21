require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox
def url(page)
  "https://www.wsl.waseda.jp/syllabus/JAA101.php"
end

# 最初のページで全学科を選択して授業一覧を表示するところまで
driver.get url(1)
driver.find_element(:id, 'p_bunya1').click
driver.find_element(id: "big_select_all").click
driver.find_element(name: "btnSubmit").click

# 授業ページを延々と遡る
10.times do |i|

  items = driver.find_elements(tag_name: "tr")
  puts items.length

  pagenation = items[items.length-1]

  # 最初の2つと最後の2つはいらない
  items.delete(items[0])
  items.delete(items[0])
  items.delete(items[items.length-1])
  items.delete(items[items.length-1])

  items.each do |item|
    infos = item.find_elements(tag_name: "td")
    infos.each do |info|
      puts info.text
    end
  end

  numbers = pagenation.find_elements(tag_name: "td")
  numbers[7].click
end


sleep 5

driver.quit
