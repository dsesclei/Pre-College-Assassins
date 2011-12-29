require "./models.rb"
require "awesome_print"

inactive = Player.all(:time_target_assigned.lte => Time.now.to_i - (60 * 60 * 72), :is_alive => true)

inactive.each do |p|
	assassin = Player.first(:target_id => p.id, :is_alive => true)
	assassin.update(:target_id => p.target_id, :time_target_assigned => Time.now.to_i)
	p.update(:is_alive => false)
end

