require_relative('../db/sql_runner.rb')

require('pry-byebug')

class Screening

  attr_accessor :film_id, :showtime, :capacity
  attr_reader :id

  def initialize(options)
    @film_id = options['film_id']
    @showtime = options['showtime'].to_f
    @capacity = options['capacity']
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = ("
      INSERT INTO screenings
      (
        film_id,
        showtime,
        capacity
      )VALUES(
        $1,
        $2,
        $3
      )
      RETURNING id
      ")
    values = [@film_id, @showtime, @capacity]
    @id = SqlRunner.run(sql, values).first()['id'].to_i

  end

  def Screening.delete_all()
    sql = ("DELETE FROM screenings")
    SqlRunner.run(sql, [])
  end

  def update()
    sql = "
    UPDATE screenings SET
    (
      film_id,
      showtime,
      capacity
    )=(
      $1,
      $2,
      $3
    ) WHERE id = $4
    "
    values = [@film_id, @showtime, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def Screening.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql, [])
    return screenings.map {|screen| Screening.new(screen)}
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values).first()
    # binding.pry
    # nil
    return Film.new(film)
  end

  def tickets
    sql = "SELECT * FROM tickets WHERE screening_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map{|tick| Ticket.new(tick)}
  end

  def tickets_num()
    return tickets().length
  end

  def customers()
    sql = "SELECT customers.* from customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE tickets.screening_id = $1
    "
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{|cust| Customer.new(cust)}
  end

end #class end
