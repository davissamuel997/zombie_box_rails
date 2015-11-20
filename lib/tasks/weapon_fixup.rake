namespace :weapon_fixup do
  task create_weapons: :environment do

	  User.all.each do |u|
	  	p 'Starting new user'

	  	if u.weapons.count == 0
		    u.weapons.create(name: "Gun", damage: 50,
		                     ammo: 50, kill_count: 0, 
		                     user_id: u.id)

		    u.weapons.create(name: "Shotgun", damage: 75,
		                     ammo: 30, kill_count: 0, 
		                     user_id: u.id)

		    u.weapons.create(name: "Knife", damage: 100,
		                     kill_count: 0, user_id: u.id)

		    u.weapons.create(name: "Crowbar", damage: 50,
		                     kill_count: 0, user_id: u.id)
	  	end
	  end
  end
end

namespace :skin_fixup do
	task create_skins: :environment do
	  User.all.each do |u|
	  	p 'Starting new user'

	  	if u.skins.count == 0
		    u.skins.create(name: '00', kill_count: 0)
		    u.skins.create(name: '01', kill_count: 0)
		    u.skins.create(name: '02', kill_count: 0)
		    u.skins.create(name: '03', kill_count: 0)
		    u.skins.create(name: '04', kill_count: 0)
		    u.skins.create(name: '05', kill_count: 0)
		    u.skins.create(name: '06', kill_count: 0)
		    u.skins.create(name: '07', kill_count: 0)
		    u.skins.create(name: '08', kill_count: 0)
	  	end
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
	  end
	end
end
