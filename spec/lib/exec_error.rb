class ExecError < StandardError
  attr_reader :output

  def initialize(message, output)
    super(message)

    @output = output
  end
end
