require_relative('../db/sql_runner.rb')

class Ticket

  attr_accessor :customer_id, :film_id
  attr_reader :id

  def initialize(options)
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @id = options['id'].to_i if options['id']
  end

  def save() #create
    sql = "
      INSERT INTO tickets
      (
        customer_id,
        film_id
      )
      VALUES
      (
        $1,
        $2
      )
      RETURNING id
      "
      values = [@customer_id, @film_id]
      @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def Ticket.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql, [])
  end



end #class end
