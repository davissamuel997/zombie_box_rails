namespace :weapon_fixup do
  task create_weapons: :environment do

	  User.all.each do |u|
	  	p 'Starting new user'

	  	if u.weapons.count == 0
		    u.weapons.create(name: "Gun", damage: 50,
		                        ammo: 50, kill_count: 0)

		    u.weapons.create(name: "Shotgun", damage: 75,
		                        ammo: 30, kill_count: 0)

		    u.weapons.create(name: "Knife", damage: 100,
		                        kill_count: 0)

		    u.weapons.create(name: "Crowbar", damage: 50,
		                        kill_count: 0)
	  	end
	  end
  end
end
