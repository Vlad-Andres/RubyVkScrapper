require 'nokogiri'
require 'httparty'   
require 'watir'
require 'json'

#Лимит на 20 сообщений восстанавливается приблизительно через 7,5 часов, при стараниях можно успеть три раза за сутки отправить по 20 ссобщений
module VkBot
    
    def login(username, password)
        Selenium::WebDriver::Chrome::Service.driver_path="./chromedriver.exe"
        @browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600']}})
        @browser.goto("https://vk.com/")

        @browser.wait
        email_f = @browser.text_field id: 'index_email'
        pass_f = @browser.text_field id: 'index_pass'
        login_b = @browser.button id: 'index_login_button'
           
        email_f.set("#{username}")
        sleep(1)
        pass_f.set("#{password}")
        sleep(0.4)
        login_b.click

        @browser.wait
        puts @browser.url
    end

    def configSearch(gender,age_f,age_t,country,city, online)
        @browser.wait
        #click friends
        @browser.element(:xpath => "//*[@id='l_fr']/a/span/span[2]").click
        @browser.wait
        sleep(0.3)

        #click 'find friends'
        @browser.element(:xpath => "//*[@id='invite_button']").click
        @browser.wait
        sleep(0.3)
        
        #click search parameters
        @browser.element(:xpath => "//*[@id='search_filters_minimized']").click  # parameters drop down menu
        sleep(0.3)

        #click female selector
        @browser.element(:xpath => "(//*[text() = '#{gender}' ])").click
        sleep(0.2)

        #insert country
        @browser.element(:xpath => "//*[@id='cCountry']/div[1]").click
        sleep(0.2)
        @browser.text_field(class: 'focused').set(country)
        sleep(0.1)
        @browser.send_keys :enter
        sleep(0.1)
        @browser.send_keys :tab
        sleep(0.1)
        @browser.text_field(class: 'focused').set(city)
        sleep(0.1)
        @browser.send_keys :enter
        sleep(0.5)

        #select status
        @browser.element(:xpath => "//*[@id='cStatus']/div[1]").click
        sleep(0.1)
        @browser.send_keys "a" # actively searching 
        sleep(0.1)
        @browser.send_keys :enter
        
        #select age
        @browser.element(:xpath => "(//*[@class='range_to'])[1]").click 
        (age_f.to_i-13).times do 
            @browser.send_keys :arrow_down 
            sleep(0.2) 
        end
        @browser.send_keys :enter
        sleep(1)
        @browser.element(:xpath => "(//*[@class='range_to'])[2]").click 
        (age_t.to_i-age_f.to_i+1).times do 
            @browser.send_keys :arrow_down 
            sleep(0.2) 
        end
        @browser.send_keys :enter
        
        #checks box 'Online now'
        if online 
            @browser.element(:xpath => "(//*[text() = 'Online now' ])").click
            sleep(0.2)
        end

    end

    def collect
        100.times do 
            @browser.scroll.to :bottom
            sleep(0.1)
        end
        sleep(1)
        doc = Nokogiri::HTML.parse(@browser.html)
        @profiles = Array.new
        profiles_raw = doc.css('div.info') # 1 page of profiles 
        profiles_raw.each do |profile|
            p = {
                name: profile.css('a').text,
                url: "vk.com" + profile.css('a')[0].attributes["href"].value
            }
            @profiles << p
        end
        puts "Found #{@profiles.count} profiles, saving them to profiles.json ... "
        File.open("profiles.json", "w") { |file| file.write(@profiles.to_json)}
        puts "saved."
        
    end


    def sending_proc(msg_src,arr_len)
        puts "sending message.."
        random_num = rand(0.5..3.0).round(2)
        puts "pause random_num mills ..."
        sleep(random_num)
        @browser.wait
        if @browser.text.include?("Write message")
            @browser.button(class: 'profile_btn_cut_left').click
            msg = msg_src.sample
            puts msg
            @browser.send_keys msg
            @browser.button(id: 'mail_box_send').click
        end
        if random_num < 1 
            @browser.goto("vk.com")
            sleep(1)
        end
    end

    def send_message(count, prof_src, msg_src)
       
        if !prof_src.nil?
            @profiles = prof_src
        end
        arr_len = msg_src.length
        

        if count.nil?
            @profiles.each do |profile|
                @browser.goto(profile[:url])
                sending_proc(msg_src,arr_len)
            end
        else 
            for i in 0..count.to_i-1
                @browser.goto(@profiles[i][:url])
                sending_proc(msg_src,arr_len)
            end
        end
    end
end
