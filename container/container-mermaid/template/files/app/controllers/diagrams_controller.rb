class DiagramsController < ApplicationController
  def index
  end

  def flowchart
    result = build_flowchart(direction: "TB") do |chart|
      chart.node("A", label: "Start", shape: :stadium)
      chart.node("B", label: "Process Data", shape: :rectangle)
      chart.node("C", label: "Decision", shape: :diamond)
      chart.node("D", label: "Success", shape: :rounded)
      chart.node("E", label: "Retry", shape: :rounded)

      chart.link("A", "B", text: "begin")
      chart.link("B", "C", text: "evaluate")
      chart.link("C", "D", text: "yes")
      chart.link("C", "E", text: "no", style: :dashed)
      chart.link("E", "B", text: "loop back", style: :dashed)
    end

    case result
    in Dry::Monads::Success(svg)
      @svg = svg
    in Dry::Monads::Failure(error)
      @error = error
    end
  end

  def sequence
    result = build_sequence_diagram do |seq|
      seq.participant("Browser", as: "B")
      seq.participant("Rails App", as: "R")
      seq.participant("ServiceMermaid", as: "SM")
      seq.participant("mermaid-cli", as: "CLI")

      seq.message("B", "R", "GET /diagrams/sequence")
      seq.message("R", "SM", "build_sequence_diagram")
      seq.message("SM", "CLI", "mmdc render")
      seq.message("CLI", "SM", "SVG output")
      seq.message("SM", "R", "Success(svg)")
      seq.message("R", "B", "HTML with inline SVG")

      seq.note("SM", "Server-side rendering, no client JS needed")
    end

    case result
    in Dry::Monads::Success(svg)
      @svg = svg
    in Dry::Monads::Failure(error)
      @error = error
    end
  end
end
