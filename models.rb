require "data_mapper"

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/../assassins.db")

class Player
	include DataMapper::Resource

	property :id, Serial
	property :first_name, String, :required => true,
					 :messages => {
							:presence => "We need your first name.",
					 }

	property :last_name, String, :required => true,
					 :messages => {
							:presence => "We need your last name.",
					 }

	property :program, String, :required => true
	property :email, String, :required => true, :unique => true, :format => :email_address,
					 :messages => {
							:presence => "In case of a rules change, we need your email address.",
							:is_unique => "We already have that email. If this is because you messed up on submitting the form, email either dave@sescleifer.com or aramael1@gmail.com",
							:format => "Doesn't look like an email address to me..."
					 }
	property :room, String, :required => true, :messages => { :presence => "We need your room number." }
	property :tower, String
	property :is_alive, Boolean, :default => true
	property :kills, Integer, :default => 0
	property :killed_players, String, :default => "", :length => 99999
	property :target_id, Integer
	property :time_target_assigned, Integer
	property :code, String

#	validates_format_of :room, :with => /^\d{1,3}(A|B|C|D|E|a|b|c|d|e)$/, :message => "Please enter a valid room number."
	validates_within :program,
									 :set => ["Drama", "Advanced Placement / Early Action", "Game Academy", "Architecture", "Music", "Pre-College Counselors", "Art and Design", "SAMS"],
									 :message => "Invalid program."
	def self.print_out
		Player.all.each do |p|
			puts "#{p.last_name}, #{p.first_name}, #{p.room}, #{p.email}"
		end
		nil
	end 
end

class Request
	include DataMapper::Resource

	property :id, Serial
	property :address, String
	property :time, Integer
end





DataMapper.finalize
