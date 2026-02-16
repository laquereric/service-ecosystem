class DiagramsController < ApplicationController
  def index
    @puml_content = build_sequence_diagram do |d|
      d.participant "User", as: :user
      d.participant "Browser", as: :browser
      d.participant "Rails App", as: :app
      d.participant "PlantUML Server", as: :puml

      d.blank_line
      d.message "user", "browser", "Visit /diagrams"
      d.message "browser", "app", "GET /diagrams"
      d.message "app", "app", "build_sequence_diagram DSL"
      d.message "app", "puml", "Encode & fetch SVG"
      d.message "puml", "app", "SVG response"
      d.message "app", "browser", "HTML with inline SVG"
      d.message "browser", "user", "Rendered diagram"

      d.blank_line
      d.divider "Notes"
      d.note "app", title: "ServicePuml DSL", items: [
        "Ruby block builds PUML text",
        "Encoder deflates & base64-encodes",
        "SvgFetcher retrieves rendered SVG"
      ]
    end

    @puml_content = @puml_content.value! if @puml_content.respond_to?(:value!)
  end
end
