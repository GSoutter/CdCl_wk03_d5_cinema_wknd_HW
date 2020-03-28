require_relative('../models/customer.rb')
require_relative('../models/film.rb')
require_relative('../models/ticket.rb')
require_relative('../models/screening.rb')

require('pry-byebug')

Ticket.delete_all()
Screening.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Downey', 'funds' => 50})
customer1.save()

customer2 = Customer.new({'name' => 'Daphney', 'funds' => 20})
customer2.save()

film1 = Film.new({'title' => 'Big', 'price' => 5.50})
film1.save()

film2 = Film.new({'title' => 'IT', 'price' => 7.50})
film2.save()

screening1 = Screening.new({'film_id' => film1.id, 'showtime' => 22.00, 'capacity' => 4})
screening1.save()

screening2 = Screening.new({'film_id' => film2.id, 'showtime' => 20.00, 'capacity' => 3})
screening2.save()


ticket1 = Ticket.new({'customer_id' => customer1.id, 'screening_id' => screening1.id})
ticket1.save()

ticket2 = Ticket.new({'customer_id' => customer2.id, 'screening_id' => screening1.id})
ticket2.save()

ticket3 = Ticket.new({'customer_id' => customer1.id, 'screening_id' => screening2.id})
ticket3.save()

#customer2.buy_ticket(screening2)




binding.pry
nil
