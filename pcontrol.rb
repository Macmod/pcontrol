require 'telegram/bot'
require 'securerandom'

token = '<bot_token>'
pics = Dir["img/*.png"]

authorized = {}
def set_random_password()
    $password = SecureRandom.base64(128)
    puts "Password: #{$password}"
end

set_random_password()
Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
        puts "#{message.from.first_name}> #{message.text}"

        cmd   = message.text.split()
        kill  = false
        reply = nil

        if not authorized.key?(message.from.id)
            case cmd[0]
            when '/start'
                reply = "Hello, #{message.from.first_name}! (=^-ω-^=)"
            when '/login'
                if cmd[1] == $password
                    reply = "Authorized #{message.from.id}! (˵Φ ω Φ˵)"
                    authorized[message.from.id] = 1
                end
            end
        else
            case cmd[0]
            when '/renew'
                reply = "Renewed password."
                set_random_password()
            when '/logout'
                reply = "Logged out."
                authorized.delete(message.from.id)
            when '/kill'
                reply = "Killed."
                kill = true
            else
                begin
                    reply = %x(#{message.text})
                rescue => error
                    reply = error.message
                end
            end
        end

        if reply.nil?
            pic = pics.shuffle()[0]
            puts "> #{pic}"

            bot.api.send_photo(
                chat_id: message.chat.id,
                photo: Faraday::UploadIO.new(pic, 'image/jpeg')
            )
        else
            puts "> #{reply}"
            if reply.empty? then reply = "Nothing." end

            begin
                bot.api.send_message(
                    chat_id: message.chat.id,
                    text: reply
                )
            rescue => error
                bot.api.send_message(
                    chat_id: message.chat.id,
                    text: "I can't answer that."
                )

                puts "#{error}"
            end
        end

        if kill then exit end
    end
end
