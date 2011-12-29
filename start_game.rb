require "mail"
require "./models.rb"

def email(player, target)
	Mail.deliver do
		from "missions@precassassins.com"
		to player.email
		subject "Assassins has begun!"
		body <<-eos
Good morning, Agent #{player.last_name}.

You have been personally selected as a candidate for the upcoming assignment by the Secretary. Due to the amount of qualified individuals for the mission the Organization has been unable to select only one agent and has initiated a search. Your mission, should you choose to accept it, is to survive. 

The Organization, per the Secretary's orders, has pitted every agent to another, and you will kill off the agent assigned to you and then will be assigned that agents target until only one agent survives receiving the upcoming assignment. When you were recruited for the Organization you were implanted with a chip so we could track your progress with assignments and terminate you if you were caught. The Secretary has instructed that if you remain alive for more than 72 hours without a kill you will be terminated automatically. You must work alone and follow all of the agency policies. The Organization does not want what happened last time to happen again, the Secretary was not amused, take the time to review your <a href="http://www.precasssassins.com/rules">training handbook</a> before you embark on the mission.

You have been assigned the following target:

FIRST NAME: #{target.first_name}
LAST NAME: #{target.last_name}
PROGRAM: #{target.program}
PRIMARY RESIDENCE: #{target.room}

When you have killed your target meet me with the pass code at <a href="http://www.precassassins.com/#{player.code}">mission control</a>. As always, should you be caught or killed, the Organization will disavow all knowledge of your actions and you should release your pass code (#{player.code}) to notify us of your passing.

Goodbye and Good Luck Agent #{player.last_name}
		
eos
	end
end

puts "The game is starting!"

players = Player.all.shuffle

players[0...-1].each_with_index do |player, i|
	player.update(:target_id => players[i + 1].id, :time_target_assigned => Time.now.to_i)
	email(player, Player.get(player.target_id))
end

players[-1].update(:target_id => players[0].id, :time_target_assigned => Time.now.to_i)
email(players[-1], Player.get(players[0].id))

puts "Game has been started!"
