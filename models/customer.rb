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



end #class end
