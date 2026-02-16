class DashboardsController < ApplicationController
  def index
    @scatter = Service3d::ScatterPlot3d.new(
      title: "Sample Scatter Plot",
      description: "500 random data points in 5 groups"
    )
    groups = %w[Alpha Beta Gamma Delta Epsilon]
    500.times do |i|
      group = groups[i % 5]
      offset = (i % 5) * 2
      @scatter.point(
        x: (rand * 10) - 5 + offset,
        y: (rand * 10) - 5,
        z: (rand * 10) - 5,
        label: "Point #{i + 1}",
        value: rand * 100,
        group: group
      )
    end
    @scatter.axes(x: "Feature A", y: "Feature B", z: "Feature C")
  end
end
