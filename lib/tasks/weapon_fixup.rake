namespace :weapon_fixup do
  task create_weapons: :environment do

	  User.all.each do |u|
	  	p 'Starting new user'

	    u.weapons.where(name: "Gun", user_id: u.id).first_or_create(damage: 50, ammo: 50, kill_count: 0)
	    u.weapons.where(name: "Shotgun", user_id: u.id).first_or_create(damage: 75, ammo: 30, kill_count: 0)
	    u.weapons.where(name: "Knife", user_id: u.id).first_or_create(damage: 100, kill_count: 0)
	    u.weapons.where(name: "Crowbar", user_id: u.id).first_or_create(damage: 50, kill_count: 0)
      u.weapons.where(name: "Turret", user_id: u.id).first_or_create(damage: 1, kill_count: 0, fire_rate: 5.0)
	  end
  end

  task create_turret: :environment do

  	User.all.each do |u|
  		u.weapons.where(name: "Turret", user_id: u.id).first_or_create(damage: 1, kill_count: 0, fire_rate: 5.0)
  	end

  end
end

namespace :skin_fixup do
	task create_skins: :environment do
	  User.all.each do |u|
	  	p 'Starting new user'
	    u.skins.where(name: '00').first_or_create(kill_count: 0)
	    u.skins.where(name: '01').first_or_create(kill_count: 0)
	    u.skins.where(name: '02').first_or_create(kill_count: 0)
	    u.skins.where(name: '03').first_or_create(kill_count: 0)
	    u.skins.where(name: '04').first_or_create(kill_count: 0)
	    u.skins.where(name: '05').first_or_create(kill_count: 0)
	    u.skins.where(name: '06').first_or_create(kill_count: 0)
	    u.skins.where(name: '07').first_or_create(kill_count: 0)
	    u.skins.where(name: '08').first_or_create(kill_count: 0)
	  end
	end
end

namespace :id_fixup do
	task user_ids: :environment do
	  User.all.each do |u|
	  	p 'Starting user'

	  	u.weapons.each do |weapon|
	  		weapon.update(user_id: u.id)
	  	end

	  	u.skins.each do |skin|
	  		skin.update(user_id: u.id)
	  	end
	  end
	end
end

namespace :total_fixup do
	task make_zero: :environment do
	  User.all.each do |u|
	  	p 'Starting user'

	  	if u.total_kills.nil?
	  		u.update(total_kills: 0)
	  	end

	  	if u.total_points.nil?
	  		u.update(total_points: 0)
	  	end

	  	if u.highest_round_reached.nil?
	  		u.update(highest_round_reached: 1)
	  	end
	  end
	end
end

