require_relative('../db/sql_runner.rb')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds']
    @id = options['id'].to_i if options['id']
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

  def films()
    sql = "
    SELECT films.* FROM films
    INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map {|film| Film.new(film)}
  end

  def buy_ticket(film)
    ticket = Ticket.new({'customer_id'=>@id, 'film_id' => film.id})
    @funds -= film.price
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


end #class end
