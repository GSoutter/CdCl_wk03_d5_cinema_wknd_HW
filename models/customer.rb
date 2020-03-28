require_relative('../db/sql_runner.rb')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'].to_i if options['id']
    @matinee_start = 11.0
    @matinee_end = 15.0
  end

  def save()
    sql = "
      INSERT INTO customers
      (
        name,
        funds
      )
      VALUES
      (
        $1,
        $2
        )
      RETURNING id"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values).first()['id'].to_i
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql, [])
  end

  def update()
    sql = "UPDATE customers SET (name, funds)=($1,$2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end


  def Customer.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql, [])
    return customers.map {|cust| Customer.new(cust)}
  end

  def screenings()
    sql = "
    SELECT screenings.* FROM screenings
    INNER JOIN tickets
    ON screenings.id = tickets.screening_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return screenings.map {|screen| Screening.new(screen)}
  end

  def buy_ticket(screening)
    return if screening.tickets_num() >= screening.capacity()
    ticket = Ticket.new({'customer_id'=>@id, 'screening_id' => screening.id})
    if (screening.showtime >= @matinee_start) && (screening.showtime < @matinee_end)
      ticket_price = screening.film.price.to_f / 2
      @funds -= ticket_price
    else
      @funds -= screening.film.price.to_f
    end
    update()
    ticket.save()
  end

  def tickets_num()
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    tickets_array = tickets.map{|tick| Ticket.new(tick)}
    return tickets_array.length
  end

  def films()
    screenings = screenings()
    films_array = []
    for screen in screenings
        films_array.push(screen.film)
    end
    return films_array
  end


end #class end
