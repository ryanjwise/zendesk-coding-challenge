module Shared
  @@prompt = TTY::Prompt.new

  def get_input(query, type = 'ask', positive = true)
    case type
    when "ask"
      @@prompt.ask("What is your #{query}?", required: true)
    when "mask"
      @@prompt.mask("What is your #{query}?", required: true)
    when "confirm"
      @@prompt.yes?(query) do |q|
        q.default positive
      end
    end
  end

  def get_choice(query, choices)
    @@prompt.select(query, choices)
  end
end
