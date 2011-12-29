require "sinatra"
require "erubis"
require_relative "models.rb"

set :erubis, :escape_html => true
enable :sessions



before do
	@flash = Hash.new
	if Request.first(:address => @env["REMOTE_ADDR"], :time => Time.now.to_i).nil?
		Request.create(:address => @env["REMOTE_ADDR"], :time => Time.now.to_i)
	end
end

get "/" do
	@title = "Pre-College Assassins"
	@remaining = Player.all(:is_alive => true).count
	erubis :index
end

post "/" do
	code = params[:code]
	if code.include?("%g1 ")
		player = Player.first(:email => code.split("%g1 ").last)
		if player.nil?
			redirect to("/")
		else
			redirect to("/" + player.code)
		end
	else
		redirect to("/" + code)
	end
end

#get "/register" do
	#@title = "Register for Assassins"
	#@player = Player.new
	#erubis :register
#end

get "/robots.txt" do
	"User-agent: *\nDisallow: /"
end

=begin
post "/register" do
	@player = Player.new(:first_name => params[:first_name], :last_name => params[:last_name], :program => params[:program], :email => params[:email], :room => params[:room])
	name = @player.first_name + " " +  @player.last_name
	name.downcase!
	File.open("./ips.txt", "a") do |f|
		f.puts @env['REMOTE_ADDR'] + " -- #{name} -- #{Time.now.to_i}\n"
	end

	if name == "josh green"
		redirect to("http://www.precassassins.com/warning")
	end
	if @player.save
		text = File.read("words.txt")
		words = text.split("\n")

		# Get random word
		index = Random.rand(words.length)
		code = words[index]

		# Delete it from the word file
		words.delete(code)
		File.open("words.txt", "w") do |f|
			f.write(words.join("\n"))
		end

		@player.update(:code => code)
		@flash[:notice] = "Thanks for registering. Your code is #{code}. <b>Don't forget this!</b>"
		redirect to("/" + code)
	else
		erubis :register
	end
end
=end

get "/numbers" do
	Player.all.count.to_s
end

get "/leaderboard" do
	@title = "Leaderboard"
	@players = Player.all(:order => [ :kills.desc ], :is_alive => true)
	erubis :leaderboard
end

def mission_control
	@code = params[:code]
	@player = Player.first(:code => @code)
	
	if @player.nil? || !@player.is_alive
		redirect to("/")
	end

	unless @player.nil? or @player.target_id.nil?
		@target = Player.get(@player.target_id)
	end

	erubis :mission_control
end

get "/rules" do
	erubis :rules
end

get "/warning" do
	@title = "Warning"
	erubis :warning
end

get "/privacy" do
	erubis :privacy
end

get "/terms" do
	erubis :toc
end

get "/left-alive" do
	Player.all(:is_alive => true).count.to_s
end

# Catch-all.
# This definition goes LAST

get "/:code" do
	@title = "Mission Control"
	if Request.all(:address => @env["REMOTE_ADDR"], :time.gte => (Time.now.to_i - (60 * 10))).count > 25
		redirect to("/")
	end
	mission_control
end

def confirm_kill(p_code, t_code)
	player = Player.first(:code => p_code)
	target = Player.first(:code => t_code)

	if player and target and player.target_id == target.id
		player.update(:kills => player.kills + 1,
      				:target_id => target.target_id,
				:killed_players => player.killed_players + "," + target.first_name + " " + target.last_name,
				:time_target_assigned => Time.now.to_i)

		target.update(:is_alive => false)


		@flash[:notice] = "Your kill has been confirmed. You have been assigned a new target."
	else
		@flash[:notice] = "That's not the correct code."
	end
end

post "/:code" do
	@code = params[:code]
	target_code = params[:target_code]

	confirm_kill(@code, target_code)

	mission_control
end

not_found do
	"Ahhhhhhhhhhhhhhhh! (404)"
end
