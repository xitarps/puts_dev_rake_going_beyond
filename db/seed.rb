
puts 'rodando seed.rb'
User.find_or_create_by(email: 'puts_dev@puts_dev.com')
puts 'fim do seed.rb'