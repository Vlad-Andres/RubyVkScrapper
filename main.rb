require 'byebug'  
require 'yaml'

load 'vk.rb'
    include VkBot

    CONFIG = YAML::load_file( 'config.yml' )
    #preferences settings
    @username = CONFIG["username"]
    @password = CONFIG["password"]
    @gender = CONFIG["gender"] #Male/Female
    @start_age = CONFIG["start_age"]
    @end_age = CONFIG["end_age"]
    @country = CONFIG["country"]
    @city = CONFIG["city"]
    @online = CONFIG["online"] # true/false , apply filter 'online now'

    def test
        fruits = Array.new
        p1 = {
            name: "name1",
            url: "vk.com/dsad"
        }
        fruits << p1
        p2 = {
            name: "name3",
            url: "vk.com/ds4ad"
        }
        fruits << p2
        #serialized_array = Marshal.dump(fruits)
        serialized_array = fruits.to_json
        File.open('fruits_file.json', 'w') {|f| f.write(serialized_array) }
        # read the file back
        fruits = JSON.parse(File.read('fruits_file.json'),{:symbolize_names => true})
        byebug
    end

    def handler

        unless !['Male', 'Female', 'Any'].include? @gender 
            puts "******************************"
            puts "*Welcome to Vk scrapper*" 
            puts "******************************" 
            puts
            puts "trying..."
            #test
            puts VkBot.login(@username,@password)
            puts "Check the browser if login was successful."
            puts "Want to collect profiles? (y/n - use exisitng source file) "
            if gets.chomp == "y" 
                puts "Configuring search.."
                VkBot.configSearch(@gender,@start_age,@end_age,@country,@city,@online)
                puts "Collecting profiles.."
                VkBot.collect
                puts "Want to send them a message? y/n"
                ans = gets
                if ans.chomp == "y"
                    puts "To how many persons? (empty for all)"
                    count = gets.chomp
                    if !count.empty?
                        msg_src = JSON.parse(File.read('msg.json'))
                        VkBot.send_message(count,nil,msg_src)
                    else 
                        VkBot.send_message(nil,nil,msg_src)
                    end
                end
            else
                puts "Loading profiles from the file ..."
                prof_src = JSON.parse(File.read('profiles.json'),{:symbolize_names => true})
                msg_src = JSON.parse(File.read('msg.json'))
                VkBot.send_message(nil,prof_src, msg_src)
            end
        end
        puts "Goodbye"
    end
handler

#VkBot.execute